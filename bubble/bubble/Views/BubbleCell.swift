//
//  BubbleCell.swift
//  bubble
//
//  Created by Dhruv Upadhyay on 3/11/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit

class BubbleCell: UITableViewCell {
    @IBOutlet var bubbleText: UITextView!
    var bubble: Bubble!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(bubble: Bubble) {
        self.bubble = bubble
        bubbleText.text = bubble.text
    }

}
