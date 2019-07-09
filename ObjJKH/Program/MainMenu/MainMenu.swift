//
//  MainMenu.swift
//  ObjJKH
//
//  Created by Роман Тузин on 27.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Gloss

class MainMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Запись на прием - Наш Общий Дом
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
    
    @IBOutlet weak var debtLbl: UILabel!
    @IBOutlet weak var debtTable: UITableView!
    @IBOutlet weak var debtHeight: NSLayoutConstraint!
    @IBOutlet weak var debtLblHeight: NSLayoutConstraint!
    @IBOutlet weak var backgroundHeight: NSLayoutConstraint!
    
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var ls1: UILabel!
    @IBOutlet weak var ls2: UILabel!
    @IBOutlet weak var ls3: UILabel!
    @IBOutlet weak var btnAllLS: UIButton!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var PageView: UIView!
    @IBOutlet weak var ViewInfoLS: UIView!
    @IBOutlet weak var btn_Add_LS: UIButton!
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
    // Голосования
    @IBOutlet weak var oss_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_oss: UIButton!
    @IBOutlet weak var btn_arr_oss: UIImageView!
    @IBOutlet weak var line_bottom_oss: UILabel!
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
    @IBOutlet weak var oss: UIImageView!
    
    var phone: String?
    
    @IBAction func AddLS(_ sender: UIButton) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "addLS_Mup", sender: self)
        #elseif isPocket
        self.performSegue(withIdentifier: "addLSPocket", sender: self)
        #else
        self.performSegue(withIdentifier: "addLS", sender: self)
        #endif
    }
    
    @IBAction func SupportBtnAction(_ sender: UIButton) {
        supK = true
        self.performSegue(withIdentifier: "support", sender: self)
    }
    var supK = false
    //    // Отвязать лицевые счета от аккаунта
    //    @IBOutlet weak var btn_ls1: UIButton!
    //    @IBOutlet weak var btn_ls2: UIButton!
    //    @IBOutlet weak var btn_ls3: UIButton!
    //
    //    @IBAction func ls1_del(_ sender: UIButton) {
    //        try_del_ls_from_acc(ls: ls1)
    //    }
    //    @IBAction func ls2_del(_ sender: UIButton) {
    //        try_del_ls_from_acc(ls: ls2)
    //    }
    //    @IBAction func ls3_del(_ sender: UIButton) {
    //        try_del_ls_from_acc(ls: ls3)
    //    }
    
    //    func try_del_ls_from_acc(ls: UILabel) {
    //
    //        let defaults = UserDefaults.standard
    //        let phone = defaults.string(forKey: "phone")
    //        let ident =  ls.text
    //
    //        if (phone == ident) {
    //            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Невозможно отвязать лицевой счет " + ls.text! + ". Вы зашли, используя этот лицевой счет.", preferredStyle: .alert)
    //            let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
    //            alert.addAction(okAction)
    //            self.present(alert, animated: true, completion: nil)
    //        } else {
    //            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Отвязать лицевой счет " + ls.text! + " от аккаунта?", preferredStyle: .alert)
    //            let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
    //            alert.addAction(cancelAction)
    //            let okAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
    //
    //                var urlPath = Server.SERVER + Server.MOBILE_API_PATH + Server.DEL_IDENT_ACC
    //                urlPath = urlPath + "phone=" + phone! + "&ident=" + ident!
    //                let url: NSURL = NSURL(string: urlPath)!
    //                let request = NSMutableURLRequest(url: url as URL)
    //                request.httpMethod = "GET"
    //
    //                let task = URLSession.shared.dataTask(with: request as URLRequest,
    //                                                      completionHandler: {
    //                                                        data, response, error in
    //
    //                                                        if error != nil {
    //                                                            DispatchQueue.main.async(execute: {
    //                                                                UserDefaults.standard.set("Ошибка соединения с сервером", forKey: "errorStringSupport")
    //                                                                UserDefaults.standard.synchronize()
    //                                                                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
    //                                                                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
    //                                                                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
    //                                                                    self.performSegue(withIdentifier: "support", sender: self)
    //                                                                }
    //                                                                alert.addAction(cancelAction)
    //                                                                alert.addAction(supportAction)
    //                                                                self.present(alert, animated: true, completion: nil)
    //                                                            })
    //                                                            return
    //                                                        }
    //
    //                                                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
    //                                                        print("responseString = \(responseString)")
    //
    //                                                        self.del_ls_from_acc(ls: ls)
    //                })
    //                task.resume()
    //
    //            }
    //            alert.addAction(okAction)
    //            self.present(alert, animated: true, completion: nil)
    //        }
    //
    //    }
    
    //    func del_ls_from_acc(ls: UILabel) {
    //        DispatchQueue.main.async(execute: {
    //            // Выведем подключенные лицевые счета
    //            let defaults = UserDefaults.standard
    //            let str_ls = defaults.string(forKey: "str_ls")
    //            var newStr_ls = str_ls?.replacingOccurrences(of: ls.text! + ",", with: "")
    //            newStr_ls = newStr_ls?.replacingOccurrences(of: "," + ls.text!, with: "")
    //            newStr_ls = newStr_ls?.replacingOccurrences(of: ls.text!, with: "")
    //            self.ls1.text = ""
    //            self.btn_ls1.isHidden = true
    //            self.btn_ls1.isEnabled = false
    //
    //            self.ls2.text = ""
    //            self.btn_ls2.isHidden = true
    //            self.btn_ls2.isEnabled = false
    //
    //            self.ls3.text = ""
    //            self.btn_ls3.isHidden = true
    //            self.btn_ls3.isEnabled = false
    //
    //            let str_ls_arr = newStr_ls?.components(separatedBy: ",")
    //            defaults.set(newStr_ls, forKey: "str_ls")
    //            defaults.synchronize()
    //            if ((str_ls_arr?.count)! >= 3) {
    //                self.ls1.text = str_ls_arr?[0]
    //                self.btn_ls1.isHidden = false
    //                self.btn_ls1.isEnabled = true
    //
    //                self.ls2.text = str_ls_arr?[1]
    //                self.btn_ls2.isHidden = false
    //                self.btn_ls2.isEnabled = true
    //
    //                self.ls3.text = str_ls_arr?[2]
    //                self.btn_ls3.isHidden = false
    //                self.btn_ls3.isEnabled = true
    //            } else if ((str_ls_arr?.count)! == 2) {
    //                self.ls1.text = str_ls_arr?[0]
    //                self.btn_ls1.isHidden = false
    //                self.btn_ls1.isEnabled = true
    //
    //                self.ls2.text = str_ls_arr?[1]
    //                self.btn_ls2.isHidden = false
    //                self.btn_ls2.isEnabled = true
    //
    //                self.ls3.text = ""
    //                self.btn_ls3.isHidden = true
    //                self.btn_ls3.isEnabled = false
    //            } else if ((str_ls_arr?.count)! == 1) {
    //                self.ls1.text = str_ls_arr?[0]
    //                if (self.ls1.text != "") {
    //                    self.btn_ls1.isHidden = false
    //                    self.btn_ls1.isEnabled = true
    //                }
    //                self.ls2.text = ""
    //                self.btn_ls2.isHidden = true
    //                self.btn_ls2.isEnabled = false
    //
    //                self.ls3.text = ""
    //                self.btn_ls3.isHidden = true
    //                self.btn_ls3.isEnabled = false
    //            }
    //        })
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "fromMenu")
        self.StopIndicator()
        self.getQuestions()
        self.getNews()
        let defaults = UserDefaults.standard
        // Телефон диспетчера
        phone = defaults.string(forKey: "phone_operator")
        self.backgroundHeight.constant = self.view.frame.size.height
        // Приветствие
        labelTime.text = "Здравствуйте,"
        labelName.text = defaults.string(forKey: "name")
        
        // Выведем подключенные лицевые счета
        show_ls(defaults: defaults)
        
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
        #elseif isChist_Dom
        fon_top.image = UIImage(named: "Logo_Chist_Dom_White")
        #elseif isMupRCMytishi
        UserDefaults.standard.set("MupRCMytishi", forKey: "targetName")
        UserDefaults.standard.synchronize()
        main_background.image = UIImage(named: "main_Background_MupRCMytishi")
        fon_top.image = UIImage(named: "logo_MupRCMytishi_White")
        #elseif isDJ
        fon_top.image = UIImage(named: "logo_DJ_White")
        #elseif isStolitsa
        fon_top.image = UIImage(named: "logo_Stolitsa_white")
        #elseif isKomeks
        fon_top.image = UIImage(named: "Logo_Komeks_White")
        #elseif isUKKomfort
        fon_top.image = UIImage(named: "logo_UK_Komfort_white")
        #elseif isKlimovsk12
        UserDefaults.standard.set("Klimovsk12", forKey: "targetName")
        UserDefaults.standard.synchronize()
        fon_top.image = UIImage(named: "logo_Klimovsk12_White")
        #elseif isPocket
        fon_top.image = UIImage(named: "Logo_Pocket_White")
        #elseif isReutKomfort
        fon_top.image = UIImage(named: "Logo_ReutKomfort_White")
        #elseif isUKGarant
        fon_top.image = UIImage(named: "Logo_UK_Garant_White")
        #elseif isSoldatova1
        fon_top.image = UIImage(named: "Logo_Soldatova_White")
        #elseif isTafgai
        fon_top.image = UIImage(named: "Logo_Tafgai_White")
        #elseif isServiceKomfort
        fon_top.image = UIImage(named: "Logo_ServiceKomfort_White")
        #elseif isParitet
        fon_top.image = UIImage(named: "Logo_Paritet")
        #elseif isSkyfort
        fon_top.image = UIImage(named: "Logo_Skyfort")
        #elseif isStandartDV
        fon_top.image = UIImage(named: "Logo_StandartDV")
        #elseif isGarmonia
        fon_top.image = UIImage(named: "Logo_UkGarmonia")
        #elseif isUpravdomChe
        fon_top.image = UIImage(named: "Logo_UkUpravdomChe")
        #elseif isJKH_Pavlovskoe
        fon_top.image = UIImage(named: "Logo_JKH_Pavlovskoe")
        #elseif isPerspectiva
        fon_top.image = UIImage(named: "Logo_UkPerspectiva")
        #elseif isParus
        fon_top.image = UIImage(named: "Logo_Parus")
        #elseif isUyutService
        fon_top.image = UIImage(named: "Logo_UyutService")
        #elseif isElectroSbitSaratov
        fon_top.image = UIImage(named: "Logo_ElectrosbitSaratov")
        #elseif isServicekom
        fon_top.image = UIImage(named: "Logo_Servicekom")
        #endif
        
        debtTable.delegate = self
        debtTable.dataSource = self
        
        // Картинки для разных Таргетов
        notice.image = myImages.notice_image
        notice.setImageColor(color: myColors.btnColor.uiColor())
        call.image = myImages.call_image
        call.setImageColor(color: myColors.btnColor.uiColor())
        support.setImageColor(color: myColors.btnColor.uiColor())
        application.image = myImages.application_image
        application.setImageColor(color: myColors.btnColor.uiColor())
        poll.image = myImages.poll_image
        poll.setImageColor(color: myColors.btnColor.uiColor())
        meters.image = myImages.meters_image
        meters.setImageColor(color: myColors.btnColor.uiColor())
        saldo.image = myImages.saldo_image
        saldo.setImageColor(color: myColors.btnColor.uiColor())
        payment.image = myImages.payment_image
        payment.setImageColor(color: myColors.btnColor.uiColor())
        webs_img.image = myImages.webs_image
        webs_img.setImageColor(color: myColors.btnColor.uiColor())
        services.image = myImages.services
        services.setImageColor(color: myColors.btnColor.uiColor())
        record_img.image = myImages.record_image
        record_img.setImageColor(color: myColors.btnColor.uiColor())
        exit_img.image = myImages.exit_image
        exit_img.setImageColor(color: myColors.btnColor.uiColor())
        acc_img.image = myImages.acc_image
        acc_img.setImageColor(color: myColors.btnColor.uiColor())
        oss.image = myImages.oss_image
        oss.setImageColor(color: myColors.btnColor.uiColor())
        
        btn_Add_LS.tintColor = myColors.btnColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        request_indicator.backgroundColor = myColors.indicatorColor.uiColor()
        question_indicator.backgroundColor = myColors.indicatorColor.uiColor()
        news_indicator.backgroundColor = myColors.indicatorColor.uiColor()
        getDebt()
        
        // Настройки для меню
        settings_for_menu()
    }
    
    func settings_for_menu() {
        let defaults = UserDefaults.standard
        // Уведомления - Новости
        let str_menu_0 = defaults.string(forKey: "menu_0") ?? ""
        if (str_menu_0 != "") {
            var answer = str_menu_0.components(separatedBy: ";")
            if (answer[2] == "0") {
                menu_0_heigth.constant   = 0
                btn_name_0.isHidden      = true
                btn_arr_0.isHidden       = true
                line_bottom_0.isHidden   = true
                notice.isHidden          = true
                heigth_view.constant     = heigth_view.constant - 41
            } else {
                btn_name_0.setTitle(answer[1], for: .normal)
            }
        }
        // Звонок диспетчеру
        let str_menu_1 = defaults.string(forKey: "menu_1") ?? ""
        if (str_menu_1 != "") {
            var answer = str_menu_1.components(separatedBy: ";")
            if (answer[2] == "0") {
                menu_1_heigth.constant   = 0
                btn_name_1.isHidden      = true
                call.isHidden            = true
                line_bottom_1.constant   = 0
                heigth_view.constant     = heigth_view.constant - 35
            } else {
                btn_name_1.setTitle(answer[1], for: .normal)
            }
        }
        // Заявки
        let str_menu_2 = defaults.string(forKey: "menu_2") ?? ""
        if (str_menu_2 != "") {
            var answer = str_menu_2.components(separatedBy: ";")
            if (answer[2] == "0") {
                menu_2_heigth.constant   = 0
                application.isHidden     = true
                btn_name_2.isHidden      = true
                line_bottom_2.isHidden   = true
                heigth_view.constant     = heigth_view.constant - 40
            } else {
                btn_name_2.setTitle(answer[1], for: .normal)
            }
        }
        // Опросы
        let str_menu_3 = defaults.string(forKey: "menu_3") ?? ""
        if (str_menu_3 != "") {
            var answer = str_menu_3.components(separatedBy: ";")
            if (answer[2] == "0") {
                btn_Questions.isHidden    = true
                heigth_Questions.constant = 0
                Questions_arrow.isHidden  = true
                poll.isHidden             = true
                line_bottom_3.constant    = 0
                heigth_view.constant      = heigth_view.constant - 40
            } else {
                btn_Questions.setTitle(answer[1], for: .normal)
            }
        }
        // Показания счетчиков
        let str_menu_4 = defaults.string(forKey: "menu_4") ?? ""
        if (str_menu_4 != "") {
            var answer = str_menu_4.components(separatedBy: ";")
            if (answer[2] == "0") {
                menu_4_heigth.constant   = 0
                btn_name_4.isHidden      = true
                btn_arr_4.isHidden       = true
                line_bottom_4.isHidden   = true
                meters.isHidden          = true
                heigth_view.constant     = heigth_view.constant - 39
            } else {
                btn_name_4.setTitle(answer[1], for: .normal)
            }
        }
        // Взаиморасчеты
        let str_menu_5 = defaults.string(forKey: "menu_5") ?? ""
        if (str_menu_5 != "") {
            var answer = str_menu_5.components(separatedBy: ";")
            if (answer[2] == "0") {
                menu_5_heigth.constant   = 0
                btm_name_5.isHidden      = true
                btn_arr_5.isHidden       = true
                line_bottom_5.isHidden   = true
                saldo.isHidden           = true
                heigth_view.constant     = heigth_view.constant - 40
            } else {
                btm_name_5.setTitle(answer[1], for: .normal)
            }
        }
        // Оплата ЖКУ
        let str_menu_6 = defaults.string(forKey: "menu_6") ?? ""
        if (str_menu_6 != "") {
            var answer = str_menu_6.components(separatedBy: ";")
            if (answer[2] == "0") {
                menu_6_heigth.constant   = 0
                btn_name_6.isHidden      = true
                btn_arr_6.isHidden       = true
                line_bottom_6.isHidden   = true
                payment.isHidden         = true
                heigth_view.constant     = heigth_view.constant - 90
                debtLbl.isHidden = true
                debtTable.isHidden = true
                debtHeight.constant       = 0
                debtLblHeight.constant    = 0
            } else {
                btn_name_6.setTitle(answer[1], for: .normal)
            }
        }
        // Web-камеры
        let str_menu_7 = defaults.string(forKey: "menu_7") ?? ""
        if (str_menu_7 != "") {
            var answer = str_menu_7.components(separatedBy: ";")
            if (answer[2] == "0") {
                menu_7_heigth.constant   = 0
                btn_name_7.isHidden      = true
                btn_arr_7.isHidden       = true
                line_bottom_7.isHidden   = true
                webs_img.isHidden        = true
                heigth_view.constant     = heigth_view.constant - 39
                line_bottom_6.isHidden   = true
            } else {
                line_bottom_6.isHidden   = false
                btn_name_7.setTitle(answer[1], for: .normal)
            }
        }
        // Дополнительные услуги
        let str_menu_8 = defaults.string(forKey: "menu_8") ?? ""
        if (str_menu_8 != "") {
            var answer = str_menu_8.components(separatedBy: ";")
            if (answer[2] == "0") {
                menu_8_heigth.constant   = 0
                btn_name_8.isHidden      = true
                btn_arr_8.isHidden       = true
                line_bottom_8.isHidden   = true
                services.isHidden        = true
                heigth_view.constant     = heigth_view.constant - 40
                line_bottom_6.isHidden   = true
            } else {
                line_bottom_6.isHidden   = false
                btn_name_8.setTitle(answer[1], for: .normal)
            }
        }
        // Голосования
        let str_menu_oss = defaults.bool(forKey: "enable_OSS")
//        let str_menu_oss = true
        if !str_menu_oss{
            oss_heigth.constant   = 0
            btn_name_oss.isHidden    = true
            btn_arr_oss.isHidden     = true
            oss.isHidden        = true
//            line_bottom_oss.isHidden = true
            heigth_view.constant     = heigth_view.constant - 40
        }else{
            let width = view.frame.size.width
            if width <= 320{
                oss_heigth.constant  = 60
                heigth_view.constant = heigth_view.constant + 21
            }
        }
        
        // Запись на прием - показывать только для Нашего Общего Дома
        #if isOur_Obj_Home
        #else
        menu_record_heigth.constant  = 0
        record_img.isHidden          = true
        btn_name_record.isHidden     = true
        btn_arr_record.isHidden      = true
        heigth_view.constant         = heigth_view.constant - 39
        #endif
        
        // Выход - только название
        let str_menu_9 = defaults.string(forKey: "menu_9") ?? ""
        if (str_menu_9 != "") {
            var answer = str_menu_9.components(separatedBy: ";")
            btn_name_9.setTitle(answer[1], for: .normal)
        }
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
        self.performSegue(withIdentifier: "mupCounters", sender: self)
        //        #elseif isUKKomfort
        //        self.performSegue(withIdentifier: "mupCounters", sender: self)
        //        #else
        //        self.performSegue(withIdentifier: "mainCounters", sender: self)
        #endif
        
    }
    
    // Ведомости
    @IBAction func go_osv(_ sender: UIButton) {
    }
    
    // Оплаты
    var debtArr:[AnyObject] = []
    @IBAction func go_pays(_ sender: UIButton) {
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "paysMytishi", sender: self)
        #elseif isUpravdomChe
        self.performSegue(withIdentifier: "paysMytishi", sender: self)
        #elseif isKlimovsk12
        self.performSegue(withIdentifier: "paysMytishi", sender: self)
        #else
        self.performSegue(withIdentifier: "pays", sender: self)
        #endif
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debtArr.removeAll()
        var debt:[String:String] = [:]
        if debtSum.count != 0{
            for i in 0...debtSum.count - 1{
                debt["Ident"] = debtIdent[i]
                debt["Sum"] = debtSum[i]
                debt["SumFine"] = debtSumFine[i]
                debtArr.append(debt as AnyObject)
            }
        }
