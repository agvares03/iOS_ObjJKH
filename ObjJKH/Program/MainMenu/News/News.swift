//
//  News.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import Foundation

class News {
    let idNews:String
    let created:String
    let text:String
    let header:String
    
    init(IdNews:String,Created:String,Text:String,Header:String) {
        self.idNews = IdNews
        self.created = Created
        self.text = Text
        self.header = Header
    }
}
