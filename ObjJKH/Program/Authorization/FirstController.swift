//
//  ViewController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 27.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Gloss
import SwiftyXMLParser

class FirstController: UIViewController {
    
    // Вспомогальные переменные для взаимодействия с севрером
    var responseLS: String = ""
    var responseString: String = ""
    // Для получения, хранения лиц. счетов
    private var data_ls: [String] = []
    var str_ls: String = ""

    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var questionImg: UIImageView!
    @IBOutlet weak var heigt_image: NSLayoutConstraint!
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var new_face: UIImageView!
    @IBOutlet weak var edLogin: UITextField!
    @IBOutlet weak var edPass: UITextField!
    @IBOutlet weak var new_zamoc: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnEnter: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnReg: UIButton!
    
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    
    @IBAction func Enter(_ sender: UIButton) {
        // Проверка на заполнение
        var ret: Bool = false;
        var message: String = ""
        if (edLogin.text == "") {
            message = "Не указан логин. "
            ret = true;
        }
        if (edPass.text == "") {
            message = message + "Не указан пароль."
            ret = true
        }
        if ret {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Сохраним значения
        saveUsersDefaults()
        
        // Запрос - получение данных !!! (прежде попытаемся получить лиц. счета)
        get_LS()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "fromMenu")
        StopIndicator()
        loadUsersDefaults()
        
        let defaults = UserDefaults.standard
        // Сохраним параметр, который сигнализирует о том, что надо показать приветствие в Главном окне ("Привет, г-н Иванов")
        defaults.setValue(true, forKey: "NeedHello")
        
        // Если значение из настроек - go_to_app в значении true, запустим вход в приложение сразу
        if (defaults.bool(forKey: "go_to_app")) {
            
            defaults.set(false, forKey: "go_to_app")
            defaults.synchronize()
            
            self.get_LS()
            
        }
        
        hideKeyboard_byTap()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Картинка в зависимости от Таргета
        #if isOur_Obj_Home
            fon_top.image = UIImage(named: "logo_Our_Obj_Home")
        #elseif isChist_Dom
            fon_top.image = UIImage(named: "Logo_Chist_Dom")
        #elseif isMupRCMytishi
            fon_top.image = UIImage(named: "logo_MupRCMytishi")
        #elseif isDJ
            fon_top.image = UIImage(named: "logo_DJ")
        #elseif isStolitsa
            fon_top.image = UIImage(named: "logo_Stolitsa")
        #elseif isKomeks
            fon_top.image = UIImage(named: "Logo_Komeks")
        #elseif isUKKomfort
            fon_top.image = UIImage(named: "logo_UK_Komfort")
        #elseif isKlimovsk12
            fon_top.image = UIImage(named: "logo_Klimovsk12")
        #endif
        
        // Установим цвета для элементов в зависимости от Таргета
        btnEnter.backgroundColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        
        // Картинки для разных Таргетов
        new_face.image = myImages.person_image
        new_face.setImageColor(color: myColors.btnColor.uiColor())
        new_zamoc.image = myImages.lock_image
        new_zamoc.setImageColor(color: myColors.btnColor.uiColor())
        questionImg.setImageColor(color: myColors.btnColor.uiColor())
        questionBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = show ? 0 : 95
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.heigt_image.constant = CGFloat(changeInHeight)
        })
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // РАБОТА С СЕРВЕРОМ
    func getServerUrlBy(login loginText:String ,password txtPass:String) -> String {
        #if isDJ
            return Server.SERVER + Server.ENTER_DJ + "phone=" + loginText + "&pwd=" + txtPass
        #else
            if loginText.isPhoneNumber , let phone = loginText.asPhoneNumberWithoutPlus  {
                return Server.SERVER + Server.ENTER_MOBILE + "phone=" + phone + "&pwd=" + txtPass
            } else if loginText == "test" {
                return Server.SERVER + Server.ENTER_MOBILE + "phone=" + loginText + "&pwd=" + txtPass
            } else {
                return Server.SERVER + Server.ENTER + "login=" + loginText + "&pwd=" + txtPass;
            }
        #endif
        
    }
    
    func getServerUrlByIdent(login loginText:String) -> String {
//        if loginText.isPhoneNumber , let _ = loginText.asPhoneNumberWithoutPlus  {
            return Server.SERVER + Server.MOBILE_API_PATH + Server.GET_IDENTS_ACC + "phone=" + loginText
//        } else {
//            return "xxx"
//        }
    }
    
    // Подтянем лиц. счета для указанного логина
    func get_LS() {
        StartIndicator()
        // Авторизация пользователя
        let txtLogin: String = edLogin.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
        let urlPath = self.getServerUrlByIdent(login: txtLogin)
        if (urlPath == "xxx") {
            self.choice_LS()
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
                                                    
                                                    self.responseLS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                    
                                                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? JSON {
                                                        self.data_ls = Services_ls_json(json: json!)?.data ?? []
                                                    }
                                                    
                                                    self.choice_LS()
                                                    
            })
            task.resume()
        }
    }
    
    func choice_LS() {
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
            
            self.enter()
        })
    }
    
    func enter() {
        StartIndicator()
        
        // Авторизация пользователя
        let txtLogin: String = edLogin.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let txtPass: String = edPass.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
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
                                                
                                                self.responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                                                print("responseString = \(self.responseString)")
                                                
                                                self.choice()
        })
        task.resume()
    }
    
    func choice() {
        if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Не переданы обязательные параметры", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }else if (responseString == "2") || (responseString.contains("еверный логин")){
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString.contains("error")){
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            
            DispatchQueue.main.async(execute: {
                
                // авторизация на сервере - получение данных пользователя
                var answer = self.responseString.components(separatedBy: ";")
                
                // сохраним значения в defaults
                self.save_global_data(date1: answer[0], date2: answer[1], can_count: answer[2], mail: answer[3], id_account: answer[4], isCons: answer[5], name: answer[6], history_counters: answer[7], strah: "0", phone_operator: answer[10])
                
                // отправим на сервер данные об ид. устройства для отправки уведомлений
                let token = Messaging.messaging().fcmToken
                if (token != nil) {
                    let server = Server()
                    server.send_id_app(id_account: answer[4], token: token!)
                }
                
                let db = DB()
                db.getDataByEnter(login: self.edLogin.text!, pass: self.edPass.text!)
                self.getTypesApps()
                if !UserDefaults.standard.bool(forKey: "error"){
                    if (answer[5] == "0") {
                        self.performSegue(withIdentifier: "MainMenu", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "MainMenuCons", sender: self)
                    }
                }else{
                    let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                    let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                        self.performSegue(withIdentifier: "support", sender: self)
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(supportAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
                
                self.StopIndicator()
            })
        }
    }

    // ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
    func StartIndicator(){
        self.btnEnter.isHidden = true
        self.btnForgot.isHidden = true
        self.btnReg.isHidden = true
        
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.btnEnter.isHidden = false
        self.btnForgot.isHidden = false
        self.btnReg.isHidden = false
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    // UsersDefaults
    func saveUsersDefaults() {
        let defaults = UserDefaults.standard
        defaults.setValue(edLogin.text!, forKey: "login")
        defaults.setValue(edLogin.text!, forKey: "phone")
        defaults.setValue(edPass.text!, forKey: "pass")
        defaults.synchronize()
    }
    
    func loadUsersDefaults() {
        let defaults = UserDefaults.standard
        let login = defaults.string(forKey: "login")
        let pass = defaults.string(forKey: "pass")
        
        edLogin.text = login
        edPass.text = pass
    }
    
    // сохранение глобальных значений
    func save_global_data(date1: String, date2: String, can_count: String, mail: String, id_account: String, isCons: String, name: String, history_counters: String, strah: String, phone_operator: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(date1, forKey: "date1")
        defaults.setValue(date2, forKey: "date2")
        defaults.setValue(can_count, forKey: "can_count")
        defaults.setValue(mail, forKey: "mail")
        defaults.setValue(id_account, forKey: "id_account")
        defaults.setValue(isCons, forKey: "isCons")
        defaults.setValue(name, forKey: "name")
        defaults.setValue(strah, forKey: "strah")
        defaults.setValue(history_counters, forKey: "history_counters")
        defaults.setValue(phone_operator, forKey: "phone_operator")
        defaults.synchronize()
    }

    // ВСЕ ОСТАЛЬНОЕ
    struct Services_ls_json: JSONDecodable {
        let data: [String]?
        init?(json: JSON) {
            data = "data" <~~ json
        }
    }
    
    // Получить типы заявок
    func getTypesApps() {
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_REQUEST_TYPES + "table=Support_RequestTypes")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
            defer {
                DispatchQueue.main.async {
                }
            }
            
            guard data != nil else { return }
            
            let defaults = UserDefaults.standard
            let xml = XML.parse(data!)
            xml["Table"]["Row"].forEach {
                defaults.setValue($0.attributes["name"], forKey: $0.attributes["id"]! + "_type")
            }
            defaults.synchronize()
            #if DEBUG
            print(String(data: data!, encoding: .utf8) ?? "")
            #endif
            
            }.resume()
    }
    
}

