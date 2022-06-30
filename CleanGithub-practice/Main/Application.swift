//
//  Application.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/29.
//

import UIKit

class Application {
    // Shared instance
    static let shared = Application()
    private init() {}
    
    // ユースケースを公開プロパティとして保持
    private(set) var useCase: ReposLikesUseCase!
    
    func configure(with window: UIWindow) {
        buildLayer()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = storyboard.instantiateInitialViewController()
    }
    
    private func buildLayer() {
        // -- Use Case
        useCase = ReposLikesUseCase()
        
        // -- Inteface Adapters
        let reposGateway = ReposGateway(useCase: useCase)
        let likesGateway = LikesGateway(useCase: useCase)
        
        // Use Caseとのバインド
        useCase.reposGateway = reposGateway
        useCase.likesGateway = likesGateway
        
        // -- Framework & Drivers
        let webClient = GitHubReposStub()
        let likesDataStore = UserDefaultsDataStore(userDefaults: UserDefaults.standard)
        
        // Interface Adaptersとのバインド
        reposGateway.webClient = webClient
        reposGateway.dataStore = likesDataStore
        likesGateway.dataStore = likesDataStore
        
        // Presenterの作成・バインドは各ViewControllerを生成するクラスが実施
        // (本プロジェクトではTabBarControllerのawakeFromNib())
    }
}

// presenterを外側（Viewなど）に注入
protocol ReposPresenterInjectable {
    func inject(reposPresenter: ReposPresenterProtocol)
}
