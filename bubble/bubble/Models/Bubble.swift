//
//  Bubble.swift
//  bubble
//
//  Created by Siraj Zaneer on 2/8/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import Firebase

class Bubble {

    private(set) var text: String!
    private(set) var owner: String!
    private(set) var voteCount: Int!
    private(set) var uid: String!
    private(set) var geopoint: GeoPoint!
    private(set) var timestamp: Double!
    
    init(bubbleData: [String: Any]) {
        text = bubbleData["text"] as! String
        owner = bubbleData["owner"] as! String
        voteCount = bubbleData["voteCount"] as! Int
        uid = bubbleData["uid"] as! String
        geopoint = bubbleData["location"] as! GeoPoint
        timestamp = bubbleData["timestamp"] as! Double
    }
}
