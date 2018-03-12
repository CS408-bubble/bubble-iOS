//
//  ProfileViewController.swift
//  bubble
//
//  Created by Dhruv Upadhyay on 3/9/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var bioTextView: UITextView!
    
    var currentUser: BubbleUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCurrentUser()
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            performSegue(withIdentifier: "PostedBubbles", sender: self)
        }
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Settings", let settingsVC = segue.destination as? ProfileSettingsViewController {
            settingsVC.currentUser = currentUser
            settingsVC.profilePictureImage = profilePicture.image
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("NO USER!")
            return
            
        }
        DataService.instance.getUser(userID: uid) { (user) in
            self.currentUser = user
            
            print("GETTING USER ON PROFILE")
            DispatchQueue.main.async {
                self.nameLabel.text = self.currentUser.name
                self.bioTextView.text = self.currentUser.bio.isEmpty ? "No Bio": self.currentUser?.bio
            }
            
            DataService.instance.getProfilePicture(user: self.currentUser, handler: { (image) in
                DispatchQueue.main.async {
                    self.profilePicture.image = image
                }
            })
        }
    }
}
