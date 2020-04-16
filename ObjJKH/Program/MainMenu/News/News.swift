//
//  News.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import Foundation
import Gloss

struct NewsJson: JSONDecodable {
    
    let data: [NewsDataJson]?
    
    init?(json: JSON) {
        data = "data" <~~ json
    }
    
}

struct NewsDataJson: JSONDecodable {
    
    let idNews:Int64?
    let created:String?
    let text:String?
    let header:String?
    let readed:Bool?
    let questionID:Int64?
    
    init?(json: JSON) {
        idNews      = "ID"              <~~ json
        created     = "Created"         <~~ json
        text        = "Text"            <~~ json
        header      = "Header"          <~~ json
        readed      = "IsReaded"        <~~ json
        questionID  = "QuestionGroupID" <~~ json
    }
}

class News {
    let idNews:String
    let created:String
    let text:String
    let header:String
    let readed:Bool
    let questionID:String
    
    init(IdNews:String,Created:String,Text:String,Header:String,Readed:Bool,QuestionID:String) {
        self.idNews = IdNews
        self.created = Created
        self.text = Text
        self.header = Header
        self.readed = Readed
        self.questionID = QuestionID
    }
}
