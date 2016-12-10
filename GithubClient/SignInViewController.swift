//
//  SignInViewController.swift
//  GithubClient
//
//  Created by Sau Chung Loh on 12/1/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        if UserDefaults.standard.object(forKey: "GithubAccessToken") != nil {
//            print("Can send to new VC")
//            //Will this create multiple instances?
//            let menuTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuTabBarController") as! UITabBarController
//            present(menuTabBarController, animated: true, completion: nil)
            dismiss(animated: true, completion: nil)
        }
        
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
