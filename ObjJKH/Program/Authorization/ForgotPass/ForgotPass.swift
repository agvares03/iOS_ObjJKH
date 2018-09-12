//
//  ForgotPass.swift
//  ObjJKH
//
//  Created by Роман Тузин on 27.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class ForgotPass: UIViewController {
    
    var letter: String = ""
    var responseString:NSString = ""

    @IBOutlet weak var FogLogin: UITextField!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var separator1: UIView!
    
    @IBAction func btnCancelGo(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnForgotGo(_ sender: UIButton) {
        StartIndicator()
        
        let urlPath = Server.SERVER + Server.FORGOT + "login=" + FogLogin.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let url: NSURL = NSURL(string: urlPath)!
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    let alert = UIAlertController(title: "Результат", message: "Не удалось. Попробуйте позже", preferredStyle: UIAlertControllerStyle.alert)
                                                    alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: nil))
                                                    self.present(alert, animated: true, completion: nil)
                                                    self.responseString = "xxx";
                                                    self.choice()
                                                    return
                                                }
                                                
                                                self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                                                print("responseString = \(self.responseString)")
                                                
                                                self.choice()
                                                
        })
        
        task.resume()
    }
    
    func choice(){
        if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Не указан лицевой счет", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "2") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Некорректные данные", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString.length > 150) {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Ошибка сервера. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Успешно", message: "Пароль отправлен в смс на указанный номер", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboard_byTap()
        StopIndicator()
        
        // Установим цвета для элементов в зависимости от Таргета
        btnForgot.backgroundColor = myColors.btnColor.uiColor()
        btnCancel.setTitleColor(myColors.btnColor.uiColor(), for: .normal) 
        separator1.backgroundColor = myColors.labelColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func StartIndicator(){
        self.btnForgot.isHidden = true
        self.btnCancel.isHidden = true
        
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.btnForgot.isHidden = false
        self.btnCancel.isHidden = false
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
}
