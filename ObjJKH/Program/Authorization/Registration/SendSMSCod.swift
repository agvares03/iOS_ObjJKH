//
//  SendSMSCod.swift
//  ObjJKH
//
//  Created by Роман Тузин on 27.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class SendSMSCod: UIViewController {
    
    var phone: String? = ""
    var responseString: String? = ""
    
    @IBOutlet weak var edSMS: UITextField!
    @IBOutlet weak var edSMSInfo: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnGo: UIButton!
    
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var sendSMS: UIButton!
    @IBOutlet weak var phone_img: UIImageView!
    
    @IBAction func sendSMSAgain(_ sender: UIButton) {
        send_sms(itsAgain: true)
    }
    
    func send_sms(itsAgain: Bool) {
        self.StartIndicator()
        self.view.endEditing(true)
        let urlPath = self.getServerUrlSendSMSAgain(phone: self.phone!)
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        self.StopIndicator()
                                                        let alert = UIAlertController(title: "Произошла непредивиденная ошибка", message: "", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
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
                                           //     print("responseString = \(String(describing: self.responseString))")
                                                
                                                if itsAgain {
                                                    self.choice_sms_again()
                                                } else {
                                                    self.stop()
                                                }
        })
        task.resume()
    }
    
    func stop() {
        DispatchQueue.main.async(execute: {
            self.StopIndicator()
        })
    }
    
    func choice_sms_again() {
        if (responseString == "ok") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "", message: "Проверочный код доступа отправлен", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: self.responseString?.replacingOccurrences(of: "error: ", with: ""), preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func btnGoPush(_ sender: UIButton) {
        self.view.endEditing(true)
        if (self.edSMS.text == "") {
            let alert = UIAlertController(title: "Ошибка", message: "Необходимо ввести код СМС", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let urlPath = self.getServerUrlSendSMS(phone: self.phone!, sms: self.edSMS.text!)
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        DispatchQueue.main.async(execute: {
                                                            self.StopIndicator()
                                                            let alert = UIAlertController(title: "Произошла непредивиденная ошибка", message: "", preferredStyle: .alert)
                                                            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
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
                                                  //  print("responseString = \(String(describing: self.responseString))")
                                                    
                                                    self.choice()
            })
            task.resume()
            
        }
    }
    
    func choice() {
        if (responseString == "ok") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                self.performSegue(withIdentifier: "SendNewPass", sender: self)
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Произошла непредивиденная ошибка", message: "", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
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
        
        self.phone = UserDefaults.standard.string(forKey: "phone")
        edSMSInfo.text = "отправлен на телефон " + self.phone! + " (действует в течение 10 минут)"
        
        send_sms(itsAgain: false)
        
        // Установим цвета для элементов в зависимости от Таргета
        btnGo.backgroundColor = myColors.btnColor.uiColor()
        sendSMS.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        separator1.backgroundColor = myColors.labelColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        
        phone_img.image = myImages.phone_image
        
    }

    func getServerUrlSendSMSAgain(phone PhoneText:String) -> String {
        return Server.SERVER + Server.MOBILE_API_PATH + Server.SEND_CHECK_PASS + "phone=" + PhoneText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
    }
    
    func getServerUrlSendSMS(phone PhoneText:String, sms txtSMS:String) -> String {
        return Server.SERVER + Server.MOBILE_API_PATH + Server.VALIDATE_SMS + "phone=" + PhoneText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&code=" + txtSMS.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func StartIndicator(){
        self.btnGo.isHidden = true
        self.edSMSInfo.isHidden = true
        
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.btnGo.isHidden = false
        self.edSMSInfo.isHidden = false
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }

}
