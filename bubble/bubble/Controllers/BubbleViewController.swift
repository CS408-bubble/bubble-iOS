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
        bubbleTextField.text = currentBubble.text
        
        //timeTextField.text = ("\(currentBubble.timestamp)")
        
        ownerTextField.text = currentBubble.owner
        // Do any additional setup after loading the view.
    }

    @IBAction func upVote(_ sender: Any) {
        
    }
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
