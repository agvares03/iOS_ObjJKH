//
//  Registration.swift
//  ObjJKH
//
//  Created by Роман Тузин on 27.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class Registration: UIViewController {
    
    @IBOutlet weak var edPhone: UITextField!
    @IBOutlet weak var edFIO: UITextField!
    @IBOutlet weak var btnReg: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!    
    @IBOutlet weak var phone: UIImageView!
    @IBOutlet weak var person: UIImageView!
    
    @IBOutlet weak var switch_can: UISwitch!
    var responseString: String = ""
    
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
    
    @IBAction func btnRegGo(_ sender: UIButton) {
        self.view.endEditing(true)
        // Проверка на правильность поля номер телефона
        if (edPhone.text == "") {
            let alert = UIAlertController(title: "Ошибка", message: "Необходимо указать номер телефона", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else if (edFIO.text == "") {
            let alert = UIAlertController(title: "Ошибка", message: "Необходимо указать фамилию, имя, отчество", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            
            let defaults = UserDefaults.standard
            defaults.setValue(self.edPhone.text, forKey: "phone")
            defaults.synchronize()
            
            StartIndicator()
            get_registration()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard_byTap()
        
        StopIndicator()
        edPhone.text = "+7"
        
        // Установим цвета для элементов в зависимости от Таргета
        btnReg.backgroundColor = myColors.btnColor.uiColor()
        btnCancel.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        separator1.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        
        phone.image = myImages.phone_image
        person.image = myImages.person_image
        backBtn.tintColor = myColors.btnColor.uiColor()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func getServerUrlBy(phone PhoneText:String, fio txtFIO:String) -> String {
        if PhoneText.isPhoneNumber , let phone = PhoneText.asPhoneNumberWithoutPlus  {
            return Server.SERVER + Server.MOBILE_API_PATH + Server.REGISTRATION_NEW + "phone=" + phone.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&fio=" + txtFIO.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        } else {
            return "xxx"
        }
    }
    
    func get_registration() {
        let urlPath = self.getServerUrlBy(phone: self.edPhone.text!, fio: self.edFIO.text!)
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
                                                    
                                                    self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                    print("responseString = \(self.responseString)")
                                                    
                                                    self.choice()
            })
            task.resume()
        }
    }
    
    func choice() {
        if (responseString == "ok:1") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                self.performSegue(withIdentifier: "GetSMS", sender: self)
            })
        } else if (responseString == "ok:2") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                self.performSegue(withIdentifier: "GetSMS", sender: self)
            })
        } else {
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
