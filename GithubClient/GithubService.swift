//
//  GithubService.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/2/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import Foundation

class GithubService {
    class func myProfileForSearchTerm(completionHandler: @escaping (String?, MyProfile?) -> (Void)) {
        let baseURL = URL(string: "https://api.github.com/user")
        var request = URLRequest(url: baseURL!)
        if let token = UserDefaults.standard.object(forKey: "GithubAccessToken") {
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    //Do I need to do a try catch here? or it's just handled in JSON Parsing service
                    do{
                        let results = try JSONParsingService.myProfileJSONParser(jsonData: data!)
                        completionHandler(nil, results)
                    } catch {
                        print("myProfile JSON Parser error.")
                    }
                case 400...499:
                    completionHandler("An unexpected error occurred in the application", nil)
                
                case 500...599:
                    completionHandler("An unexpected error occurred with the servers", nil)
                default:
                    completionHandler("An unexpected error occurred.", nil)
                }
            }
        }.resume()
 
    }
    
    class func myProfileReposForSearchTerm(completionHandler: @escaping (String?, [MyProfileRepos]?) -> (Void)) {
        let baseURL = URL(string: "https://api.github.com/user/repos")
        var request = URLRequest(url: baseURL!)
        if let token = UserDefaults.standard.object(forKey: "GithubAccessToken") {
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let results = try JSONParsingService.myProfileReposJSONParser(jsonData: data!)
                        completionHandler(nil, results)
                        
                    } catch {
                        print("ProfileRepo JSON Parser error.")
                    }
                case 400...499:
                    completionHandler("An unexpected error occurred in the application", nil)
                    
                case 500...599:
                    completionHandler("An unexpected error occurred with the servers", nil)
                default:
                    completionHandler("An unexpected error occurred.", nil)
                }
            }
        }.resume()
        
    }
    
    class func usersForSearchTerm(url : String, completionHandler: @escaping (String?, [UserSearch]?) -> (Void)) {
        let baseURL = URL(string: url)
        var request = URLRequest(url: baseURL!)
        
        if let token = UserDefaults.standard.object(forKey: "GithubAccessToken") {
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let results = try JSONParsingService.usersSearchJSONParser(jsonData: data!)
                        completionHandler(nil, results)
                        
                    } catch {
                        print("ProfileRepo JSON Parser error.")
                    }
                case 400...499:
                    completionHandler("An unexpected error occurred in the application", nil)
                    
                case 500...599:
                    completionHandler("An unexpected error occurred with the servers", nil)
                default:
                    completionHandler("An unexpected error occurred.", nil)
                }
            }
        }.resume()
    }
    
    class func reposForSearchTerm(url : String, completionHandler: @escaping (String?, [Repos]?) -> (Void)) {
        let baseURL = URL(string: url)
        var request = URLRequest(url: baseURL!)
 
        
        if let token = UserDefaults.standard.object(forKey: "GithubAccessToken") {
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
 
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let results = try JSONParsingService.reposJSONParser(jsonData: data!)
                        completionHandler(nil, results)
                        
                    } catch {
                        print("ProfileRepo JSON Parser error.")
                    }
                case 400...499:
                    completionHandler("An unexpected error occurred in the application", nil)
                case 500...599:
                    completionHandler("An unexpected error occurred with the servers", nil)
                default:
                    completionHandler("An unexpected error occurred.", nil)
                }
            }
        }.resume()
    }
}
