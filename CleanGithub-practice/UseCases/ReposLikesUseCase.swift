//
//  ReposLikesUseCase.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/30.
//

import Foundation

// MARK: - UseCaseが外側（InterfaceAdapter）に公開するインターフェース
// Presenterで処理が呼ばれる
protocol ReposLikesUseCaseProtocol: AnyObject {
    // キーワードを使ったサーチ
    func startFetch(using keywords: [String])
    // お気に入り済みリポジトリ一覧の取得
    func collectLikedRepos()
    // お気に入りの追加・削除
    func set(liked: Bool, for id: GitHubRepo.ID)
    
    // 外側のオブジェクトはプロパティとして後からセットする
    var output: ReposLikesUseCaseOutput! { get set }
    var reposGateway: ReposGatewayProtocol! { get set }
    var likesGateway: LikesGatewayProtocol! { get set }
}

// MARK: - Presenterに準拠させるプロトコル
protocol ReposLikesUseCaseOutput {
    // GitHubリポジトリ（+お気に入りのON/OFF）の情報が更新されたときに呼ばれる
    func useCaseDidUpdateStatuses(_ repoStatuses: [GitHubRepoStatus])
    // お気に入り一覧情報が更新されたときに呼ばれる
    func useCaseDidUpdateLikesList(_ likesList: [GitHubRepoStatus])
    // UseCaseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(_ error: Error)
}

// MARK: - フレームワークドライバ（Web, DBなど）からUseCaseに値を返す際にデータを変換する役割をもつ
protocol ReposGatewayProtocol {
    // キーワードで検索した結果を完了ハンドラで返す
    func fetch(using keywords: [String],
               completion: @escaping(Result<[GitHubRepo]>) -> Void)
    
    // IDで検索した結果を完了ハンドラで返す
    func fetch(using ids: [GitHubRepo.ID],
               completion: @escaping(Result<[GitHubRepo]>) -> Void)
}

protocol LikesGatewayProtocol {
    // IDで検索したお気に入りの結果を完了ハンドラで返す
    func fetch(ids: [GitHubRepo.ID], completion: @escaping(Result<[GitHubRepo.ID: Bool]>) -> Void)
    // IDについてお気に入りの状態を保存する
    func save(liked: Bool,
              for id: GitHubRepo.ID,
              completion: @escaping(Result<Bool>) -> Void)
    // お気に入りの情報の一覧を返す
    func allLikes(completion: @escaping(Result<[GitHubRepo.ID: Bool]>) -> Void)
}

// MARK: - Entityを使ったアプリケーションで固有なビジネスロジック
// キーワードに該当するGitHubリポジトリ一覧の用意、GitHubリポジトリをお気に入り追加・削除
final class ReposLikesUseCase: ReposLikesUseCaseProtocol {
    var output: ReposLikesUseCaseOutput!
    
    var reposGateway: ReposGatewayProtocol!
    var likesGateway: LikesGatewayProtocol!
    
    private var statusList = GitHubRepoStatusList(repos: [], likes: [:])
    private var likesList = GitHubRepoStatusList(repos: [], likes: [:])
    
    // キーワードでリポジトリを検索し、結果とお気に入り状態を組み合わせた結果をOutputに通知
    func startFetch(using keywords: [String]) {
        reposGateway.fetch(using: keywords) { [weak self] repoResult in
            guard let strongSelf = self else { return }
            
            switch repoResult {
            case .failure(let error):
                strongSelf.output.useCaseDidReceiveError(FetchingError.failedToFetchRepos(error))
                
            case .success(let repos):
                let ids = repos.map { $0.id }
                strongSelf.likesGateway.fetch(ids: ids) { [weak self] likesResult in
                    guard let strongSelf = self else { return }
                    
                    switch likesResult {
                    case .failure(let error):
                        strongSelf.output.useCaseDidReceiveError(FetchingError.failedToFetchLikes(error))
                        
                    case .success(let likes):
                        // 結果を保持
                        let statusList = GitHubRepoStatusList(repos: repos, likes: likes)
                        strongSelf.statusList = statusList
                        strongSelf.output.useCaseDidUpdateStatuses(statusList.statuses)
                    }
                }
                
            }
        }
    }
    
    func collectLikedRepos() {
        likesGateway.allLikes { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.output.useCaseDidReceiveError(FetchingError.failedToFetchLikes(error))
                
            case.success(let allLikes):
                let ids = Array(allLikes.keys)
                strongSelf.reposGateway.fetch(using: ids) { [weak self] reposResult in
                    guard let strongSelf = self else { return }
                    
                    switch reposResult {
                    case .failure(let error):
                        self?.output.useCaseDidReceiveError(FetchingError.failedToFetchLikes(error))
                        
                    case.success(let repos):
                        // 結果を保持
                        let likesList = GitHubRepoStatusList(repos: repos, likes: allLikes, trimmed: true)
                        
                        strongSelf.likesList = likesList
                        strongSelf.output.useCaseDidUpdateLikesList(likesList.statuses)
                    }
                }
            }
        }
    }
    
    func set(liked: Bool, for id: GitHubRepo.ID) {
        // お気に入りの状態を保存し、更新の結果を伝える
        likesGateway.save(liked: liked, for: id) { [weak self] likesResult in
            guard let strongSelf = self else { return }
            
            switch likesResult {
            case .failure:
                strongSelf.output.useCaseDidReceiveError(SavingError.failedToSaveLike)
                
            case .success(let isLiked):
                do {
                    try strongSelf.statusList.set(isLiked: isLiked, for: id)
                    try strongSelf.likesList.set(isLiked: isLiked, for: id)
                    
                    strongSelf.output.useCaseDidUpdateStatuses(strongSelf.statusList.statuses)
                    strongSelf.output.useCaseDidUpdateLikesList(strongSelf.likesList.statuses)
                } catch {
                    strongSelf.output.useCaseDidReceiveError(SavingError.failedToSaveLike)
                }
            }
        }
    }
    
    
    
    
}
