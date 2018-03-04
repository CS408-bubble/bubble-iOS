//
//  AuthService.swift
//  bubble
//
//  Created by Abdul Aziz Bah on 2/13/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase
import FBSDKCoreKit
import FacebookCore

class AuthService {
     static var sharedInstance = AuthService()
    
    
    func registerEmail(email: String, password: String, confirmPassword: String, success: @escaping (Bool)->(), failure: @escaping (Error)->()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                failure(error)
            } else if user != nil {
                success(true)
            }
        }
    }
    
    func signInEmail(email: String, password: String, success: @escaping (Bool)->(), failure: @escaping (Error)->()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                failure(error)
            } else if user != nil {
                success(true)
            }
        } 
    }
    

/*class AuthService : NSObject, GIDSignInDelegate{
    //class AuthService {
    static var sharedInstance = AuthService()
    //var googleSignInDelegate: GoogleSignInDelegate?
    
    private override init () {
        super.init()
         GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
         GIDSignIn.sharedInstance().delegate = self
    }
        
//    func registerEmail(email: String, password: String, confirmPassword: String, success: @escaping ()->(), failure: @escaping (Error)->()) {
        
    func registerEmail(email: String, password: String, confirmPassword: String, success: @escaping (Bool)->(), failure: @escaping (Error)->()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                failure(error)
            } else if user != nil {
                success(true)
            }
        }
    }
    
    func signInEmail(email: String, password: String, success: @escaping (Bool)->(), failure: @escaping (Error)->()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                failure(error)
            } else if user != nil {
                success(true)
            }
        }
    }
    func googleAuth(forVC vc: AuthLoginViewController){
        GIDSignIn.sharedInstance().uiDelegate = vc
        GIDSignIn.sharedInstance().signIn()
        
        let user = Auth.auth().currentUser;
        
        if ((user) != nil) {
            vc.performSegue(withIdentifier: "segueOnSuccessfulLogin", sender: self)
        } else {
            print("google sign in fails")
        }
    }
        
         @available(iOS 9.0, *)
         func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
         -> Bool {
             return GIDSignIn.sharedInstance().handle(url,
             sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
             annotation: [:])
         }
         func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
             return GIDSignIn.sharedInstance().handle(url,
             sourceApplication: sourceApplication,
             annotation: annotation)
         }
         
         func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
             if error != nil {
                 print("\(String(describing: error?.localizedDescription))")
                 return
             }
            
             guard let authentication = user.authentication else { return }
             let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
             accessToken: authentication.accessToken)
            
             let userDict: [String: Any] = ["firstName": user.profile.givenName, "lastName": user.profile.familyName, "fullName": user.profile.name, "email": user.profile.email, "provider": credential.provider]
            
            print(userDict);
             Auth.auth().signIn(with: credential) { (user, error) in
             if error != nil {
                 print("\(String(describing: error?.localizedDescription))")
                 return
             }
                // User is signed in
                print("User is signed in")
             }
         }
         func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
         // Perform any operations when the user disconnects from app here.
         if error != nil {
         // ...
            print("\(String(describing: error?.localizedDescription))")
            return
         }
            print("move out")
         }
  
*/
}
