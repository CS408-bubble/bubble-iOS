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
import FirebaseStorage

class DataService {
    
    // Static instance variable used to call DataService functions
    static let instance = DataService()
    
    //var userData: [String:Any]
    
    // TODO: Add references for database
    let db = Firestore.firestore()
    let userCollection = Firestore.firestore().collection("user")
    private var _REF_PROFILE_PICS = Storage.storage().reference().child("profile-pics")
    
    let bubbleCollection = Firestore.firestore().collection("Bubble")
    let bubbleVoteCollection = Firestore.firestore().collection("BubbleVote")
    
    var REF_PROFILE_PICS: StorageReference {
        return _REF_PROFILE_PICS
    }
    
    // TODO: complete following functions: createUser, getUser, getProfilePicture
    
    // Adds/updates user's entry in the Firebase database
    func updateUser(uid: String, userData: [String:Any]) {
        userCollection.document(uid).updateData(userData) { (error) in
            if error != nil {
                print("USER UPDATE ERROR: \(error?.localizedDescription)")
            } else {
                print("USER UPDATED!")
            }
        }
    }
    
    func deleteUser(uid: String) {
        userCollection.document(uid).delete()
    }
    
    // Retrives user based on userID/user's key in Firebase
    func getUser(userID: String,  handler: @escaping (_ user: BubbleUser) -> ()) {
        userCollection.document(userID).getDocument { (snapshot, error) in
            
            if error != nil {
                print("GET USER ERROR: \(error?.localizedDescription)")
                return
            }
            
            guard let userDict = snapshot?.data() else { return }
            let user = BubbleUser(userDict: userDict, userID: userID)
            return handler(user)
        }
    }
    
    // Gets a user's profile picture from Firebase Storage
    func getProfilePicture(user: BubbleUser, handler: @escaping (_ image: UIImage) -> ()) {
        guard let url = URL(string: user.profilePictureURL) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        
        //creating a dataTask to get profile picture
        let getImageFromUrl = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                //displaying the message
                print("Error downloading image: \(String(describing: error))")
            } else {
                guard let _ = response as? HTTPURLResponse else {
                    print("No response from server")
                    return
                }
                
                if let imageData = data {
                    guard let image = UIImage(data: imageData) else {
                        return
                    }
                    
                    handler(image)
                    return
                } else {
                    print("Image file is corrupted")
                }
            }
        }
        
        getImageFromUrl.resume()
    }

    // Creates a Bubble given dictionary of information
    func createBubble(bubbleData: [String: Any], latitude: Double, longitude: Double, success: @escaping (Bubble) ->(), failure: @escaping (Error) -> ()) {
        var bubbleData = bubbleData
        let bubblePoint = GeoPoint(latitude: longitude, longitude: latitude)
        let bubbleDoc = bubbleCollection.document()
        let voteList = bubbleVoteCollection.document(bubbleDoc.documentID)
        
        bubbleData["uid"] = bubbleDoc.documentID
        bubbleData["voteCount"] = 0
        bubbleData["location"] = bubblePoint
        bubbleData["timestamp"] = Date().timeIntervalSince1970
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            transaction.setData(bubbleData, forDocument: bubbleDoc)
            transaction.setData([:], forDocument: voteList)
            
            return bubbleData
        }, completion: { (bubbleData, error) in
            if let error = error {
                failure(error)
            } else if let bubbleData = bubbleData as? [String: Any] {
            }
        })
    }
  
    // Returns all bubbles from database TODO: Only return nearest bubbles
    func getBubbles(latitude: Double, longitude: Double, success: @escaping ([Bubble]) -> (), failure: @escaping (Error) -> ()) {
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        
        let lowerLat = latitude - (lat * 1.0)
        let lowerLon = longitude - (lon * 1.0)
        
        let greaterLat = latitude + (lat * 1.0)
        let greaterLon = longitude + (lon * 1.0)
        
        let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)
        
        bubbleCollection.whereField("location", isGreaterThan: lesserGeopoint).whereField("location", isLessThan: greaterGeopoint).getDocuments { (bubblesSnapshot, error) in
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
    
    // Returns all user bubbles from database TODO: Only return nearest bubbles
    func getUserBubbles(uid: String, success: @escaping ([Bubble]) -> (), failure: @escaping (Error) -> ()) {
        bubbleCollection.whereField("owner", isEqualTo: uid).getDocuments { (bubblesSnapshot, error) in
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
    
    func voteBubble(bubble: Bubble, uid: String, success: @escaping (Int) ->(), failure: @escaping (Error) -> ()) {
        
        let bubbleRef = bubbleCollection.document(bubble.uid)
        let votingRef = bubbleVoteCollection.document(bubble.uid)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            var bubbleDoc: DocumentSnapshot
            do {
                bubbleDoc = try transaction.getDocument(bubbleRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            let bubbleData = bubbleDoc.data()
            let oldVoteCount = bubbleData!["voteCount"] as! Int
            
            let newVoteCount = oldVoteCount - 1
            
            transaction.updateData(["voteCount": newVoteCount], forDocument: bubbleRef)
            transaction.updateData([uid: true], forDocument: votingRef)
            return newVoteCount
        }, completion: { (object, error) in
            if let error = error {
                failure(error)
            } else {
                success(object as! Int)
            }
        })
    }
    
    func unvoteBubble(bubble: Bubble, uid: String, success: @escaping (Int) ->(), failure: @escaping (Error) -> ()) {
        
        let bubbleRef = bubbleCollection.document(bubble.uid)
        let votingRef = bubbleVoteCollection.document(bubble.uid)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            var bubbleDoc: DocumentSnapshot
            do {
                bubbleDoc = try transaction.getDocument(bubbleRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            let bubbleData = bubbleDoc.data()
            let oldVoteCount = bubbleData!["voteCount"] as! Int
            
            let newVoteCount = oldVoteCount + 1
            
            transaction.updateData(["voteCount": newVoteCount], forDocument: bubbleRef)
            transaction.updateData([uid: false], forDocument: votingRef)
            return newVoteCount
        }, completion: { (object, error) in
            if let error = error {
                failure(error)
            } else {
                success(object as! Int)
            }
        })
    }
    
    func deleteUserData(uid: String, success: @escaping (Bool)->(), failure: @escaping (Error)->()) {
        userCollection.document(uid).setData([:]) { (error) in
            if let error = error {
                failure(error)
            } else {
                success(true)
            }
        }
    }
    
    func deleteBubble(bubble: Bubble, success: @escaping (Bool) ->(), failure: @escaping (Error) -> ()) {
        
        let bubbleRef = bubbleCollection.document(bubble.uid)
        let votingRef = bubbleVoteCollection.document(bubble.uid)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            transaction.deleteDocument(bubbleRef)
            transaction.deleteDocument(votingRef)
            
            return nil
        }, completion: { (object, error) in
            if let error = error {
                failure(error)
            } else {
                success(true)
            }
        })
    }
    
}
