//
//  ResultsCell.swift
//  GithubGraphQL
//
//  Created by Annemarie Ketola on 3/3/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit


class ResultsCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var repoTitle: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        spinner.hidesWhenStopped = true
    }

    func configure(with searchGQLDataResult: SearchResultModel?) {
        if let searchGQLDataResult = searchGQLDataResult {
            self.avatarImage.image = UIImage(named: "blank-profile-picture-1.png")
            repoTitle?.alpha = 1
            authorLabel?.alpha = 1
            starsLabel.alpha = 1
            
            repoTitle?.text = searchGQLDataResult.name
            authorLabel?.text = searchGQLDataResult.owner
            
            let starCount = searchGQLDataResult.stars
            if starCount < 1 {
                starsLabel.isHidden = true
            } else {
                let starCountString = String(starCount)
                starsLabel?.text = starCountString + "⭐️"
            }
            if searchGQLDataResult.avatar.count > 0 {
                let imageUrl = searchGQLDataResult.avatar
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                        DispatchQueue.main.async {
                            self.avatarImage.image = UIImage(data: data)
                                self.setNeedsLayout()
                        }
                    }
                }
            spinner.stopAnimating()
        } else {
            repoTitle?.alpha = 0
            authorLabel?.alpha = 0
            starsLabel.alpha = 0

            spinner.startAnimating()
        }
    }

}
}
