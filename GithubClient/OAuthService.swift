//
//  OAuthService.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/1/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class OAuthService {
    
    class func performInitialRequest() {
        let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(kClientID)&redirect_uri=GithubClient://oauth&scope=user,repo")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    class func exchangeCodeForAccessToken(codeURL: URL) {
        guard let code = codeURL.query else {
            print("No query available for URL provided.")
            return
        }
        print(code)
        
        let url = URL(string: "https://github.com/login/oauth/access_token?\(code)&client_id=\(kClientID)&client_secret=\(kClientSecret)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Unable to get httpResponse")
                return
            }
            
            if httpResponse.statusCode == 200 {
                do {
                    if let rootObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject] {
                        if let accessToken = rootObject["access_token"] as? String {
                            print("Success!")
                            UserDefaults.standard.set(accessToken, forKey: "GithubAccessToken")
                            UserDefaults.standard.synchronize()
                            
                        }
                    }
                } catch {
                    print("Unable to convert JSON data into dictionary.")
                }
                
                
            }
            
        }.resume()
    }
}
