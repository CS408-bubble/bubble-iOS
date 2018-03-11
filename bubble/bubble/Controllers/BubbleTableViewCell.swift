//
//  BubbleTableViewCell.swift
//  bubble
//
//  Created by Abdul Aziz Bah on 3/11/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit

class BubbleTableViewCell: UITableViewCell {

    @IBOutlet weak var bubbleTextField: UILabel!
    @IBOutlet weak var countTextField: UILabel!
    @IBOutlet weak var timeTextField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
