//
//  ReportAlertVC.swift
//  RKC_Samara
//
//  Created by Sergey Ivanov on 07.04.2020.
//  Copyright © 2020 The Best. All rights reserved.
//

import UIKit
import MessageUI

class ReportAlertVC: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var webBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    
    @IBAction func btnCancelGo(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onePhoneAction(_ sender: UIButton) {
//        let newPhone = phoneBtn.titleLabel?.text
//        if let url = URL(string: "tel://" + newPhone!) {
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
    }
    
    @IBAction func goWebAction(_ sender: UIButton) {
        let newPhone = webBtn.titleLabel?.text
        if let url = URL(string: newPhone!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func sendEmailAction(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let email = MFMailComposeViewController()
            email.mailComposeDelegate = self
            email.setToRecipients([emailBtn.titleLabel?.text ?? ""])
            present(email, animated: true)
        } else {
            
            let alert = UIAlertController(title: nil, message: "Пожалуйста, настройте почту на вашем телефоне", preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "Открыть настройки", style: .default, handler: { (_) in
                
                if let url = URL(string:UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:]) { (_) in }
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            } ) )
            alert.addAction( UIAlertAction(title: "Отменить", style: .default, handler: { (_) in } ) )
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func goViberAction(_ sender: UIButton) {
        let newPhone = phoneBtn.titleLabel?.text
        if let url = URL(string: "viber://add?number=" + newPhone!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func goWhatsAppAction(_ sender: UIButton) {
        let phone: String = phoneBtn.titleLabel?.text ?? ""
        let urlWhats = "whatsapp://send?phone=\(phone.replacingOccurrences(of: "-", with: ""))"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.tintColor = myColors.btnColor.uiColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
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
