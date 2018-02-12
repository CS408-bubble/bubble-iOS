//
//  DataService.swift
//  bubble
//
//  Created by Dhruv Upadhyay on 2/8/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class DataService {
    
    // Static instance variable used to call DataService functions
    static let instance = DataService()

    // TODO: Add references for database
    
    /* private var _REF_USERS = something here
    
    var REF_USERS: some_type {
        return _REF_USERS
    }
     */
    
    // TODO: complete following functions: createOrUpdateUser, getUser, getProfilePicture
    
    // Adds/updates user's entry in the Firebase database
    func createOrUpdateUser(uid: String, userData: [String:Any]) {
        // add user to database
    }
    
    // Retrives user based on userID/user's key in Firebase
    func getUser(userID: String,  handler: @escaping (_ user: User) -> ()) {
        // retrieve user from database and send back using handler
    }
    
    // Gets a user's profile picture from Firebase Storage
    func getProfilePicture(user: User, handler: @escaping (_ image: UIImage) -> ()) {
        guard let url = URL(string: user.profilePictureURL) else {
            return
        }
        
       // get profile picture and send back using handler
    }
}
