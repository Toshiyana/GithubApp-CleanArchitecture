//
//  Error.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/30.
//

import Foundation

enum FetchingError: Error {
    case failedToFetchRepos(Error)
    case failedToFetchLikes(Error)
    case otherError
}

enum SavingError: Error {
    case failedToSaveLike
}
