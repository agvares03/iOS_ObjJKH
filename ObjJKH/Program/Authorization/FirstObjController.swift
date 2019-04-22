//
//  FirstObjController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 08/04/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Gloss
import SwiftyXMLParser
import AKMaskField

class FirstObjController: UIViewController {

    var responseLS: String = ""
    var responseString: String = ""
    
    var strLogin = ""
    var strPass = ""
    // Для получения, хранения лиц. счетов
    private var data_ls: [String] = []
    var str_ls: String = ""
    
    @IBOutlet weak var ver_Lbl: UILabel!
    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var questionImg: UIImageView!
    @IBOutlet weak var heigt_image: NSLayoutConstraint!
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnEnter: UIButton!
    public var firstEnter = false
    @IBOutlet weak var btnConsEnter: UIButton!
    
    var iconClick = false
    var enterCons = false
    @IBAction func Enter(_ sender: UIButton) {
        // Сохраним значения
        strLogin = "test"
        strPass = "1"
        saveUsersDefaults()
        enterCons = false
        // Запрос - получение данных !!! (прежде попытаемся получить лиц. счета)
        get_LS()
    }
    
    @IBAction func EnterCons(_ sender: UIButton) {
        // Сохраним значения
        strLogin = "buh"
        strPass = "1"
        saveUsersDefaults()
        enterCons = true
        // Запрос - получение данных !!! (прежде попытаемся получить лиц. счета)
        get_LS()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "fromMenu")
        StopIndicator()
        
        loadUsersDefaults()
        let version = targetSettings().getVersion()
        ver_Lbl.text = "ver. " + version
        let defaults = UserDefaults.standard
        // Сохраним параметр, который сигнализирует о том, что надо показать приветствие в Главном окне ("Привет, г-н Иванов")
        defaults.setValue(true, forKey: "NeedHello")
        
        // Если значение из настроек - go_to_app в значении true, запустим вход в приложение сразу
        if (defaults.bool(forKey: "go_to_app")) {
            
            defaults.set(false, forKey: "go_to_app")
            defaults.synchronize()
            
            self.get_LS()
            
        }
        
        // Кнопка - Вход для сотрудников
        btnConsEnter.layer.cornerRadius = 3
        btnConsEnter.layer.borderWidth = 1.0
        btnConsEnter.layer.borderColor = myColors.btnColor.uiColor().cgColor
        btnConsEnter.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        btnConsEnter.clipsToBounds = true
        
        btnEnter.layer.cornerRadius = 3
        btnEnter.layer.borderWidth = 1.0
        btnEnter.layer.borderColor = myColors.btnColor.uiColor().cgColor
        btnEnter.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        btnEnter.clipsToBounds = true
        // Если используется вход для консультантов - покажем кнопку
//        if !defaults.bool(forKey: "useDispatcherAuth") {
//            btnConsEnter.isHidden = true
//        }
        
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
        #elseif isPocket
        fon_top.image = UIImage(named: "Logo_Pocket")
        #elseif isReutKomfort
        fon_top.image = UIImage(named: "Logo_ReutKomfort")
        #elseif isUKGarant
        fon_top.image = UIImage(named: "Logo_UK_Garant")
        #elseif isSoldatova1
        fon_top.image = UIImage(named: "Logo_Soldatova1")
        #elseif isTafgai
        fon_top.image = UIImage(named: "Logo_Tafgai")
        #elseif isTafgai
        fon_top.image = UIImage(named: "Logo_ServiceKomfort")
        #elseif isParitet
        fon_top.image = UIImage(named: "Logo_Paritet")
        #endif
        
        // Установим цвета для элементов в зависимости от Таргета
        indicator.color = myColors.indicatorColor.uiColor()
        
