//
//  NewRegistration.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 28/08/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import AKMaskField
import FirebaseMessaging
import Gloss

class NewRegistration: UIViewController {
    
    
    @IBOutlet weak var authBtn:     UIButton!
    @IBOutlet weak var authLbl:     UILabel!
    @IBOutlet weak var edPhone:     AKMaskField!
    @IBOutlet weak var edFIO:       UITextField!
    @IBOutlet weak var edPass1:     UITextField!
    @IBOutlet weak var edPass2:     UITextField!
    @IBOutlet weak var btnReg:      UIButton!
    @IBOutlet weak var btnCancel:   UIButton!
    @IBOutlet weak var indicator:   UIActivityIndicatorView!
    @IBOutlet weak var backBtn:     UIBarButtonItem!
    @IBOutlet weak var regBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var showPass1:   UIButton!
    @IBOutlet weak var showPass2:   UIButton!
    
    @IBOutlet weak var separator1:  UIView!
    @IBOutlet weak var separator2:  UIView!
    @IBOutlet weak var separator3:  UIView!
    @IBOutlet weak var separator4:  UIView!
    @IBOutlet weak var phone:       UIImageView!
    @IBOutlet weak var person:      UIImageView!
    @IBOutlet weak var pass1:       UIImageView!
    @IBOutlet weak var pass2:       UIImageView!
    
    public var firstEnter = false
    private var data_ls: [String] = []
    var str_ls: String = ""
    var maskPhone = false
    var maskLogin = false
    
    @IBOutlet weak var switch_can: UISwitch!
    var responseString: String = ""
    
    var eye = false
    @IBAction func showPassAction1(_ sender: UIBarButtonItem) {
        if eye {
            showPass1.tintColor = .lightGray
            eye = false
        } else {
            showPass1.tintColor = myColors.btnColor.uiColor()
            eye = true
        }
        edPass1.isSecureTextEntry.toggle()
    }
    
    var eye2 = false
    @IBAction func showPassAction2(_ sender: UIBarButtonItem) {
        if eye2 {
            showPass2.tintColor = .lightGray
            eye2 = false
        } else {
            showPass2.tintColor = myColors.btnColor.uiColor()
            eye2 = true
        }
        edPass2.isSecureTextEntry.toggle()
    }
    
