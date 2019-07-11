//
//  FirstControllerCons.swift
//  ObjJKH
//
//  Created by Роман Тузин on 29/03/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import Foundation
import UIKit
import FirebaseMessaging
import SwiftyXMLParser

class FirstControllerCons: UIViewController, UITextFieldDelegate {
    
    // Вспомогальные переменные для взаимодействия с севрером
    var responseString: String = ""

    @IBOutlet weak var ver_Lbl: UILabel!
    @IBOutlet weak var new_face: UIImageView!
    @IBOutlet weak var new_zamoc: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    @IBOutlet weak var edLogin: UITextField!
    @IBOutlet weak var edPass: UITextField!
    @IBOutlet weak var showPass: UIButton!
    @IBOutlet weak var btnUserEnter: UIButton!
    @IBOutlet weak var btnEnter: UIButton!
    
    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var questionImg: UIImageView!
    @IBOutlet weak var errAuthLbl: UILabel!
    @IBOutlet weak var errArrowLbl: UILabel!
    var eye = false
    @IBAction func showPassAction(_ sender: UIButton) {
        if eye{
            showPass.tintColor = .lightGray
            eye = false
        }else{
            showPass.tintColor = myColors.btnColor.uiColor()
            eye = true
        }
        edPass.isSecureTextEntry.toggle()
    }
    
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
        
