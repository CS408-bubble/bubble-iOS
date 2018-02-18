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
    let db = Firestore.firestore()
    let userCollection = Firestore.firestore().collection("User")
    let userImageCollection = Firestore.firestore().collection("UserImage")
    
    let bubbleCollection = Firestore.firestore().collection("Bubble")
    let bubbleVoteCollection = Firestore.firestore().collection("BubbleVote")
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
    
    // Creates a Bubble given dictionary of information
    func createBubble(bubbleData: [String: Any], latitude: Double, longitude: Double, success: @escaping (Bubble) ->(), failure: @escaping (Error) -> ()) {
        var bubbleData = bubbleData
        let bubblePoint = GeoPoint(latitude: latitude, longitude: longitude)
        let bubbleDoc = bubbleCollection.document()
        let voteList = bubbleVoteCollection.document(bubbleDoc.documentID)
        
        bubbleData["uid"] = bubbleDoc.documentID
        bubbleData["voteCount"] = 0
        bubbleData["location"] = bubblePoint
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            transaction.setData(bubbleData, forDocument: bubbleDoc)
            transaction.setData([:], forDocument: voteList)
            
            return bubbleData
        }, completion: { (bubbleData, error) in
            if let error = error {
                failure(error)
            } else if let bubbleData = bubbleData as? [String: Any] {
                success(Bubble(bubbleData: bubbleData))
            }
        })
    }
  
    // Returns all bubbles from database TODO: Only return nearest bubbles
    func getBubbles(latitude: Double, longitude: Double, success: @escaping ([Bubble]) -> (), failure: @escaping (Error) -> ()) {
        bubbleCollection.getDocuments { (bubblesSnapshot, error) in
            if let error = error {
                failure(error)
            } else {
                var bubbleResult: [Bubble] = []
                guard let bubbles = bubblesSnapshot?.documents else {
                    success(bubbleResult)
                    return
                }
                
                for bubble in bubbles {
                    bubbleResult.append(Bubble(bubbleData: bubble.data()))
                }
                
                success(bubbleResult)
            }
        }
        
    }
}
