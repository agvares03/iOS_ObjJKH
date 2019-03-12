//
//  RegLSMup.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 14/11/2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class RegLSMup: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var separator1: UILabel!
    @IBOutlet weak var separator2: UILabel!
    @IBOutlet weak var separator3: UILabel!
    @IBOutlet weak var separator4: UILabel!
    
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func supportBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "support", sender: self)
    }
    
    @IBOutlet weak var btnReg: UIButton!
    
    // Телефон, который регистрируется
    var phone: String = ""
    var response_add_ident: String?
    
    @IBOutlet weak var txtNumberLS: UILabel!
    @IBOutlet weak var txtPassLS: UILabel!
    @IBOutlet weak var txtEmailLS: UILabel!
    @IBOutlet weak var txtBillKeyLS: UILabel!
    
    @IBOutlet weak var identLS: UITextField!
    @IBOutlet weak var passLS: UITextField!
    @IBOutlet weak var emailLS: UITextField!
    @IBOutlet weak var billkeyLS: UITextField!
    
    @IBAction func RegLS(_ sender: UIButton) {
        if identLS.text == "" || passLS.text == "" || emailLS.text == "" || billkeyLS.text == "" {
            let alert = UIAlertController(title: "Заполните все поля", message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let fio = UserDefaults.standard.string(forKey: "name")
        // Регистрация лицевого счета
        var urlPath = "http://uk-gkh.org/muprcmytishi_admin/api/muprkcdatasync/register?"
        urlPath = urlPath + "ident=" + (identLS.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
        urlPath = urlPath + "&phone=" + phone.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        urlPath = urlPath + "&pwd=" + (passLS.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
        urlPath = urlPath + "&email=" + (emailLS.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
        urlPath = urlPath + "&fio=" + (fio!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)
        urlPath = urlPath + "&billkey=" + (billkeyLS.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
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
                                                print("responseString = \(String(describing: self.response_add_ident))")
                                                self.choice_reg_ident()
                                                
        })
        task.resume()
    }
    
    func choice_reg_ident() {
        if ((self.response_add_ident?.contains("ok"))!) {
            self.addLS()
        } else {
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Ошибка", message: self.response_add_ident?.replacingOccurrences(of: "error: ", with: ""), preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    func addLS() {
        // Регистрация лицевого счета
        var urlPath = "http://uk-gkh.org/muprcmytishi_admin/api/muprkcdatasync/startsync?"
        urlPath = urlPath + "ident=" + (identLS.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
        urlPath = urlPath + "&pwd=" + (passLS.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
        urlPath = urlPath + "&phone=" + phone.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
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
                                                print("responseString = \(String(describing: self.response_add_ident))")
                                                self.choice_add_ident()
                                                
        })
        task.resume()
    }

    
    func choice_add_ident() {
        if ((self.response_add_ident?.contains("ok"))!) {
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Успешно", message: "Лицевой счет - " + (self.identLS.text)! + "зарегестрирован и привязан к аккаунту " + self.phone, preferredStyle: .alert)
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
        } else {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        phone = defaults.string(forKey: "phone")!
        identLS.delegate = self
        // Установим цвета для элементов в зависимости от Таргета
        btnReg.backgroundColor = myColors.btnColor.uiColor()
        back.tintColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
        separator3.backgroundColor = myColors.labelColor.uiColor()
        separator4.backgroundColor = myColors.labelColor.uiColor()
        
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        identLS.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}
