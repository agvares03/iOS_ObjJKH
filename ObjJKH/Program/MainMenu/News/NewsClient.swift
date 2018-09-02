//
//  NewsClient.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import Foundation
import Alamofire

class NewsClient {
    func getNews(completedBlock: @escaping (_ list:[News]) -> ()) {
        
        let defaults = UserDefaults.standard
        let login = defaults.string(forKey: "login")!
        
        let strUrl = Server.SERVER + Server.GET_NEWS
        let params:Parameters = ["phone":login]
        let url = URL(string: strUrl)!
        Alamofire.request(url,
                          method:HTTPMethod.get,
                          parameters: params,
                          encoding:URLEncoding.default,
                          headers: nil).responseJSON { (response) in
                            
                            guard response.result.isSuccess else {
                                print("Error while fetching tags: \(String(describing: response.result.error))")
                                return
                            }
                            
                            guard let responseJSON = response.result.value as? [String: Any] else {
                                print("Invalid tag information received from service")
                                return
                            }
                            
                            guard let data = responseJSON["data"] as? [[String: Any]] else {
                                print("Invalid tag information received from service")
                                return
                            }
                            
                            let newsList = data.map({ (dict) -> News in
                                let idNews = dict["ID"] as? Int ?? 0
                                let Created = dict["Created"] as? String ?? ""
                                let Header = dict["Header"] as? String ?? ""
                                let Text = dict["Text"] as? String ?? ""
                                
                                let newsObj = News(IdNews: String(idNews), Created: Created, Text: Text, Header: Header)
                                return newsObj
                            })
                            completedBlock(newsList)
        }
    }
}

