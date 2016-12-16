//
//  JSONParsingService.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/2/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import Foundation

class JSONParsingService {
    class func myProfileJSONParser (jsonData : Data) throws -> MyProfile? {
            if let myProfileObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject] {
                var myProfile : MyProfile!
                var location = " "
                var bio = " "
                var hireable = false
                if let login = myProfileObject["login"] as? String,
                    let name = myProfileObject["name"] as? String,
                    let htmlURL = myProfileObject["html_url"] as? String,
                    let publicRepos = myProfileObject["public_repos"] as? Int,
                    let ownedPrivateRepos = myProfileObject["owned_private_repos"] as? Int,
                    let followers = myProfileObject["followers"] as? Int,
                    let following = myProfileObject["following"] as? Int,
                    let avatarURL = myProfileObject["avatar_url"] as? String {
                        if let setLocation = myProfileObject["location"] as? String {
                            location = setLocation
                        }
                        if let setBio = myProfileObject["bio"] as? String {
                            bio = setBio
                        }
                        if let setHireable = myProfileObject["location"] as? Bool {
                            hireable = setHireable
                        }
                    myProfile = MyProfile(login: login, name: name, htmlURL: htmlURL, bio: bio, avatarURL: avatarURL, publicRepos: publicRepos, ownedPrivateRepos: ownedPrivateRepos, followers: followers, following: following)
                    return myProfile
                }
            }
        return nil
    }
    
    
    class func userProfileReposJSONParser (jsonData : Data) throws -> [Repos]? {
        if let profileReposObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String : AnyObject]] {
            var profileRepos = [Repos]()
            for repo in profileReposObject {
                var description = " "
                var date = Date()
                if let name = repo["name"] as? String,
                    let htmlURL = repo["html_url"] as? String,
                    let starGazers = repo["stargazers_count"] as? Int,
                    let forks = repo["forks_count"] as? Int,
                    let updatedAt = repo["updated_at"] as? String,
                    let owner = repo["owner"] as? [String: AnyObject],
                    let ownerName = owner["login"] as? String,
                    let avatarURL = owner["avatar_url"] as? String {
                    let setUpdateTime = dateFormatHelper(date: updatedAt)
                    if let setDate = convertToDate(date: updatedAt) {
                        date = setDate
                    }
                    
                    if let setDescription = repo["description"] as? String {
                        description = setDescription
                    }
                    let profileRepo = Repos(name: name, description: description, htmlURL: htmlURL, avatarURL: avatarURL, forksCount: forks, stargazersCount: starGazers, ownerName: ownerName, updatedAt: date, updatedAtString: setUpdateTime)
                    
                    //let profileRepo = Repos(name: name, description: description, htmlURL: htmlURL, updatedAt: setUpdateTime, avatarURL: avatarURL, forksCount: forks, stargazersCount: starGazers, ownerName: ownerName)
                    profileRepos.append(profileRepo)
                }
            }
            return profileRepos
        }
        return nil
    }
    
    class func reposJSONParser (jsonData : Data) throws -> [Repos]? {
        if let myProfileReposObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject],
            let items = myProfileReposObject["items"] as? [[String : AnyObject]] {
            var repos = [Repos]()
            for item in items {
                var description = " "
                var date = Date()
                if let name = item["name"] as? String,
                    let htmlURL = item["html_url"] as? String,
                    let starGazers = item["stargazers_count"] as? Int,
                    let forks = item["forks_count"] as? Int,
                    let updatedAt = item["updated_at"] as? String,
                    let owner = item["owner"] as? [String: AnyObject],
                    let ownerName = owner["login"] as? String,
                    let avatarURL = owner["avatar_url"] as? String {
                    let setUpdateTime = dateFormatHelper(date: updatedAt)
                    if let setDate = convertToDate(date: updatedAt) {
                        date = setDate
                    }
                    if let setDescription = item["description"] as? String {
                        description = setDescription
                    }
                    let repo = Repos(name: name, description: description, htmlURL: htmlURL, avatarURL: avatarURL, forksCount: forks, stargazersCount: starGazers, ownerName: ownerName, updatedAt: date, updatedAtString: setUpdateTime)
                    repos.append(repo)
                    
                }

            }
            return repos
        }
        return nil
    }
    

    
    /*
 "login": "mojombo",
 "id": 1,
 "avatar_url": "https://secure.gravatar.com/avatar/25c7c18223fb42a4c6ae1c8db6f50f9b?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
 "gravatar_id": "",
 "url": "https://api.github.com/users/mojombo",
 "html_url": "https://github.com/mojombo",
 "followers_url": "https://api.github.com/users/mojombo/followers",
 "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
 "organizations_url": "https://api.github.com/users/mojombo/orgs",
 "repos_url": "https://api.github.com/users/mojombo/repos",
 "received_events_url": "https://api.github.com/users/mojombo/received_events",
 "type": "User",
 "score": 105.47857
 */
 
    class func usersSearchJSONParser (jsonData : Data) throws -> [UserSearch]? {
        if let usersObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject],
            let items = usersObject["items"] as? [[String: AnyObject]] {
            var searchedUsers = [UserSearch]()
            for item in items {
                var bio = " "
                if let login = item["login"] as? String,
                    let avatarURL = item["avatar_url"] as? String,
                    let htmlURL = item["html_url"] as? String,
                    let reposURL = item["repos_url"] as? String {
                    let userSearch = UserSearch(login: login, avatarURL: avatarURL, htmlURL: htmlURL, reposURL: reposURL)
                    searchedUsers.append(userSearch)
                }
            }
            return searchedUsers
        }
        return nil
    }
    
    
    class func userJSONParser (jsonData : Data) throws -> User? {
        if let userObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]{
                var bio = " "
                if let login = userObject["login"] as? String,
                    let avatarURL = userObject["avatar_url"] as? String,
                    let htmlURL = userObject["html_url"] as? String,
                    let reposURL = userObject["repos_url"] as? String,
                    let publicRepos = userObject["public_repos"] as? Int,
                    let followers = userObject["followers"] as? Int,
                    let following = userObject["following"] as? Int {
                    if let setBio = userObject["bio"] as? String {
                        bio = setBio
                    }
                    let user = User(login: login, htmlURL: htmlURL, bio: bio, avatarURL: avatarURL, publicRepos: publicRepos, followers: followers, following: following, reposURL : reposURL)
                    return user
                }
        }
        return nil
    }
}

extension JSONParsingService {
    class func dateFormatHelper(date : String) -> String {
        let dateParts = date.components(separatedBy: "T")[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateFromString = dateFormatter.date(from: dateParts)
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: dateFromString!)
    }
    
    class func convertToDate(date : String) -> Date? {
        let dateParts = date.components(separatedBy: "T")[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateFromString = dateFormatter.date(from: dateParts)
        dateFormatter.dateFormat = "MM-dd-yyyy"
        if let date = dateFromString {
            return date
        }
        return nil
    }
}
