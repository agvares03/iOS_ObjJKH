//
//  NewMainMenu2.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 12/04/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import Gloss
import SwiftyXMLParser
import Crashlytics

class NewMainMenu2: UIViewController {
    
    // Запись на прием - Наш Общий Дом
    @IBOutlet weak var targetName: UILabel!
    @IBOutlet weak var elipseBackground: UIView!
    @IBOutlet weak var elipseBackground2: UIView!
    @IBOutlet weak var fon_Samara: UIImageView!
    @IBOutlet weak var name_Samara: UILabel!
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
    
    // Размеры для настройки меню
    // Уведомления - Новости
    @IBOutlet weak var menu_0_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_0: UIButton!
    @IBOutlet weak var line_bottom_0: UILabel!
    @IBOutlet weak var btn_arr_0: UIImageView!
    // Звонок диспетчеру
    @IBOutlet weak var btn_name_1: UIButton!
    @IBOutlet weak var supportBtn: UIButton!
    // Заявки
    @IBOutlet weak var menu_2_heigth: NSLayoutConstraint!
    @IBOutlet weak var line_bottom_2: UILabel!
    @IBOutlet weak var btn_arr_2: UIImageView!
    @IBOutlet weak var btn_name_2: UIButton!
    // Опросы - было реализовано ранее для Мытищ
    @IBOutlet weak var line_bottom_3: UILabel!
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
    // Осмотр
    @IBOutlet weak var menu_9_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_9: UIButton!
    @IBOutlet weak var btn_arr_9: UIImageView!
    @IBOutlet weak var line_bottom_9: UILabel!
    // Телефоны при аварии РКС Самара
    @IBOutlet weak var menu_11_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_11: UIButton!
    @IBOutlet weak var btn_arr_11: UIImageView!
    @IBOutlet weak var line_bottom_11: UILabel!
    // Сообщить об аварии РКС Самара
    @IBOutlet weak var menu_12_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_12: UIButton!
    @IBOutlet weak var btn_arr_12: UIImageView!
    @IBOutlet weak var line_bottom_12: UILabel!
    // Голосования
    @IBOutlet weak var oss_heigth: NSLayoutConstraint!
    @IBOutlet weak var btn_name_oss: UIButton!
    @IBOutlet weak var btn_arr_oss: UIImageView!
    @IBOutlet weak var line_bottom_oss: UILabel!
    // Выход - только название
    @IBOutlet weak var line_bottom_10: UILabel!
    @IBOutlet weak var btn_name_10: UIButton!
    @IBOutlet weak var heigth_Questions: NSLayoutConstraint!
    @IBOutlet weak var btn_Questions: UIButton!
    @IBOutlet weak var Questions_arrow: UIImageView!
    
    @IBOutlet weak var callBtnImg: UIImageView!
    @IBOutlet weak var callLbl1: UILabel!
    @IBOutlet weak var callLbl2: UILabel!
    // Картинки - для разных Таргетов
    @IBOutlet weak var notice: UIImageView!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var application: UIImageView!
    @IBOutlet weak var poll: UIImageView!
    @IBOutlet weak var meters: UIImageView!
    @IBOutlet weak var saldo: UIImageView!
    @IBOutlet weak var payment: UIImageView!
    @IBOutlet weak var webs_img: UIImageView!
    @IBOutlet weak var services: UIImageView!
    @IBOutlet weak var object: UIImageView!
    @IBOutlet weak var exit_img: UIImageView!
    @IBOutlet weak var oss: UIImageView!
    @IBOutlet weak var phoneSamara: UIImageView!
    @IBOutlet weak var alertSamara: UIImageView!
    
    var phone: String?
    
    @IBAction func AddLS(_ sender: UIButton) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "addLS_Mup", sender: self)
        #elseif isPocket
        self.performSegue(withIdentifier: "addLSPocket", sender: self)
//        #elseif isRodnikMUP
//        self.performSegue(withIdentifier: "addLSSimple", sender: self)
        #else
