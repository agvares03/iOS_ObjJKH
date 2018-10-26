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
        if !news.readed{
            self.headerNewsLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            self.headerNewsLabel.textColor = .black
            self.textNewsLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            self.textNewsLabel.textColor = .black
            self.dataCreatedNewsLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
            self.dataCreatedNewsLabel.textColor = .black
        }else{
            self.headerNewsLabel.font = UIFont.systemFont(ofSize: 16.0)
            self.headerNewsLabel.textColor = .black
            self.textNewsLabel.font = UIFont.systemFont(ofSize: 16.0)
            self.textNewsLabel.textColor = .lightGray
            self.dataCreatedNewsLabel.font = UIFont.systemFont(ofSize: 13.0)
            self.dataCreatedNewsLabel.textColor = .black
        }
        self.headerNewsLabel.text = news.header
        self.textNewsLabel.text = news.text
        self.dataCreatedNewsLabel.text = news.created
    }

}
