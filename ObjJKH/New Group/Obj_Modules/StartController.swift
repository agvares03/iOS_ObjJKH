//
//  StartController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 03.10.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Foundation

class StartController: UIViewController {
    
    var responseLS: String?

    @IBOutlet weak var progress: UIProgressView!
    var progressValue = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.perform(#selector(updateProgress), with: nil, afterDelay: 0.01)
        
        // Запустим подгрузку настроек
        getSettings()
        
    }
    
    @objc func updateProgress() {
        progressValue = progressValue + 0.01
        self.progress.progress = Float(progressValue)
        if progressValue != 1.0 {
            self.perform(#selector(updateProgress), with: nil, afterDelay: 0.01)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    // ЗАГРУЗИМ НАСТРОЙКИ С СЕРВЕРА
    func getSettings() {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        #if DEBUG
        let urlPath = Server.SERVER + Server.GET_MOBILE_MENU
        #else
        let urlPath = Server.SERVER + Server.GET_MOBILE_MENU + "appVersionIOS=" + version
        #endif
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
//        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    return
                                                }
                                                
                                                self.responseLS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("Response: \(self.responseLS!)")
                                                if (self.responseLS?.contains("обновить"))!{
                                                    self.update_app()
                                                }else{
                                                   self.setSettings()
                                                }
        })
        task.resume()
        
    }
    
    func setSettings() {
        DispatchQueue.main.sync {
            
            let inputData = self.responseLS?.data(using: .utf8)!
            let decoder = JSONDecoder()
            let stat = try! decoder.decode(MenuData.self, from: inputData!)
            
            self.set_settings(color: stat.color, statMenu: stat.menu)
            
            self.start_app()
        }
    }
    
    func set_settings(color: String, statMenu: [Menu]) {
        let defaults = UserDefaults.standard
        defaults.setValue(color, forKey: "hex_color")
        var numb: Int = 0
        statMenu.forEach {
            defaults.setValue(String($0.id) + ";" + $0.name_app + ";" + String($0.visible)  + ";" + $0.simple_name, forKey: "menu_" + String(numb))
            numb = numb + 1
        }
        defaults.synchronize()
    }
    
    @objc func update_app() {
        DispatchQueue.main.sync {
            if progressValue < 1.0 {
                self.perform(#selector(update_app), with: nil, afterDelay: 0.1)
            } else {
                self.performSegue(withIdentifier: "update_app", sender: self)
            }
        }
    }
    
    @objc func start_app() {
        if progressValue < 1.0 {
            self.perform(#selector(start_app), with: nil, afterDelay: 0.01)
        } else {
            self.performSegue(withIdentifier: "start_app", sender: self)
        }
    }
    
    struct MenuData: Decodable {
        let color: String
        let menu: [Menu]
    }
    
    struct Menu: Decodable {
        let id: Int
        let name_app: String
        let visible: Int
        let simple_name: String
    }
    
}
