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
import AKMaskField

class FirstController: UIViewController {
    
    // Вспомогальные переменные для взаимодействия с севрером
    var responseLS: String = ""
    var responseString: String = ""
    // Для получения, хранения лиц. счетов
    private var data_ls: [String] = []
    var str_ls: String = ""
    var maskPhone = false
    var maskLogin = false
    
    @IBOutlet weak var ver_Lbl: UILabel!
    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var questionImg: UIImageView!
    @IBOutlet weak var heigt_image: NSLayoutConstraint!
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var new_face: UIImageView!
    @IBOutlet weak var edLogin: AKMaskField!
    @IBOutlet weak var edPass: UITextField!
    @IBOutlet weak var new_zamoc: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnEnter: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnReg: UIButton!
    @IBOutlet weak var showPass: UIButton!
    
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    public var firstEnter = false
    @IBOutlet weak var btnConsEnter: UIButton!
    
    var iconClick = false
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
    @IBAction func regAction(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "registerWithoutSMS"){
            self.performSegue(withIdentifier: "reg_app2", sender: self)
        }else{
            self.performSegue(withIdentifier: "reg_app", sender: self)
        }
    }
    var loginText = ""
    @IBAction func Enter(_ sender: UIButton) {
        // Проверка на заполнение
        var ret: Bool = false;
        var message: String = ""
        print(edLogin.text!)
        loginText = edLogin.text!
        if loginText.last == " "{
            for _ in 0...loginText.count - 1{
                if loginText.last == " "{
                    loginText.removeLast()
                }
            }
        }
        if (edLogin.text == "") || (edLogin.text!.replacingOccurrences(of: " ", with: "").count == 0){
            message = "Не указан логин. "
            ret = true;
        }
        if (edPass.text == "") || edPass.text!.contains(" ") || (edPass.text!.replacingOccurrences(of: " ", with: "").count == 0){
            message = message + "Не указан пароль."
            ret = true
        }
        if (!DB().isValidLogin(testStr: loginText) && maskLogin) || (loginText.contains(" ") && maskLogin){
            message = message + "Логин может содержать только буквы латинские (большие, маленькие), цифры и знак нижнего подчеркивания «_»"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "support1") {
            let nav = segue.destination as! UINavigationController
            let AddApp = nav.topViewController as! SupportUpdate
            AddApp.fromAuth = true
        }
        if (segue.identifier == "support"){
            let nav = segue.destination as! UINavigationController
            let AddApp = nav.topViewController as! SupportUpdate
            AddApp.fromAuth = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "fromMenu")
        UserDefaults.standard.set(false, forKey: "fromTech")
        UserDefaults.standard.set(true, forKey: "newApps")
        StopIndicator()
        #if isDJ
        maskLogin = true
        edLogin.keyboardType = .asciiCapable
        edLogin.placeholder = "Логин или номер телефона"
        #else
        if UserDefaults.standard.bool(forKey: "registerWithoutSMS"){
            edLogin.maskDelegate = self
            edLogin.maskExpression = "{.}"
            edLogin.text = ""
            edLogin.placeholder = "Логин или номер телефона"
        }else{
            // Маска для ввода - телефон
            #if isDJ
            maskLogin = true
            edLogin.keyboardType = .asciiCapable
            #else
            edLogin.maskExpression = "+7 ({ddd}) {ddd}-{dd}-{dd}"
            #endif
        }
        #endif
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
        // Если используется вход для консультантов - покажем кнопку
        if !defaults.bool(forKey: "useDispatcherAuth") {
            btnConsEnter.isHidden = true
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
        #elseif isServiceKomfort
        fon_top.image = UIImage(named: "Logo_ServiceKomfort")
        #elseif isParitet
        fon_top.image = UIImage(named: "Logo_Paritet")
        #elseif isSkyfort
        fon_top.image = UIImage(named: "Logo_Skyfort")
        #elseif isStandartDV
        fon_top.image = UIImage(named: "Logo_StandartDV")
        #elseif isGarmonia
        fon_top.image = UIImage(named: "Logo_UkGarmonia")
        #elseif isUpravdomChe
        fon_top.image = UIImage(named: "Logo_UkUpravdomChe")
        #elseif isJKH_Pavlovskoe
        fon_top.image = UIImage(named: "Logo_JKH_Pavlovskoe")
        #elseif isPerspectiva
        fon_top.image = UIImage(named: "Logo_UkPerspectiva")
        #elseif isParus
        fon_top.image = UIImage(named: "Logo_Parus")
        #elseif isUyutService
        fon_top.image = UIImage(named: "Logo_UyutService")
        #elseif isElectroSbitSaratov
        fon_top.image = UIImage(named: "Logo_ElectrosbitSaratov")
        #elseif isServicekom
        fon_top.image = UIImage(named: "Logo_Servicekom")
        #elseif isTeplovodoresources
        fon_top.image = UIImage(named: "Logo_Teplovodoresources")
        #elseif isStroimBud
        fon_top.image = UIImage(named: "Logo_StroimBud")
        #elseif isRodnikMUP
        fon_top.image = UIImage(named: "Logo_RodnikMUP")
        #elseif isUKParitetKhab
        fon_top.image = UIImage(named: "Logo_Paritet")
        #elseif isADS68
        fon_top.image = UIImage(named: "Logo_ADS68")
        #elseif isAFregat
        fon_top.image = UIImage(named: "Logo_Fregat")
        #elseif isNewOpaliha
        fon_top.image = UIImage(named: "Logo_NewOpaliha")
        #elseif isPritomskoe
        fon_top.image = UIImage(named: "Logo_Pritomskoe")
        #elseif isDJVladimir
        fon_top.image = UIImage(named: "Logo_DJVladimir")
        #elseif isTSN_Dnestr
        fon_top.image = UIImage(named: "Logo_TSN_Dnestr")
        #elseif isCristall
        fon_top.image = UIImage(named: "Logo_Cristall")
        #elseif isNarianMarEl
        fon_top.image = UIImage(named: "Logo_Narian_Mar_El")
        #elseif isSibAliance
        fon_top.image = UIImage(named: "Logo_SibAliance")
        #elseif isSpartak
        fon_top.image = UIImage(named: "Logo_Spartak")
        #elseif isTSN_Ruble40
        fon_top.image = UIImage(named: "Logo_Ruble40")
        #elseif isKosm11
        fon_top.image = UIImage(named: "Logo_Kosm11")
        #elseif isTSJ_Rachangel
        fon_top.image = UIImage(named: "Logo_TSJ_Archangel")
        #elseif isMUP_IRKC
        fon_top.image = UIImage(named: "Logo_MUP_IRKC")
        #elseif isUK_First
        fon_top.image = UIImage(named: "Logo_Uk_First")
        #elseif isRKC_Samara
        fon_top.image = UIImage(named: "Logo_Samara")
        #endif
        UserDefaults.standard.set("", forKey: "targetName")
        UserDefaults.standard.synchronize()
        // targetName - используется для определения ключа терминала (оплата Мытищи)
        #if isOur_Obj_Home
        #elseif isChist_Dom
        #elseif isMupRCMytishi
        UserDefaults.standard.set("MupRCMytishi", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isDJ
        #elseif isStolitsa
        #elseif isKomeks
        #elseif isUKKomfort
        #elseif isElectroSbitSaratov
        UserDefaults.standard.set("ElectroSbitSaratov", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isRodnikMUP
        UserDefaults.standard.set("RodnikMUP", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isAFregat
        UserDefaults.standard.set("AFregat", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isKlimovsk12
        UserDefaults.standard.set("Klimovsk12", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isPocket
        #elseif isReutKomfort
        UserDefaults.standard.set("ReutComfort", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isUKGarant
        UserDefaults.standard.set("UK_Garant", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isSoldatova1
        #elseif isTafgai
        #elseif isServiceKomfort
        UserDefaults.standard.set("UK_Service_Comfort", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isParus
        UserDefaults.standard.set("Parus", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isParitet
        #elseif isNewOpaliha
        UserDefaults.standard.set("NewOpaliha", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isSkyfort
        #elseif isStandartDV
        #elseif isGarmonia
        #elseif isUpravdomChe
        UserDefaults.standard.set("UK_Upravdom_Che", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isJKH_Pavlovskoe
        UserDefaults.standard.set("JKH_Pavlovskoe", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isPerspectiva
        #elseif isServicekom
        UserDefaults.standard.set("Servicekom", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isTeplovodoresources
        UserDefaults.standard.set("Teplovodoresources", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isStroimBud
        UserDefaults.standard.set("StroimBud", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #elseif isUKParitetKhab
        UserDefaults.standard.set("UKParitetKhab", forKey: "targetName")
        UserDefaults.standard.synchronize()
        #endif
        
        // Установим цвета для элементов в зависимости от Таргета
        btnEnter.backgroundColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        UITabBar.appearance().tintColor = myColors.btnColor.uiColor()
        // Картинки для разных Таргетов
        new_face.image = myImages.person_image
        new_face.setImageColor(color: myColors.btnColor.uiColor())
        new_zamoc.image = myImages.lock_image
        new_zamoc.setImageColor(color: myColors.btnColor.uiColor())
        questionImg.setImageColor(color: myColors.btnColor.uiColor())
        questionBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        showPass.tintColor = .lightGray
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
        if loginText == "test" {
            return Server.SERVER + Server.ENTER_MOBILE + "phone=" + loginText + "&pwd=" + txtPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        } else if loginText.isPhoneNumber , let phone = loginText.asPhoneNumberWithoutPlus  {
            return Server.SERVER + Server.ENTER_MOBILE + "phone=" + phone + "&pwd=" + txtPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        } else {
            return Server.SERVER + Server.ENTER_MOBILE + "phone=" + loginText + "&pwd=" + txtPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            //return Server.SERVER + Server.ENTER + "login=" + loginText + "&pwd=" + txtPass;
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
        var strLogin = ""
        if !maskLogin{
            strLogin = loginText.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }else{
            strLogin = loginText.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
        
        let txtLogin: String = strLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
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
        
        // Переменная - контроль одного факта обращения за сессию (пока не зайдешь снова, обращение отправить будет нельзя)
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "can_tech")
        defaults.synchronize()
        
        // Авторизация пользователя
        var strLogin = ""
        if !maskLogin{
            strLogin = loginText.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
            print(strLogin)
            strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
            print(strLogin)
            strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            print(strLogin)
            strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }else{
            strLogin = loginText.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
        print(strLogin)
        
        let txtLogin: String = strLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
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
    
    private func choice() {
        if (responseString == "1") {
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
                        vc.login = self.loginText
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
                #else
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
                db.getDataByEnter(login: self.loginText, pass: self.edPass.text!)
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
                UserDefaults.standard.set(false, forKey: "exit")
                if (self.isCons == "0") {
                    UserDefaults.standard.set(true, forKey: "NewMain")//Закоментить для старого дизайна
                    self.performSegue(withIdentifier: "NewMainMenu", sender: self)//Закоментить для старого дизайна
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
        
        var strLogin = ""
        if !maskLogin{
            strLogin = loginText.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            strLogin = strLogin.replacingOccurrences(of: "*", with: "", options: .literal, range: nil)
        }else{
            strLogin = loginText.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
        defaults.setValue(strLogin, forKey: "login")
        defaults.setValue(strLogin, forKey: "phone")
        defaults.setValue(edPass.text!, forKey: "pass")
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
        #if isDJ
        maskLogin = true
        edLogin.keyboardType = .asciiCapable
        if (login == "") {
            edLogin.text = "+7"
        } else {
            edLogin.text = login
            loginText = edLogin.text!.replacingOccurrences(of: " ", with: "")
            edPass.text = pass
            if !UserDefaults.standard.bool(forKey: "exit"){
                // Сохраним значения
                saveUsersDefaults()
                
                // Запрос - получение данных !!! (прежде попытаемся получить лиц. счета)
                get_LS()
            }
        }
        #else
        if UserDefaults.standard.bool(forKey: "registerWithoutSMS"){
            edLogin.maskDelegate = self
            edLogin.maskExpression = "{.}"
            edLogin.keyboardType = .asciiCapable
            edLogin.reloadInputViews()
            edLogin.text = ""
            if login != nil && login != "" && login?.first == "+" && !maskPhone{
                maskPhone = true
                edLogin.maskExpression = "+7 ({ddd}) {ddd}-{dd}-{dd}"
                edLogin.maskTemplate = "*"
                edLogin.text = login
                loginText = edLogin.text!.replacingOccurrences(of: " ", with: "")
                edLogin.keyboardType = .phonePad
                edLogin.reloadInputViews()
                edPass.text = pass
            }else if login != nil && login != "" && !maskLogin && !maskPhone {//&& login!.count > 0{
                maskLogin = true
                var mask = ""
                for _ in 0...login!.count - 1{
                    mask = mask + "."
                }
                mask = "{" + mask + "}"
                edLogin.maskExpression = mask
                edLogin.maskTemplate = " "
                edLogin.text = login
                loginText = edLogin.text!.replacingOccurrences(of: " ", with: "")
                edLogin.keyboardType = .asciiCapable
                edLogin.reloadInputViews()
                edPass.text = pass
            }
            if !UserDefaults.standard.bool(forKey: "exit"){
                // Сохраним значения
                saveUsersDefaults()
                
                // Запрос - получение данных !!! (прежде попытаемся получить лиц. счета)
                get_LS()
            }
        }else{
            // Маска для ввода - телефон
            edLogin.maskExpression = "+7 ({ddd}) {ddd}-{dd}-{dd}"
            if (login == "") {
                edLogin.text = "+7"
            } else {
                edLogin.text = login
                loginText = edLogin.text!.replacingOccurrences(of: " ", with: "")
                edPass.text = pass
                if !UserDefaults.standard.bool(forKey: "exit"){
                    // Сохраним значения
                    saveUsersDefaults()
                    
                    // Запрос - получение данных !!! (прежде попытаемся получить лиц. счета)
                    get_LS()
                }
            }
        }
        #endif
        //        print(login)
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
        print("encoding_Pays: ", encoding_Pays)
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

extension FirstController: AKMaskFieldDelegate {
    
    func maskField(_ maskField: AKMaskField, didChangedWithEvent event: AKMaskFieldEvent) {
        let s = maskField.text!
        #if isDJ
        #else
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
        }else if maskField.text!.count == 0 && (maskPhone || maskLogin){
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
        #endif
    }
}

