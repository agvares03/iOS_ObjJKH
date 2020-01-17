//
//  Pay.swift
//  ObjJKH
//
//  Created by Роман Тузин on 30.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import SafariServices
import WebKit
import Crashlytics

class Pay: UIViewController, WKUIDelegate, AddAppDelegate, NewAddAppDelegate, WKNavigationDelegate {
    func newAddAppDone(addApp: NewAddAppUser) {
    }
    
    func addAppDone(addApp: AddAppUser) {
    }
    

    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
//        navigationController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var appBtn: UIButton!
    @IBOutlet weak var appLbl: UILabel!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    var webView: WKWebView!
    @IBAction func addAppAction(_ sender: UIButton){
        if UserDefaults.standard.bool(forKey: "newApps"){
            self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "new_add_app", sender: self)
        }else{
            self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "add_app", sender: self)
        }
    }
    
    var login: String = ""
    var pass: String  = ""
    var sum: String   = ""
    var ident: String = ""
    
    var responseString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appBtn.isHidden = true
        self.appLbl.isHidden = true
        Crashlytics.sharedInstance().setObjectValue("Pay", forKey: "last_UI_action")
        let defaults     = UserDefaults.standard
        
        // Логин и пароль
        login = defaults.string(forKey: "login")!
        pass  = defaults.string(forKey: "pass")!
        sum  = defaults.string(forKey: "sum")!
        
        if (self.responseString == "Ошибка: Недопустимый URI: Невозможно определить формат URI.") {
            self.appBtn.isHidden = false
            self.appLbl.isHidden = false
        }else if (self.responseString.contains("Ошибка")) {
            let alert = UIAlertController(title: "Ошибка", message: "Не удалось подключиться к серверу оплаты", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else if (self.responseString != "") {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            webView.navigationDelegate = self
            view = webView
            let url : NSURL! = NSURL(string: (responseString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!))
//            print(url)
            webView.load(NSURLRequest(url: url as URL) as URLRequest)
        
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Не удалось подключиться к серверу оплаты", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        backBtn.tintColor = myColors.btnColor.uiColor()
//        appBtn.backgroundColor = myColors.btnColor.uiColor()
//        #if isStolitsa
//            let url = NSURL(string: Server.SERVER + Server.GET_LINK_STOLITSA + "login=" + self.login + "&pwd=" + self.pass + "&sum=" + self.sum)
//            let requestObj = NSURLRequest(url: url! as URL)
//            self.webView.loadRequest(requestObj as URLRequest)
//        #else
//            get_link()
//        #endif
        
    }
    var webViewCurrUrl = ""
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let text = webView.url?.absoluteString{
            webViewCurrUrl = text
            print(text)
        }
        var doc = ""
        webView.evaluateJavaScript("document.documentElement.outerHTML") { (result, error) in
            if error != nil {
                doc = "\(String(describing: result))"
            }
        }
//        let doc = webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")
        if doc != ""{
            webViewCurrUrl = doc
        }
//        print(webViewCurrUrl)
        URLCache.shared.removeAllCachedResponses()
        print("loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        StartIndicator()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        StopIndicator()
    }
    
    func getServerUrlByIdent() -> String {
        if ident != ""{
            return Server.SERVER + Server.GET_LINK + "login=" + self.login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + self.pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&sum=" + self.sum + "&ident=" + self.ident.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        }else{
            return Server.SERVER + Server.GET_LINK + "login=" + self.login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + self.pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&sum=" + self.sum
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Чистим кэш у webView
        if !UserDefaults.standard.bool(forKey: "settSaveCard"){
            URLCache.shared.removeAllCachedResponses()
            if let cookies = HTTPCookieStorage.shared.cookies {
                for cookie in cookies {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
        }
        if webViewCurrUrl.containsIgnoringCase(find: "успешно") || webViewCurrUrl.containsIgnoringCase(find: "success"){
            UserDefaults.standard.set(true, forKey: "PaymentSucces")
            UserDefaults.standard.set("12345", forKey: "PaymentID")
            UserDefaults.standard.synchronize()
        }        
    }
    
    func get_link() {
        let urlPath = self.getServerUrlByIdent()
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        UserDefaults.standard.set("Ошибка соединения с сервером", forKey: "errorStringSupport")
                                                        UserDefaults.standard.synchronize()
                                                        let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                                                        let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                                                            self.performSegue(withIdentifier: "support", sender: self)
                                                        }
                                                        alert.addAction(cancelAction)
                                                        alert.addAction(supportAction)
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
            if (self.responseString == "Ошибка: Недопустимый URI: Невозможно определить формат URI.") {
//                let alert = UIAlertController(title: "Ошибка", message: "Оплата не подключена", preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
//                    self.navigationController?.popViewController(animated: true)
//                }
//                alert.addAction(cancelAction)
//                self.present(alert, animated: true, completion: nil)
                self.appBtn.isHidden = false
                self.appLbl.isHidden = false
            }else if (self.responseString.contains("Ошибка")) {
                let alert = UIAlertController(title: "Ошибка", message: "Не удалось подключиться к серверу оплаты", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            } else if (self.responseString != "") {
                let webConfiguration = WKWebViewConfiguration()
                self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
                self.webView.uiDelegate = self
                self.webView.navigationDelegate = self
                self.view = self.webView
                let url : NSURL! = NSURL(string: self.responseString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
                self.webView.load(NSURLRequest(url: url as URL) as URLRequest)
            
                // Отправлять в сафари-аналог
//                if let url = URL(string: self.responseString) {
//                    let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
//                    vc.delegate = self as? SFSafariViewControllerDelegate
//
//                    self.present(vc, animated: true)
//                }
            
            } else {
                let alert = UIAlertController(title: "Ошибка", message: "Не удалось подключиться к серверу оплаты", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "add_app") {
            let AddApp = segue.destination as! AddAppUser
            AddApp.delegate = self
            AddApp.fromMenu = true
        }else if (segue.identifier == "new_add_app") {
            let AddApp = segue.destination as! NewAddAppUser
            AddApp.delegate = self
            AddApp.fromMenu = true
        }
    }

}
