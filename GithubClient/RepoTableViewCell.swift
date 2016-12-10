//
//  RepoTableViewCell.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/8/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var repoOwnerLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var stargazersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
