//
//  GitHubRepo.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/29.
//

import Foundation

// MARK: - GitHubリポジトリ情報
struct GitHubRepo: Equatable, Codable {
    struct ID: RawRepresentable, Hashable, Codable {
        let rawValue: String
    }
    let id: ID
    let fullName: String
    let description: String
    let language: String
    let stargazersCount: Int
    
    // IDが準拠するHashableプロトコルは、Equatableを準拠しているので == を定義可能
    public static func == (lhs: GitHubRepo, rhs: GitHubRepo) -> Bool {
        return lhs.id == rhs.id
    }
}
