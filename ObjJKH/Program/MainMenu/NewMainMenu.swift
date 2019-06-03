//
//  NewMainMenu.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 21/03/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class NewMainMenu: UIViewController {

    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var countersView: UIView!
    @IBOutlet weak var paysView: UIView!
    @IBOutlet weak var appsView: UIView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var saldoView: UIView!
    @IBOutlet weak var webCamView: UIView!
    @IBOutlet weak var serviceView: UIView!
    
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var countersImg: UIImageView!
    @IBOutlet weak var paysImg: UIImageView!
    @IBOutlet weak var appsImg: UIImageView!
    @IBOutlet weak var questionImg: UIImageView!
    @IBOutlet weak var saldoImg: UIImageView!
    @IBOutlet weak var webCamImg: UIImageView!
    @IBOutlet weak var serviceImg: UIImageView!
    
    @IBOutlet weak var newsLbl: UILabel!
    @IBOutlet weak var countersLbl: UILabel!
    @IBOutlet weak var paysLbl: UILabel!
    @IBOutlet weak var appsLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var saldoLbl: UILabel!
    @IBOutlet weak var webCamLbl: UILabel!
    @IBOutlet weak var serviceLbl: UILabel!
    
    @IBOutlet weak var newsHeight: NSLayoutConstraint!
    @IBOutlet weak var countersHeight: NSLayoutConstraint!
    @IBOutlet weak var paysHeight: NSLayoutConstraint!
    @IBOutlet weak var appsHeight: NSLayoutConstraint!
    @IBOutlet weak var questionHeight: NSLayoutConstraint!
    @IBOutlet weak var saldoHeight: NSLayoutConstraint!
    @IBOutlet weak var webCamHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceHeight: NSLayoutConstraint!
    
    @IBOutlet weak var firstColumnWidth: NSLayoutConstraint!
    @IBOutlet weak var twoColumnWidth: NSLayoutConstraint!
    @IBOutlet weak var threeColumnWidth: NSLayoutConstraint!
    
    @IBOutlet weak var newsImgTop: NSLayoutConstraint!
    @IBOutlet weak var countersImgTop: NSLayoutConstraint!
    @IBOutlet weak var paysImgTop: NSLayoutConstraint!
    @IBOutlet weak var appsImgTop: NSLayoutConstraint!
    @IBOutlet weak var questionImgTop: NSLayoutConstraint!
    @IBOutlet weak var saldoImgTop: NSLayoutConstraint!
    @IBOutlet weak var webCamImgTop: NSLayoutConstraint!
    @IBOutlet weak var serviceImgTop: NSLayoutConstraint!
    
    @IBOutlet weak var newsAppsSpace: NSLayoutConstraint!
    @IBOutlet weak var appsQuestionSpace: NSLayoutConstraint!
    @IBOutlet weak var countersSaldoSpace: NSLayoutConstraint!
    @IBOutlet weak var paysWebSpace: NSLayoutConstraint!
    @IBOutlet weak var webServiceSpace: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstColumnWidth.constant = (self.view.frame.size.width - 30) / 3
        twoColumnWidth.constant = (self.view.frame.size.width - 30) / 3
        threeColumnWidth.constant = (self.view.frame.size.width - 30) / 3
        
        newsImg.image = myImages.notice_image
        newsImg.setImageColor(color: myColors.btnColor.uiColor())
        appsImg.image = UIImage(named: "appsIcon")
        appsImg.setImageColor(color: myColors.btnColor.uiColor())
        questionImg.image = myImages.poll_image
        questionImg.setImageColor(color: myColors.btnColor.uiColor())
        countersImg.image = myImages.meters_image
        countersImg.setImageColor(color: myColors.btnColor.uiColor())
        saldoImg.image = myImages.saldo_image
        saldoImg.setImageColor(color: myColors.btnColor.uiColor())
        paysImg.image = myImages.payment_image
        paysImg.setImageColor(color: myColors.btnColor.uiColor())
        webCamImg.image = myImages.webs_image
        webCamImg.setImageColor(color: myColors.btnColor.uiColor())
        serviceImg.image = myImages.services
        serviceImg.setImageColor(color: myColors.btnColor.uiColor())
        
        newsLbl.textColor = myColors.btnColor.uiColor()
        countersLbl.textColor = myColors.btnColor.uiColor()
        paysLbl.textColor = myColors.btnColor.uiColor()
        appsLbl.textColor = myColors.btnColor.uiColor()
        questionLbl.textColor = myColors.btnColor.uiColor()
        saldoLbl.textColor = myColors.btnColor.uiColor()
        webCamLbl.textColor = myColors.btnColor.uiColor()
        serviceLbl.textColor = myColors.btnColor.uiColor()
        
