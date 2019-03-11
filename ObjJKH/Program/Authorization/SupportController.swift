//
//  SupportController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 31/01/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class SupportController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var problemTxt: UITextView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var ver_Lbl: UILabel!
    @IBOutlet weak var heigth_text_tech: NSLayoutConstraint!
    
    @IBAction func updateConect(_ sender: UIButton) {
        self.viewDidLoad()
    }
    @IBOutlet weak var updateConectBtn: UIButton!
    @IBOutlet weak var nonConectView: UIView!
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    @IBOutlet weak var separator3: UIView!
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendClick(_ sender: UIButton) {
        let login: String = phoneTxt.text!
        let email: String = emailTxt.text!
        let text: String  = problemTxt.text!
        if (!(login.contains("+7")) || (login.count < 12)){
            let alert = UIAlertController(title: "Ошибка", message: "Введите номер в формате +7хххххххххх", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if ((email.contains("@")) && (email.contains(".ru"))) || ((email.contains("@")) && (email.contains(".com"))){
            
        }else{
            let alert = UIAlertController(title: "Ошибка", message: "Укажите корректный e-mail", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if text == "" || text == "Описание проблемы"{
            let alert = UIAlertController(title: "Ошибка", message: "Опишите проблему", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.StartIndicator()
        let version = targetSettings().getVersion()
        var str_ls:String = ""
        if UserDefaults.standard.string(forKey: "str_ls") != nil{
            str_ls = UserDefaults.standard.string(forKey: "str_ls")!
        }
        //        let str_ls_arr = str_ls?.components(separatedBy: ",")
        var info = "Аккаунт - \(login)"
        if UserDefaults.standard.bool(forKey: "fromMenu"){
            info = "Аккаунт - \(login) лиц. счета - \(str_ls)"
        }
        let urlPath = Server.SERVER + Server.SEND_SUPPORT + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&text=" + text.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&mail=" + email.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&os=iOS" + "&appVersion=" + version.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&info=" + info.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        let alert = UIAlertController(title: "Ошибка сервера", message: "Попробуйте позже", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                    return
                                                }
                                                
                                                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                                                print("responseString = \(responseString)")
                                                if responseString == "0"{
                                                    DispatchQueue.main.async(execute: {
                                                        self.StopIndicator()
                                                        // Переменная - контроль одного факта обращения за сессию (пока не зайдешь снова, обращение отправить будет нельзя)
                                                        let defaults = UserDefaults.standard
                                                        defaults.set(false, forKey: "can_tech")
                                                        defaults.set(self.problemTxt.text, forKey: "txt_tech")
                                                        defaults.synchronize()
                                                        
                                                        let alert = UIAlertController(title: "Ваше сообщение успешно отправлено!", message: "", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                                                            self.navigationController?.popViewController(animated: true)
                                                        }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                        
                                                        self.enable_btn_send()
                                                    })
                                                }else{
                                                    DispatchQueue.main.async(execute: {
                                                        self.StopIndicator()
                                                        let alert = UIAlertController(title: "Ошибка!", message: responseString.replacingOccurrences(of: "error:", with: ""), preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                    return
                                                }
                                                
                                                
        })
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true
        nonConectView.isHidden = true
        questionLbl.isHidden = false
        phoneTxt.isHidden = false
        separator1.isHidden = false
        separator2.isHidden = false
        separator3.isHidden = false
        sendBtn.isHidden = false
        problemTxt.isHidden = false
        emailTxt.isHidden = false
        let version = targetSettings().getVersion()
        ver_Lbl.text = "ver. " + version
        problemTxt.delegate = self
        phoneTxt.delegate = self
        problemTxt.text = "Описание проблемы"
        problemTxt.textColor = UIColor.lightGray
        if UserDefaults.standard.bool(forKey: "fromMenu"){
            phoneTxt.text = UserDefaults.standard.string(forKey: "login")
            var login: String = UserDefaults.standard.string(forKey: "login")!
            if login.first == "7"{
                phoneTxt.text = "+" + login
            }else if login.first == "8"{
                login = "+" + login
                phoneTxt.text = login.replacingOccurrences(of: "+8", with: "+7")
            }
            emailTxt.text = UserDefaults.standard.string(forKey: "mail")
        }
        sendBtn.backgroundColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
        separator3.backgroundColor = myColors.labelColor.uiColor()
        ver_Lbl.textColor = myColors.labelColor.uiColor()
        backBtn.tintColor = myColors.btnColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        updateConectBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: Network.reachability)
        updateUserInterface()
        
        // Доступность и видимость кнопки отправки
        enable_btn_send()
        
    }
    
    func enable_btn_send() {
        
        // Переменная - контроль одного факта обращения за сессию (пока не зайдешь снова, обращение отправить будет нельзя)
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "can_tech") {
            
            sendBtn.isHidden = false
            phoneTxt.isEnabled = true
            emailTxt.isEnabled = true
            heigth_text_tech.constant = 130
            questionLbl.text = "Задайте вопрос здесь, опишите проблему. Мы обязательно Вам поможем."
            
        } else {
            
            sendBtn.isHidden = true
            phoneTxt.isEnabled = false
            emailTxt.isEnabled = false
            heigth_text_tech.constant = -2
            let txt_tech: String = defaults.string(forKey: "txt_tech") ?? ""
            questionLbl.text = "Ваше обращение отправлено. " + txt_tech
            
        }
    }
    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            nonConectView.isHidden = false
            questionLbl.isHidden = true
            phoneTxt.isHidden = true
            separator1.isHidden = true
            separator2.isHidden = true
            separator3.isHidden = true
            sendBtn.isHidden = true
            problemTxt.isHidden = true
            emailTxt.isHidden = true
        case .wifi: break
            
        case .wwan: break
            
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if problemTxt.textColor == UIColor.lightGray {
            problemTxt.text = nil
            problemTxt.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if problemTxt.text.isEmpty {
            problemTxt.text = "Описание проблемы"
            problemTxt.textColor = UIColor.lightGray
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.placeholder == "Номер телефона" && textField.text == ""{
            textField.text = "+7"
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "+7"{
            textField.text = ""
        }
    }
    
    func StartIndicator(){
        self.sendBtn.isHidden = true
        
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.sendBtn.isHidden = false
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
