//
//  OAuthViewController.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/1/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    let authorizationEndPoint = "https://github.com/login/oauth/authorize"
    
    let accessTokenEndPoint = "https://github.com/login/oauth/access_token"
    
    let state = "github\(Int(NSDate().timeIntervalSince1970))"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        startAuthorization()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Make initial request for OAuth to get user approval
    func startAuthorization() {
        //let redirectURI = "https://com.matthewloh.github.oauth/oauth"
        let redirectURI = "GithubClient://oauth"
        let scope = "user,repo"

        
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "client_id=\(kClientID)&"
        authorizationURL += "redirect_uri=\(redirectURI)&"
        authorizationURL += "scope=\(scope)"
        //authorizationURL += "state=\(state)"
        
        let requestURL = URL(string: authorizationURL)
        let request = URLRequest(url: requestURL!)
        
        webView.loadRequest(request)
    }
    
    //Extract the code from the response from GitHub
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!
        //if url.host == "com.matthewloh.github.oauth" {
        if url.host == "oauth" {
            if url.absoluteString.range(of: "code") != nil {
                let urlParts = url.absoluteString.components(separatedBy: "?")
                let code = urlParts[1].components(separatedBy: "=")[1]
                print(code)
                requestForAccessToken(authorizationCode: code)
            }
        }
        return true
    }
    
    //Create a POST request to exchange the 'code' for the access token and save it. Then return the main screen. Maybe use delegate to create new VC?
    func requestForAccessToken(authorizationCode: String) {
        
        var postParameters = "code=\(authorizationCode)&"
        postParameters += "client_id=\(kClientID)&"
        postParameters += "client_secret=\(kClientSecret)"

        let postData = postParameters.data(using: String.Encoding.utf8)
        
        //var request = URLRequest(url: URL(string: "https://github.com/login/oauth/access_token?code=\(authorizationCode)&client_id=\(kClientID)&client_secret=\(kClientSecret)")!)
        
        var request = URLRequest(url: URL(string: accessTokenEndPoint)!)
        
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //Make session happen to get access token?
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            let statusCode = (response as! HTTPURLResponse).statusCode

            if statusCode == 200 {
                do {
                    guard let responseData = data else {
                        print("Error: Did not recieve data.")
                        return
                    }
                    
                    guard let rootObject = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject] else {
                        print("Error: Unable to convert data to JSON")
                        return
                    }
                    
                    guard let accessToken = rootObject["access_token"] as? String else {
                        print("Error: Access token is nil.")
                        return
                    }
                    UserDefaults.standard.set(accessToken, forKey: "GithubAccessToken")
                    UserDefaults.standard.synchronize()
                    
                    DispatchQueue.main.async(execute: { 
                        self.dismiss(animated: true, completion: nil)
                    })
        
                } catch {
                    print("Unable to convert data into JSON")
                }
            } //Handle other error codes here? Perhaps a switch statement should be used?
        }
        task.resume()
    }

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
