//
//  BubbleUser.swift
//  bubble
//
//  Created by Dhruv Upadhyay on 2/8/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import Foundation

class BubbleUser {
    private var _name: String!
    private var _email: String!
    private var _userID: String!
    private var _bio: String?
    private var _profilePictureURL: String?
    private var _userDict: [String:Any]!
    
    // TODO: Add other user class properties (include private variables with getters)
    
    var name: String {
        return _name
    }
    
    var email: String {
        return _email
    }
    
    var userID: String {
        return _userID
    }
    
    var bio: String {
        return _bio ?? ""
    }
    
    var profilePictureURL: String {
        return _profilePictureURL ?? ""
    }
    
    var userDict: [String:Any] {
        return _userDict
    }
    
    init(userDict: [String:Any], userID: String) {
        
        // TODO: Complete intializer once other properties have been added to the class
        
        self._userDict = userDict
        
        self._userID = userID
        
        if let name = userDict["name"] as? String {
            self._name = name
        }
        
        if let email = userDict["email"] as? String {
            self._email = email
        }
        
        if let bio = userDict["bio"] as? String {
            self._bio = bio
        }
        
        if let profilePictureURL = userDict["profilePictureURL"] as? String {
            self._profilePictureURL = profilePictureURL
        }
    }
}
