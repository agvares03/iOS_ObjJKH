//
//  SaldoCell.swift
//  ObjJKH
//
//  Created by Роман Тузин on 30.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class SaldoCell: UITableViewCell {
    
    var delegate: UIViewController?

    @IBOutlet weak var usluga: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var plus: UILabel!
    @IBOutlet weak var minus: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var pays: UILabel!
    @IBOutlet weak var totalSum: UILabel!
    @IBOutlet weak var lblHeight1: NSLayoutConstraint!
    @IBOutlet weak var lblHeight2: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.start.adjustsFontSizeToFitWidth = true
        self.plus.adjustsFontSizeToFitWidth = true
        self.minus.adjustsFontSizeToFitWidth = true
        self.end.adjustsFontSizeToFitWidth = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.start.text = nil
        self.plus.text = nil
        self.minus.text = nil
        self.end.text = nil
        self.usluga.text = nil
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
