//
//  User.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/7/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import Foundation

struct User {
    let login : String
    let htmlURL : String
    let bio : String
    let avatarURL : String?
    let publicRepos: Int
    let followers : Int
    let following : Int
    let reposURL : String
}
