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
    
    // Картинки - для разных Таргетов
    @IBOutlet weak var notice: UIImageView!
    @IBOutlet weak var application: UIImageView!
    @IBOutlet weak var poll: UIImageView!
    @IBOutlet weak var meters: UIImageView!
    @IBOutlet weak var saldo: UIImageView!
    @IBOutlet weak var payment: UIImageView!
    @IBOutlet weak var webs_img: UIImageView!
    @IBOutlet weak var services: UIImageView!
    @IBOutlet weak var exit_img: UIImageView!
    
    var phone: String?
    
    @IBAction func AddLS(_ sender: UIButton) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    // Отвяжать лицевые счета от аккаунта
    @IBOutlet weak var btn_ls1: UIButton!
    @IBOutlet weak var btn_ls2: UIButton!
    @IBOutlet weak var btn_ls3: UIButton!

    @IBAction func ls1_del(_ sender: UIButton) {
        try_del_ls_from_acc(ls: ls1)
    }
    @IBAction func ls2_del(_ sender: UIButton) {
        try_del_ls_from_acc(ls: ls2)
    }
    @IBAction func ls3_del(_ sender: UIButton) {
        try_del_ls_from_acc(ls: ls3)
    }
    
    func try_del_ls_from_acc(ls: UILabel) {
        
        let defaults = UserDefaults.standard
        let phone = defaults.string(forKey: "phone")
        let ident =  ls.text
        
        if (phone == ident) {
            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Невозможно отвязать лицевой счет " + ls.text! + ". Вы зашли, используя этот лицевой счет.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Отвязать лицевой счет " + ls.text! + " от аккаунта?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
                
                var urlPath = Server.SERVER + Server.MOBILE_API_PATH + Server.DEL_IDENT_ACC
                urlPath = urlPath + "phone=" + phone! + "&ident=" + ident!
                let url: NSURL = NSURL(string: urlPath)!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "GET"
                
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
                                                        
                                                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                        print("responseString = \(responseString)")
                                                        
                                                        self.del_ls_from_acc(ls: ls)
                })
                task.resume()
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func del_ls_from_acc(ls: UILabel) {
        DispatchQueue.main.async(execute: {
            // Выведем подключенные лицевые счета
            let defaults = UserDefaults.standard
            let str_ls = defaults.string(forKey: "str_ls")
            var newStr_ls = str_ls?.replacingOccurrences(of: ls.text! + ",", with: "")
            newStr_ls = newStr_ls?.replacingOccurrences(of: ls.text!, with: "")
            
            self.ls1.text = ""
            self.btn_ls1.isHidden = true
            self.btn_ls1.isEnabled = false
            
            self.ls2.text = ""
            self.btn_ls2.isHidden = true
            self.btn_ls2.isEnabled = false
            
            self.ls3.text = ""
            self.btn_ls3.isHidden = true
            self.btn_ls3.isEnabled = false
            
            let str_ls_arr = newStr_ls?.components(separatedBy: ",")
            
            if ((str_ls_arr?.count)! > 3) {
                self.ls1.text = str_ls_arr?[0]
                self.btn_ls1.isHidden = false
                self.btn_ls1.isEnabled = true
                
                self.ls2.text = str_ls_arr?[1]
                self.btn_ls2.isHidden = false
                self.btn_ls2.isEnabled = true
                
                self.ls3.text = str_ls_arr?[2]
                self.btn_ls3.isHidden = false
                self.btn_ls3.isEnabled = true
            } else if ((str_ls_arr?.count)! == 2) {
                self.ls1.text = str_ls_arr?[0]
                self.btn_ls1.isHidden = false
                self.btn_ls1.isEnabled = true
                
                self.ls2.text = str_ls_arr?[1]
                self.btn_ls2.isHidden = false
                self.btn_ls2.isEnabled = true
            } else if ((str_ls_arr?.count)! == 1) {
                self.ls1.text = str_ls_arr?[0]
                if (self.ls1.text != "") {
                    self.btn_ls1.isHidden = false
                    self.btn_ls1.isEnabled = true
                }
            }
            
            defaults.set(newStr_ls, forKey: "str_ls")
            defaults.synchronize()
        })
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
            btn_ls1.isHidden = false
            btn_ls1.isEnabled = true
            
            ls2.text = str_ls_arr?[1]
            btn_ls2.isHidden = false
            btn_ls2.isEnabled = true
            
            ls3.text = str_ls_arr?[2]
            btn_ls3.isHidden = false
            btn_ls3.isEnabled = true
        } else if ((str_ls_arr?.count)! == 2) {
            ls1.text = str_ls_arr?[0]
            btn_ls1.isHidden = false
            btn_ls1.isEnabled = true
            
            ls2.text = str_ls_arr?[1]
            btn_ls2.isHidden = false
            btn_ls2.isEnabled = true
        } else if ((str_ls_arr?.count)! == 1) {
            ls1.text = str_ls_arr?[0]
            if (ls1.text != "") {
                btn_ls1.isHidden = false
                btn_ls1.isEnabled = true
            }
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
        
            heigth_view.constant = 320
        #elseif isChist_Dom
            fon_top.image = UIImage(named: "Logo_Chist_Dom_White")
        #elseif isMupRCMytishi
            fon_top.image = UIImage(named: "logo_MupRCMytishi_White")
            btn_Questions.isEnabled = false
            btn_Questions.isHidden = true
            heigth_Questions.constant = 0
            Questions_arrow.isHidden = true
            poll.isHidden = true
        
            payment.isHidden = true
            btn_Pays.isEnabled = false
            btn_Pays.isHidden = true
            height_Pays.constant = 0
        
            heigth_view.constant = 322
        #elseif isDJ
            fon_top.image = UIImage(named: "logo_DJ_White")
        #elseif isStolitsa
            fon_top.image = UIImage(named: "logo_Stolitsa_white")
        #elseif isUKKomfort
            fon_top.image = UIImage(named: "logo_UK_Komfort_white")
        #endif
        
        // Картинки для разных Таргетов
        notice.image = myImages.notice_image
        application.image = myImages.application_image
        poll.image = myImages.poll_image
        meters.image = myImages.meters_image
        saldo.image = myImages.saldo_image
        payment.image = myImages.payment_image
        webs_img.image = myImages.webs_image
        services.image = myImages.application_image
        exit_img.image = myImages.exit_image
        
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
