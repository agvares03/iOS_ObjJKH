//
//  CommCell.swift
//  ObjJKH
//
//  Created by Роман Тузин on 31.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class CommCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var text_comm: UILabel!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        author.textColor = myColors.labelColor.uiColor()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class NewCommCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var text_comm: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var heightDate: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        view.backgroundColor = myColors.labelColor.uiColor()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class NewCommFileCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var heightDate: NSLayoutConstraint!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var heightImg: NSLayoutConstraint!
    @IBOutlet weak var widthImg: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
