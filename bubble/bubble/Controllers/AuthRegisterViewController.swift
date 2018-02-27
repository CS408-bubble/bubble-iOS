//
//  AuthRegisterViewController.swift
//  bubble
//
//  Created by Abdul Aziz Bah on 2/13/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import Firebase

class AuthRegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    
    
    @IBAction func onContinue(_ sender: Any) {
        
        guard let fullName = fullNameField.text, !fullName.isEmpty else {
            let alert = UIAlertController(title: "Warning", message: "Enter Fullname", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let email = emailField.text, !email.isEmpty else {
            let alert = UIAlertController(title: "Warning", message: "Enter Email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "Warning", message: "Enter Password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty else {
            let alert = UIAlertController(title: "Warning", message: "Enter Password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if(confirmPassword != password){
            let alert = UIAlertController(title: "Warning", message: "Password Mismatch", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        AuthService.sharedInstance.registerEmail(email: emailField.text!, password: passwordField.text!, confirmPassword: confirmPasswordField.text!, success:{
           (true) in
            
           
            print("Account Created")
            let userData: [String:Any] = [
            "name" : fullName,
            "uid" : Auth.auth().currentUser?.uid,
            "email": email,
            "postCount": 0]

            DataService.instance.createOrUpdateUser(uid: "", userData: userData)
            self.performSegue(withIdentifier: "segueOnSuccessfulActCreated", sender: self)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
