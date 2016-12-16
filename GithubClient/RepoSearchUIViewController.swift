//
//  RepoSearchUIViewController.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/8/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class RepoSearchUIViewController: UIViewController, RepoForkedDelegate {

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
    
    func successfulFork() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "repoForkSuccessful"), object: self)
        
        let alert = UIAlertController(title: "Alert", message: "You have successfully forked the repo!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        //Alert controller to display success Fork!
        self.present(alert, animated: true, completion: nil)
        //Broadcast to home VC and fetch again
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
            cell.delegate = self
            cell.cellRepo = repo
            cell.repoOwnerLabel.text = "\(repo.ownerName)/\(repo.name)"
            cell.forksLabel.text = "Forks: \(repo.forksCount)"
            cell.stargazersLabel.text = "Stargazers: \(repo.stargazersCount)"
            cell.descriptionTextView.text = repo.description
            cell.updatedLabel.text = "Updated: \(repo.updatedAtString)"
        }
        
        return cell
    }
}
