//
//  UserViewController.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/9/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfReposLabel: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var numberOfFollowingLabel: UILabel!
    
    var selectedUser : UserSearch!
    var user : User!
    var repos = [Repos]()
    let imageQueue = OperationQueue()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Fetch profile information
        self.fetchProfile()
        self.fetchProfileRepos()
        tableView.delegate = self
        tableView.dataSource = self
        //TODO: Fetch Repos Information

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFields() {
        userNameLabel.text = user.login
        numberOfReposLabel.text = "Repositories: \(user.publicRepos)"
        numberOfFollowersLabel.text = "Followers: \(user.followers)"
        numberOfFollowingLabel.text = "Following: \(user.following)"
        DispatchQueue.main.async { 
            if let image = ImageDownloader.downloadImage(avatarURL: self.user.avatarURL!) {
                self.userAvatarImageView.image = image
                self.userAvatarImageView.layer.masksToBounds = true
                self.userAvatarImageView.layer.cornerRadius = 40
            }
            
        }
    }
    
    func fetchProfile() {
        if let user = selectedUser {
            let url = "https://api.github.com/users/" + user.login
            GithubService.specificUserforSearchTerm(url: url, completionHandler: { (errorDescription, userInfo) -> (Void) in
                if let errorDescription = errorDescription {
                    print(errorDescription)
                } else if let currentUser = userInfo {
                    DispatchQueue.main.async(execute: {
                        self.user = currentUser
                        self.setFields()
                    })
                }
            })
        }
    }
    
    func fetchProfileRepos() {
        if let user = selectedUser {
            let url = "https://api.github.com/users/\(user.login)/repos"
            GithubService.userProfileReposForSearchTerm(url: url, completionHandler: { (errorDescription, myProfileRepos) -> (Void) in
            if let errorDescription = errorDescription {
                print(errorDescription)
            } else if let repos = myProfileRepos {
                DispatchQueue.main.async(execute: {
                    //Reload tableViewData
                    self.repos = repos
                    self.tableView.reloadData()
                })
            }
        })
        }
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

extension UserViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRepoCell", for: indexPath) as! MyProfileTableViewCell
        let repo = repos[indexPath.row]
        //Tag necessary?
        cell.repoNameLabel.text = repo.name
        cell.repoDescriptionTextView.text = repo.description
        cell.dateLabel.text = repo.updatedAtString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
