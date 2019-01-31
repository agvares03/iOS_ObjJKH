//
//  SupportController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 31/01/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class SupportController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var problemTxt: UITextView!
    
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
        let urlPath = Server.SERVER + Server.SEND_SUPPORT + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&text=" + text.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&mail=" + email.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        
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
                                                        let alert = UIAlertController(title: "Ваше сообщение успешно отправленно!", message: "", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                                                            self.navigationController?.popViewController(animated: true)
                                                        }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                }else{
                                                    DispatchQueue.main.async(execute: {
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
        problemTxt.delegate = self
        problemTxt.text = "Описание проблемы"
        problemTxt.textColor = UIColor.lightGray
        if UserDefaults.standard.bool(forKey: "fromMenu"){
            phoneTxt.text = UserDefaults.standard.string(forKey: "login")
            emailTxt.text = UserDefaults.standard.string(forKey: "mail")
        }
        sendBtn.backgroundColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
        separator3.backgroundColor = myColors.labelColor.uiColor()
        backBtn.tintColor = myColors.btnColor.uiColor()
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
