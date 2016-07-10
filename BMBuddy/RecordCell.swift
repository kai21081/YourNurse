//
//  RecordCell.swift
//  BMBuddy
//
//  Created by Jung Kim on 3/23/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {

    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var voidCheckView: UIView!
    @IBOutlet weak var bmCheckView: UIView!
    @IBOutlet weak var accidentCheckView: UIView!
    @IBOutlet weak var dryRunCheckView: UIView!
    @IBOutlet weak var skippedView: UIView!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var voidCheckImage: UIImageView!
    @IBOutlet weak var bmCheckImage: UIImageView!
    @IBOutlet weak var accidentCheckImage: UIImageView!
    @IBOutlet weak var dryRunCheckImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.timeView.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.timeView.layer.borderWidth = 1
        self.voidCheckView.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.voidCheckView.layer.borderWidth = 1
        self.bmCheckView.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.bmCheckView.layer.borderWidth = 1
        self.accidentCheckView.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.accidentCheckView.layer.borderWidth = 1
        self.dryRunCheckView.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.dryRunCheckView.layer.borderWidth = 1
        self.voidCheckView.backgroundColor = UIColor.lightGrayColor()
        self.accidentCheckView.backgroundColor = UIColor.lightGrayColor()
        self.skippedView.layer.borderWidth = 1
        self.skippedView.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.skippedView.backgroundColor = UIColor.lightGrayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
