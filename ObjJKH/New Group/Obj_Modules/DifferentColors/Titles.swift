//
//  Titles.swift
//  ObjJKH
//
//  Created by Роман Тузин on 04.10.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class Titles {
    
    public func getTitle(numb: String) -> String {
        let defaults = UserDefaults.standard
        let answer = defaults.string(forKey: "menu_" + numb)?.components(separatedBy: ";")
        let rezult: String = (answer?[1])!
        
        return rezult
    }
    
    public func getSimpleTitle(numb: String) -> String {
        let defaults = UserDefaults.standard
        let answer = defaults.string(forKey: "menu_" + numb)?.components(separatedBy: ";")
        let rezult: String = (answer?[3])!
        
        return rezult
    }
    
}
