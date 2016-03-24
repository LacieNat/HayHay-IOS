//
//  ThreadTableViewCell.swift
//  HayHay
//
//  Created by Lacie on 3/21/16.
//  Copyright © 2016 Lacie. All rights reserved.
//

import UIKit

class ThreadTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var topicIcon: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
