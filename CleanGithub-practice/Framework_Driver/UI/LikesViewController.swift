//
//  LikesViewController.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/26.
//

import UIKit

final class LikesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewDataArray = [GitHubRepoViewData]()
    private weak var presenter: ReposPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // SearchVCからtabで遷移後、再度LikedReposを読み込む（SearchVCでLikeが更新される可能性があるため）
        presenter.collectLikedRepos()
    }
    
    private func setup() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(LikeRepositoryCell.nib(), forCellReuseIdentifier: LikeRepositoryCell.identifier)
    }
}

// MARK: - ReposPresenterInjectable
extension LikesViewController: ReposPresenterInjectable {
    func inject(reposPresenter: ReposPresenterProtocol) {
        presenter = reposPresenter
        presenter.likesOutput = self
        presenter.collectLikedRepos()
    }
}

// MARK: - LikesPresenterOutput
extension LikesViewController: LikesPresenterOutput {
    func update(by viewDataArray: [GitHubRepoViewData]) {
        self.viewDataArray = viewDataArray
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension LikesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikeRepositoryCell.identifier, for: indexPath) as! LikeRepositoryCell
        cell.configure(with: viewDataArray[indexPath.row])
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension LikesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewData = viewDataArray[indexPath.row]
        // お気に入り状態をToggle
        presenter.set(liked: !viewData.isLiked, for: viewData.id)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
