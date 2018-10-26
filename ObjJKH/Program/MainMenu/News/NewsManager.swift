//
//  NewsManager.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import Foundation
typealias Handler = () -> Void

class NewsManager {
    static let instance = NewsManager()
    private let newsClient = NewsClient()
    var completionLoaded:Handler?
    
    private var newsList:[News] = [News]()
    
    func loadNewsIfNeed() {
        newsClient.getNews { [weak self] (list) in
            self?.newsList = list
            self?.completionLoaded?()
        }
    }
    
    func loadNews() {
        newsList.removeAll()
        newsClient.getNews { [weak self] (list) in
            self?.newsList = list
            self?.completionLoaded?()
        }
        
    }
    
    func getNewsList() -> [News] {
        return self.newsList
    }
}
