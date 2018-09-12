//
//  MainMenu.swift
//  ObjJKH
//
//  Created by Роман Тузин on 27.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class MainMenu: UIViewController {
    
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var ls1: UILabel!
    @IBOutlet weak var ls2: UILabel!
    @IBOutlet weak var ls3: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var PageView: UIView!
    @IBOutlet weak var ViewInfoLS: UIView!
    
    @IBOutlet weak var height_Pays: NSLayoutConstraint!
    @IBOutlet weak var btn_Pays: UIButton!
    @IBOutlet weak var heigth_Questions: NSLayoutConstraint!
    @IBOutlet weak var btn_Questions: UIButton!
    @IBOutlet weak var Questions_arrow: UIImageView!
    @IBOutlet weak var heigth_view: NSLayoutConstraint!
    
    var phone: String?
    
    @IBAction func AddLS(_ sender: UIButton) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        // Телефон диспетчера
        phone = defaults.string(forKey: "phone_operator")
        
        // Приветствие
        labelTime.text = "Здравствуйте,"
        labelName.text = defaults.string(forKey: "name")
        
        // Выведем подключенные лицевые счета
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        
        if ((str_ls_arr?.count)! > 3) {
            ls1.text = str_ls_arr?[0]
            ls2.text = str_ls_arr?[1]
            ls3.text = str_ls_arr?[2]
        } else if ((str_ls_arr?.count)! == 2) {
            ls1.text = str_ls_arr?[0]
            ls2.text = str_ls_arr?[1]
        } else if ((str_ls_arr?.count)! == 1) {
            ls1.text = str_ls_arr?[0]
        }
        
        // Подключим счетчик секунд
        if (defaults.bool(forKey: "NeedHello")) {
            
            self.ViewInfoLS.isHidden = true
            
            let timer = Timer(timeInterval: 4, target: self, selector: #selector(timerEndedUp(_:)), userInfo: ["start" : "ok"], repeats: false)
            RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
            defaults.setValue(false, forKey: "NeedHello")
        } else {
            self.PageView.isHidden = true
            self.ViewInfoLS.isHidden = false
        }

        // Картинка в зависимости от Таргета
        #if isOur_Obj_Home
            fon_top.image = UIImage(named: "logo_Our_Obj_Home_white")
            height_Pays.constant = 3
            btn_Pays.isHidden = true
            btn_Pays.isEnabled = false
        
            heigth_Questions.constant = 0
            btn_Questions.isHidden = true
            btn_Questions.isEnabled = false
            Questions_arrow.isHidden = true
        
            heigth_view.constant = 287
        #elseif isChist_Dom
            fon_top.image = UIImage(named: "Logo_Chist_Dom_White")
        #elseif isMupRCMytishi
            fon_top.image = UIImage(named: "logo_MupRCMytishi_White")
        #elseif isDJ
            fon_top.image = UIImage(named: "logo_DJ_White")
        #elseif isUKKomfort
            fon_top.image = UIImage(named: "logo_UK_Komfort_white")
        #endif
    }
    
    // Звонок оператору
    @IBAction func phone_operator(_ sender: UIButton) {
        let newPhone = phone?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        if let url = URL(string: "tel://" + newPhone!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // Заявки
    @IBAction func go_apps(_ sender: UIButton) {
    }
    
    // Опросы
    @IBAction func go_questions(_ sender: UIButton) {
    }
    
    // Показания счетчиков
    @IBAction func go_counters(_ sender: UIButton) {
        #if isOur_Obj_Home
            self.performSegue(withIdentifier: "noCounters", sender: self)
        #else
            self.performSegue(withIdentifier: "mainCounters", sender: self)
        #endif
        
    }
    
    // Ведомости
    @IBAction func go_osv(_ sender: UIButton) {
    }
    
    // Оплаты
    @IBAction func go_pays(_ sender: UIButton) {
    }
    
    // Web-камеры
    @IBAction func go_web(_ sender: UIButton) {
    }
    
    // Выход
    @IBAction func go_exit(_ sender: UIButton) {
        exit(0)
//        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
    
    @objc func timerEndedUp(_ timer : Timer) {
        setHidenView(view: self.PageView, hidden:  true)
        setHidenView(view: self.ViewInfoLS, hidden: false)
    }
    
    func setHidenView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 3, options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {
                            view.isHidden = hidden
        },
                          completion: { finished in
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false;
    }

}
