//
//  Web_JSON.swift
//  ObjJKH
//
//  Created by Роман Тузин on 01.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import Gloss

struct Web_Cameras_json: JSONDecodable {
    
    let data: [Web_Camera_json]?
    
    init?(json: JSON) {
        data = "data" <~~ json
    }
    
}

struct Web_Camera_json: JSONDecodable {
    
    let name:       String?
    let link:         String?
    
    init?(json: JSON) {
        name        = "Address"        <~~ json
        link        = "Url"            <~~ json
    }
    
}
