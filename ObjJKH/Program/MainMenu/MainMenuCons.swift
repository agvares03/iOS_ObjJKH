//
//  MainMenuCons.swift
//  ObjJKH
//
//  Created by Роман Тузин on 05.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Gloss

class MainMenuCons: UIViewController {

    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var LabelTime: UILabel!
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var notice: UIImageView!
    @IBOutlet weak var application: UIImageView!
    @IBOutlet weak var webs_img: UIImageView!
    @IBOutlet weak var exit_img: UIImageView!
    @IBOutlet weak var news_indicator: UILabel!
    @IBOutlet weak var request_indicator: UILabel!
    
    @IBAction func goExit(_ sender: UIButton)
    {
        exit(0)
        //UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getNews()
        let defaults = UserDefaults.standard
        // Приветствие
        LabelTime.text = "Здравствуйте,"
        LabelName.text = defaults.string(forKey: "name")
        
        notice.image = myImages.notice_image
        notice.setImageColor(color: myColors.btnColor.uiColor())
        application.image = myImages.application_image
        application.setImageColor(color: myColors.btnColor.uiColor())
        webs_img.image = myImages.webs_image
        webs_img.setImageColor(color: myColors.btnColor.uiColor())
        exit_img.image = myImages.exit_image
        exit_img.setImageColor(color: myColors.btnColor.uiColor())
    }
    
    var news_read = 0
    
    func getNews(){
        news_read = 0
        let phone = UserDefaults.standard.string(forKey: "phone") ?? ""
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_NEWS + "phone=" + phone)!)
        request.httpMethod = "GET"
        print(request)
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
            //            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            //            print("responseString = \(responseString)")
            
            guard data != nil else { return }
            let json = try? JSONSerialization.jsonObject(with: data!,
                                                         options: .allowFragments)
            let unfilteredData = NewsJson(json: json! as! JSON)?.data
            unfilteredData?.forEach { json in
                if !json.readed! {
                    self.news_read += 1
                    UserDefaults.standard.setValue(self.news_read, forKey: "news_read")
                    UserDefaults.standard.synchronize()
                }
            }
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.integer(forKey: "news_read") > 0{
            news_indicator.text = String(UserDefaults.standard.integer(forKey: "news_read"))
            news_indicator.isHidden = false
        }else{
            news_indicator.isHidden = true
        }
        if UserDefaults.standard.integer(forKey: "request_read_cons") > 0{
            request_indicator.text = String(UserDefaults.standard.integer(forKey: "request_read_cons"))
            request_indicator.isHidden = false
        }else{
            request_indicator.isHidden = true
        }
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false;
    }

}