    @IBAction func authAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "start_app", sender: self)
    }
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "", message: "Вы действительно хотите прервать регистрацию?", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "Да", style: .destructive) { (_) -> Void in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Нет", style: .default) { (_) -> Void in        }
        alert.addAction(exitAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func canRegistration(_ sender: UISwitch) {
        if (switch_can.isOn) {
            btnReg.isEnabled = true
            btnReg.backgroundColor = btnReg.backgroundColor?.withAlphaComponent(1)
            //            btnReg.isHidden = false
        } else {
            btnReg.isEnabled = false
            btnReg.backgroundColor = btnReg.backgroundColor?.withAlphaComponent(0.5)
            //            btnReg.isHidden = true
        }
    }
    
    @IBAction func btnCancelGo(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Вы действительно хотите прервать регистрацию?", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "Да", style: .destructive) { (_) -> Void in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Нет", style: .default) { (_) -> Void in        }
        alert.addAction(exitAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    var loginText = ""
    @IBAction func btnRegGo(_ sender: UIButton) {
        self.view.endEditing(true)
        loginText = edPhone.text!.replacingOccurrences(of: " ", with: "")
        // Проверка на правильность поля номер телефона
        if (loginText.contains("*")) && maskPhone{
            let alert = UIAlertController(title: "Ошибка", message: "Укажите номер телефона в формате +7(***)***-**-**", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else if !DB().isValidLogin(testStr: loginText) && maskLogin{
            print("-\(loginText)-")
            let alert = UIAlertController(title: "Ошибка", message: "Логин может содержать только буквы латинские (большие, маленькие), цифры и знак нижнего подчеркивания «_»", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else if (loginText == ""){
            let alert = UIAlertController(title: "Ошибка", message: "Необходимо указать логин или номер телефона", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else if (edFIO.text == "") {
            let alert = UIAlertController(title: "Ошибка", message: "Необходимо указать фамилию, имя, отчество", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else if (self.edPass1.text == "") {
            let alert = UIAlertController(title: "Ошибка", message: "Укажите пароль для входа", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else if (self.edPass1.text != self.edPass2.text) {
            let alert = UIAlertController(title: "Ошибка", message: "Введенные пароли не совпадают. Введите еще раз", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                self.edPass1.text = ""
                self.edPass2.text = ""
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            
            let defaults = UserDefaults.standard
            var strLogin = ""
            if maskPhone{
                strLogin = loginText.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
                strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
                strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
                strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            }else{
                strLogin = loginText.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            }
            
            
            defaults.setValue(strLogin, forKey: "phone")
            defaults.synchronize()
            
            StartIndicator()
            get_registration()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard_byTap()
        // Маска для ввода - телефон
        StopIndicator()
        edPhone.maskDelegate = self
        #if isDJ
        maskLogin = true
        #else
        edPhone.maskExpression = "{.}"
        #endif
        edPhone.text = ""
        // Установим цвета для элементов в зависимости от Таргета
        btnReg.backgroundColor = myColors.btnColor.uiColor()
        btnCancel.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        separator1.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
        separator3.backgroundColor = myColors.labelColor.uiColor()
        separator4.backgroundColor = myColors.labelColor.uiColor()
        showPass1.tintColor = .lightGray
        showPass2.tintColor = .lightGray
        indicator.color = myColors.indicatorColor.uiColor()
        btnCancel.isHidden = false
        authLbl.isHidden = true
        authBtn.isHidden = true
        
        phone.image = myImages.phone_image
        phone.setImageColor(color: myColors.btnColor.uiColor())
        person.image = myImages.person_image
        person.setImageColor(color: myColors.btnColor.uiColor())
        pass1.image = myImages.lock_image
        pass1.setImageColor(color: myColors.btnColor.uiColor())
        pass2.image = myImages.lock_image
        pass2.setImageColor(color: myColors.btnColor.uiColor())
        backBtn.tintColor = myColors.btnColor.uiColor()
        if firstEnter{
            btnCancel.isHidden = true
            authLbl.isHidden = false
            authBtn.isHidden = false
            regBtnWidth.constant = self.view.frame.width - 32
            authBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        }
        
        switch_can.onTintColor = myColors.btnColor.uiColor()
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
        if segue.identifier == "GetSMS"{
            let defaults = UserDefaults.standard
            let login = defaults.string(forKey: "login")
            if login == "" || login == nil{
                let payController             = segue.destination as! SendSMSCod
                payController.firstEnter = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        if firstEnter == true{
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }else{
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    func getServerUrlBy(phone PhoneText:String, fio txtFIO:String, pass txtPass: String) -> String {
        //        if PhoneText.isPhoneNumber , let phone = PhoneText.asPhoneNumberWithoutPlus  {
        var strLogin = ""
        if maskPhone{
            strLogin = loginText.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }else{
            strLogin = loginText.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
        return Server.SERVER + Server.MOBILE_API_PATH + Server.REGISTER_WITHOUT_SMS + "login=" + strLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + txtPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&fio=" + txtFIO.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
    }
    
    func get_registration() {
        let urlPath = self.getServerUrlBy(phone: self.loginText, fio: self.edFIO.text!, pass: edPass1.text!)
        if (urlPath == "xxx") {
            let alert = UIAlertController(title: "Ошибка", message: "Необходимо указать номер телефона в формате +7XXXXXXXXXX", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            self.StopIndicator()
        } else {
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            //print(request)
            
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
                                                    //print("responseString = \(self.responseString)")
                                                    
                                                    self.choice()
            })
            task.resume()
        }
    }
    
    func choice() {
        if (responseString == "ok:1") || (responseString == "ok:2"){
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                var message = ""
                if self.responseString == "ok:1"{
                    message = "Новый пароль установлен"
                }else{
                    message = "Аккаунт успешно создан"
                }
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    
                    var strLogin = ""
                    if self.maskPhone{
                        strLogin = self.loginText.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
                        strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
                        strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
                        strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                    }else{
                        strLogin = self.loginText.replacingOccurrences(of: " ", with: "", options: .literal, range: nil).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                    }
                    
                    let defaults = UserDefaults.standard
                    defaults.set(strLogin, forKey: "login")
                    defaults.set(self.edPass1.text, forKey: "pass")
                    defaults.synchronize()
                    
                    // Сразу заходим в приложение
                    self.view.endEditing(true)
                    self.StartIndicator()
                    
                    self.get_LS(txtLogin: (strLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!), txtPass: (self.edPass1.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!)
                    
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
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
        }
    }
    
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
            //print(request)
            
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
                                                    self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                    //print("responseString = \(self.responseString)")
                                                    
                                                    self.choice_LS(txtLogin: txtLogin, txtPass: txtPass)
                                                    
            })
            task.resume()
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
        //print(request)
        
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
                                                //print("responseString = \(responseString)")
                                                
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
        
        var strLogin = ""
        if self.maskPhone{
            strLogin = self.loginText.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }else{
            strLogin = self.loginText.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
        
        return Server.SERVER + Server.ENTER_MOBILE + "phone=" + strLogin + "&pwd=" + txtPass
        //        } else {
        //            return Server.SERVER + Server.ENTER + "login=" + loginText + "&pwd=" + txtPass;
        //        }
    }
    
    func getServerUrlByIdent(login loginText:String) -> String {
        //        if loginText.isPhoneNumber , let _ = loginText.asPhoneNumberWithoutPlus  {
        
        var strLogin = ""
        if self.maskPhone{
            strLogin = self.loginText.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }else{
            strLogin = self.loginText.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
        
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
    
    func StartIndicator(){
        self.btnCancel.isHidden = true
        self.btnReg.isHidden = true
        
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.btnCancel.isHidden = false
        self.btnReg.isHidden = false
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
}

extension NewRegistration: AKMaskFieldDelegate {
    
    func maskField(_ maskField: AKMaskField, didChangedWithEvent event: AKMaskFieldEvent) {
        let s = maskField.text!
        if maskField.text!.count == 1 && (Int(maskField.text!) != nil || maskField.text?.first == "+") && !maskPhone{
            maskPhone = true
            #if isDJ
            #else
            maskField.maskExpression = "+7 ({ddd}) {ddd}-{dd}-{dd}"
            #endif
            maskField.maskTemplate = "*"
            maskField.text = s
            maskField.keyboardType = .phonePad
            maskField.reloadInputViews()
        }else if maskField.text!.count == 1 && !maskLogin && !maskPhone{
            maskLogin = true
            maskField.maskExpression = "{..........................}"
            maskField.maskTemplate = " "
            maskField.text = s
            maskField.keyboardType = .asciiCapable
            maskField.reloadInputViews()
        }else if maskField.text!.count == 0{
            maskPhone = false
            maskLogin = false
            #if isDJ
            #else
            maskField.maskExpression = "{.}"
            #endif
            maskField.maskTemplate = " "
            maskField.keyboardType = .asciiCapable
            maskField.reloadInputViews()
        }
    }
}
