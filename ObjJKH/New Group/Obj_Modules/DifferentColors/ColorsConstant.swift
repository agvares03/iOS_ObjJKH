//
//  ColorsConstant.swift
//  ObjJKH
//
//  Created by Роман Тузин on 11.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

struct myColors {
    #if isMupRCMytishi
        static let btnColor = SchemeColor(сolor: UIColor.colorWithHex("#623c56"))
    #else
        static let btnColor = SchemeColor(сolor: UIColor.colorWithHex("#00BFFF"))
    #endif
    
    #if isMupRCMytishi
        static let labelColor = SchemeColor(сolor: UIColor.colorWithHex("#623c56"))
    #else
        static let labelColor = SchemeColor(сolor: UIColor.colorWithHex("#00BFFF"))
    #endif
    
    #if isMupRCMytishi
        static let indicatorColor = SchemeColor(сolor: UIColor.colorWithHex("#623c56"))
    #else
        static let indicatorColor = SchemeColor(сolor: UIColor.colorWithHex("#00BFFF"))
    #endif
}


