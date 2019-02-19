//
//  CounterCell.swift
//  ObjJKH
//
//  Created by Роман Тузин on 29.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class CounterCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var ident: UILabel!
    @IBOutlet weak var imgCounter: UIImageView!
    @IBOutlet weak var viewImgCounter: UIView!
    
    @IBOutlet weak var pred: UILabel!
    @IBOutlet weak var teck: UILabel!
    @IBOutlet weak var diff: UILabel!
    
    @IBOutlet weak var predLbl: UILabel!
    @IBOutlet weak var teckLbl: UILabel!
    @IBOutlet weak var diffLbl: UILabel!
    
    @IBOutlet weak var nonCounter: UILabel!
    @IBOutlet weak var sendCounter: UILabel!
    
    @IBOutlet weak var lblHeight1: NSLayoutConstraint!
    @IBOutlet weak var lblHeight2: NSLayoutConstraint!
    @IBOutlet weak var lblHeight3: NSLayoutConstraint!
    @IBOutlet weak var lblHeight4: NSLayoutConstraint!
    @IBOutlet weak var lblHeight5: NSLayoutConstraint!
    @IBOutlet weak var lblHeight6: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