//        if segue.identifier == "goSaldo" {
////            let nav = segue.destination as! UINavigationController
//            let payController             = segue.destination as! SaldoController
//            print(self.debtArr.count)
//            payController.debtArr = self.debtArr
//        }
        #if isMupRCMytishi
        if segue.identifier == "paysMytishi" {
//            let nav = segue.destination as! UINavigationController
            let payController             = segue.destination as! PaysMytishiController
            payController.debtArr = self.debtArr
        }
        #elseif isUpravdomChe
        if segue.identifier == "paysMytishi" {
            //            let nav = segue.destination as! UINavigationController
            let payController             = segue.destination as! PaysMytishiController
            payController.debtArr = self.debtArr
        }
        #elseif isKlimovsk12
        if segue.identifier == "paysMytishi" {
//            let nav = segue.destination as! UINavigationController
            let payController             = segue.destination as! PaysMytishiController
            payController.debtArr = self.debtArr
        }
        #else
        if segue.identifier == "pays" {
//            let nav = segue.destination as! UINavigationController
            let payController             = segue.destination as! PaysController
            payController.debtArr = self.debtArr
        }
        #endif
    }
    
    // Web-камеры
    @IBAction func go_web(_ sender: UIButton) {
    }
    var dateOld = "01.01"
    func getDebt() {
        let defaults = UserDefaults.standard
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        var sumObj = 0.00
        var u = 0
        let viewHeight = self.heigth_view.constant
        let backHeight = self.backgroundHeight.constant
        if (str_ls_arr?.count)! > 0 && str_ls_arr?[0] != ""{
            str_ls_arr?.forEach{
                let ls = $0
                let urlPath = Server.SERVER + Server.GET_DEBT_ACCOUNT + "ident=" + ls.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
                let url: NSURL = NSURL(string: urlPath)!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "GET"
                print(request)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                      completionHandler: {
                                                        data, response, error in
                                                        
                                                        if error != nil {
                                                            return
                                                        } else {
                                                            do {
                                                                u += 1
                                                                let responseStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                                print(responseStr)
                                                                
                                                                if !responseStr.contains("error"){
                                                                    var date        = ""
                                                                    var sum         = ""
                                                                    var sumFine     = ""
                                                                    //                                                                var sumOver     = ""
                                                                    //                                                                var sumFineOver = ""
                                                                    var sumAll      = ""
                                                                    var json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
//                                                                                                                                        print(json)
                                                                    
                                                                    if let json_bills = json["data"] {
                                                                        let int_end = (json_bills.count)!-1
                                                                        if (int_end < 0) {
                                                                            
                                                                        } else {
                                                                            sum = String(format:"%.2f", json_bills["Sum"] as! Double)
//                                                                            let s = json_bills["Sum"] as! Double
                                                                            sumFine = String(format:"%.2f", json_bills["SumFine"] as! Double)
//                                                                            sum = "0.00"
//                                                                            let s = 0
//                                                                            sumFine = "0.00"
                                                                            self.debtIdent.append(ls)
                                                                            self.debtSum.append(sum)
                                                                            self.debtSumFine.append(sumFine)
                                                                            sumAll = String(format:"%.2f", json_bills["SumAll"] as! Double)
                                                                            date = json_bills["Date"] as! String
                                                                            
                                                                            defaults.set(date, forKey: "dateDebt")
                                                                            if Double(sumAll) != 0.00{
                                                                                let d = date.components(separatedBy: ".")
                                                                                let d1 = self.dateOld.components(separatedBy: ".")
                                                                                if (Int(d[0])! >= Int(d1[0])!) && (Int(d[1])! >= Int(d1[1])!){
                                                                                    DispatchQueue.main.async {
                                                                                        self.debtLbl.text = "Задолженность на " + date + " г."
                                                                                        self.debtLbl.textColor = .red
                                                                                        self.dateOld = date
                                                                                    }
                                                                                }
                                                                                sumObj = sumObj + Double(sumAll)!
                                                                            }
                                                                        }
                                                                    }
                                                                    defaults.set(sumObj, forKey: "sumDebt")
                                                                    defaults.synchronize()
                                                                    
                                                                    let str_menu_6 = UserDefaults.standard.string(forKey: "menu_6") ?? ""
                                                                    if (str_menu_6 != "") {
                                                                        var answer = str_menu_6.components(separatedBy: ";")
                                                                        if (answer[2] == "0") {
                                                                        }else{
                                                                            DispatchQueue.main.async {
                                                                                let tht: String = self.debtLbl.text!
                                                                                print(tht)
                                                                                var o = 0
                                                                                self.debtSum.forEach{
                                                                                    if Double($0) != 0.00{
                                                                                        o += 1
                                                                                    }
                                                                                }
                                                                                if o == 0 && tht.contains("отсутствует") == false{
                                                                                    self.debtLbl.text = self.debtLbl.text! + " отсутствует"
                                                                                    self.debtLbl.textColor = .init(red: 0, green: 100, blue: 0, alpha: 1.0)
                                                                                    self.debtHeight.constant = 3
                                                                                    self.menu_6_heigth.constant = 63
                                                                                    self.heigth_view.constant = self.heigth_view.constant - 25
                                                                                    if self.view.frame.size.width <= 375{
                                                                                        self.debtLblHeight.constant = 36
                                                                                        self.menu_6_heigth.constant = 80
                                                                                        self.heigth_view.constant = self.heigth_view.constant + 15
                                                                                    }
                                                                                    if (self.heigth_view.constant + 115) > self.view.frame.size.height{
                                                                                        self.backgroundHeight.constant = backHeight + ((self.heigth_view.constant + 115) - self.view.frame.size.height) + 40
                                                                                    }
                                                                                    u += 1
                                                                                }
                                                                                self.debtTable.reloadData()
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                
                                                            } catch let error as NSError {
                                                                print(error)
                                                            }
                                                            
                                                        }
                })
                task.resume()
            }
        }else{
            let str_menu_6 = UserDefaults.standard.string(forKey: "menu_6") ?? ""
            if (str_menu_6 != "") {
                var answer = str_menu_6.components(separatedBy: ";")
                if (answer[2] == "0") {
                }else{
                    DispatchQueue.main.async {
                        self.debtLbl.isHidden = true
                        self.debtTable.isHidden = true
                        self.menu_6_heigth.constant    = 39
                        self.heigth_view.constant      = self.heigth_view.constant - 51
                        self.debtHeight.constant       = 0
                        self.debtLblHeight.constant    = 0
                    }
                }
            }
        }
    }
    
    // Запись на прием
    @IBAction func go_record(_ sender: UIButton) {
        
        // Если нет лицевых счетов - сообщим об этом
        let defaults = UserDefaults.standard
        let str_ls = defaults.string(forKey: "str_ls")
        var str_ls_arr = str_ls?.components(separatedBy: ",")
        
        if ((str_ls_arr?.count)! > 0) {
            
            if ((str_ls_arr?.count)! > 1) {
                let actionSheet = UIAlertController(title: "Лицевые счета", message: nil, preferredStyle: .actionSheet)
                
                let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                
                if ((str_ls_arr?.count)! > 3) {
                    let do_it0 = UIAlertAction(title: str_ls_arr?[0], style: .default) { action in
                        self.login = (str_ls_arr?[0])!
                    }
                    actionSheet.addAction(do_it0)
                    
                    let do_it1 = UIAlertAction(title: str_ls_arr?[1], style: .default) { action in
                        self.login = (str_ls_arr?[1])!
                        self.set_add_record()
                    }
                    actionSheet.addAction(do_it1)
                    
                    let do_it2 = UIAlertAction(title: str_ls_arr?[2], style: .default) { action in
                        self.login = (str_ls_arr?[2])!
                        self.set_add_record()
                    }
                    actionSheet.addAction(do_it2)
                } else if ((str_ls_arr?.count)! == 2) {
                    let do_it0 = UIAlertAction(title: str_ls_arr?[0], style: .default) { action in
                        self.login = (str_ls_arr?[0])!
                        self.set_add_record()
                    }
                    actionSheet.addAction(do_it0)
                    
                    let do_it1 = UIAlertAction(title: str_ls_arr?[1], style: .default) { action in
                        self.login = (str_ls_arr?[1])!
                        self.set_add_record()
                    }
                    actionSheet.addAction(do_it1)
                } else if ((str_ls_arr?.count)! == 1) {
                    let do_it0 = UIAlertAction(title: str_ls_arr?[0], style: .default) { action in
                        self.login = (str_ls_arr?[0])!
                        self.set_add_record()
                    }
                    actionSheet.addAction(do_it0)
                }
                
                actionSheet.addAction(cancel)
                
                present(actionSheet, animated: true, completion: nil)
            } else {
                login = str_ls_arr?[0] ?? ""
                set_add_record()
            }
            
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Не привязан лицевой счет", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func set_add_record() {
        let actionSheet = UIAlertController(title: "Запись на прием", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let do_it1 = UIAlertAction(title: "К руководителю", style: .default) { action in
            self.StartIndicator()
            self.add_record(numb: 1)
        }
        let do_it2 = UIAlertAction(title: "К специалисту", style: .default) { action in
            self.StartIndicator()
            self.add_record(numb: 2)
        }
        
        actionSheet.addAction(do_it1)
        actionSheet.addAction(do_it2)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
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
    
    func show_ls(defaults: UserDefaults) {
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        
        ls1.text = ""
        //        btn_ls1.isHidden = true
        //        btn_ls1.isEnabled = false
        
        ls2.text = ""
        //        btn_ls2.isHidden = true
        //        btn_ls2.isEnabled = false
        
        ls3.text = ""
        //        btn_ls3.isHidden = true
        //        btn_ls3.isEnabled = false
        
        btnAllLS.isHidden = true
        btnAllLS.isEnabled = false
        
        if ((str_ls_arr?.count)! >= 3) {
            ls1.text = str_ls_arr?[0]
            //            btn_ls1.isHidden = false
            //            btn_ls1.isEnabled = true
            
            ls2.text = str_ls_arr?[1]
            //            btn_ls2.isHidden = false
            //            btn_ls2.isEnabled = true
            
            ls3.text = str_ls_arr?[2]
            //            btn_ls3.isHidden = false
            //            btn_ls3.isEnabled = true
            
            btnAllLS.isHidden = false
            btnAllLS.isEnabled = true
        } else if ((str_ls_arr?.count)! == 2) {
            ls1.text = str_ls_arr?[0]
            //            btn_ls1.isHidden = false
            //            btn_ls1.isEnabled = true
            
            ls2.text = str_ls_arr?[1]
            //            btn_ls2.isHidden = false
            //            btn_ls2.isEnabled = true
            
            btnAllLS.isHidden = true
            btnAllLS.isEnabled = false
        } else if ((str_ls_arr?.count)! == 1) {
            ls1.text = str_ls_arr?[0]
            if (ls1.text != "") {
                //                btn_ls1.isHidden = false
                //                btn_ls1.isEnabled = true
            }
            
            btnAllLS.isHidden = true
            btnAllLS.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        if UserDefaults.standard.integer(forKey: "question_read") > 0{
            question_indicator.text = String(UserDefaults.standard.integer(forKey: "question_read"))
            // Опросы
            let str_menu_3 = defaults.string(forKey: "menu_3") ?? ""
            if (str_menu_3 != "") {
                var answer = str_menu_3.components(separatedBy: ";")
                if (answer[2] == "0") {
                    question_indicator.isHidden = true
                } else {
                    question_indicator.isHidden = false
                }
            }
        }else{
            question_indicator.isHidden = true
        }
        if UserDefaults.standard.integer(forKey: "news_read") > 0{
            news_indicator.text = String(UserDefaults.standard.integer(forKey: "news_read"))
            // Уведомления - Новости
            let str_menu_0 = defaults.string(forKey: "menu_0") ?? ""
            if (str_menu_0 != "") {
                var answer = str_menu_0.components(separatedBy: ";")
                if (answer[2] == "0") {
                    news_indicator.isHidden = true
                } else {
                    news_indicator.isHidden = false
                }
            }
        }else{
            news_indicator.isHidden = true
        }
        if UserDefaults.standard.integer(forKey: "request_read") > 0{
            request_indicator.text = String(UserDefaults.standard.integer(forKey: "request_read"))
            // Заявки
            let str_menu_2 = defaults.string(forKey: "menu_2") ?? ""
            if (str_menu_2 != "") {
                var answer = str_menu_2.components(separatedBy: ";")
                if (answer[2] == "0") {
                    request_indicator.isHidden = true
                } else {
                    request_indicator.isHidden = false
                }
            }
        }else{
            request_indicator.isHidden = true
        }
        if !load{
            let updatedBadgeNumber = UserDefaults.standard.integer(forKey: "question_read") + UserDefaults.standard.integer(forKey: "news_read") + UserDefaults.standard.integer(forKey: "request_read")
            if (updatedBadgeNumber > -1) {
                UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
            }
            load = true
        }
        
        show_ls(defaults: defaults)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        if !supK{
            self.navigationController?.isNavigationBarHidden = false;
        }        
    }
    
    func add_record(numb: Int) {
        
        if (numb == 1) {
            txt_name = "Запись на прием к руководителю"
        }
        
        let defaults = UserDefaults.standard
        
        pass = defaults.string(forKey: "pass") ?? ""
        name_account = defaults.string(forKey: "name") ?? ""
        
        if (login == "") {
            // Сообщение об ошибке
            let alert = UIAlertController(title: "Ошибка", message: "Не привязан ни один лицевой счет к аккаунту", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let urlPath = Server.SERVER + Server.ADD_APP +
            "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! +
            "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! +
            "&name=" + txt_name.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! +
            "&text=" + txt_name.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! +
            "&type=" + "11" +
            "&priority=" + "2"
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        //            print(request.url)
        
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
                                                
                                                self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(self.responseString)")
                                                
                                                self.choice()
        })
        task.resume()
    }
    
    func choice() {
        if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Не переданы обязательные параметры", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "2") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Не удалось. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                
                // все ок - запишем заявку в БД (необходимо получить и записать авт. комментарий в БД
                // Запишем заявку в БД
                let db = DB()
                db.add_app(id: 1, number: self.responseString, text: self.txt_name, tema: self.txt_name, date: self.date_teck()!, adress: "", flat: "", phone: "", owner: self.name_account, is_close: 1, is_read: 1, is_answered: 1, type_app: "11")
                db.getComByID(login: self.login, pass: self.pass, number: self.responseString)
                
                self.StopIndicator()
                
                let alert = UIAlertController(title: "Успешно", message: "Создана запись на прием (см. в Заявках)" , preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            })
        }
        
    }
    
    func getQuestions() {
        question_read = 0
        let phone = UserDefaults.standard.string(forKey: "phone") ?? ""
        //        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "accID=" + id)!)
        
        var strLogin = phone.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "phone=" + strLogin)!)
        request.httpMethod = "GET"
        print(request)
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
            guard data != nil else { return }
            let json = try? JSONSerialization.jsonObject(with: data!,
                                                         options: .allowFragments)
            let unfilteredData = QuestionsJson(json: json! as! JSON)?.data
            unfilteredData?.forEach { json in
                if !json.readed!{
                    self.question_read += 1
                }
            }
            DispatchQueue.main.async {
                UserDefaults.standard.setValue(self.question_read, forKey: "question_read")
                UserDefaults.standard.synchronize()
                if self.question_read > 0{
                    self.question_indicator.text = String(self.question_read)
                    self.question_indicator.isHidden = false
                }else{
                    self.question_indicator.isHidden = true
                }
                
            }
            
            }.resume()
        
    }
    
    func getNews(){
        news_read = 0
        let phone = UserDefaults.standard.string(forKey: "phone") ?? ""
        
        var strLogin = phone.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        strLogin = strLogin.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_NEWS + "phone=" + strLogin)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
            //            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            //            print("responseString = \(responseString)")
            
            guard data != nil else { return }
            let json = try? JSONSerialization.jsonObject(with: data!,
                                                         options: .allowFragments)
            let unfilteredData = NewsJson(json: json! as! JSON)?.data
            unfilteredData?.forEach { json in
                if !json.readed! {
                    self.news_read += 1
                }
            }
            DispatchQueue.main.async {
                UserDefaults.standard.setValue(self.news_read, forKey: "news_read")
                UserDefaults.standard.synchronize()
                if self.news_read > 0{
                    self.news_indicator.text = String(self.news_read)
                    self.news_indicator.isHidden = false
                }else{
                    self.news_indicator.isHidden = true
                }
                
            }
            }.resume()
    }
    
    func date_teck() -> (String)? {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
        
    }
    
    func StartIndicator() {
        self.mainView.isHidden = true
        
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator() {
        self.mainView.isHidden = false
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    var debtIdent:[String] = []
    var debtSum:[String] = []
    var debtSumFine:[String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let str_menu_6 = UserDefaults.standard.string(forKey: "menu_6") ?? ""
        if (str_menu_6 != "") {
            var answer = str_menu_6.components(separatedBy: ";")
            if (answer[2] == "0") {
                return 0
            }else{
                var o = 0
                debtSum.forEach{
                    if Double($0) != 0.00{
                        o += 1
                    }
                }
                if o != 0 && debtSum.count != 0{
                    debtHeight.constant = CGFloat(debtSum.count * 30)
                    heigth_view.constant = heigth_view.constant + CGFloat((debtSum.count - 1) * 25)
                    if (self.heigth_view.constant + 115) > self.view.frame.size.height{
                        self.backgroundHeight.constant = self.backgroundHeight.constant + ((self.heigth_view.constant + 115) - self.view.frame.size.height) + 20
                    }
                    menu_6_heigth.constant   = 60 + CGFloat(debtSum.count * 30)
                    return debtSum.count
                } else {
//                    self.debtLbl.text = self.debtLbl.text! + " отсутствует"
//                    self.debtLbl.textColor = .green
                    debtHeight.constant = 3
                    return 0
                }
            }
        }
        return 0
    }
    
    var sendedArr:[Bool] = []
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.debtTable.dequeueReusableCell(withIdentifier: "DebtMenuCell") as! DebtMenuCell
        cell.dataLbl.text = debtSum[indexPath.row] + " р., пеня " + debtSumFine[indexPath.row] + " р. (л/сч " + debtIdent[indexPath.row] + ")"
        //        cell.delegate = self
        return cell
    }
    
}

class DebtMenuCell: UITableViewCell {
    
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var lblHeight6: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
