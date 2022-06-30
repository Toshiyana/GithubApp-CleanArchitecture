//
//  ReposPresenter.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/29.
//

import Foundation

// MARK: - 画面表示用のデータ
struct GitHubRepoViewData {
    let id: String
    let fullname: String
    let description: String
    let language: String
    let stargazersCount: Int
    let isLiked: Bool
}

// MARK: - Presenterが外側（Viewなど）に公開するインターフェース
protocol ReposPresenterProtocol: AnyObject {
    // キーワードを使ったサーチ
    func startFetch(using keywords: [String])
    // お気に入り済みリポジトリ一覧の取得
    func collectLikedRepos()
    // お気に入りの設定・解除
    func set(liked: Bool, for id: String)

    var reposOutput: ReposPresenterOutput? { get set }
    var likesOutput: LikesPresenterOutput? { get set }
}

// MARK: - GitHubリポジトリの検索View向け出力インターフェース
protocol ReposPresenterOutput {
    // 表示用のデータが変化したことをPresenterから外側に通知
    func update(by viewDataArray: [GitHubRepoViewData])
}

// MARK: - GitHubリポジトリのお気に入り一覧View向け出力インターフェース
protocol LikesPresenterOutput {
    // 表示用のデータが変化したことをPresenterから外側に通知
    func update(by viewDataArray: [GitHubRepoViewData])
}

// MARK: - ViewとUseCaseの仲介 (Viewに表示するためのデータ構造を作成)
class ReposPresenter: ReposPresenterProtocol, ReposLikesUseCaseOutput {
    
    private weak var useCase: ReposLikesUseCaseProtocol!
    var reposOutput: ReposPresenterOutput?
    var likesOutput: LikesPresenterOutput?
    
    init(useCase: ReposLikesUseCaseProtocol) {
        self.useCase = useCase
        self.useCase.output = self // ReposLikesUseCaseOutputに準拠したオブジェクト
    }

    func startFetch(using keywords: [String]) {
        // UseCaseに検索を依頼
        useCase.startFetch(using: keywords)
    }
    
    func collectLikedRepos() {
        useCase.collectLikedRepos()
    }
    
    func set(liked: Bool, for id: String) {
        useCase.set(liked: liked, for: GitHubRepo.ID(rawValue: id))
    }
    
    func useCaseDidUpdateStatuses(_ repoStatuses: [GitHubRepoStatus]) {
        // UseCaseから届いたデータを外側で使うデータに変換してから伝える
        let viewDataArray = Array.init(repoStatus: repoStatuses)
        
        DispatchQueue.main.async { [weak self] in
            self?.reposOutput?.update(by: viewDataArray)
        }
    }
    
    func useCaseDidUpdateLikesList(_ likesList: [GitHubRepoStatus]) {
        // UseCaseから届いたデータを外側で使うデータに変換してから伝える
        let viewDataArray = Array.init(repoStatus: likesList)
        
        DispatchQueue.main.async { [weak self] in
            self?.likesOutput?.update(by: viewDataArray)
        }
    }
    
    func useCaseDidReceiveError(_ error: Error) {
        // TODO:
    }
    
    
    
    
    
}

// ArrayのElementの型がGitHubRepoViewDataの時のみextension
extension Array where Element == GitHubRepoViewData {
    init(repoStatus: [GitHubRepoStatus]) {
        // selfに値を代入（独自イニシャライザ）
        self = repoStatus.map {
            return GitHubRepoViewData(
                id: $0.repo.id.rawValue,
                fullname: $0.repo.fullName,
                description: $0.repo.description,
                language: $0.repo.language,
                stargazersCount: $0.repo.stargazersCount,
                isLiked: $0.isLiked)
        }
    }
}
