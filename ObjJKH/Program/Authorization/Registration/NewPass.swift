//
//  NewPass.swift
//  ObjJKH
//
//  Created by Роман Тузин on 27.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Gloss

class NewPass: UIViewController {
    
    // Для получения, хранения лиц. счетов
    private var data_ls: [String] = []
    var str_ls: String = ""
    
    var phone: String? = ""
    var responseString: String? = ""
    public var firstEnter = false

    @IBOutlet weak var edPass: UITextField!
    @IBOutlet weak var edPassAgain: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var showPass1: UIButton!
    @IBOutlet weak var showPass2: UIButton!
    @IBOutlet weak var labelEnter: UILabel!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!    
    @IBOutlet weak var lock1: UIImageView!
    @IBOutlet weak var lock2: UIImageView!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "", message: "Вы действительно хотите прервать регистрацию?", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "Да", style: .destructive) { (_) -> Void in
            if self.firstEnter == false{
                self.navigationController?.dismiss(animated: true, completion: nil)
            }else{
                self.performSegue(withIdentifier: "start_app", sender: self)
            }
        }
        let cancelAction = UIAlertAction(title: "Нет", style: .default) { (_) -> Void in        }
        alert.addAction(exitAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showPassAction1(_ sender: UIBarButtonItem) {
        edPass.isSecureTextEntry.toggle()
    }
    
    @IBAction func showPassAction2(_ sender: UIBarButtonItem) {
        edPassAgain.isSecureTextEntry.toggle()
    }
    
    @IBAction func btnSaveGo(_ sender: UIButton) {
        if (self.edPass.text == "") {
            let alert = UIAlertController(title: "Ошибка", message: "Укажите пароль для входа", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else if (self.edPass.text != self.edPassAgain.text) {
            let alert = UIAlertController(title: "Ошибка", message: "Введенные пароли не совпадают. Введите еще раз", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                self.edPass.text = ""
                self.edPassAgain.text = ""
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let urlPath = self.getServerUrlNewPass(phone: self.phone!, pass: self.edPass.text!)
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        DispatchQueue.main.async(execute: {
                                                            self.StopIndicator()
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
                                          //          print("responseString = \(String(describing: self.responseString))")
                                                    self.choice()
            })
            task.resume()
            
        }
    }
    
    func choice() {
        if (responseString == "ok") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "", message: "Новый пароль установлен", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    
                    let defaults = UserDefaults.standard
                    defaults.set(self.phone, forKey: "login")
                    defaults.set(self.edPass.text, forKey: "pass")
                    defaults.synchronize()
                    
                    // Сразу заходим в приложение
                    self.labelEnter.isHidden = false
                    self.view.endEditing(true)
                    self.edPass.isEnabled = false
                    self.edPassAgain.isEnabled = false
                    self.StartIndicator()
                    
                    var strLogin: String = self.phone?.replacingOccurrences(of: "(", with: "", options: .literal, range: nil) ?? ""
                    strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
                    strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
                    strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                    
                    self.get_LS(txtLogin: (strLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!), txtPass: (self.edPass.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!)
                    
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                UserDefaults.standard.set(self.responseString, forKey: "errorStringSupport")
                UserDefaults.standard.synchronize()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен. \nОтвет с сервера: <" + self.responseString! + ">", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard_byTap()
        let defaults = UserDefaults.standard
        phone = defaults.string(forKey: "phone")
        
        self.StopIndicator()
        self.labelEnter.isHidden = true
        
        // Установим цвета для элементов в зависимости от Таргета
        btnSave.backgroundColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
        labelEnter.textColor = myColors.labelColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        
        lock1.image = myImages.lock_image
        lock1.setImageColor(color: myColors.btnColor.uiColor())
        lock2.image = myImages.lock_image
        lock2.setImageColor(color: myColors.btnColor.uiColor())
        backBtn.tintColor = myColors.btnColor.uiColor()
        showPass1.tintColor = myColors.btnColor.uiColor()
        showPass2.tintColor = myColors.btnColor.uiColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func getServerUrlNewPass(phone PhoneText:String, pass txtPass:String) -> String {
        
        
        var strLogin = PhoneText.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
        return Server.SERVER + Server.MOBILE_API_PATH + Server.SEND_NEW_PASS + "phone=" + strLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + txtPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func StartIndicator(){
        self.btnSave.isHidden = true
        
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.btnSave.isHidden = false
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }

    
    // ВХОД В ПРИЛОЖЕНИЕ (СДУБЛИРОВАН - БЫТЬ ВНИМАТЕЛЬНЕЙ, ПОСЛЕ СДЕЛАТЬ ОДНИМ МОДУЛЕМ)
    // Подтянем лиц. счета для указанного логина
    func get_LS(txtLogin: String, txtPass: String) {
        // Авторизация пользователя
//        txtLogin = txtLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
        let urlPath = self.getServerUrlByIdent(login: txtLogin)
        if (urlPath == "xxx") {
            self.choice_LS(txtLogin: txtLogin, txtPass: txtPass)
        } else {
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        return
                                                    }
                                                    
//                                                    let responseLS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                    
                                                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? JSON {
                                                        self.data_ls = Services_ls_json(json: json!)?.data ?? []
                                                    }
                                                    
                                                    self.choice_LS(txtLogin: txtLogin, txtPass: txtPass)
                                                    
            })
            task.resume()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "start_app"{
            let defaults = UserDefaults.standard
            let login = defaults.string(forKey: "login")
            if login == "" || login == nil{
                let payController             = segue.destination as! FirstController
                payController.firstEnter = true
            }
        }
        if (segue.identifier == "support") {
            let AddApp = segue.destination as! SupportUpdate
            AddApp.fromAuth = true
        }
    }
    
    func choice_LS(txtLogin: String, txtPass: String) {
        DispatchQueue.main.async(execute: {
            var itsFirst: Bool = true
            for item in self.data_ls {
                if (itsFirst) {
                    self.str_ls = item
                    itsFirst = false
                } else {
                    self.str_ls = self.str_ls + "," + item
                }
            }
            let defaults = UserDefaults.standard
            defaults.set(self.str_ls, forKey: "str_ls")
            defaults.synchronize()
            
            self.enter(txtLogin: txtLogin, txtPass: txtPass)
        })
    }
    
    func enter(txtLogin: String, txtPass: String) {
        let urlPath = self.getServerUrlBy(login: txtLogin, password: txtPass)
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        self.StopIndicator()
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
                                                
                                                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
//                                                print("responseString = \(self.responseString)")
                                                
                                                self.choice(responseString: responseString, login: txtLogin, pass: txtPass)
        })
        task.resume()
    }
    
    func choice(responseString: String, login: String, pass: String) {
        if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Не переданы обязательные параметры", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "2") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            
            DispatchQueue.main.async(execute: {
                
                // авторизация на сервере - получение данных пользователя
                var answer = responseString.components(separatedBy: ";")
                
                // сохраним значения в defaults
                self.save_global_data(date1: answer[0], date2: answer[1], can_count: answer[2], mail: answer[3], id_account: answer[4], isCons: answer[5], name: answer[6], history_counters: answer[7], strah: "0", phone_operator: answer[10], encoding_Pays: answer[11])
                
                // отправим на сервер данные об ид. устройства для отправки уведомлений
                let token = Messaging.messaging().fcmToken
                if (token != nil) {
                    let server = Server()
                    server.send_id_app(id_account: answer[4], token: token!)
                }
                
                let db = DB()
                db.getDataByEnter(login: login, pass: pass)
                
//                self.performSegue(withIdentifier: "GoToApp", sender: self)
                UserDefaults.standard.set(true, forKey: "NewMain")
                self.performSegue(withIdentifier: "NewMainMenu", sender: self)
                
                self.StopIndicator()
            })
        }
    }
    
    func getServerUrlBy(login loginText:String ,password txtPass:String) -> String {
//        if loginText.isPhoneNumber , let phone = loginText.asPhoneNumberWithoutPlus  {
        
        var strLogin = loginText.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
            return Server.SERVER + Server.ENTER_MOBILE + "phone=" + strLogin + "&pwd=" + txtPass
//        } else {
//            return Server.SERVER + Server.ENTER + "login=" + loginText + "&pwd=" + txtPass;
//        }
    }
    
    func getServerUrlByIdent(login loginText:String) -> String {
//        if loginText.isPhoneNumber , let _ = loginText.asPhoneNumberWithoutPlus  {
        
        var strLogin = loginText.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
            return Server.SERVER + Server.MOBILE_API_PATH + Server.GET_IDENTS_ACC + "phone=" + strLogin
//        } else {
//            return "xxx"
//        }
    }
    
    // сохранение глобальных значений
    func save_global_data(date1: String, date2: String, can_count: String, mail: String, id_account: String, isCons: String, name: String, history_counters: String, strah: String, phone_operator: String, encoding_Pays: String) {
        let defaults = UserDefaults.standard
//        defaults.setValue(date1, forKey: "date1")
//        defaults.setValue(date2, forKey: "date2")
        defaults.setValue(can_count, forKey: "can_count")
        defaults.setValue(mail, forKey: "mail")
        defaults.setValue(id_account, forKey: "id_account")
        defaults.setValue(isCons, forKey: "isCons")
        defaults.setValue(name, forKey: "name")
        defaults.setValue(strah, forKey: "strah")
        defaults.setValue(history_counters, forKey: "history_counters")
        defaults.setValue(phone_operator, forKey: "phone_operator")
        defaults.setValue(encoding_Pays, forKey: "encoding_Pays")
        defaults.synchronize()
    }
    
    // ВСЕ ОСТАЛЬНОЕ
    struct Services_ls_json: JSONDecodable {
        let data: [String]?
        init?(json: JSON) {
            data = "data" <~~ json
        }
    }
}
