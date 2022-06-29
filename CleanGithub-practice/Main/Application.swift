//
//  Application.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/29.
//

import UIKit

class Application {
    
}

// presenterを外側（Viewなど）に注入
protocol ReposPresenterInjectable {
    func inject(reposPresenter: ReposPresenterProtocol)
}
