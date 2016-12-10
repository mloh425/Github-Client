//
//  MyProfile.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/2/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import Foundation

struct MyProfile {
    let login : String
    let name: String
    let htmlURL : String
    let bio : String
    let avatarURL : String?
    let publicRepos: Int
    let ownedPrivateRepos : Int
    let followers : Int
    let following : Int
}
