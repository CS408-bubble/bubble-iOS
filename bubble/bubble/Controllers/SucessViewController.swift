//
//  SucessViewController.swift
//  bubble
//
//  Created by Abdul Aziz Bah on 2/11/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
//import FacebookLogin
import Firebase
class SucessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       /* if AccessToken.current != nil {
            // User is logged in, use 'accessToken' here.
            //loginButton = LoginButton(readPermissions: [ .publicProfile, .Email, .UserFriends ])
            
        }*/
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
    @IBAction func LogOutClick(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("am out mann")
            self.performSegue(withIdentifier: "segueOnSuccessfulLogOut", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