//        self.performSegue(withIdentifier: "addLS", sender: self)
        self.performSegue(withIdentifier: "addLSSimple", sender: self)
        #endif
    }
    
    @IBAction func SupportBtnAction(_ sender: UIButton) {
        supK = true
        self.performSegue(withIdentifier: "support", sender: self)
    }
    var supK = false
    
    @IBAction func goAccount(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("MainMenu", forKey: "last_UI_action")
        self.getQuestions()
        self.getNews()
        #if isRKC_Samara
        name_Samara.isHidden = false
        elipseBackground.isHidden = true
        elipseBackground2.isHidden = true
        fon_Samara.isHidden = false
        #else
        name_Samara.isHidden = true
        elipseBackground.isHidden = false
        elipseBackground2.isHidden = false
        fon_Samara.isHidden = true
        #endif
        let defaults = UserDefaults.standard
        // Телефон диспетчера
        phone = defaults.string(forKey: "phone_operator")
        var phone1 = defaults.string(forKey: "phone_operator")
        if phone1?.first == "8" && phone1!.count > 10{
            phone1?.removeFirst()
            phone1 = "+7" + phone1!
        }
        var phoneOperator = ""
        if phone1!.count > 10{
//            phone1 = phone1?.replacingOccurrences(of: " ", with: "")
//            phone1 = phone1?.replacingOccurrences(of: "-", with: "")
            if !(phone1?.contains(")"))! && phone1 != ""{
                for i in 0...11{
                    if i == 2{
                        phoneOperator = phoneOperator + " (" + String(phone1!.first!)
                    }else if i == 5{
                        phoneOperator = phoneOperator + ") " + String(phone1!.first!)
                    }else if i == 8{
                        phoneOperator = phoneOperator + "-" + String(phone1!.first!)
                    }else if i == 10{
                        phoneOperator = phoneOperator + "-" + String(phone1!.first!)
                    }else{
                        phoneOperator = phoneOperator + String(phone1!.first!)
                    }
                    phone1?.removeFirst()
                }
            }else if !(phone1?.contains("-"))! && phone1 != ""{
                phone1 = phone1?.replacingOccurrences(of: " ", with: "")
                phone1 = phone1?.replacingOccurrences(of: "-", with: "")
                phone1 = phone1?.replacingOccurrences(of: ")", with: "")
                phone1 = phone1?.replacingOccurrences(of: "(", with: "")
                for i in 0...11{
                    if i == 2{
                        phoneOperator = phoneOperator + " (" + String(phone1!.first!)
                    }else if i == 5{
                        phoneOperator = phoneOperator + ") " + String(phone1!.first!)
                    }else if i == 8{
                        phoneOperator = phoneOperator + "-" + String(phone1!.first!)
                    }else if i == 10{
                        phoneOperator = phoneOperator + "-" + String(phone1!.first!)
                    }else{
                        phoneOperator = phoneOperator + String(phone1!.first!)
                    }
                    phone1?.removeFirst()
                }
            }else{
                phoneOperator = phone1!
            }
        }else{
            phoneOperator = phone1!
        }
        if phoneOperator.contains(")"){
            callLbl1.text = String(phoneOperator.prefix(through: phoneOperator.index(of: ")")!))
            callLbl2.text = phoneOperator.replacingOccurrences(of: phoneOperator.prefix(through: phoneOperator.index(of: ")")!), with: "")
        }else if !phoneOperator.contains("+7"){
            btn_name_1.isHidden = true
            callBtnImg.isHidden = true
            callLbl1.isHidden = true
            callLbl2.isHidden = true
        }else{
            callLbl1.text = ""
            callLbl2.text = phoneOperator
        }
        btn_name_1.setTitle(phoneOperator, for: .normal)
        targetName.text = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String)
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
        #elseif isSoldatova1
        fon_top.image = UIImage(named: "Logo_Soldatova1")
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
        #elseif isTeplovodoresources
        fon_top.image = UIImage(named: "Logo_Teplovodoresources")
        #elseif isStroimBud
        fon_top.image = UIImage(named: "Logo_StroimBud")
        #elseif isRodnikMUP
        fon_top.image = UIImage(named: "Logo_RodnikMUP")
        #elseif isUKParitetKhab
        fon_top.image = UIImage(named: "Logo_Paritet")
        #elseif isADS68
        fon_top.image = UIImage(named: "Logo_ADS68")
        #elseif isAFregat
        fon_top.image = UIImage(named: "Logo_Fregat")
        #elseif isNewOpaliha
        fon_top.image = UIImage(named: "Logo_NewOpaliha")
        #elseif isStroiDom
        fon_top.image = UIImage(named: "Logo_StroiDom")
        #elseif isDJVladimir
        fon_top.image = UIImage(named: "Logo_DJVladimir")
        #elseif isTSN_Dnestr
        fon_top.image = UIImage(named: "Logo_TSN_Dnestr")
        #elseif isCristall
        fon_top.image = UIImage(named: "Logo_Cristall")
        #elseif isNarianMarEl
        fon_top.image = UIImage(named: "Logo_Narian_Mar_El")
        #elseif isSibAliance
        fon_top.image = UIImage(named: "Logo_SibAliance")
        #elseif isSpartak
        fon_top.image = UIImage(named: "Logo_Spartak")
        #elseif isTSN_Ruble40
        fon_top.image = UIImage(named: "Logo_Ruble40")
        #elseif isKosm11
        fon_top.image = UIImage(named: "Logo_Kosm11")
        #elseif isTSJ_Rachangel
        fon_top.image = UIImage(named: "Logo_TSJ_Archangel")
        #elseif isMUP_IRKC
        fon_top.image = UIImage(named: "Logo_MUP_IRKC")
        #elseif isUK_First
        fon_top.image = UIImage(named: "Logo_Uk_First")
        #elseif isRKC_Samara
        fon_top.image = UIImage(named: "Logo_Samara")
        #elseif isEnergoProgress
        fon_top.image = UIImage(named: "Logo_EnergoProgress")
        #elseif isMurmanskPartnerPlus
        fon_top.image = UIImage(named: "Logo_Murmansk")
        #elseif isEasyLife
        fon_top.image = UIImage(named: "Logo_EasyLife")
        #elseif isRIC
        fon_top.image = UIImage(named: "Logo_RIC")
        #elseif isMonolit
        fon_top.image = UIImage(named: "Logo_Monolit")
        #elseif isVodSergPosad
        fon_top.image = UIImage(named: "Logo_VodSergPosad")
        #elseif isMobileMIR
        fon_top.image = UIImage(named: "Logo_MobileMIR")
        #elseif isZarinsk
        fon_top.image = UIImage(named: "Logo_Zarinsk")
        #elseif isPedagog
        fon_top.image = UIImage(named: "Logo_Pedagog")
        #elseif isGorAntenService
        fon_top.image = UIImage(named: "Logo_GorAntenService")
        #elseif isElectroTech
        fon_top.image = UIImage(named: "Logo_ElectroTech")
        #elseif isTSJ_Lider
        fon_top.image = UIImage(named: "Logo_TSJLider")
        #elseif isUK_Drujba
        fon_top.image = UIImage(named: "Logo_UkDrujba")
        #elseif isKFH_Ryab
        fon_top.image = UIImage(named: "Logo_KFHRyab")
        #elseif isDOM24
        fon_top.image = UIImage(named: "Logo_DOM24")
        #elseif isLefortovo
        fon_top.image = UIImage(named: "Logo_Lefortovo")
        #elseif isERC_UDM
        fon_top.image = UIImage(named: "Logo_ERC_UDM")
        #elseif isAvalon
        fon_top.image = UIImage(named: "Logo_Avalon")
        #elseif isDoka
        fon_top.image = UIImage(named: "Logo_Doka")
        #elseif isInvest
        fon_top.image = UIImage(named: "Logo_Invest")
        #elseif isUniversSol
        fon_top.image = UIImage(named: "Logo_UniversSol")
        #elseif isClearCity
        fon_top.image = UIImage(named: "Logo_ClearCity")
        #elseif isAlternative
        fon_top.image = UIImage(named: "Logo_Alternative")
        #elseif isMUP_Severnoe
        fon_top.image = UIImage(named: "Logo_MUP_Severnoe")
        #elseif isAlphaJKH
        fon_top.image = UIImage(named: "Logo_AlphaJKH")
        #elseif isSuhanovo
        fon_top.image = UIImage(named: "Logo_Suhanovo")
        #elseif isMaximum
        fon_top.image = UIImage(named: "Logo_Maximum")
        #elseif isEJF
        fon_top.image = UIImage(named: "Logo_EJF")
        #elseif isClean_Tid
        fon_top.image = UIImage(named: "Logo_Clean_Tid")
        #elseif isJilUpravKom
        fon_top.image = UIImage(named: "Logo_JilUpravKom")
        #elseif isTihGavan
        fon_top.image = UIImage(named: "Logo_TihGavan")
        #elseif isOptimumService
        fon_top.image = UIImage(named: "Logo_OptimumService")
        #elseif isSibir
        fon_top.image = UIImage(named: "Logo_Sibir")
        #elseif isNovogorskoe
        fon_top.image = UIImage(named: "Logo_Novogorskoe")
        #elseif isION
        fon_top.image = UIImage(named: "Logo_ION")
        #elseif isGrinvay
        fon_top.image = UIImage(named: "Logo_Grinvay")
        #elseif isGumse
        fon_top.image = UIImage(named: "Logo_Gumse")
        #elseif isSV14
        fon_top.image = UIImage(named: "Logo_SV14")
        #endif
        
        // Картинки для разных Таргетов
        notice.image = myImages.notice_image
        notice.setImageColor(color: myColors.btnColor.uiColor())
        callBtnImg.setImageColor(color: myColors.btnColor.uiColor())
        callLbl1.textColor = myColors.btnColor.uiColor()
        callLbl2.textColor = myColors.btnColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
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
        object.image = myImages.obj_image
        object.setImageColor(color: myColors.btnColor.uiColor())
        exit_img.image = myImages.exit_image
        exit_img.setImageColor(color: myColors.btnColor.uiColor())
        oss.image = myImages.oss_image
        oss.setImageColor(color: myColors.btnColor.uiColor())
        phoneSamara.setImageColor(color: myColors.btnColor.uiColor())
        alertSamara.setImageColor(color: myColors.btnColor.uiColor())
        
        line_bottom_0.backgroundColor = myColors.btnColor.uiColor()
        line_bottom_2.backgroundColor = myColors.btnColor.uiColor()
        line_bottom_3.backgroundColor = myColors.btnColor.uiColor()
        line_bottom_4.backgroundColor = myColors.btnColor.uiColor()
        line_bottom_5.backgroundColor = myColors.btnColor.uiColor()
        line_bottom_6.backgroundColor = myColors.btnColor.uiColor()
        line_bottom_7.backgroundColor = myColors.btnColor.uiColor()
        line_bottom_8.backgroundColor = myColors.btnColor.uiColor()
        line_bottom_9.backgroundColor = myColors.btnColor.uiColor()
        line_bottom_10.backgroundColor = myColors.btnColor.uiColor()
        line_bottom_11.backgroundColor = myColors.btnColor.uiColor()
        line_bottom_12.backgroundColor = myColors.btnColor.uiColor()
        line_bottom_oss.backgroundColor = myColors.btnColor.uiColor()
        elipseBackground.backgroundColor = myColors.btnColor.uiColor()
        getDebt()
        let login = defaults.string(forKey: "login")
        let pass  = defaults.string(forKey: "pass")
        get_Services(login: login!, pass: pass!)
        // Настройки для меню
        settings_for_menu()
    }
    
    var serviceArr: [Services] = []
    var mainScreenXml:  XML.Accessor?
    func get_Services(login: String, pass: String){
        serviceArr.removeAll()
        let data: Data? = TemporaryHolder.instance.AccountDataAll?.getAdditionalServices?.data(using: .utf8)
        guard data != nil else { return }
        //                let responseString = String(data: data!, encoding: .utf8) ?? ""
        //                #if DEBUG
        //                print("responseString = \(responseString)")
        //                #endif
        var obj: [Services] = []
        let xml = XML.parse(data!)
        self.mainScreenXml = xml
        let requests = xml["AdditionalServices"]
        let row = requests["Group"]
        row.forEach { row in
            row["AdditionalService"].forEach {
                obj.append(Services(row: $0))
            }
        }
        obj.forEach{
            if ($0.logo?.contains("http"))!{
                let url:NSURL = NSURL(string: ($0.logo)!)!
                let data = try? Data(contentsOf: url as URL)
                if data != nil{
                    if UIImage(data: data!) == nil{
                        
                    }else{
                        self.serviceArr.append($0)
                    }
                }
            }
        }
        
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
                //heigth_view.constant     = //heigth_view.constant - 41
            } else {
                btn_name_0.setTitle(answer[1], for: .normal)
            }
        }
        // Звонок диспетчеру
        let str_menu_1 = defaults.string(forKey: "menu_1") ?? ""
        if (str_menu_1 != "") {
            var answer = str_menu_1.components(separatedBy: ";")
            if (answer[2] == "0") {
//                menu_1_heigth.constant   = 0
                btn_name_1.isHidden      = true
//                line_bottom_1.constant   = 0
                //heigth_view.constant     = //heigth_view.constant - 35
            } else {
//                btn_name_1.setTitle(answer[1], for: .normal)
            }
        }
        // Заявки
        let str_menu_2 = defaults.string(forKey: "menu_2") ?? ""
        if (str_menu_2 != "") {
            var answer = str_menu_2.components(separatedBy: ";")
            if (answer[2] == "0") {
                menu_2_heigth.constant   = -2
                application.isHidden     = true
                btn_name_2.isHidden      = true
                line_bottom_2.isHidden   = true
                btn_arr_2.isHidden       = true
                //heigth_view.constant     = //heigth_view.constant - 40
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
                heigth_Questions.constant = -2
                Questions_arrow.isHidden  = true
                poll.isHidden             = true
                line_bottom_3.isHidden    = true
                //heigth_view.constant      = //heigth_view.constant - 40
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
                //heigth_view.constant     = //heigth_view.constant - 39
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
                //heigth_view.constant     = //heigth_view.constant - 40
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
                //heigth_view.constant     = //heigth_view.constant - 90
            } else {
                btn_name_6.setTitle(answer[1], for: .normal)
            }
        }
        // Web-камеры
        let str_menu_7 = defaults.string(forKey: "menu_7") ?? ""
        if (str_menu_7 != "") {
            var answer = str_menu_7.components(separatedBy: ";")
            if (answer[2] == "0") {
                menu_7_heigth.constant   = -2
                btn_name_7.isHidden      = true
                btn_arr_7.isHidden       = true
                line_bottom_7.isHidden   = true
                webs_img.isHidden        = true
                //heigth_view.constant     = //heigth_view.constant - 39
            } else {
                btn_name_7.setTitle(answer[1], for: .normal)
            }
        }
        // Дополнительные услуги
        let str_menu_8 = defaults.string(forKey: "menu_8") ?? ""
        if (str_menu_8 != "") {
            let answer = str_menu_8.components(separatedBy: ";")
            if (answer[2] == "0") {
                menu_8_heigth.constant   = -2
                btn_name_8.isHidden      = true
                btn_arr_8.isHidden       = true
                line_bottom_8.isHidden   = true
                services.isHidden        = true
                //heigth_view.constant     = //heigth_view.constant - 40
            } else {
                btn_name_8.setTitle(answer[1], for: .normal)
            }
        }
        // Осмотр
        menu_9_heigth.constant   = -2
        btn_name_9.isHidden      = true
        btn_arr_9.isHidden       = true
        line_bottom_9.isHidden   = true
        object.isHidden = true
