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
    
    func registerEmail(userData: [String: Any], success: @escaping (User)->(), failure: @escaping (Error)->()) {
        var userData = userData
        userData["postCount"] = 0
        let email = userData["email"] as! String
        let password = userData["password"] as! String
        userData["password"] = nil
        userData["profilePictureURL"] = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                user?.delete(completion: nil)
                failure(error)
            } else if let user = user {
                userData["uid"] = user.uid
                DataService.instance.userCollection.document(user.uid).setData(userData, completion: { (error) in
                    if let error = error {
                        user.delete(completion: nil)
                        failure(error)
                    } else {
                        success(user)
                    }
                })
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
    
    func LogOutClicked() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("am out mann")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func signOut(success: @escaping (Bool) -> (Void)) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                success(false)
                print("Error signing out: %@", signOutError)
            }
            success(true)
        }
    }
    
    func deleteAccount(success: @escaping (Bool) -> (Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.deleteUser(uid: uid)
        Auth.auth().currentUser?.delete(completion: { (error) in
            if error != nil {
                success(false)
                print("Error deleting user: \(String(describing: error))")
            } else {
                success(true)
            }
        })
    }
    

    func deleteUser(user: User, success: @escaping (Bool)->(), failure: @escaping (Error)->()) {
        user.delete { (error) in
            if let error = error {
                failure(error)
            } else {
                success(true)
            }
        }
    }
    
    func loginOrRegisterWithFacebook(credential: AuthCredential, success: @escaping (User, [String: Any], Bool) -> (), failure: @escaping (Error) -> ()) {
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start { (request, result, error) in
            if let error = error {
                failure(error)
            } else if let result = result {
                let userInfo = result as! [String: Any]
                print(userInfo)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        failure(error)
                    } else if let user = user {
                        DataService.instance.userCollection.document(user.uid).getDocument(completion: { (userDoc, error) in
                            if let error = error {
                                failure(error)
                            } else if userDoc!.exists {
                                success(user, userInfo, true)
                            } else {
                                success(user, userInfo, false)
                            }
                        })
                        
                    }
                }
            }
        }
        
    }
    
    func registerFacebookUser(uid: String, userData: [String: Any], success: @escaping () ->(), failure: @escaping (Error) -> ()) {
        var userData = userData
        userData["postCount"] = 0
        userData["uid"] = uid
        
        DataService.instance.userCollection.document(uid).setData(userData, completion: { (error) in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        })
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
