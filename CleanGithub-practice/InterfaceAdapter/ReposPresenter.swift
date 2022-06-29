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

// MARK: - 外側（Viewなど）にPresenterが公開するインターフェース
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
class ReposPresenter {
    
}
