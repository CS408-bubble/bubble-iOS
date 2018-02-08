//
//  CreateBubbleView.swift
//  bubble
//
//  Created by Siraj Zaneer on 2/8/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit

class CreateBubbleView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BubbleCreateView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
