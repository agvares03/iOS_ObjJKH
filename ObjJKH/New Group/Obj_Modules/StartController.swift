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
        UserDefaults.standard.set("", forKey: "errorStringSupport")
        UserDefaults.standard.synchronize()
        self.perform(#selector(updateProgress), with: nil, afterDelay: 0.01)
        
        // Запустим подгрузку настроек
        getSettings()
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: Network.reachability)
        updateUserInterface()
    }
    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            let alert = UIAlertController(title: "Ошибка загрузки данных", message: "Проверьте соединение с интернетом", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Повторить", style: .default) { (_) -> Void in
                self.viewDidLoad()
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        case .wifi: break
            
        case .wwan: break
            
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .flagsChanged, object: Network.reachability)
    }

    
    // ЗАГРУЗИМ НАСТРОЙКИ С СЕРВЕРА
    func getSettings() {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let urlPath = Server.SERVER + Server.GET_MOBILE_MENU + "appVersionIOS=" + version
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    return
                                                }
                                                
                                                self.responseLS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("Response: \(self.responseLS!)")
                                                if (self.responseLS?.contains("обновить"))!{
                                                    self.updateApp = true
                                                    self.getSettings2()
                                                }else{
                                                    self.setSettings()
                                                }
        })
        task.resume()
        
    }
    
    func getSettings2() {
        let urlPath = Server.SERVER + Server.GET_MOBILE_MENU
        
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
                                                self.setSettings()
        })
        task.resume()
        
    }
    
    var updateApp = false
    func setSettings() {
        DispatchQueue.main.sync {
            if (self.responseLS?.contains("color"))!{
                let inputData = self.responseLS?.data(using: .utf8)!
                let decoder = JSONDecoder()
                let stat = try! decoder.decode(MenuData.self, from: inputData!)
                self.set_settings(color: stat.color, statMenu: stat.menu)
            }else{
                UserDefaults.standard.set(self.responseLS, forKey: "errorStringSupport")
                UserDefaults.standard.synchronize()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен. \nОтвет с сервера: <" + self.responseLS! + ">", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) ->
                    Void in
                    self.getSettings()
                }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            if updateApp{
                self.update_app()
            }else{
                self.start_app()
            }
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
        if progressValue < 1.0 {
            self.perform(#selector(update_app), with: nil, afterDelay: 0.01)
        } else {
            self.performSegue(withIdentifier: "update_app", sender: self)
        }
    }
    
    @objc func start_app() {
        if progressValue < 1.0 {
            self.perform(#selector(start_app), with: nil, afterDelay: 0.01)
        } else {
            let defaults = UserDefaults.standard
            let login = defaults.string(forKey: "login")
            if login == "" || login == nil{
                self.performSegue(withIdentifier: "reg_app", sender: self)
            }else{
                self.performSegue(withIdentifier: "start_app", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reg_app" {
            let nav = segue.destination as! UINavigationController
            let payController             = nav.topViewController as! Registration
            payController.firstEnter = true
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

public class targetSettings{
    var version = ""
    func getVersion() -> String{
        let dictionary = Bundle.main.infoDictionary!
        version = dictionary["CFBundleShortVersionString"] as! String
        return version
    }
}
