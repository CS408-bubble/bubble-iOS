//
//  BubbleViewController.swift
//  bubble
//
//  Created by Abdul Aziz Bah on 3/11/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit

class BubbleViewController: UIViewController {
    @IBOutlet weak var bubbleTextField: UILabel!
    @IBOutlet weak var ownerTextField: UILabel!
    @IBOutlet weak var bubbleoPopUpview: UIView!
    @IBOutlet weak var timeTextField: UILabel!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var upVoteButton: UIButton!
    @IBOutlet weak var downVoteButton: UIButton!
    
    var currentBubble: Bubble!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bubbleoPopUpview.layer.cornerRadius = 10
        bubbleoPopUpview.layer.masksToBounds = true
        upVoteButton.layer.cornerRadius = 20
        upVoteButton.layer.masksToBounds = true
        downVoteButton.layer.cornerRadius = 20
        downVoteButton.layer.masksToBounds = true
        bubbleTextField.numberOfLines = 0;
        bubbleTextField.text = "Hello My Dear you have opened the bubble"
        timeTextField.text = ("\(Date(timeIntervalSince1970: currentBubble.timestamp))")
        
        print("\("user.name")")
        print(currentBubble.uid)
        DataService.instance.getUser(userID: currentBubble.uid) { (user) in
              print("\(user.name)")
              self.ownerTextField.text = user.name
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func upVote(_ sender: Any) {
        print("init  up")
        print(currentBubble.uid)
        DataService.instance.voteBubble(bubble: currentBubble, uid: currentBubble.uid, success: {(bubbleResult) in
            print("up by one")
            print("\(bubbleResult)")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    @IBAction func downVote(_ sender: Any) {
        print("init  down")
        print(currentBubble.uid)
        DataService.instance.unvoteBubble(bubble: currentBubble, uid: currentBubble.uid, success: {(bubbleResult) in
            print("down by one")
            print("\(bubbleResult)")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    @IBAction func closePopUp(_ sender: Any) {
        print("this mis popup")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
