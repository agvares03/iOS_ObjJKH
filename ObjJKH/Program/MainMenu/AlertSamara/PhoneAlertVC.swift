//
//  PhoneAlertVC.swift
//  RKC_Samara
//
//  Created by Sergey Ivanov on 07.04.2020.
//  Copyright © 2020 The Best. All rights reserved.
//

import UIKit

class PhoneAlertVC: UIViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var onePhoneBtn: UIButton!
    @IBOutlet weak var twoPhoneBtn: UIButton!
    
    @IBAction func btnCancelGo(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onePhoneAction(_ sender: UIButton) {
        let newPhone = onePhoneBtn.titleLabel?.text
        if let url = URL(string: "tel://" + newPhone!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func twoPhoneAction(_ sender: UIButton) {
        let newPhone = twoPhoneBtn.titleLabel?.text
        if let url = URL(string: "tel://" + newPhone!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backBtn.tintColor = myColors.btnColor.uiColor()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
