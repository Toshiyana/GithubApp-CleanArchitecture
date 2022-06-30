//
//  Result.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/30.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
