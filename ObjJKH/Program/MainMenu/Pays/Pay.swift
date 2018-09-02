//
//  Pay.swift
//  ObjJKH
//
//  Created by Роман Тузин on 30.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class Pay: UIViewController {

    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var webView: UIWebView!
    
    var login: String = ""
    var pass: String  = ""
    var sum: String   = ""
    
    var responseString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults     = UserDefaults.standard
        
        // Логин и пароль
        login = defaults.string(forKey: "login")!
        pass  = defaults.string(forKey: "pass")!
        sum  = defaults.string(forKey: "sum")!
        
        get_link()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getServerUrlByIdent() -> String {
        return Server.SERVER + Server.GET_LINK + "login=" + self.login + "&pwd=" + self.pass + "&sum=" + self.sum
    }
    
    func get_link() {
        let urlPath = self.getServerUrlByIdent()
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        let alert = UIAlertController(title: "Ошибка сервера", message: "Попробуйте позже", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                    return
                                                }
                                                
                                                self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(self.responseString)")
                                                
                                                self.choice()
        })
        task.resume()
    }
    
    func choice() {
        DispatchQueue.main.async(execute: {
            if (self.responseString.contains("Ошибка")) {
                let alert = UIAlertController(title: "Ошибка", message: "Ну удалось подключиться к серверу оплаты", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            } else if (self.responseString != "") {
                let url = NSURL(string: self.responseString)
                let requestObj = NSURLRequest(url: url! as URL)
                self.webView.loadRequest(requestObj as URLRequest)
            } else {
                let alert = UIAlertController(title: "Ошибка", message: "Ну удалось подключиться к серверу оплаты", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

}
