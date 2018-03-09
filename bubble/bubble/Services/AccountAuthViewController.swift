//
//  AccountAuthViewController.swift
//  bubble
//
//  Created by Abdul Aziz Bah on 2/10/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class AccountAuthViewController: UIViewController, GIDSignInUIDelegate {

    
    // view objects
    @IBOutlet weak var usernameTxtFrmJU: UITextField!
    @IBOutlet weak var userPassTxtFrmJU: UITextField!
    @IBOutlet weak var cUserPassTxtFromJU: UITextField!
    @IBOutlet weak var usernameFrmTxtL: UITextField!
    @IBOutlet weak var userPassFrmTxtL: UITextField!
   
    @IBOutlet weak var loginBtnFrmWlc: UIButton!
    @IBOutlet weak var loginBtnFrmL: UIButton!
    @IBOutlet weak var cancelBtnFrmJU: UIButton!
    @IBOutlet weak var cancelBtnFrmL: UIButton!
    @IBOutlet weak var joinUsBtn: UIButton!
    
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var fbBtn: UIButton!
    
    
    
    @IBAction func joinUsClickFrmWlc(_ sender: Any) {
        print("joinUsClickFrmWlc")
        self.performSegue(withIdentifier: "segueToJoinUFrmWlc", sender: self)

    }
    
    @IBAction func logInClickFrmWlc(_ sender: Any) {
        print("logInClickFrmWlc")
        self.performSegue(withIdentifier: "segueToLogInFrmWlc", sender: self)

    }
    
    
    @IBAction func logInClickFrmL(_ sender: Any) {
        print("logInClickFrmWlc")
        guard let username = usernameFrmTxtL.text, !username.isEmpty else {
            let alert = UIAlertController(title: "Warning", message: "Please enter username", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let userPass = userPassFrmTxtL.text, !userPass.isEmpty else {
            
            let alert = UIAlertController(title: "Warning", message: "Please enter password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        signTheUserIn(email: username, password: userPass)
    }
    
    @IBAction func cancellClickFrmL(_ sender: Any) {
        print("logInClickFrmWlc")
        self.performSegue(withIdentifier: "segueBckToWlcPageFromSIN", sender: self)
    }
    
    
    @IBAction func continueClickJU(_ sender: Any) {
        guard let usernameFrmJU = usernameTxtFrmJU.text, !usernameFrmJU.isEmpty else {
            let alert = UIAlertController(title: "Warning", message: "Please enter username", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let userPassFrmJU = userPassTxtFrmJU.text, !userPassFrmJU.isEmpty else {
            let alert = UIAlertController(title: "Warning", message: "Please enter password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let cuserPassFrmJU = cUserPassTxtFromJU.text, !cuserPassFrmJU.isEmpty else {
            let alert = UIAlertController(title: "Warning", message: "Please confirm password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        Auth.auth().createUser(withEmail: usernameFrmJU, password: userPassFrmJU) { (user, error) in
            // ...
            if(user != nil){
                print("Account Created")
                self.performSegue(withIdentifier: "segueOnSuccessfulActCreated", sender: self)
            }else{
                if let the_error = error?.localizedDescription{
                    print(the_error)
                    let alert = UIAlertController(title: "Try Again", message: the_error, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    print("Error")
                }
            }
        }
    }
    
    @IBAction func cancellClickFrmJU(_ sender: Any) {
        print("logInClickFrmWlc")
        self.performSegue(withIdentifier: "segueBckToWlcPageFromSUP", sender: self)
    }
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()*/       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //helper to sign user in
    func signTheUserIn(email: String, password: String) {
        print("Alert: \(email) | \(password)")
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if(user != nil){
                print("successfull Signed in")
                self.performSegue(withIdentifier: "segueOnSuccessfulLogin", sender: self)
            }else{
                if let the_error = error?.localizedDescription{
                    print(the_error)
                    let alert = UIAlertController(title: "Try Again", message: "Invalid Username or Password", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    print("Error")
                }
            }
        }
    }
}
