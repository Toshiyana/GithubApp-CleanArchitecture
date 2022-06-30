//
//  ReposGateway.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/30.
//

import Foundation

protocol WebClientProtocol {
    func fetch(using keywords: [String], completion: @escaping(Result<[GitHubRepo]>) -> Void)
}

// MARK: - フレームワークドライバ（Web, DBなど）からUseCaseに値を返す際にデータを変換する役割をもつ
// この場合、UseCaseとWebクライアント（Github API）の仲介
class ReposGateway: ReposGatewayProtocol {
    
    private weak var useCase: ReposLikesUseCaseProtocol!
    var webClient: WebClientProtocol!
    var dataStore: DataStoreProtocol!
    
    init(useCase: ReposLikesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetch(using keywords: [String], completion: @escaping (Result<[GitHubRepo]>) -> Void) {
        // キャッシュとして保存した上でGatewayの外側へ処理を伝える
        webClient.fetch(using: keywords) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let repos):
                strongSelf.dataStore.save(repos: repos, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetch(using ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo]>) -> Void) {
        // Gatewayの外側へ処理を伝える
        dataStore.fetch(using: ids, completion: completion)
    }
    
    
}
