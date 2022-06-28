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

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO:
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO:
        let cell = tableView.dequeueReusableCell(withIdentifier: LikeRepositoryCell.identifier, for: indexPath) as! LikeRepositoryCell
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    
}