        self.enter()

    }
    
    func enter() {
        StartIndicator()
        
        // Переменная - контроль одного факта обращения за сессию (пока не зайдешь снова, обращение отправить будет нельзя)
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "can_tech")
        defaults.synchronize()
        
        // Авторизация пользователя
        let txtLogin: String = edLogin.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let txtPass: String = edPass.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
        let urlPath = self.getServerUrlBy(login: txtLogin, password: txtPass)
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        self.StopIndicator()
                                                        UserDefaults.standard.set("Ошибка соединения сервера", forKey: "errorStringSupport")
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
                                                
                                                self.responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                                                //                                                self.responseString = "error: смена пароля: 12345678"
                                                print("responseString = \(self.responseString)")
                                                self.choice()
        })
        task.resume()
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
    
    func choice() {
        if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
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
        } else if (responseString.contains("смена пароля")){
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let str = self.responseString.replacingOccurrences(of: "error: смена пароля: ", with: "")
                var ls: [String] = []
                if str.contains(";"){
                    ls = str.components(separatedBy: ";")
                }else{
                    ls.append(str)
                }
                #if isMupRCMytishi
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "nonPassController") as! nonPassController
                vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                if ls.count != 0{
                    if ls[0] != "" && ls[0] != " "{
                        vc.ls = ls[0]
                        vc.lsLbl.text = "У лицевого счета \(ls[0]) был изменён пароль"
                        vc.login = self.edLogin.text!
                        self.addChildViewController(vc)
                        self.view.addSubview(vc.view)
                    }else{
                        UserDefaults.standard.set(self.responseString, forKey: "errorStringSupport")
                        UserDefaults.standard.synchronize()
                        let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен. \nОтвет с сервера: <" + self.responseString + ">", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                        let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                            self.performSegue(withIdentifier: "support_cons", sender: self)
                        }
                        alert.addAction(cancelAction)
                        alert.addAction(supportAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }else{
                    UserDefaults.standard.set(self.responseString, forKey: "errorStringSupport")
                    UserDefaults.standard.synchronize()
                    let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен. \nОтвет с сервера: <" + self.responseString + ">", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                    let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                        self.performSegue(withIdentifier: "support_cons", sender: self)
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(supportAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
                #endif
            })
        }else if (responseString.contains("error")){
            DispatchQueue.main.async(execute: {UserDefaults.standard.set(true, forKey: "firstConst")
                self.StopIndicator()
                UserDefaults.standard.set(self.responseString, forKey: "errorStringSupport")
                UserDefaults.standard.synchronize()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен. \nОтвет с сервера: <" + self.responseString + ">", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support_cons", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                
                // авторизация на сервере - получение данных пользователя
                var answer = self.responseString.components(separatedBy: ";")
                print(answer.count)
                // сохраним значения в defaults
                self.save_global_data(date1: answer[0], date2: answer[1], can_count: answer[2], mail: answer[3], id_account: answer[4], isCons: answer[5], name: answer[6], history_counters: answer[7], strah: "0", phone_operator: answer[10], encoding_Pays: answer[11])
                
                // отправим на сервер данные об ид. устройства для отправки уведомлений
                let token = Messaging.messaging().fcmToken
                if (token != nil) {
                    let server = Server()
                    server.send_id_app(id_account: answer[4], token: token!)
                }
                
                let db = DB()
                db.getDataByEnter(login: self.edLogin.text!, pass: self.edPass.text!)
                self.getTypesApps()
                self.isCons = answer[5]
                self.startApp()
                
            })
        }
    }
    
    var isCons: String = ""
    
    func startApp(){
        DispatchQueue.main.async {
            if !UserDefaults.standard.bool(forKey: "error"){
                UserDefaults.standard.set("", forKey: "errorStringSupport")
                UserDefaults.standard.set(false, forKey: "successParse")
                UserDefaults.standard.synchronize()
                //                DispatchQueue.main.async {
                self.StopIndicator()
                //                }
                if (self.isCons == "0") {
                    self.errAuthLbl.isHidden = false
                    self.errArrowLbl.isHidden = false
                    self.view.backgroundColor = UIColor(red:205/255.0, green: 205/255.0, blue: 205/255.0, alpha:1)
                } else {
                    self.performSegue(withIdentifier: "MainMenuCons_", sender: self)
                }
            }else{
                //                DispatchQueue.main.async {
                self.StopIndicator()
                //                }
                UserDefaults.standard.set("Ошибка сохранения данных", forKey: "errorStringSupport")
                UserDefaults.standard.synchronize()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен. \nОтвет с сервера: <" + "Ошибка сохранения данных" + ">", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support_cons", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StopIndicator()
        loadUsersDefaults()
        let version = targetSettings().getVersion()
        ver_Lbl.text = "ver. " + version
        edLogin.delegate = self
        edPass.delegate = self
        hideKeyboard_byTap()
        
        // Кнопка - Вход для сотрудников
        btnUserEnter.layer.cornerRadius = 3
        btnUserEnter.layer.borderWidth = 1.0
        btnUserEnter.layer.borderColor = myColors.btnColor.uiColor().cgColor
        btnUserEnter.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        btnUserEnter.clipsToBounds = true
        
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
        showPass.tintColor = .lightGray
        ver_Lbl.textColor = myColors.btnColor.uiColor()
        questionImg.setImageColor(color: myColors.btnColor.uiColor())
        questionBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "support_cons1") {
            let nav = segue.destination as! UINavigationController
            let AddApp = nav.topViewController as! SupportController
            AddApp.fromAuth = true
        }
        if (segue.identifier == "support_cons"){
            let AddApp = segue.destination as! SupportController
            AddApp.fromAuth = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(true, forKey: "firstConst")
        UserDefaults.standard.synchronize()
//        self.navigationController?.isNavigationBarHidden = false;
    }
    
    // ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
    func StartIndicator(){
        self.btnEnter.isHidden = true
        
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.btnEnter.isHidden = false
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    func saveUsersDefaults() {
        let defaults = UserDefaults.standard
        defaults.setValue(edLogin.text!, forKey: "login_cons")
        defaults.setValue(edPass.text!, forKey: "pass_cons")
        defaults.setValue(true, forKey: "windowCons")
        defaults.synchronize()
    }
    
    func loadUsersDefaults() {
        let defaults = UserDefaults.standard
        let login = defaults.string(forKey: "login_cons")
        let pass = defaults.string(forKey: "pass_cons")
        edLogin.text = login
        edPass.text = pass
    }
    
    // сохранение глобальных значений
    func save_global_data(date1: String, date2: String, can_count: String, mail: String, id_account: String, isCons: String, name: String, history_counters: String, strah: String, phone_operator: String, encoding_Pays: String) {
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
        defaults.setValue(encoding_Pays, forKey: "encoding_Pays")
        defaults.synchronize()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errAuthLbl.isHidden = true
        self.errArrowLbl.isHidden = true
        self.view.backgroundColor = UIColor(red:255/255.0, green: 255/255.0, blue: 255/255.0, alpha:1)
    }
    
}
