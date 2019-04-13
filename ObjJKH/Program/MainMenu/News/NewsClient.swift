//
//  NewsClient.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

class NewsClient {
    
//    func getNews(completedBlock: @escaping (_ list:[News]) -> ()) {
//        var news_read = 0
//        let defaults = UserDefaults.standard
//        let login = defaults.string(forKey: "login")!
//
//        let strUrl = Server.SERVER + Server.GET_NEWS
//        let params:Parameters = ["phone":login]
//        let url = URL(string: strUrl)!
//
//
//        Alamofire.request(url,
//                          method:HTTPMethod.get,
//                          parameters: params,
//                          encoding:URLEncoding.default,
//                          headers: nil).responseJSON { (response) in
//                            guard response.result.isSuccess else {
//                                print("Error while fetching tags: \(String(describing: response.result.error))")
//                                return
//                            }
//
//                            guard let responseJSON = response.result.value as? [String: Any] else {
//                                print("Invalid tag information received from service")
//                                return
//                            }
//
//                            guard let data = responseJSON["data"] as? [[String: Any]] else {
//                                print("Invalid tag information received from service")
//                                return
//                            }
//                            let newsList = data.map({ (dict) -> News in
//                                let idNews = dict["ID"] as? Int ?? 0
//                                let Created = dict["Created"] as? String ?? ""
//                                let Header = dict["Header"] as? String ?? ""
//                                let Text = dict["Text"] as? String ?? ""
//                                let IsReaded = dict["IsReaded"] as? Bool
//                                if !IsReaded! {
//                                    //                request_read = UserDefaults.standard.integer(forKey: "request_read")
//                                    news_read += 1
//                                    UserDefaults.standard.setValue(news_read, forKey: "news_read")
//                                    UserDefaults.standard.synchronize()
//                                }
//                                let newsObj = News(IdNews: String(idNews), Created: Created, Text: Text, Header: Header, Readed: IsReaded!)
//                                return newsObj
//                            })
//                            completedBlock(newsList)
//        }
//    }
    
    func getNews(completedBlock: @escaping (_ list:[News]) -> ()){
        var news_read = 0
        let phone = UserDefaults.standard.string(forKey: "login") ?? ""
        //        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "accID=" + id)!)
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_NEWS + "phone=" + phone)!)
        request.httpMethod = "GET"
        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
            data, error, responce in
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            print("responseString = \(responseString)")
                                                
//            if error != nil {
//                print("ERROR")
//                return
//            }
            
            guard data != nil else { return }
                                                var newsList: [News] = []
                                                if !responseString.contains("error"){
                                                    let json = try? JSONSerialization.jsonObject(with: data!,
                                                                                                 options: .allowFragments)
                                                    let unfilteredData = NewsJson(json: json! as! JSON)?.data
                                                    
                                                    unfilteredData?.forEach { json in
                                                        if !json.readed! {
                                                            news_read += 1
                                                            UserDefaults.standard.setValue(news_read, forKey: "news_read")
                                                            UserDefaults.standard.synchronize()
                                                        }
                                                        let idNews = json.idNews
                                                        let Created = json.created
                                                        let Header = json.header
                                                        let Text = json.text
                                                        let IsReaded = json.readed
                                                        let newsObj = News(IdNews: String(idNews!), Created: Created!, Text: Text!, Header: Header!, Readed: IsReaded!)
                                                        newsList.append(newsObj)
                                                    }
                                                    
                                                    
                                                }
                                                completedBlock(newsList)
        })
        task.resume()
    }
    
}

