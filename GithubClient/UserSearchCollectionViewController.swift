//
//  UserSearchCollectionViewController.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/8/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class UserSearchCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var userSearchResults : [UserSearch]!
    let imageQueue = OperationQueue()
    var selectedUser : UserSearch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserProfile" {
            let destinationVC = segue.destination as! UserViewController
            destinationVC.selectedUser = self.selectedUser
        }
    }
}

extension UserSearchCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let userSearch = userSearchResults {
            return userSearch.count
        } else {
            return 0
        }
    }
    
    func setUpCellImage(cell : UserCollectionViewCell) {
        cell.userAvatar.layer.masksToBounds = true
        cell.userAvatar.layer.cornerRadius = 40
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            cell.alpha = 1
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCollectionViewCell
        
        cell.alpha = 0
        cell.tag += 1
        let tag = cell.tag
        
        
        if let users = userSearchResults {
            let user = users[indexPath.row]
            cell.userLoginLabel.text = user.login
            if let avatarURL = user.avatarURL {
                if let image = ImageCache.sharedCache.findImage(name: avatarURL) {
                    if cell.tag == tag {
                        cell.userAvatar.image = image
                        setUpCellImage(cell: cell)
                    }
                } else {
                    imageQueue.addOperation({
                        let image = ImageDownloader.downloadImage(avatarURL: avatarURL)
                        DispatchQueue.main.async(execute: {
                            cell.userAvatar.image = image
                            self.setUpCellImage(cell: cell)
                        })
                        
                    })
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedUser = userSearchResults[indexPath.row]
        performSegue(withIdentifier: "toUserProfile", sender: self)
    }
}
