//
//  AppsCell.swift
//  ObjJKH
//
//  Created by Роман Тузин on 31.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class AppsCell: UITableViewCell {
    
    var delegate: UIViewController?

    @IBOutlet weak var Number: UILabel!
    @IBOutlet weak var tema: UILabel!
    @IBOutlet weak var date_app: UILabel!
    @IBOutlet weak var image_app: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
