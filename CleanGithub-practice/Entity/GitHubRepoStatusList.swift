//
//  GitHubRepoStatusList.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/29.
//

import Foundation

// MARK: - お気に入りGitHubリポジトリ
struct GitHubRepoStatus: Equatable {
    let repo: GitHubRepo
    let isLiked: Bool
    
    //  比較演算子 == の処理をカスタマイズ
    // GitHubRepoStatusオブジェクト同士を比較し、repoプロパティが一致したときにtrueを返す（isLikedは無視）
    static func == (lhs: GitHubRepoStatus, rhs: GitHubRepoStatus) -> Bool {
        return lhs.repo == rhs.repo
    }
}

extension Array where Element == GitHubRepoStatus {
    init(repos: [GitHubRepo], likes: [GitHubRepo.ID: Bool]) {
        self = repos.map { repo in
            GitHubRepoStatus(
                repo: repo,
                isLiked: likes[repo.id] ?? false
            )
        }
    }
}

// MARK: - お気に入りGitHubリポジトリ一覧
struct GitHubRepoStatusList {
    enum Error: Swift.Error {
        case notFoundRepo(ofID: GitHubRepo.ID)
    }
    private(set) var statuses: [GitHubRepoStatus] // お気に入りGitHubリポジトリ
    
    // trimmed: Likeでフィルタリングするかどうか
    init(repos: [GitHubRepo], likes: [GitHubRepo.ID: Bool], trimmed: Bool = false) {
        // Arrayのinit()は"extension Array where Element == GitHubRepoStatus"の拡張
        statuses = Array(repos: repos, likes: likes)
            .unique(resolve: { _, _ in
                    .ignoreNewOne
            })
        
        if trimmed {
            statuses = statuses.filter { $0.isLiked }
        }
    }
    
    // 理解できてない
    mutating func append(repos: [GitHubRepo], likes: [GitHubRepo.ID: Bool]) {
        let newStatusesMayNotUnique = statuses + Array(repos: repos, likes: likes)
        statuses = newStatusesMayNotUnique.unique(resolve: { _, _ in
                .removeOldOne
        })
    }
    
    mutating func set(isLiked: Bool, for id: GitHubRepo.ID) throws {
        guard let index = statuses.firstIndex(where: { $0.repo.id == id }) else {
            throw Error.notFoundRepo(ofID: id)
        }
        
        let currentStatus = statuses[index]
        
        statuses[index] = GitHubRepoStatus(
            repo: currentStatus.repo,
            isLiked: isLiked)
    }
    
    subscript(id: GitHubRepo.ID) -> GitHubRepoStatus? {
        return statuses.first(where: { $0.repo.id == id })
    }
}
