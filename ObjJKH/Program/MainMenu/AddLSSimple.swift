//
//  AddLSSimple.swift
//  ObjJKH
//
//  Created by Роман Тузин on 04/08/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class AddLSSimple: UIViewController {

    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendTech(_ sender: UIButton) {
        self.performSegue(withIdentifier: "support", sender: self)
    }

    @IBOutlet weak var indicatior:      UIActivityIndicatorView!
    @IBOutlet weak var edLS:            UITextField!
    @IBOutlet weak var helpLSImg:       UIImageView!
    @IBOutlet weak var helpLSHeight:    NSLayoutConstraint!
    @IBOutlet weak var edPin:           UITextField!
    @IBOutlet weak var imgTech:         UIImageView!
    @IBOutlet weak var support:         UIImageView!
    @IBOutlet weak var supportBtn:      UIButton!
    @IBOutlet weak var back:            UIBarButtonItem!
    @IBOutlet weak var separator:       UILabel!
    @IBOutlet weak var separator2:      UILabel!
    @IBOutlet weak var pinView:         UIView!
    @IBOutlet weak var pinViewHeight:   NSLayoutConstraint!
    @IBOutlet weak var urlHeight:       NSLayoutConstraint!
    @IBOutlet weak var helpLbl:         UILabel!
    @IBOutlet weak var btnAddOutlet:    UIButton!
    @IBOutlet weak var openURLBtn:      UIButton!
    
    // Телефон, который регистрируется
    var phone: String = ""
    var response_add_ident: String?
    var response_ident: String?
    
    @IBAction func openURL(_ sender: UIButton) {
        let url  = NSURL(string: "https://irkcm.ru/irkcm.htm")
        if UIApplication.shared.canOpenURL(url! as URL) == true  {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func btnAdd(_ sender: UIButton) {
        var err = false
        #if isMUP_IRKC
        let textPin = edPin.text?.replacingOccurrences(of: " ", with: "")
        if (edPin.text == "") || textPin == "" {
            err = true
        }
        #endif
        if UserDefaults.standard.string(forKey: "enablePin") == "1"{
            let textPin = edPin.text?.replacingOccurrences(of: " ", with: "")
            if (edPin.text == "") || textPin == "" {
                err = true
            }
        }
        let textLS = edLS.text?.replacingOccurrences(of: " ", with: "")
        if (edLS.text == "") || textLS == "" {
            
            let alert = UIAlertController(title: "Ошибка", message: "Укажите лицевой счет для подключения", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }else if err{
            let alert = UIAlertController(title: "Ошибка", message: "Укажите пин-код для подключения", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            
            StartIndicator()
            
            // Добавление лицевого счета
            var urlPath = Server.SERVER + Server.MOBILE_API_PATH + Server.ADD_LS_SIMPLE
            urlPath = urlPath + "phone=" + phone.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            urlPath = urlPath + "&ident=" + (edLS.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
            #if isMUP_IRKC
            urlPath = urlPath + "&pin=" + (edPin.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
            #endif
            if UserDefaults.standard.string(forKey: "enablePin") == "1"{
                urlPath = urlPath + "&pin=" + (edPin.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
            }
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
                                                    
                                                    self.response_ident = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                    print("responseString = \(String(describing: self.response_ident))")
                                                    self.choice_ident()
                                                    
            })
            task.resume()
            
        }
        
    }
    
    func choice_ident() {
        if (self.response_ident?.contains("ok") == true) {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                
                var alert = UIAlertController(title: "Проверьте правильность адреса", message: self.response_ident?.replacingOccurrences(of: "ok: ", with: ""), preferredStyle: .alert)
                #if isElectroSbitSaratov
                    alert.addTextField { textField in
                        textField.placeholder = "Введите пин-код..."
                    }
                #endif
                #if isRKC_Samara
                alert = UIAlertController(title: "Введите ФИО", message: "Необходимо указывать ФИО, обозначенные в ваших квитанциях на оплату, соблюдая написание в точности до знака.", preferredStyle: .alert)
                alert.addTextField { textField in
                    textField.placeholder = "Фамилия..."
                    textField.textContentType = .name
                }
                alert.addTextField { textField in
                    textField.placeholder = "Имя..."
                    textField.textContentType = .name
                }
                alert.addTextField { textField in
                    textField.placeholder = "Отчество..."
                    textField.textContentType = .name
                }
                #endif
                
                let addAction = UIAlertAction(title: "Добавить лицевой счет", style: .default, handler: { (_) -> Void in
                    
                    #if isElectroSbitSaratov

                        if (alert.textFields?.first?.text == "") {
                        
                            DispatchQueue.main.async(execute: {
                                self.StopIndicator()
                                let alert = UIAlertController(title: "Ошибка", message: "Укажите пин-код", preferredStyle: .alert)
                                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                                    self.choice_ident()
                                }
                                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                                    self.performSegue(withIdentifier: "support", sender: self)
                                }
                                alert.addAction(cancelAction)
                                alert.addAction(supportAction)
                                self.present(alert, animated: true, completion: nil)
                            })
                            return
                        
                        }
                    
                    #endif
                    #if isRKC_Samara
                    var ref = false
                    var refStr = ""
                    if (alert.textFields?[0].text == "") {
                        ref = true
                        refStr = "Укажите фамилию"
                    }
                    if (alert.textFields?[1].text == "") {
                        ref = true
                        if refStr == ""{
                            refStr = "Укажите имя"
                        }else{
                            refStr = refStr + ", имя"
                        }
                    }
                    if (alert.textFields?[2].text == "") {
                        ref = true
                        if refStr == ""{
                            refStr = "Укажите отчество"
                        }else{
                            refStr = refStr + ", отчество"
                        }
                    }
                    if ref{
                        DispatchQueue.main.async(execute: {
                            self.StopIndicator()
                            let alert = UIAlertController(title: "Ошибка", message: refStr, preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                                self.choice_ident()
                            }
                            let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                                self.performSegue(withIdentifier: "support", sender: self)
                            }
                            alert.addAction(cancelAction)
                            alert.addAction(supportAction)
                            self.present(alert, animated: true, completion: nil)
                        })
                        return
                    }
                    #endif
                    
                    self.StartIndicator()
                    // Добавление лицевого счета
                    var urlPath = Server.SERVER + Server.MOBILE_API_PATH + Server.ADD_LS_SIMPLE
                    urlPath = urlPath + "phone=" + self.phone.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                    urlPath = urlPath + "&ident=" + (self.edLS.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
                    #if isMUP_IRKC
                    urlPath = urlPath + "&pin=" + (self.edPin.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
                    #endif
                    if UserDefaults.standard.string(forKey: "enablePin") == "1"{
                        urlPath = urlPath + "&pin=" + (self.edPin.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
                    }
                    urlPath = urlPath + "&doAdd=1"
                    #if isRKC_Samara
                    urlPath = urlPath + "&f=" + (alert.textFields?[0].text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
                    urlPath = urlPath + "&i=" + (alert.textFields?[1].text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
                    urlPath = urlPath + "&o=" + (alert.textFields?[2].text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
                    #endif
                    #if isElectroSbitSaratov
                    
                        urlPath = urlPath + "&pin=" + (alert.textFields?.first!.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
                    
                    #endif
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
                                                            
                                                            self.response_add_ident = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                            // print("responseString = \(String(describing: self.response_add_ident))")
                                                            self.choice_add_ident()
                                                            
                    })
                    task.resume()
                    
                })
                alert.addAction(addAction)
                let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (self.response_ident?.contains("проверочный код уже отправлен"))! {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Проверочный код уже отправлен", message: "Введите код из уведомления", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Код из уведомления..."
                    textField.keyboardType = .decimalPad
                }
                let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    let textField = alert.textFields![0]
                    let str = textField.text
                    self.checkSMS(smsCode: str!)
                }
                let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            }
        } else if (self.response_ident?.contains("уже привязан"))! {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: self.response_add_ident, message: "Введите код из уведомления", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Код из уведомления..."
                    textField.keyboardType = .decimalPad
                }
                let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    let textField = alert.textFields![0]
                    let str = textField.text
                    self.checkSMS(smsCode: str!)
                }
                let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: self.response_ident?.replacingOccurrences(of: "error: ", with: ""), preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    func choice_add_ident() {
        if (self.response_add_ident?.contains("ok") == true) {
                DispatchQueue.main.async(execute: {
                    self.StopIndicator()
                    let alert = UIAlertController(title: "Успешно", message: "Лицевой счет - " + (self.edLS.text)! + " привязан к аккаунту " + self.phone, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                        
                        let defaults = UserDefaults.standard
                        defaults.set(self.phone, forKey: "login")
                        defaults.set(true, forKey: "go_to_app")
                        defaults.synchronize()
                        
                        // Перейдем на главную страницу со входом в приложение
                        self.performSegue(withIdentifier: "go_to_app", sender: self)
                        
                    }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                })
        } else if (self.response_add_ident?.contains("проверочный код уже отправлен"))! {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Проверочный код уже отправлен", message: "Введите код из уведомления", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Код из уведомления..."
                    textField.keyboardType = .decimalPad
                }
                let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    let textField = alert.textFields![0]
                    let str = textField.text
                    self.checkSMS(smsCode: str!)
                }
                let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in
                    self.StopIndicator()
                }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            }
        } else if (self.response_add_ident?.contains("уже привязан"))! {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: self.response_add_ident?.replacingOccurrences(of: "error:", with: ""), message: "Введите код из уведомления", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Код из уведомления..."
                    textField.keyboardType = .decimalPad
                }
                let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    let textField = alert.textFields![0]
                    let str = textField.text
                    self.checkSMS(smsCode: str!)
                }
                let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in
                    self.StopIndicator()
                }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: self.response_add_ident?.replacingOccurrences(of: "error: ", with: ""), preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        phone = defaults.string(forKey: "phone")!
        
        StopIndicator()
        #if isRKC_Samara
        helpLSImg.isHidden = false
        helpLSHeight.constant = 112
        #else
        helpLSImg.isHidden = true
        helpLSHeight.constant = 0
        #endif
        #if isMUP_IRKC
        pinView.isHidden = false
        pinViewHeight.constant = 130
        #else
        pinView.isHidden = true
        pinViewHeight.constant = 0
        #endif
        if UserDefaults.standard.string(forKey: "enablePin") == "1"{
            pinView.isHidden = false
            pinViewHeight.constant = 100
            urlHeight.constant = 0
            openURLBtn.isHidden = true
            helpLbl.textAlignment = .left
            helpLbl.text = "Лицевой счет и пин-код указывается на квитанции"
        }else{
            pinView.isHidden = true
            pinViewHeight.constant = 0
        }
        back.tintColor = myColors.btnColor.uiColor()
        btnAddOutlet.backgroundColor = myColors.btnColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        imgTech.setImageColor(color: myColors.btnColor.uiColor())
        separator.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if UserDefaults.standard.bool(forKey: "NewMain"){
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    func StartIndicator() {
        self.btnAddOutlet.isHidden = true
        self.indicatior.startAnimating()
        self.indicatior.isHidden = false
    }
    
    func StopIndicator() {
        self.btnAddOutlet.isHidden = false
        self.indicatior.stopAnimating()
        self.indicatior.isHidden = true
    }
    
    func checkSMS(smsCode: String){
        let urlPath = Server.SERVER + Server.MOBILE_API_PATH + "ValidateCheckCodeIdent.ashx?phone=" + phone.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&code=" + smsCode.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&ident=" + (edLS.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
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
                                                
                                                self.response_add_ident = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                //                                                print("responseString = \(String(describing: self.response_add_ident))")
                                                
                                                self.choice_sms_check()
                                                
        })
        task.resume()
    }
    
    func choice_sms_check() {
        if (self.response_add_ident == "ok") {
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Успешно", message: "Лицевой счет - " + (self.edLS.text)! + " привязан к аккаунту " + self.phone, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    
                    let defaults = UserDefaults.standard
                    defaults.set(self.phone, forKey: "login")
                    defaults.set(true, forKey: "go_to_app")
                    defaults.synchronize()
                    
                    // Перейдем на главную страницу со входом в приложение
                    self.performSegue(withIdentifier: "go_to_app", sender: self)
                    
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }else{
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Ошибка", message: self.response_add_ident?.replacingOccurrences(of: "error: ", with: ""), preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    
                    // Если я тут - регистрация уже прошла, логин, пароль есть - можно перекинуть в приложение
                    let defaults = UserDefaults.standard
                    defaults.set(self.phone, forKey: "login")
                    defaults.synchronize()
                    
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
}
