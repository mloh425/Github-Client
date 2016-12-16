//
//  MyProfileViewController.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/2/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var numberOfFollowingLabel: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var numberOfReposLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    var myProfile : MyProfile!
    var myProfileRepositories = [MyProfileRepos]()
    var repos = [Repos]()
    let imageQueue = OperationQueue()
    let refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshController.tintColor = UIColor.black
        refreshController.addTarget(self, action: #selector(MyProfileViewController.fetchProfileRepos), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshController)
        

                // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkForExistingAccessToken()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(MyProfileViewController.fetchProfileRepos), name: NSNotification.Name(rawValue: "repoForkSuccessful"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForExistingAccessToken() {
        if UserDefaults.standard.object(forKey: "GithubAccessToken") == nil {
            //Maybe check the token Specifically if it is still valid or not!!!!!!
            print("Need to login")
            //Will this create multiple instances?
            let signInViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController") 
            present(signInViewController, animated: true, completion: nil)
        } else {
            //Load data
            print("Ready to load profile data")
            fetchProfile()
            fetchProfileRepos()
        }
        
    }
    
    func fetchProfile() {
        GithubService.myProfileForSearchTerm { (errorDescription, myProfile) -> (Void) in
            if let errorDescription = errorDescription {
                print(errorDescription)
            } else if let profile = myProfile {
                DispatchQueue.main.async(execute: {
                    self.myProfile = profile
                    self.setFields()
                    if let image = ImageDownloader.downloadImage(avatarURL: self.myProfile.avatarURL!) {
                        self.userImageView.image = image
                        self.userImageView.layer.masksToBounds = true
                        self.userImageView.layer.cornerRadius = 40
                    }
                })
            }
        }
    }
    
    func fetchProfileRepos() {
        let url = "https://api.github.com/user/repos"
        GithubService.userProfileReposForSearchTerm(url: url) { (errorDescription, repositories) -> (Void) in
            if let errorDescription = errorDescription {
                print(errorDescription)
            } else if let repos = repositories {
                DispatchQueue.main.async(execute: {
                    self.repos = repos
                    self.repos.sort(by: { (date1 : Repos, date2: Repos) -> Bool in
                        date1.updatedAt > date2.updatedAt
                    })
                    
                    self.tableView.reloadData()
                    self.refreshController.endRefreshing()
                })
            }
        }

    }
    
    func setFields() {
        usernameLabel.text = myProfile.login
        numberOfReposLabel.text = "\(myProfile.publicRepos)"
        numberOfFollowersLabel.text = "\(myProfile.followers)"
        numberOfFollowingLabel.text = "\(myProfile.following)"
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

extension MyProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return myProfileRepositories.count
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRepoCell", for: indexPath) as! MyProfileTableViewCell
        //let repo = myProfileRepositories[indexPath.row]
        let repo = repos[indexPath.row]
        //Tag necessary?
        cell.repoNameLabel.text = repo.name
        cell.repoDescriptionTextView.text = repo.description
        //cell.dateLabel.text = repo.updatedAt
        cell.dateLabel.text = repo.updatedAtString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
