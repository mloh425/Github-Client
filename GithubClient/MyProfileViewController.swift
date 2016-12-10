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
    let imageQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
                // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkForExistingAccessToken()
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
        GithubService.myProfileReposForSearchTerm  { (errorDescription, myProfileRepos) -> (Void) in
            if let errorDescription = errorDescription {
                print(errorDescription)
            } else if let repos = myProfileRepos {
                DispatchQueue.main.async(execute: { 
                    self.myProfileRepositories = repos
                    self.tableView.reloadData()
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
        return myProfileRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRepoCell", for: indexPath) as! MyProfileTableViewCell
        let repo = myProfileRepositories[indexPath.row]
        //Tag necessary?
        cell.repoNameLabel.text = repo.name
        cell.repoDescriptionTextView.text = repo.description
        cell.dateLabel.text = repo.updatedAt
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
