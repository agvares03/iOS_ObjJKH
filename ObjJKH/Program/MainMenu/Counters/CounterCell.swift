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
    
    @IBOutlet weak var pred: UILabel!
    @IBOutlet weak var teck: UILabel!
    @IBOutlet weak var diff: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
