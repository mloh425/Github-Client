//
//  RepoTableViewCell.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/8/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

protocol RepoForkedDelegate {
    func successfulFork()
}

class RepoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var repoOwnerLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var stargazersLabel: UILabel!
    var cellRepo: Repos!
    var delegate: RepoForkedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func forkItButtonPressed(_ sender: UIButton) {
            let url = "https://api.github.com/repos/\(cellRepo.ownerName)/\(cellRepo.name)/forks"
            GithubService.forkARepositoryPost(url: url, completionHandler: { (errorDescription) -> (Void) in
                if let errorDescription = errorDescription { //Really should change this and not call it error description. It's successful
                    if errorDescription == "You have successfully forked the repository!" {
                        DispatchQueue.main.async(execute: {
                            if let actualDelegate = self.delegate {
                            actualDelegate.successfulFork()
                            }
                        })

                    } else {
                        print(errorDescription)
                    }
            }

            })
        //Pass in userURL
    
    }
}
