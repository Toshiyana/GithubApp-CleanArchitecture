//
//  UserDefaultsDataStore.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/30.
//

import Foundation
import UIKit

protocol UserDefaultsProtocol {
    func dictionary(forKey defaultName: String) -> [String: Any]?
    func string(forKey defaultName: String) -> String?
    func set(_ value: Any?, forKey defaultName: String)
}

// swift標準のUserDefaultsにUserDefaultsProtocolを準拠させる
extension UserDefaults: UserDefaultsProtocol {}

final class UserDefaultsDataStore: DataStoreProtocol {
    let userDefaults: UserDefaultsProtocol
    
    init(userDefaults: UserDefaultsProtocol) {
        self.userDefaults = userDefaults
    }
    
    func fetch(ids: [GitHubRepo.ID], completion: @escaping(Result<[GitHubRepo.ID: Bool]>) -> Void) {
        let all = allLikes()
        let result = all.filter { (key, value) -> Bool in
            ids.contains { $0 == key }
        }
        completion(.success(result))
    }
    
    // MARK: - DataStoreProtocol
    func save(liked: Bool, for id: GitHubRepo.ID, completion: @escaping (Result<Bool>) -> Void) {
        var all = allLikes()
        all[id] = liked
        let pairs = all.map { (key, value) in
            (key.rawValue, value)
        }
        let newAll = Dictionary(uniqueKeysWithValues: pairs)
        userDefaults.set(newAll, forKey: "likes")
        completion(.success(liked))
    }
    
    func allLikes(completion: @escaping (Result<[GitHubRepo.ID : Bool]>) -> Void) {
        completion(.success(allLikes()))
    }
    
    func save(repos: [GitHubRepo], completion: @escaping (Result<[GitHubRepo]>) -> Void) {
        do {
            try repos.forEach { repo in
                let encoder = JSONEncoder()
                let data = try encoder.encode(repo)
                let jsonString = String(data: data, encoding: .utf8)
                userDefaults.set(jsonString, forKey: repo.id.rawValue)
            }
            completion(.success(repos))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetch(using ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo]>) -> Void) {
        let decoder = JSONDecoder()
        do {
            var result = [GitHubRepo]()
            for id in ids {
                if let jsonString = userDefaults.string(forKey: id.rawValue),
                    let data = jsonString.data(using: .utf8) {
                    
                    let repo: GitHubRepo = try decoder.decode(GitHubRepo.self, from: data)
                    result.append(repo)
                    
                }
            }
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }

    }
    
    
    private func allLikes() -> [GitHubRepo.ID: Bool] {
        if let dictionary = userDefaults.dictionary(forKey: "likes") as? [String: Bool] {
            let pair = dictionary.map { (key, value) in
                (GitHubRepo.ID(rawValue: key), value)
            }
            
            let likes = Dictionary(uniqueKeysWithValues: pair)
            return likes
        } else {
            return [:]
        }
    }
}