//        if self.view.frame.size.width <= 320{
//            saldoLbl.font = UIFont.systemFont(ofSize: 9.0)
//        }        
        // Do any additional setup after loading the view.
        settings_for_menu()
    }
    
    func settings_for_menu() {
        var newsHidd = false
        var countersHidd = false
        var paysHidd = false
        var appsHidd = false
        var questionHidd = false
        var saldoHidd = false
        var webCamHidd = false
        var serviceHidd = false
        
        let defaults = UserDefaults.standard
        // Уведомления - Новости
        let str_menu_0 = defaults.string(forKey: "menu_0") ?? ""
        if (str_menu_0 != "") {
            var answer = str_menu_0.components(separatedBy: ";")
            if (answer[2] == "0") {
                newsHeight.constant = 0
                newsView.isHidden = true
                newsHidd = true
            } else {
                newsLbl.text = answer[1]
            }
        }
        // Заявки
        let str_menu_2 = defaults.string(forKey: "menu_2") ?? ""
        if (str_menu_2 != "") {
            var answer = str_menu_2.components(separatedBy: ";")
            if (answer[2] == "0") {
                appsHeight.constant = 0
                appsView.isHidden = true
                appsHidd = true
            } else {
                appsLbl.text = answer[1]
            }
        }
        // Опросы
        let str_menu_3 = defaults.string(forKey: "menu_3") ?? ""
        if (str_menu_3 != "") {
            var answer = str_menu_3.components(separatedBy: ";")
            if (answer[2] == "0") {
                questionHeight.constant = 0
                questionView.isHidden = true
                questionHidd = true
            } else {
                questionLbl.text = answer[1]
            }
        }
        // Показания счетчиков
        let str_menu_4 = defaults.string(forKey: "menu_4") ?? ""
        if (str_menu_4 != "") {
            var answer = str_menu_4.components(separatedBy: ";")
            if (answer[2] == "0") {
                countersHeight.constant = 0
                countersView.isHidden = true
                saldoHeight.constant =  saldoHeight.constant + 185
                countersSaldoSpace.constant = 0
                countersHidd = true
            } else {
                countersLbl.text = answer[1]
            }
        }
        // Взаиморасчеты
        let str_menu_5 = defaults.string(forKey: "menu_5") ?? ""
        if (str_menu_5 != "") {
            var answer = str_menu_5.components(separatedBy: ";")
            if (answer[2] == "0") {
                saldoHeight.constant   = 0
                saldoView.isHidden      = true
                countersHeight.constant = countersHeight.constant + 185
                countersSaldoSpace.constant = 0
                saldoHidd = true
            } else {
                saldoLbl.text = answer[1]
            }
        }
        // Оплата ЖКУ
        let str_menu_6 = defaults.string(forKey: "menu_6") ?? ""
        if (str_menu_6 != "") {
            var answer = str_menu_6.components(separatedBy: ";")
            if (answer[2] == "0") {
                paysHeight.constant = 0
                paysView.isHidden   = true
                paysHidd = true
            } else {
                paysLbl.text = answer[1]
            }
        }
        // Web-камеры
        let str_menu_7 = defaults.string(forKey: "menu_7") ?? ""
        if (str_menu_7 != "") {
            var answer = str_menu_7.components(separatedBy: ";")
            if (answer[2] == "0") {
                webCamHeight.constant = 0
                webCamView.isHidden   = true
                webCamHidd = true
            } else {
                webCamLbl.text = answer[1]
            }
        }
        // Дополнительные услуги
        let str_menu_8 = defaults.string(forKey: "menu_8") ?? ""
        if (str_menu_8 != "") {
            var answer = str_menu_8.components(separatedBy: ";")
            if (answer[2] == "0") {
                serviceHeight.constant = 0
                serviceView.isHidden   = true
                serviceHidd = true
            } else {
                serviceLbl.text = answer[1]
            }
        }
        //Первый столбец
        if appsHidd && questionHidd{
            newsHeight.constant = 365
            newsAppsSpace.constant = 0
            appsQuestionSpace.constant = 0
        }else if appsHidd && newsHidd{
            questionHeight.constant = 365
            newsAppsSpace.constant = 0
            appsQuestionSpace.constant = 0
        }else if questionHidd && newsHidd{
            appsHeight.constant = 365
            newsAppsSpace.constant = 0
            appsQuestionSpace.constant = 0
        }else if appsHidd{
            newsHeight.constant = 200
            newsAppsSpace.constant = 0
            questionHeight.constant = 160
        }else if questionHidd{
            newsHeight.constant = 200
            appsQuestionSpace.constant = 0
            appsHeight.constant = 160
        }else if newsHidd{
            appsHeight.constant = 200
            newsAppsSpace.constant = 0
            questionHeight.constant = 160
        }
        
        //Третий столбец
        if webCamHidd && serviceHidd{
            paysHeight.constant = 365
            paysWebSpace.constant = 0
            webServiceSpace.constant = 0
        }else if webCamHidd && paysHidd{
            serviceHeight.constant = 365
            paysWebSpace.constant = 0
            webServiceSpace.constant = 0
        }else if questionHidd && newsHidd{
            webCamHeight.constant = 365
            paysWebSpace.constant = 0
            webServiceSpace.constant = 0
        }else if paysHidd{
            webCamHeight.constant = 200
            paysWebSpace.constant = 0
            serviceHeight.constant = 160
        }else if webCamHidd{
            paysHeight.constant = 200
            paysWebSpace.constant = 0
            serviceHeight.constant = 160
        }else if serviceHidd{
            paysHeight.constant = 200
            webServiceSpace.constant = 0
            webCamHeight.constant = 160
        }
        
        if countersHidd && saldoHidd{
            firstColumnWidth.constant = (self.view.frame.size.width - 25) / 2
            twoColumnWidth.constant = 0
            threeColumnWidth.constant = (self.view.frame.size.width - 25) / 2
        }
        if newsHidd && appsHidd && questionHidd{
            firstColumnWidth.constant = 0
            twoColumnWidth.constant = (self.view.frame.size.width - 25) / 2
            threeColumnWidth.constant = (self.view.frame.size.width - 25) / 2
        }
        if paysHidd && webCamHidd && serviceHidd{
            firstColumnWidth.constant = (self.view.frame.size.width - 25) / 2
            twoColumnWidth.constant = (self.view.frame.size.width - 25) / 2
            threeColumnWidth.constant = 0
        }
        
        newsImgTop.constant     = (newsHeight.constant / 2) - 36.25
        countersImgTop.constant = (countersHeight.constant / 2) - 36.25
        paysImgTop.constant     = (paysHeight.constant / 2) - 36.25
        appsImgTop.constant     = (appsHeight.constant / 2) - 36.25
        questionImgTop.constant = (questionHeight.constant / 2) - 36.25
        saldoImgTop.constant    = (saldoHeight.constant / 2) - 36.25
        webCamImgTop.constant   = (webCamHeight.constant / 2) - 36.25
        serviceImgTop.constant  = (serviceHeight.constant / 2) - 36.25
    }
    
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
    
    // Оплаты
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
}
