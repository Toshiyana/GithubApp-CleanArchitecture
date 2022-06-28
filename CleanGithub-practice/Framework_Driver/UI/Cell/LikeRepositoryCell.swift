//
//  LikeRepositoryCell.swift
//  CleanGithub-practice
//
//  Created by Toshiyana on 2022/06/29.
//

import UIKit

final class LikeRepositoryCell: UITableViewCell {
    
    static let identifier = "LikeRepositoryCell"
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 8
            containerView.layer.masksToBounds = true
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet private weak var repositoryNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var languageContainerView: UIView!
    @IBOutlet private weak var languageLabel: UILabel!
    
    @IBOutlet private weak var starLabel: UILabel!
    @IBOutlet private weak var likedLabel: UILabel!

    func configure(with viewData: GitHubRepoViewData) {
        repositoryNameLabel.text = viewData.fullname
        
        descriptionLabel.isHidden = false
        descriptionLabel.text = viewData.description
        
        languageContainerView.isHidden = false
        languageLabel.text = viewData.language
        
        starLabel.text = "★ \(viewData.stargazersCount)"
    
        likedLabel.text = viewData.isLiked ? "❤️" : "♡"
    }
}
