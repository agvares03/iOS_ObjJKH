//
//  NewsCell.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var dataCreatedNewsLabel: UILabel!
    @IBOutlet weak var headerNewsLabel: UILabel!
    @IBOutlet weak var textNewsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fiilBy(_ news:News) {
        self.headerNewsLabel.text = news.header
        self.textNewsLabel.text = news.text
        self.dataCreatedNewsLabel.text = news.created
    }

}
