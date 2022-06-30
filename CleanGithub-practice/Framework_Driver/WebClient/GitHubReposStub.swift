//
//  GitHubReposStub.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/30.
//

import Foundation

class GitHubReposStub: WebClientProtocol {
    func fetch(using keywords: [String], completion: @escaping (Result<[GitHubRepo]>) -> Void) {
        // ダミーデータを作成して返す
        let repos = (0..<5).map{
            GitHubRepo(id: GitHubRepo.ID(rawValue: "repos/\($0)"),
                fullName: "repos/\($0)",
                description: "my awesome project",
                language: "swift",
                stargazersCount: $0)
        }
        completion(.success(repos))
    }
}