        // Картинки для разных Таргетов
        questionImg.setImageColor(color: myColors.btnColor.uiColor())
        questionBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        ver_Lbl.textColor = myColors.btnColor.uiColor()
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
        //        UserDefaults.standard.addObserver(self, forKeyPath: "successParse", options:NSKeyValueObservingOptions.new, context: nil)
        // Hide the navigation bar on the this view controller
        UserDefaults.standard.addObserver(self, forKeyPath: "successParse", options:NSKeyValueObservingOptions.new, context: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(false, forKey: "firstPerson")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObserver(self, forKeyPath: "successParse", context: nil)
        
        //        self.navigationController?.isNavigationBarHidden = false;
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
//        strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
//        strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
//        strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let txtLogin: String = strLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
        let urlPath = self.getServerUrlByIdent(login: txtLogin)
        if (urlPath == "xxx") {
            self.choice_LS()
        } else {
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
        
        // Переменная - контроль одного факта обращения за сессию (пока не зайдешь снова, обращение отправить будет нельзя)
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "can_tech")
        defaults.synchronize()
        
        // Авторизация пользователя
        
        let txtLogin: String = strLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let txtPass: String = strPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
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
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    let alert = UIAlertController(title: "Для работы в приложении необходимо зарегистрироваться", message: "\nДля регистрации в приложении необходимо указать № телефона и Ваше имя. Номер телефона укажите в формате +7xxxxxxxxxx \n \nПосле регистрации Вы сможете привязать Ваши лицевые счета.", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "ОK", style: .default) { (_) -> Void in }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
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
                            self.performSegue(withIdentifier: "support", sender: self)
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
                        self.performSegue(withIdentifier: "support", sender: self)
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(supportAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
                #endif
            })
        }else if (responseString.contains("error")){
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                UserDefaults.standard.set(self.responseString, forKey: "errorStringSupport")
                UserDefaults.standard.synchronize()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен. \nОтвет с сервера: <" + self.responseString + ">", preferredStyle: .alert)
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
                db.getDataByEnter(login: self.strLogin, pass: self.strPass)
                self.getTypesApps()
                self.isCons = answer[5]
            })
        }
    }
    var isCons = ""
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if UserDefaults.standard.bool(forKey: "successParse") && !one{
            one = true
            self.startApp()
        }
    }
    var one = false
    func startApp(){
        DispatchQueue.main.async {
            if !UserDefaults.standard.bool(forKey: "error"){
                UserDefaults.standard.set("", forKey: "errorStringSupport")
                UserDefaults.standard.set(false, forKey: "successParse")
                UserDefaults.standard.synchronize()
                //                DispatchQueue.main.async {
                self.StopIndicator()
                //                }
                self.one = false
                if (self.isCons == "0") {
                    UserDefaults.standard.set(true, forKey: "NewMain")
                    self.performSegue(withIdentifier: "NewMainMenu", sender: self)
//                    self.performSegue(withIdentifier: "MainMenu", sender: self)
                } else {
                    self.performSegue(withIdentifier: "MainMenuCons", sender: self)
                }
            }else{
                //                DispatchQueue.main.async {
                self.StopIndicator()
                //                }
                UserDefaults.standard.set("Ошибка сохранения данных", forKey: "errorStringSupport")
                UserDefaults.standard.synchronize()
                self.one = false
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен. \nОтвет с сервера: <" + "Ошибка сохранения данных" + ">", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    // ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
    func StartIndicator(){
        self.btnEnter.isHidden = true
        self.btnConsEnter.isHidden = true
        
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.btnEnter.isHidden = false
        self.btnConsEnter.isHidden = false
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    // UsersDefaults
    func saveUsersDefaults() {
        let defaults = UserDefaults.standard
        
//        var strLogin = edLogin.text!.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
//        strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
//        strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
//        strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        defaults.setValue(strLogin, forKey: "login")
        defaults.setValue(strLogin, forKey: "phone")
        defaults.setValue(strPass, forKey: "pass")
        defaults.setValue(false, forKey: "windowCons")
        defaults.synchronize()
    }
    
    func loadUsersDefaults() {
        let defaults = UserDefaults.standard
        let login = defaults.string(forKey: "login")
        let pass = defaults.string(forKey: "pass")
        if (login == "" || login == nil) && firstEnter == false{
            let alert = UIAlertController(title: "Для работы в приложении необходимо зарегистрироваться", message: "\nДля регистрации в приложении необходимо указать № телефона и Ваше имя. \n \nПосле регистрации Вы сможете привязать Ваши лицевые счета.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
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
