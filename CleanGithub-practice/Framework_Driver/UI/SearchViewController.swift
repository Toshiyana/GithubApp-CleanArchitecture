//
//  SearchViewController.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/26.
//

import UIKit

final class SearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewDataArray = [GitHubRepoViewData]()
    private weak var presenter: ReposPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(LikeRepositoryCell.nib(), forCellReuseIdentifier: LikeRepositoryCell.identifier)
    }
}

// MARK: - ReposPresenterInjectable
extension SearchViewController: ReposPresenterInjectable {
    func inject(reposPresenter: ReposPresenterProtocol) {
        presenter = reposPresenter
        presenter.reposOutput = self // SearchViewControllerにReposPresenterOutputを準拠させる必要あり（delegateみたいな使い方）
        presenter.startFetch(using: [])
    }
}

// MARK: - ReposPresenterOutput
extension SearchViewController: ReposPresenterOutput {
    // viewDataArrayが更新されたらtableViewも更新
    func update(by viewDataArray: [GitHubRepoViewData]) {
        self.viewDataArray = viewDataArray
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
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
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewData = viewDataArray[indexPath.row]
        // お気に入り状態をToggle
        presenter.set(liked: !viewData.isLiked, for: viewData.id)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // UISearchBarからフォーカスを外し、キーボードを非表示
        searchBar.resignFirstResponder()
        
        guard let text = searchBar.text else {
            return
        }
        let keywords = text.split(separator: " ").map(String.init)
        presenter.startFetch(using: keywords)
    }
}
