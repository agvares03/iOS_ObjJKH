//
//  ShemeColor.swift
//  ObjJKH
//
//  Created by Роман Тузин on 11.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

struct SchemeColor {
    
    let сolor: UIColor
    
    init(сolor: UIColor) {
        self.сolor = сolor
    }
    
    func uiColor() -> UIColor {
        return сolor
    }
    
    func cgColor() -> CGColor {
        return uiColor().cgColor
    }
    
}
