//
//  RepoSearchUIViewController.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/8/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class RepoSearchUIViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var repos : [Repos]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RepoSearchUIViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repoCount = repos {
            return repoCount.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoTableViewCell
        if let displayRepos = repos {
            let repo = displayRepos[indexPath.row]
            cell.repoOwnerLabel.text = "\(repo.ownerName)/\(repo.name)"
            cell.forksLabel.text = "Forks: \(repo.forksCount)"
            cell.stargazersLabel.text = "Stargazers: \(repo.stargazersCount)"
            cell.descriptionTextView.text = repo.description
            cell.updatedLabel.text = "Updated: \(repo.updatedAt)"
        }
        
        return cell
    }
}
