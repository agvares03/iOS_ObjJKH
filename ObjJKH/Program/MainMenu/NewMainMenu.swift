//
//  NewMainMenu.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 14/03/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class NewMainMenu: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var responseString: String = ""
    var name_account: String = ""
    var login: String = ""
    var pass: String = ""
    var txt_name: String = "Запись на прием к специалисту"
    var load = false
    private var question_read = 0
    private var request_read = 0
    private var news_read = 0
    
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var ls1: UILabel!
    @IBOutlet weak var ls2: UILabel!
    @IBOutlet weak var ls3: UILabel!
    @IBOutlet weak var btnAllLS: UILabel!
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
    
    // Размеры для настройки меню
    // Уведомления - Новости
    @IBOutlet weak var menu_0_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_0: UIButton!
    @IBOutlet weak var line_bottom_0: UILabel!
    @IBOutlet weak var btn_arr_0: UIImageView!
    // Звонок диспетчеру
    @IBOutlet weak var menu_1_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_1: UIButton!
    @IBOutlet weak var line_bottom_1: NSLayoutConstraint!
    @IBOutlet weak var supportBtn: UIButton!
    // Заявки
    @IBOutlet weak var menu_2_heigth: NSLayoutConstraint!
    @IBOutlet weak var line_bottom_2: UILabel!
    @IBOutlet weak var btn_arr_2: UIImageView!
    @IBOutlet weak var btn_name_2: UIButton!
    // Опросы - было реализовано ранее для Мытищ
    @IBOutlet weak var line_bottom_3: NSLayoutConstraint!
    // Показания счетчиков
    @IBOutlet weak var menu_4_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_4: UIButton!
    @IBOutlet weak var btn_arr_4: UIImageView!
    @IBOutlet weak var line_bottom_4: UILabel!
    // Ведомости
    @IBOutlet weak var menu_5_heigth: NSLayoutConstraint!
    @IBOutlet weak var btm_name_5: UIButton!
    @IBOutlet weak var btn_arr_5: UIImageView!
    @IBOutlet weak var line_bottom_5: UILabel!
    // Оплата ЖКУ
    @IBOutlet weak var menu_6_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_6: UIButton!
    @IBOutlet weak var btn_arr_6: UIImageView!
    @IBOutlet weak var line_bottom_6: UILabel!
    // Web-камеры
    @IBOutlet weak var menu_7_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_7: UIButton!
    @IBOutlet weak var btn_arr_7: UIImageView!
    @IBOutlet weak var line_bottom_7: UILabel!
    // Дополнительные настройки
    @IBOutlet weak var menu_8_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_8: UIButton!
    @IBOutlet weak var btn_arr_8: UIImageView!
    @IBOutlet weak var line_bottom_8: UILabel!
    // Выход - только название
    @IBOutlet weak var btn_name_9: UIButton!
    
    // Запись на прием - только для Нашего общего дома
    @IBOutlet weak var menu_record_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_record: UIButton!
    @IBOutlet weak var btn_arr_record: UIImageView!
    @IBOutlet weak var line_bottom: UILabel!
    
    @IBOutlet weak var supp_Line: UILabel!
    @IBOutlet weak var acc_Line: UILabel!
    @IBOutlet weak var heigth_Questions: NSLayoutConstraint!
    @IBOutlet weak var btn_Questions: UIButton!
    @IBOutlet weak var Questions_arrow: UIImageView!
    @IBOutlet weak var heigth_view: NSLayoutConstraint!
    
    // Картинки - для разных Таргетов
    @IBOutlet weak var notice: UIImageView!
    @IBOutlet weak var call: UIImageView!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var application: UIImageView!
    @IBOutlet weak var poll: UIImageView!
    @IBOutlet weak var meters: UIImageView!
    @IBOutlet weak var saldo: UIImageView!
    @IBOutlet weak var payment: UIImageView!
    @IBOutlet weak var webs_img: UIImageView!
    @IBOutlet weak var services: UIImageView!
    @IBOutlet weak var exit_img: UIImageView!
    @IBOutlet weak var record_img: UIImageView!
    @IBOutlet weak var acc_img: UIImageView!
    @IBOutlet weak var main_background: UIImageView!
    
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
            
            self.ls3.text = ""
            self.btn_ls3.isHidden = true
            self.btn_ls3.isEnabled = false
            
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
                
                self.ls3.text = ""
                self.btn_ls3.isHidden = true
                self.btn_ls3.isEnabled = false
            } else if ((str_ls_arr?.count)! == 1) {
                self.ls1.text = str_ls_arr?[0]
                if (self.ls1.text != "") {
                    self.btn_ls1.isHidden = false
                    self.btn_ls1.isEnabled = true
                }
                self.ls2.text = ""
                self.btn_ls2.isHidden = true
                self.btn_ls2.isEnabled = false
                
                self.ls3.text = ""
                self.btn_ls3.isHidden = true
                self.btn_ls3.isEnabled = false
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if isOur_Obj_Home
        fon_top.image = UIImage(named: "logo_Our_Obj_Home")
        #elseif isChist_Dom
        fon_top.image = UIImage(named: "Logo_Chist_Dom")
        #elseif isMupRCMytishi
        fon_top.image = UIImage(named: "logo_MupRCMytishi")
        #elseif isDJ
        fon_top.image = UIImage(named: "logo_DJ")
        #elseif isStolitsa
        fon_top.image = UIImage(named: "logo_Stolitsa")
        #elseif isKomeks
        fon_top.image = UIImage(named: "Logo_Komeks")
        #elseif isUKKomfort
        fon_top.image = UIImage(named: "logo_UK_Komfort")
        #elseif isKlimovsk12
        fon_top.image = UIImage(named: "logo_Klimovsk12")
        #elseif isPocket
        fon_top.image = UIImage(named: "Logo_Pocket")
        #elseif isReutKomfort
        fon_top.image = UIImage(named: "Logo_ReutKomfort")
        #elseif isUKGarant
        fon_top.image = UIImage(named: "Logo_UK_Garant")
        #endif
        news_View.layer.borderWidth = 1
        news_View.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        ls_View.layer.borderWidth = 1
        ls_View.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        counters_View.layer.borderWidth = 1
        counters_View.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        // Do any additional setup after loading the view.
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
