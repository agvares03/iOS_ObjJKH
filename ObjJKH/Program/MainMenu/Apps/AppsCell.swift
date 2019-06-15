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

class LsAddAppsCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var textLS: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
class TypeAddAppsCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var textType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
class FileAddAppsCell: UITableViewCell {
    
    var delegate: UIViewController?
    var delegate2: DelFileAppCellDelegate?
    var ident = -1
    
    @IBOutlet weak var textFile: UILabel!
    @IBOutlet weak var iconFile: UIImageView!
    @IBOutlet weak var delIconFile: UIImageView!
    @IBOutlet weak var delFileBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addAppAction(_ sender: UIButton) {
        delegate2?.delFileLs(ident: ident, name: textFile.text!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