//        let str_menu_8 = defaults.string(forKey: "menu_8") ?? ""
//        if (str_menu_8 != "") {
//            var answer = str_menu_8.components(separatedBy: ";")
//            if (answer[2] == "0") {
//                menu_9_heigth.constant   = -2
//                btn_name_9.isHidden      = true
//                btn_arr_9.isHidden       = true
//                line_bottom_9.isHidden   = true
//                services.isHidden        = true
                //heigth_view.constant     = //heigth_view.constant - 40
//            } else {
//                btn_name_8.setTitle(answer[1], for: .normal)
//            }
//        }
        // Голосования
        let str_menu_oss = defaults.bool(forKey: "enable_OSS")
        //        let str_menu_oss = true
        if !str_menu_oss{
            oss_heigth.constant         = -2
            btn_name_oss.isHidden       = true
            btn_arr_oss.isHidden        = true
            oss.isHidden                = true
            line_bottom_oss.isHidden    = true
            //heigth_view.constant     = //heigth_view.constant - 40
        }else{
            let width = view.frame.size.width
            if width <= 320{
                oss_heigth.constant  = 50
                //heigth_view.constant = //heigth_view.constant + 21
            }
        }
        #if isRKC_Samara
//        menu_11_heigth.constant   = -2
//        btn_name_11.isHidden      = true
//        btn_arr_11.isHidden       = true
//        line_bottom_11.isHidden   = true
//        phoneSamara.isHidden      = true
//
//        menu_12_heigth.constant   = -2
//        btn_name_12.isHidden      = true
//        btn_arr_12.isHidden       = true
//        line_bottom_12.isHidden   = true
//        alertSamara.isHidden      = true
        #else
        menu_11_heigth.constant   = -2
        btn_name_11.isHidden      = true
        btn_arr_11.isHidden       = true
        line_bottom_11.isHidden   = true
        phoneSamara.isHidden      = true
        
        menu_12_heigth.constant   = -2
        btn_name_12.isHidden      = true
        btn_arr_12.isHidden       = true
        line_bottom_12.isHidden   = true
        alertSamara.isHidden      = true
        #endif
        // Выход - только название
        let str_menu_9 = defaults.string(forKey: "menu_9") ?? ""
        if (str_menu_9 != "") {
            var answer = str_menu_9.components(separatedBy: ";")
            btn_name_10.setTitle(answer[1], for: .normal)
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
        self.performSegue(withIdentifier: "paysMytishi2", sender: self)
        #else
        self.performSegue(withIdentifier: "paysMytishi", sender: self)
        #endif
//        self.performSegue(withIdentifier: "pays", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if UserDefaults.standard.value(forKey: "fromMenu") != nil{
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(true, forKey: "fromMenu")
            
        }
        debtArr.removeAll()
        var debt:[String:String] = [:]
        if lsArr.count != 0{
            for i in 0...lsArr.count - 1{
                debt["Ident"] = lsArr[i].ident
                debt["Sum"] = lsArr[i].sum
                debt["SumFine"] = lsArr[i].sumFine
                debt["InsuranceSum"] = lsArr[i].insuranceSum
                debt["HouseId"] = lsArr[i].houseId
                debt["INN"] = lsArr[i].inn
                debtArr.append(debt as AnyObject)
            }
        }
