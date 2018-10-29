//
//  NewsView.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class NewsView: UIViewController {
    
    var newsTitle: String?
    var newsData: String?
    var newsText: String?
    var newsRead: Bool?
    var newsId: String?
    
    @IBOutlet weak var NewsTitle: UILabel!
    @IBOutlet weak var NewsData: UILabel!
    @IBOutlet weak var NewsText: UILabel!
    
    @IBOutlet weak var nav_bottom: UINavigationItem!
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
//        navigationController?.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !newsRead!{
            self.read_news()
        }

        NewsTitle.text = newsTitle
        NewsData.text = newsData
        NewsText.text = newsText
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        
        let titles = Titles()
        self.title = titles.getSimpleTitle(numb: "0")
        
    }
    
    func read_news(){
        let phone = UserDefaults.standard.string(forKey: "login")!
        let url: String = "SetAnnouncementIsReaded.ashx?"
        var request = URLRequest(url: URL(string: Server.SERVER + url + "id=" + newsId! + "&phone=" + phone)!)
        request.httpMethod = "GET"
        print(request)
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
                         print(String(data: data!, encoding: .utf8) ?? "")
            guard data != nil else { return }
            var news_read = UserDefaults.standard.integer(forKey: "news_read")
            news_read -= 1
//            DispatchQueue.main.async {
//                let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
//                let updatedBadgeNumber = currentBadgeNumber - 1
//                if (updatedBadgeNumber > -1) {
//                    UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
//                }
//            }
            UserDefaults.standard.setValue(news_read, forKey: "news_read")
            UserDefaults.standard.synchronize()
            
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
