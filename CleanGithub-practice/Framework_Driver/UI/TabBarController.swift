//
//  TabBarController.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/30.
//

import UIKit

// Presenterの作成・バインドは各ViewControllerを生成するクラスが実施
// (本プロジェクトではTabBarControllerのawakeFromNib())
class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        let useCase: ReposLikesUseCase! = Application.shared.useCase
        
        // -- Interface adapters
        let reposPresenter = ReposPresenter(useCase: useCase)
        
        useCase.output = reposPresenter
        
        // PresenterをViewControllerに注入
        inject(presenter: reposPresenter)
    }
    
    private func inject(presenter: ReposPresenterProtocol) {
        viewControllers?.forEach { vc in
            inject(presenter: presenter, into: vc)
        }
    }
    
    private func inject(presenter: ReposPresenterProtocol, into vc: UIViewController) {
        switch vc {
        case let injectable as ReposPresenterInjectable:
            injectable.inject(reposPresenter: presenter)
        
        case let navVC as UINavigationController:
            if let topVC = navVC.topViewController {
                inject(presenter: presenter, into: topVC)
            }
            
        default:
            break
        }
    }
}
