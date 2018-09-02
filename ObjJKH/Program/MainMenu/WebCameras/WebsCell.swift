//
//  WebsCell.swift
//  ObjJKH
//
//  Created by Роман Тузин on 01.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class WebsCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    func display(_ item: Web_Camera_json) {
        
        name.text = item.name
        
    }
    
}
