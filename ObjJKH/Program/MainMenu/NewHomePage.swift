//
//  NewMainMenu.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 14/03/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class NewHomePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var ls1: UILabel!
    @IBOutlet weak var ls2: UILabel!
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var ls_View: UIView!
    @IBOutlet weak var news_View: UIView!
    @IBOutlet weak var counters_View: UIView!
    @IBOutlet weak var btn_Add_LS: UIButton!
    @IBOutlet weak var lbl_Add_LS: UILabel!
    @IBOutlet weak var news_indicator: UILabel!
    @IBOutlet weak var request_indicator: UILabel!
    @IBOutlet weak var question_indicator: UILabel!
    
    @IBOutlet weak var tableLS: UITableView!
    @IBOutlet weak var tableLSHeight: NSLayoutConstraint!
    
    // Размеры для настройки меню
    // Звонок диспетчеру
    @IBOutlet weak var callBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var callBtnImg: UIImageView!
    // Письмо в техподдержку
    @IBOutlet weak var suppBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var suppBtn: UIButton!
    @IBOutlet weak var suppBtnImg: UIImageView!
    
    @IBOutlet weak var targetName: UILabel!
    
    @IBOutlet weak var allNewsBtn: UILabel!
    @IBOutlet weak var allLSBtn: UILabel!
    @IBOutlet weak var allCountersBtn: UILabel!
    
    @IBOutlet weak var one_LS_Pay: UILabel!
    @IBOutlet weak var two_LS_Pay: UILabel!
    
    @IBOutlet weak var one_Counters_Set: UILabel!
    @IBOutlet weak var two_Counters_Set: UILabel!
    
    var phone: String?
    
    @IBAction func AddLS(_ sender: UIButton) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "addLS_Mup", sender: self)
        #else
        self.performSegue(withIdentifier: "addLS", sender: self)
        #endif
    }
    
    // Отвязать лицевые счета от аккаунта
    @IBOutlet weak var btn_ls1: UIButton!
    @IBOutlet weak var btn_ls2: UIButton!
    @IBOutlet weak var btn_ls3: UIButton!
    
    @IBAction func ls1_del(_ sender: UIButton) {
        try_del_ls_from_acc(ls: ls1)
    }
    @IBAction func ls2_del(_ sender: UIButton) {
        try_del_ls_from_acc(ls: ls2)
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
            newStr_ls = newStr_ls?.replacingOccurrences(of: "," + ls.text!, with: "")
            newStr_ls = newStr_ls?.replacingOccurrences(of: ls.text!, with: "")
            self.ls1.text = ""
            self.btn_ls1.isHidden = true
            self.btn_ls1.isEnabled = false
            
            self.ls2.text = ""
            self.btn_ls2.isHidden = true
            self.btn_ls2.isEnabled = false
            
            let str_ls_arr = newStr_ls?.components(separatedBy: ",")
            defaults.set(newStr_ls, forKey: "str_ls")
            defaults.synchronize()
            if ((str_ls_arr?.count)! >= 3) {
                self.ls1.text = str_ls_arr?[0]
                self.btn_ls1.isHidden = false
                self.btn_ls1.isEnabled = true
                
                self.ls2.text = str_ls_arr?[1]
                self.btn_ls2.isHidden = false
                self.btn_ls2.isEnabled = true
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
                self.ls2.text = ""
                self.btn_ls2.isHidden = true
                self.btn_ls2.isEnabled = false
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableLS.delegate = self
        tableLS.dataSource = self
        
        targetName.text = "Мобильное ЖКХ"
        #if isOur_Obj_Home
        targetName.text = "Наш Общий Дом"
        fon_top.image = UIImage(named: "logo_Our_Obj_Home")
        #elseif isChist_Dom
        fon_top.image = UIImage(named: "Logo_Chist_Dom")
        #elseif isMupRCMytishi
        targetName.text = "МУП РЦ Мытищи"
        fon_top.image = UIImage(named: "logo_MupRCMytishi")
        #elseif isDJ
        fon_top.image = UIImage(named: "logo_DJ")
        #elseif isStolitsa
        targetName.text = "УК Жилищник Столица"
        fon_top.image = UIImage(named: "logo_Stolitsa")
        #elseif isKomeks
        fon_top.image = UIImage(named: "Logo_Komeks")
        #elseif isUKKomfort
        targetName.text = "УК Комфорт"
        fon_top.image = UIImage(named: "logo_UK_Komfort")
        #elseif isKlimovsk12
        targetName.text = "ТСЖ Климовск 12"
        fon_top.image = UIImage(named: "logo_Klimovsk12")
        #elseif isPocket
        fon_top.image = UIImage(named: "Logo_Pocket")
        #elseif isReutKomfort
        targetName.text = "УК Реут Комфорт"
        fon_top.image = UIImage(named: "Logo_ReutKomfort")
        #elseif isUKGarant
        fon_top.image = UIImage(named: "Logo_UK_Garant")
        #elseif isSoldatova1
        fon_top.image = UIImage(named: "Logo_Soldatova1")
        #elseif isTafgai
        fon_top.image = UIImage(named: "Logo_Tafgai_White")
        #endif
        UITabBar.appearance().tintColor = myColors.btnColor.uiColor()
        suppBtnImg.setImageColor(color: myColors.btnColor.uiColor())
        suppBtn.tintColor = myColors.btnColor.uiColor()
        
        let str_menu_2 = UserDefaults.standard.string(forKey: "menu_2") ?? ""
        if (str_menu_2 != "") {
            var answer = str_menu_2.components(separatedBy: ";")
            if (answer[2] == "0") {
                if let tabBarController = self.tabBarController {
                    let indexToRemove = 1
                    if indexToRemove < tabBarController.viewControllers!.count {
                        var viewControllers = tabBarController.viewControllers
                        viewControllers?.remove(at: indexToRemove)
                        tabBarController.viewControllers = viewControllers
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    let vote = ["123","12"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.async {
            var height: CGFloat = 0
            for cell in self.tableLS.visibleCells {
                height += cell.bounds.height
            }
            self.tableLSHeight.constant = CGFloat((self.vote.count) * Int(height) + 10)
            print(self.tableLSHeight.constant, height)
        }
        return vote.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableLS.dequeueReusableCell(withIdentifier: "HomeLSCell") as! HomeLSCell
        cell.delegate = self
        return cell
    }
}

class HomeLSCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var textQuestion: UILabel!
    @IBOutlet weak var statusImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
