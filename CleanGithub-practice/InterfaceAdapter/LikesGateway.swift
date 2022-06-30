//
//  LikesGateway.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/30.
//

import Foundation

protocol DataStoreProtocol: AnyObject {
    // お気に入り情報を検索・保存する
    func fetch(ids: [GitHubRepo.ID], completion: @escaping(Result<[GitHubRepo.ID: Bool]>) -> Void)
    func save(liked: Bool, for id: GitHubRepo.ID, completion: @escaping(Result<Bool>) -> Void)
    func allLikes(completion: @escaping(Result<[GitHubRepo.ID: Bool]>) -> Void)
    
    // リポジトリ情報を保存・検索する
    func save(repos: [GitHubRepo], completion: @escaping(Result<[GitHubRepo]>) -> Void)
    func fetch(using ids: [GitHubRepo.ID], completion: @escaping(Result<[GitHubRepo]>) -> Void)
}

// MARK: - フレームワークドライバ（Web, DBなど）からUseCaseに値を返す際にデータを変換する役割をもつ
// この場合、UseCaseとデータストア（UserDefauts）の仲介
class LikesGateway: LikesGatewayProtocol {
    private weak var useCase: ReposLikesUseCaseProtocol!
    var dataStore: DataStoreProtocol!
    
    init(useCase: ReposLikesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetch(ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo.ID : Bool]>) -> Void) {
        dataStore.fetch(ids: ids, completion: completion)
    }
    
    func save(liked: Bool, for id: GitHubRepo.ID, completion: @escaping (Result<Bool>) -> Void) {
        dataStore.save(liked: liked
                       , for: id, completion: completion)
    }
    
    func allLikes(completion: @escaping (Result<[GitHubRepo.ID : Bool]>) -> Void) {
        dataStore.allLikes(completion: completion)
    }
    
}
