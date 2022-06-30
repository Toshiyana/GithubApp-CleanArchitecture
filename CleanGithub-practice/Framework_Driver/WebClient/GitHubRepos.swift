//
//  GitHubRepos.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/30.
//

import Foundation

class GitHubRepos {
    
}

// GitHubのRepository型を用いているのでここで定義
extension GitHubRepo {
    init(repository: Repository) {
        self.init(id: GitHubRepo.ID(rawValue: String(repository.id)),
                  fullName: repository.fullName,
                  description: repository.description ?? "",
                  language: repository.language ?? "",
                  stargazersCount: repository.stargazersCount)
    }
}
