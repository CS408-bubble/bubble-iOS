//
//  BubbleTBViewController.swift
//  bubble
//
//  Created by Abdul Aziz Bah on 3/11/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import Firebase

class BubbleTBViewController: UIViewController,
UITableViewDelegate, UITableViewDataSource {
    let myuid:String = (Auth.auth().currentUser?.uid)!
    var gBubbleResult = [Bubble]()
    

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("hello")
        return self.gBubbleResult.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bubblecell", for: indexPath) as? BubbleTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let data = gBubbleResult[indexPath.row]
        // Configure the cell...
        cell.bubbleTextField.text = data.text
        cell.timeTextField.text = ("\(data.timestamp)")
        cell.countTextField.text = ("\(data.voteCount)")
        /*let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = gBubbleResult[indexPath.row].text*/
        return cell
    }

   
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        print(myuid)
        DataService.instance.getUserBubbles(uid: myuid, success: {(bubbleResult) in
            self.gBubbleResult = bubbleResult
            for bubbler in bubbleResult {
                print(bubbler.text)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
