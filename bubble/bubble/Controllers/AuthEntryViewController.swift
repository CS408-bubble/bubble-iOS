//
//  AuthEntryViewController.swift
//  bubble
//
//  Created by Abdul Aziz Bah on 2/18/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class AuthEntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //FBSDKAccessToken.currentAccessToken()
        if(FBSDKAccessToken.current() != nil){
            print("// logged in")
            /*DispatchQueue.main.async() {
                //do something
                let storyboard: UIStoryboard = UIStoryboard(name: "main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AuthLoginViewController")
                self.show(vc, sender: self)
            }*/
            //self.performSegue(withIdentifier: "segueOnAlreadyLogin", sender: self)
            print("// logged in 2")
        }else{
            print("// not logged in")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "segueOnAlreadyLogin") {
            let storyboard: UIStoryboard = UIStoryboard(name: "AccountAuthStoryboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SucessViewController")
            self.show(vc, sender: self)
        }
    }
    

}
