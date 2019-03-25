//
//  nonPassController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 27/02/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class nonPassController: UIViewController {
    
    @IBOutlet weak var lsLbl: UILabel!
    @IBOutlet weak var hLbl: UILabel!
    @IBOutlet weak var editPassBtn: UIButton!
    @IBOutlet weak var cancelPassBtn: UIButton!
    @IBOutlet weak var delLsBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var widthBtn: NSLayoutConstraint!
    @IBOutlet weak var heightPass: NSLayoutConstraint!
    @IBOutlet weak var viewBottom: NSLayoutConstraint!
    @IBOutlet weak var topView: NSLayoutConstraint!
    @IBOutlet weak var lsPass: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var separator1: UILabel!
    
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        if editPass{
            editPass = false
            let str = lsPass.text
            if str != ""{
                self.StartIndicator()
                self.sendNewPass(ls: ls, pass: str!)
            }else{
                lsPass.text = ""
                let alert = UIAlertController(title: "Ошибка", message: "Укажите пароль!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }else{
            DispatchQueue.main.async {
                self.widthBtn.constant = (self.view.frame.width - 80) / 2 - 1
                self.heightPass.constant = 65
                self.separator1.isHidden = false
                self.viewBottom.constant = 0
                self.cancelBtn.isHidden = true
                self.delLsBtn.isHidden = true
                self.hLbl.isHidden = false
                self.editPassBtn.setTitle("Сменить", for: .normal)
            }
            editPass = true
        }
    }
    
    @IBAction func cancelPassAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.editPass = false
            self.widthBtn.constant = 0
            self.heightPass.constant = 0
            self.viewBottom.constant = 82
            self.cancelBtn.isHidden = false
            self.delLsBtn.isHidden = false
            self.hLbl.isHidden = true
            self.separator1.isHidden = true
            self.editPassBtn.setTitle("Сменить пароль", for: .normal)
        }
    }
    
    @IBAction func delLsAction(_ sender: UIButton) {
        self.delLS()
    }
    
    public var ls = ""
    var editPass = false
    var responseString = ""
    public var login = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StopIndicator()
        hLbl.isHidden = true
        self.separator1.isHidden = true
        self.topView.constant = getPoint()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        self.topView.constant = getPoint() - 100
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        self.topView.constant = getPoint()
    }
    
    func sendNewPass(ls: String, pass: String){
        let txtLogin: String = login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let txtPass: String = pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let ident: String = ls.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
        let urlPath = Server.SERVER + Server.NEW_PASS_LS + "phone=" + txtLogin + "&ident=" + ident + "&pwd=" + txtPass
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
                                                if self.responseString == "ok"{
                                                    DispatchQueue.main.async(execute: {
                                                        self.StopIndicator()
                                                        let alert = UIAlertController(title: "Пароль для \(ls) успешно изменён!", message: "", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                                                            self.removeFromParentViewController()
                                                            self.view.removeFromSuperview()
                                                        }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                }else{
                                                    DispatchQueue.main.async(execute: {
                                                        self.StopIndicator()
                                                        let alert = UIAlertController(title: "Неверный пароль", message: "", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                                                            
                                                        }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                }
        })
        task.resume()
    }
    
    func delLS(){
        let phone = login
        let ident =  ls
        let alert = UIAlertController(title: "Удаление лицевого счета", message: "Отвязать лицевой счет " + ls + " от аккаунта?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in
            
        }
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
            self.StartIndicator()
            var urlPath = Server.SERVER + Server.MOBILE_API_PATH + Server.DEL_IDENT_ACC
            urlPath = urlPath + "phone=" + phone + "&ident=" + ident
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
                                                    
                                                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                    print("responseString = \(responseString)")
                                                    if responseString == "ok"{
                                                        DispatchQueue.main.async(execute: {
                                                            self.StopIndicator()
                                                            let alert = UIAlertController(title: "Лицевой счет успешно отвязан", message: "", preferredStyle: .alert)
                                                            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                                                                self.removeFromParentViewController()
                                                                self.view.removeFromSuperview()
                                                            }
                                                            alert.addAction(cancelAction)
                                                            self.present(alert, animated: true, completion: nil)
                                                        })
                                                    }else{
                                                        DispatchQueue.main.async(execute: {
                                                            self.StopIndicator()
                                                            let alert = UIAlertController(title: "Аккаунт не найден в БД", message: "", preferredStyle: .alert)
                                                            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                                                                
                                                            }
                                                            alert.addAction(cancelAction)
                                                            self.present(alert, animated: true, completion: nil)
                                                        })
                                                    }
            })
            task.resume()
            
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func StartIndicator(){
        self.cancelPassBtn.isHidden = true
        self.editPassBtn.isHidden = true
        self.hLbl.isHidden = true
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.cancelPassBtn.isHidden = false
        self.editPassBtn.isHidden = false
        self.hLbl.isHidden = false
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    func removeController(){
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    func getPoint() -> CGFloat{
        return (self.view.frame.height / 2) - 97
    }
}
