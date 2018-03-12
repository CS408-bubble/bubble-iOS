//
//  UserBubblesViewController.swift
//  bubble
//
//  Created by Dhruv Upadhyay on 3/11/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserBubblesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bubblesTableView: UITableView!
    var bubbles: [Bubble] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bubblesTableView.delegate = self
        bubblesTableView.dataSource = self
        
        getBubbles()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bubbles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BubbleCell", for: indexPath) as? BubbleCell else {
            return BubbleCell()
        }
        
        cell.configureCell(bubble: bubbles[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let cell = bubblesTableView.cellForRow(at: indexPath) as? BubbleCell else { return }
        
        if editingStyle == .delete {
            DataService.instance.deleteBubble(bubble: cell.bubble, success: { (sucess) in
                print("BUBBLE DELETED!")
                self.getBubbles()
            }, failure: { (error) in
                print("BUBBLE DELETE ERROR: \(error.localizedDescription)")
            })
        }
    }
    
    func getBubbles() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.getUserBubbles(uid: uid, success: { (bubbles) in
            self.bubbles = bubbles
            self.bubblesTableView.reloadData()
        }) { (error) in
            print("USER BUBBLES ERROR: \(error.localizedDescription)")
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
