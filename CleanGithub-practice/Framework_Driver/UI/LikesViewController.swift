//
//  LikesViewController.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/26.
//

import UIKit

final class LikesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LikesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO:
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO:
        return UITableViewCell()
    }
    
    
}

extension LikesViewController: UITableViewDelegate {
    
}
