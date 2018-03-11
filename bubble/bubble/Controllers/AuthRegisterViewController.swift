//
//  AuthRegisterViewController.swift
//  bubble
//
//  Created by Abdul Aziz Bah on 2/13/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import Firebase

class AuthRegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        fullNameField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        } else if textField == confirmPasswordField {
            textField.endEditing(true)
        }

        return true
    }
    
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
        
        let newUserData: [String: Any] = [
            "name" : fullName,
            "password": password,
            "email": email]
        
        view.isUserInteractionEnabled = false
        AuthService.sharedInstance.registerEmail(userData: newUserData, success: { (newUser) in
            self.performSegue(withIdentifier: "segueOnSuccessfulActCreated", sender: self)
            self.view.isUserInteractionEnabled = true
        }) { (error) in
            print(error.localizedDescription)
            self.view.isUserInteractionEnabled = true
        }
    }
}
