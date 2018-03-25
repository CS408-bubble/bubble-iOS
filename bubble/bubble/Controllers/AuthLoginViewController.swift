//
//  AuthLoginViewController.swift
//  bubble
//
//  Created by Abdul Aziz Bah on 2/15/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
//import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class AuthLoginViewController: UIViewController, GIDSignInUIDelegate {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var googleBTN: GIDSignInButton!
    @IBOutlet weak var fbButton: FBSDKLoginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

        fbButton.delegate = self
        fbButton.readPermissions = ["email", "public_profile"]
        fbButton.layer.cornerRadius = 5;
       //*********** AuthService.sharedInstance.googleSignInDelegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view.
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }

    @IBAction func onLoginBtn(_ sender: Any) {

        guard let email = emailField.text, !email.isEmpty else {
            print("Enter email")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            print("Enter Password")
            return
        }

        AuthService.sharedInstance.signInEmail(email: email, password: password, success: {(true) in
            print("successfull Signed in")
            DataService.instance.getUser(userID: (Auth.auth().currentUser?.uid)!) { (user) in
             print(user.userID)
                print("pass retrieve")
            }
            self.performSegue(withIdentifier: "segueOnSuccessfulLogin", sender: self)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onGoogleLoginBTN(_ sender: Any) {
        
        
    }
    
    /**********@IBAction func onGoogleLoginBTN(_ sender: Any) {
        AuthService.sharedInstance.googleAuth(forVC: self)
    }*/

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "facebookSegue":
                let vc = segue.destination as! AuthRegisterViewController
                vc.userInfo = sender as! [String: Any]
            default:
                return
            }
        }
    }
}

extension AuthLoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        if (result.isCancelled) {
            return
        }
        
        print(result.description)
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        AuthService.sharedInstance.loginOrRegisterWithFacebook(credential: credential, success: { (user, userInfo, exists) -> () in
            if exists {
                self.performSegue(withIdentifier: "segueOnSuccessfulLogin", sender: nil)
            } else {
                self.performSegue(withIdentifier: "facebookSegue", sender: userInfo)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
}
