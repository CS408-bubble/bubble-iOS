//
//  ProfileSettingsViewController.swift
//  bubble
//
//  Created by Dhruv Upadhyay on 3/9/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import FirebaseStorage
import MessageUI

class ProfileSettingsViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var bioTextView: UITextView!
    
    var imagePicker: UIImagePickerController!
    var currentUser: BubbleUser!
    var profilePictureImage: UIImage? = #imageLiteral(resourceName: "profile-pic")
    var profilePictureURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bioTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2
            self.profilePicture.image = self.profilePictureImage
            self.bioTextView.text = self.currentUser.bio ?? "No bio"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        saveUserInfo()
        dismiss(animated: true, completion: nil)
    }
    
    
    func deleteAccount() {
        AuthService.sharedInstance.deleteAccount { (success) -> (Void) in
            if success {
                print("SUCCESS DELETE ACCOUNT")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "SignIn", sender: self)
                }
            } else {
                print("DELETE ACCOUNT FAILED")
            }
        }
    }
    
    func saveUserInfo() {
        print("SAVING URL: \(profilePictureURL)")
        var userData = ["bio": bioTextView.text, "profilePictureURL": profilePictureURL ?? "no picture"] as [String : Any]
        
        if profilePictureURL != nil {
            userData["profilePictureURL"] = profilePictureURL
        }
        
        DataService.instance.updateUser(uid: currentUser.userID, userData: userData)
        
    }
    
    func logOut() {
        AuthService.sharedInstance.signOut { (success) -> (Void) in
            if success {
                print("SUCCESS SIGN OUT")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "SignIn", sender: self)
                }
            } else {
                print("SIGN OUT FAILED")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("CELL SELECTED: \(indexPath.section)")
        if indexPath.section == 1, indexPath.row == 3 {
            print("LOG OUT PRESSED")
            logOut()
        }
        
        if indexPath.section == 1, indexPath.row == 2 {
            print("DELETE ACCOUNT PRESSED")
            
            let alert = UIAlertController(title: "Deleting Account", message: "Are you sure you want to delete your account? This cannot be undone!", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                self.deleteAccount()
            })
            
            let no = UIAlertAction(title: "No", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(yes)
            alert.addAction(no)
            self.present(alert, animated: true, completion: nil)
        }
        
        if indexPath.section == 2, indexPath.row == 0 {
            let mailComposeViewController = configureMailController()
            if(MFMailComposeViewController.canSendMail()){
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else{
                showMailError()
            }
        }
    }
    
    
    @IBAction func editPicturePressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("A VALID IMAGE WAS NOT SELECTED")
            return
        }
        
        DispatchQueue.main.async {
            self.profilePicture.image = selectedImage
        }
        
        profilePictureImage = selectedImage
        guard let profileImage = profilePictureImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.2) else {
            return
        }
        
        let imageUID = NSUUID().uuidString
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        DataService.instance.REF_PROFILE_PICS.child(imageUID).putData(imageData, metadata: metaData) { (metaData, error) in
            
            if error != nil {
                print("IMAGE UPLOAD ERROR: Image wasn't uploaded to Firebase")
            } else {
                print("IMAGE UPLOAD SUCCESS: Image was uploaded to Firebase")
                guard let imageURL = metaData?.downloadURL()?.absoluteString else {
                    return
                }
                
                self.profilePictureURL = imageURL
                print("IMAGE URL: \(String(describing: self.profilePictureURL))")
                
            }
        }
        
        DispatchQueue.main.async {
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let count = bioTextView.text.count
        if range.length + range.location > count {
            return false
        }
        
        let newLength = count + text.count - range.length
        return newLength <= 140
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func configureMailController() -> MFMailComposeViewController{
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["cs307idebate@gmail.com"])
        mailComposerVC.setSubject("Feedback")
        return mailComposerVC
    }
    func showMailError(){
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device couldn't send the email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