//        if segue.identifier == "goSaldo" {
//            let payController             = segue.destination as! SaldoController
//            print(self.debtArr.count)
//            payController.debtArr = self.debtArr
//        }
        #if isMupRCMytishi
        if segue.identifier == "paysMytishi2" {
            let payController             = segue.destination as! PaysMytishi2Controller
            payController.serviceArr = self.serviceArr 
            payController.debtArr = self.debtArr
        }
        #else
        if segue.identifier == "paysMytishi" {
            let payController             = segue.destination as! PaysMytishiController
            payController.serviceArr = self.serviceArr
            payController.debtArr = self.debtArr
        }
        #endif
        
        if segue.identifier == "mupCounters"{
            let payController             = segue.destination as! MupCounterController
            payController.serviceArr = self.serviceArr
            payController.lsArr = self.lsArr
        }
//        if segue.identifier == "pays" {
//            let payController             = segue.destination as! PaysController
//            payController.debtArr = self.debtArr
//        }
    }
    
    // Web-камеры
    @IBAction func go_web(_ sender: UIButton) {
    }
    
    var dateOld = "01.01"
    var lsArr:[lsData] = []
    func getDebt() {
        var debtIdent:[String] = []
        var debtSum:[String] = []
        var debtSumFine:[String] = []
        var debtDate:[String] = []
        var debtAddress:[String] = []
        var debtHouse:[String] = []
        var debtInn:[String] = []
        let defaults = UserDefaults.standard
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        var sumObj = 0.00
        var u = 0
        let login = defaults.string(forKey: "login")
        if (str_ls_arr?.count)! > 0 && str_ls_arr?[0] != ""{
            //            str_ls_arr?.forEach{
            let data: Data? = TemporaryHolder.instance.AccountDataAll?.getDebt?.data(using: .utf8)
            do {
                u += 1
                let responseStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                print(responseStr)
                
                if !responseStr.contains("error"){
                    var date        = "0"
                    var sum         = "0"
                    var sumFine     = "0"
                    var insuranceSum = "0"
                    var ls = "-"
                    var address = "-"
                    var houseId = "0"
                    var inn = ""
                    //                                                                var sumOver     = ""
                    //                                                                var sumFineOver = ""
                    //                                                                    var sumAll      = ""
                    var json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    //                                                                                                                                        print(json)
                    
                    if let json_bills = json["data"] {
                        let int_end = (json_bills.count)!-1
                        if (int_end < 0) {
                            
                        } else {
                            for index in 0...int_end {
                                let json_bill = json_bills.object(at: index) as! [String:AnyObject]
                                for obj in json_bill {
                                    if obj.key == "Sum" {
                                        if ((obj.value as? NSNull) == nil){
                                            sum = String(describing: obj.value as! Double)
                                        }
                                    }
                                    if obj.key == "SumFine" {
                                        if ((obj.value as? NSNull) == nil){
                                            sumFine = String(describing: obj.value as! Double)
                                        }
                                    }
                                    if obj.key == "Address" {
                                        if ((obj.value as? NSNull) == nil){
                                            address = String(describing: obj.value as! String)
                                        }
                                    }
                                    if obj.key == "Ident" {
                                        if ((obj.value as? NSNull) == nil){
                                            ls = String(describing: obj.value as! String)
                                        }
                                    }
                                    if obj.key == "DebtActualDate" {
                                        if ((obj.value as? NSNull) == nil){
                                            date = String(describing: obj.value as! String)
                                        }
                                    }
                                    if obj.key == "InsuranceSum" {
                                        if ((obj.value as? NSNull) == nil){
                                            insuranceSum = String(describing: obj.value as! Double)
                                        }
                                    }
                                    if obj.key == "HouseId" {
                                        if ((obj.value as? NSNull) == nil){
                                            houseId = String(describing: obj.value as! Int)
                                        }else{
                                            houseId = "0"
                                        }
                                    }
                                    if obj.key == "INN" {
                                        if ((obj.value as? NSNull) == nil){
                                            inn = String(describing: obj.value as! String)
                                        }
                                    }

                                    
                                }
                                //                                                                                if date == ""{
                                //                                                                                    let dateFormatter = DateFormatter()
                                //                                                                                    dateFormatter.dateFormat = "dd.MM.yyyy"
                                //                                                                                    date = dateFormatter.string(from: Date())
                                //                                                                                }
                                debtIdent.append(ls)
                                debtSum.append(sum)
                                debtSumFine.append(sumFine)
                                debtAddress.append(address)
                                debtDate.append(date)
                                debtHouse.append(houseId)
                                debtInn.append(inn)
                                self.lsArr.append(lsData.init(ident: ls, sum: sum, sumFine: sumFine, date: date, address: address, insuranceSum: insuranceSum, houseId: houseId, inn: inn))
                            }
                            
                            //                                                                            defaults.set(date, forKey: "dateDebt")
                            //                                                                            if Double(sumAll) != 0.00{
                            //                                                                                let d = date.components(separatedBy: ".")
                            //                                                                                let d1 = self.dateOld.components(separatedBy: ".")
                            //                                                                                if (Int(d[0])! >= Int(d1[0])!) && (Int(d[1])! >= Int(d1[1])!){
                            //                                                                                    DispatchQueue.main.async {
                            //                                                                                        self.dateOld = date
                            //                                                                                    }
                            //                                                                                }
                            //                                                                                sumObj = sumObj + Double(sumAll)!
                            //                                                                            }
                        }
                    }
                }
                
            } catch let error as NSError {
                print(error)
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
            self.add_record(numb: 1)
        }
        let do_it2 = UIAlertAction(title: "К специалисту", style: .default) { action in
            self.add_record(numb: 2)
        }
        
        actionSheet.addAction(do_it1)
        actionSheet.addAction(do_it2)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // Выход
    @IBAction func go_exit(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "exit")
        if UserDefaults.standard.bool(forKey: "сheckCrashSystem"){
            Crashlytics.sharedInstance().crash()
        }else{
            exit(0)
        }
        //        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
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
        Crashlytics.sharedInstance().setObjectValue("MainMenu", forKey: "last_UI_action")
//        if !load{
//            let updatedBadgeNumber = UserDefaults.standard.integer(forKey: "question_read") + UserDefaults.standard.integer(forKey: "news_read") + UserDefaults.standard.integer(forKey: "request_read")
//            if (updatedBadgeNumber > -1) {
//                UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
//            }
//            load = true
//        }
        
        self.tabBarController?.tabBar.isHidden = false
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.tabBarController?.tabBar.isHidden = true
//        UserDefaults.standard.set(true, forKey: "fromMenu")
//        UserDefaults.standard.synchronize()
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
                let alert = UIAlertController(title: "Ошибка", message: "Не переданы обязательные параметры", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "2") {
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
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
                db.add_app(id: 1, number: self.responseString, text: self.txt_name, tema: self.txt_name, date: self.date_teck()!, adress: "", flat: "", phone: "", owner: self.name_account, is_close: 1, is_read: 1, is_answered: 1, type_app: "11", serverStatus: "новая заявка")
                db.getComByID(login: self.login, pass: self.pass, number: self.responseString)
                
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
        let data: Data? = TemporaryHolder.instance.AccountDataAll?.getQuestions?.data(using: .utf8)
            
        guard data != nil else { return }
        if let json = try? JSONSerialization.jsonObject(with: data!,
                                                        options: .allowFragments){
            let unfilteredData = QuestionsJson(json: json as! JSON)?.data
            unfilteredData?.forEach { json in
                if !json.readed!{
                    self.question_read += 1
                }
            }
        }
    }
    
    func getNews(){
        news_read = 0
        var phone = ""
        
        if UserDefaults.standard.string(forKey: "phone") != nil{
            phone = UserDefaults.standard.string(forKey: "phone") ?? ""
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
                if let json = try? JSONSerialization.jsonObject(with: data!,
                                                                options: .allowFragments){
                    let unfilteredData = NewsJson(json: json as! JSON)?.data
                    unfilteredData?.forEach { json in
                        if !json.readed! {
                            self.news_read += 1
                        }
                    }
                }
                if self.news_read > 0{
                     UserDefaults.standard.set(self.news_read, forKey: "newsKol")
                }else{
                     UserDefaults.standard.set(0, forKey: "newsKol")
                }
                DispatchQueue.main.async {
                    let updatedBadgeNumber = UserDefaults.standard.integer(forKey: "appsKol") + UserDefaults.standard.integer(forKey: "newsKol")
                    if (updatedBadgeNumber > -1) {
                        UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
                    }
                    //                if request_read >= 0{
                    //                    UserDefaults.standard.setValue(request_read, forKey: "request_read")
                    //                    UserDefaults.standard.synchronize()
                    //                }else{
                    //                    UserDefaults.standard.setValue(0, forKey: "request_read")
                    //                    UserDefaults.standard.synchronize()
                    //                }
                    
                }
                }.resume()
        }
    }
    
    func date_teck() -> (String)? {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
        
    }
    
    var sendedArr:[Bool] = []
    
}

