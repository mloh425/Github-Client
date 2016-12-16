//
//  GitHubSearchViewController.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/7/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class GitHubSearchViewController: UIViewController {


    @IBOutlet weak var searchBar: UISearchBar!

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var userSearchContainerView: UIView!
    
    @IBOutlet weak var repoSearchContainerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var repoSearchContainerViewController: RepoSearchUIViewController?
    var userSearchContainerViewController: UserSearchCollectionViewController?
    
    var searchedRepositories = [Repos]()
    var searchedUsers = [UserSearch]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchTypeSwitched(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            userSearchContainerView.isHidden = false
            repoSearchContainerView.isHidden = true
        case 1:
            userSearchContainerView.isHidden = true
            repoSearchContainerView.isHidden = false
        default:
            break;
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReposSearchTableView" {
            repoSearchContainerViewController = segue.destination as? RepoSearchUIViewController
        }
        
        if segue.identifier == "toUserSearch" {
            userSearchContainerViewController = segue.destination as? UserSearchCollectionViewController
        }
    }
    
    func fetchThings() {
        let baseURL = "https://api.github.com/search/"
            let finalURL = baseURL + "repositories?q=swift"
            GithubService.reposForSearchTerm(url: finalURL, completionHandler: { (errorDescription, repositories) -> (Void) in
                if let errorDescription = errorDescription {
                    print(errorDescription)
                } else if let repos = repositories {
                    DispatchQueue.main.async(execute: {
                        self.searchedRepositories = repos
                        self.repoSearchContainerViewController?.repos = repos
                        self.repoSearchContainerViewController?.tableView.reloadData()
                    })
                }
            })

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

extension GitHubSearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        //add activity indicator
        //If the User container view is present, use this base URL else use other
        let baseURL = "https://api.github.com/search/"
        if userSearchContainerView.isHidden {
            let finalURL = baseURL + "repositories?q=\(searchBar.text!)"
            GithubService.reposForSearchTerm(url: finalURL, completionHandler: { (errorDescription, repositories) -> (Void) in
                if let errorDescription = errorDescription {
                    print(errorDescription)
                } else if let repos = repositories {
                    DispatchQueue.main.async(execute: {
                        self.searchedRepositories = repos
                        self.repoSearchContainerViewController?.repos = repos
                        self.repoSearchContainerViewController?.tableView.reloadData()
                    })
                }
            })
        } else { //Search case for Users
            let finalURL = baseURL + "users?q=\(searchBar.text!)"
            GithubService.usersForSearchTerm(url: finalURL, completionHandler: { (errorDescription, searchedUsers) -> (Void) in
                if let errorDescription = errorDescription {
                    print(errorDescription)
                } else if let users = searchedUsers {
                    DispatchQueue.main.async(execute: { 
                        self.searchedUsers = users
                        self.userSearchContainerViewController?.userSearchResults = users
                        self.userSearchContainerViewController?.collectionView.reloadData()
                    })
                }
            })

        }
    }
}
