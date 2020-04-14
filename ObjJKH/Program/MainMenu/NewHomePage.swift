//
//  NewMainMenu.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 14/03/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import Gloss
import CoreData
import SwiftyXMLParser
import YandexMobileAds
import GoogleMobileAds
import StoreKit
import Crashlytics
import FSPagerView
import DeviceCheck

protocol DebtCellDelegate: class {
    func goPaysPressed(ident: String)
}
protocol DelLSCellDelegate: class {
    func try_del_ls_from_acc(ls: String)
}
protocol GoUrlReceiptDelegate: class {
    func goUrlReceipt(url: String)
}

class NewHomePage: UIViewController, UITableViewDelegate, UITableViewDataSource, QuestionTableDelegate, CountersCellDelegate, DebtCellDelegate, DelLSCellDelegate, YMANativeAdDelegate, YMANativeAdLoaderDelegate, GoUrlReceiptDelegate, GADBannerViewDelegate, FSPagerViewDataSource, FSPagerViewDelegate {
    
    @IBOutlet weak var view_no_ls: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var adLoader: YMANativeAdLoader!
    var yaBannerView: YMANativeBannerView?
    var gadBannerView: GADBannerView!
    var request = GADRequest()
    @IBOutlet weak var adTopConst: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    private var refreshControl: UIRefreshControl?
    @IBOutlet weak var newsIndicator: UIActivityIndicatorView!
    @IBOutlet weak var appsIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webIndicator: UIActivityIndicatorView!
    @IBOutlet weak var serviceIndicator: UIActivityIndicatorView!
    @IBOutlet weak var questionIndicator: UIActivityIndicatorView!
    @IBOutlet weak var counterIndicator: UIActivityIndicatorView!
    @IBOutlet weak var receiptsIndicator: UIActivityIndicatorView!
    @IBOutlet weak var adIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var elipseBackground: UIView!
    @IBOutlet weak var elipseBackground2: UIView!
    @IBOutlet weak var fon_Samara: UIImageView!
    @IBOutlet weak var name_Samara: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var ls_View: UIView!
    @IBOutlet weak var news_View: UIView!
    @IBOutlet weak var counters_View: UIView!
    @IBOutlet weak var apps_View: UIView!
    @IBOutlet weak var questions_View: UIView!
    @IBOutlet weak var webs_View: UIView!
    @IBOutlet weak var services_View: UIView!
    @IBOutlet weak var receipts_View: UIView!
    
    @IBOutlet weak var ls_Title:         UILabel!
    @IBOutlet weak var news_Title:       UILabel!
    @IBOutlet weak var counters_Title:   UILabel!
    @IBOutlet weak var apps_Title:       UILabel!
    @IBOutlet weak var questions_Title:  UILabel!
    @IBOutlet weak var webs_Title:       UILabel!
    @IBOutlet weak var services_Title:   UILabel!
    @IBOutlet weak var receipts_Title:   UILabel!
    
    @IBOutlet weak var btn_Add_LS: UIButton!
    @IBOutlet weak var btn_add_Apps: UIButton!
    @IBOutlet weak var btn_Apps_Height: NSLayoutConstraint!
    
    @IBOutlet weak var tableLS: UITableView!
    @IBOutlet weak var tableLSHeight: NSLayoutConstraint!
    @IBOutlet weak var tableNews: UITableView!
    @IBOutlet weak var tableNewsHeight: NSLayoutConstraint!
    @IBOutlet weak var tableCounter: UITableView!
    @IBOutlet weak var tableCounterHeight: NSLayoutConstraint!
    @IBOutlet weak var tableApps: UITableView!
    @IBOutlet weak var tableAppsHeight: NSLayoutConstraint!
    @IBOutlet weak var tableQuestion: UITableView!
    @IBOutlet weak var tableQuestionHeight: NSLayoutConstraint!
    @IBOutlet weak var tableWeb: UITableView!
    @IBOutlet weak var tableWebHeight: NSLayoutConstraint!
    @IBOutlet weak var tableServiceHeight: NSLayoutConstraint!
    @IBOutlet weak var tableReceipts: UITableView!
    @IBOutlet weak var tableReceiptsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var fonLS: UIImageView!
    @IBOutlet weak var fonNews: UIImageView!
    @IBOutlet weak var fonCounter: UIImageView!
    @IBOutlet weak var fonApps: UIImageView!
    @IBOutlet weak var fonQuestion: UIImageView!
    @IBOutlet weak var fonWeb: UIImageView!
//    @IBOutlet weak var fonService: UIImageView!
    @IBOutlet weak var fonReceipts: UIImageView!
    
    @IBOutlet weak var newsHeight: NSLayoutConstraint!
    @IBOutlet weak var counterHeight: NSLayoutConstraint!
    @IBOutlet weak var appsHeight: NSLayoutConstraint!
    @IBOutlet weak var questionLSHeight: NSLayoutConstraint!
    @IBOutlet weak var webLSHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceHeight: NSLayoutConstraint!
    @IBOutlet weak var receipts1Height: NSLayoutConstraint!
    @IBOutlet weak var receipts2Height: NSLayoutConstraint!
    
    @IBOutlet weak var menu_1_const: NSLayoutConstraint!
    @IBOutlet weak var menu_2_const: NSLayoutConstraint!
    @IBOutlet weak var menu_3_const: NSLayoutConstraint!
    @IBOutlet weak var menu_4_const: NSLayoutConstraint!
    @IBOutlet weak var menu_5_const: NSLayoutConstraint!
    @IBOutlet weak var menu_6_const: NSLayoutConstraint!
    @IBOutlet weak var menu_7_const: NSLayoutConstraint!
    
    // Размеры для настройки меню
    // Звонок диспетчеру
    @IBOutlet weak var callBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var callBtnImg: UIImageView!
    @IBOutlet weak var callLbl1: UILabel!
    @IBOutlet weak var callLbl2: UILabel!
    // Письмо в техподдержку
    @IBOutlet weak var suppBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var suppBtn: UIButton!
    @IBOutlet weak var suppBtnImg: UIImageView!
    
    @IBOutlet weak var targetName: UILabel!
    
    @IBOutlet weak var allNewsBtn: UIButton!
    @IBOutlet weak var allLSBtn: UIButton!
    @IBOutlet weak var allCountersBtn: UIButton!
    @IBOutlet weak var allAppsBtn: UIButton!
    @IBOutlet weak var allQuestionsBtn: UIButton!
    @IBOutlet weak var allWebsBtn: UIButton!
    @IBOutlet weak var allServicesBtn: UIButton!
    @IBOutlet weak var allReceiptsBtn: UIButton!
    @IBOutlet weak var allSaldoBtn: UIButton!
    @IBOutlet weak var allPayHistoryBtn: UIButton!
    
    var phone: String?
    var fetchedResultsController: NSFetchedResultsController<Applications>?
    
    @IBAction func goNewsAction(_ sender: UIButton) {
        DispatchQueue.main.async{
            self.newsIndicator.startAnimating()
            self.newsIndicator.isHidden = false
            self.allNewsBtn.isHidden = true
        }
    }
    @IBAction func goAppsAction(_ sender: UIButton) {
        DispatchQueue.main.async{
            self.appsIndicator.startAnimating()
            self.appsIndicator.isHidden = false
            self.allAppsBtn.isHidden = true
        }
    }
    @IBAction func goCounterAction(_ sender: UIButton) {
        DispatchQueue.main.async{
            self.counterIndicator.startAnimating()
            self.counterIndicator.isHidden = false
            self.allCountersBtn.isHidden = true
        }
    }
    @IBAction func goQuestionAction(_ sender: UIButton) {
        DispatchQueue.main.async{
            self.questionIndicator.startAnimating()
            self.questionIndicator.isHidden = false
            self.allQuestionsBtn.isHidden = true
        }
    }
    @IBAction func goWebAction(_ sender: UIButton) {
        DispatchQueue.main.async{
            self.webIndicator.startAnimating()
            self.webIndicator.isHidden = false
            self.allWebsBtn.isHidden = true
        }
    }
    @IBAction func goServiceAction(_ sender: UIButton) {
        DispatchQueue.main.async{
            self.serviceIndicator.startAnimating()
            self.serviceIndicator.isHidden = false
            self.allServicesBtn.isHidden = true
        }
    }
    @IBAction func goReceiptsAction(_ sender: UIButton) {
        DispatchQueue.main.async{
            self.receiptsIndicator.startAnimating()
            self.receiptsIndicator.isHidden = false
            self.allReceiptsBtn.isHidden = true
        }
        self.performSegue(withIdentifier: "goSaldo", sender: self)
    }
    @IBAction func goSaldoAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goSaldo", sender: self)
    }
    @IBAction func goPayHistoryAction(_ sender: UIButton) {
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "goPayHistoryMytishi", sender: self)
        #else
        self.performSegue(withIdentifier: "goPayHistory", sender: self)
        #endif
    }
    
    @IBAction func addAppC(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "newApps"){
            self.performSegue(withIdentifier: "new_add_app", sender: self)
        }else{
            self.performSegue(withIdentifier: "add_app", sender: self)
        }
    }
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
    
    @IBAction func ShowAllCounter(_ sender: UIButton) {
        self.performSegue(withIdentifier: "allCounter", sender: self)
    }
    
    func try_del_ls_from_acc(ls: String) {
        
        let defaults = UserDefaults.standard
        let phone = defaults.string(forKey: "phone")
        let ident =  ls
        
//        if (phone == ident) {
//            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Невозможно отвязать лицевой счет " + ident + ". Вы зашли, используя этот лицевой счет.", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//        } else {
            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Отвязать лицевой счет " + ident + " от аккаунта?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
                
                var urlPath = Server.SERVER + Server.MOBILE_API_PATH + Server.DEL_IDENT_ACC
                urlPath = urlPath + "phone=" + phone! + "&ident=" + ident.stringByAddingPercentEncodingForRFC3986()!
                let url: NSURL = NSURL(string: urlPath)!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "GET"
//                print("DelLsURL: " , ident, request)
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
//                                                        print("responseStringDEL = \(responseString)")
                                                        if responseString.containsIgnoringCase(find: "error"){
                                                            DispatchQueue.main.async(execute: {
                                                                UserDefaults.standard.set(responseString, forKey: "errorStringSupport")
                                                                UserDefaults.standard.synchronize()
                                                                let alert = UIAlertController(title: "Ошибка", message: responseString, preferredStyle: .alert)
                                                                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                                                                    self.performSegue(withIdentifier: "support", sender: self)
                                                                }
                                                                alert.addAction(cancelAction)
                                                                alert.addAction(supportAction)
                                                                self.present(alert, animated: true, completion: nil)
                                                            })
                                                            return
                                                        }else{
                                                            DispatchQueue.main.async{
                                                                let defaults = UserDefaults.standard
                                                                
                                                                defaults.set(true, forKey: "go_to_app")
                                                                defaults.synchronize()
                                                                // Перейдем на главную страницу со входом в приложение
                                                                self.performSegue(withIdentifier: "go_to_app", sender: self)
                                                            }
                                                        }
                                                        
                })
                task.resume()
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
//        }
        
    }
    
    var currYear: String = ""
    var currMonth: String = ""
    
    @IBAction func phone_operator(_ sender: UIButton) {
        let newPhone = UserDefaults.standard.string(forKey: "phone_operator")!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        if let url = URL(string: "tel://" + newPhone) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("HomePage", forKey: "last_UI_action")
        Crashlytics.sharedInstance().setObjectValue(UserDefaults.standard.string(forKey: "login"), forKey: "login_text")
        StopIndicators()
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
        self.ls_View.isHidden = true
        self.news_View.isHidden = true
        self.counters_View.isHidden = true
        self.apps_View.isHidden = true
        self.questions_View.isHidden = true
        self.webs_View.isHidden = true
        self.services_View.isHidden = true
        self.receipts_View.isHidden = true
        self.backgroundView.isHidden = true
        UserDefaults.standard.set(false, forKey: "PaymentSucces")
        UserDefaults.standard.synchronize()
        let defaults = UserDefaults.standard
        var phone = defaults.string(forKey: "phone_operator")
        if phone?.first == "8" && phone!.count > 10{
            phone?.removeFirst()
            phone = "+7" + phone!
        }
        var phoneOperator = ""
        if phone!.count > 10{
//            phone = phone?.replacingOccurrences(of: " ", with: "")
//            phone = phone?.replacingOccurrences(of: "-", with: "")
            if !(phone?.contains(")"))! && phone != ""{
                for i in 0...11{
                    if i == 2{
                        phoneOperator = phoneOperator + " (" + String(phone!.first!)
                    }else if i == 5{
                        phoneOperator = phoneOperator + ") " + String(phone!.first!)
                    }else if i == 8{
                        phoneOperator = phoneOperator + "-" + String(phone!.first!)
                    }else if i == 10{
                        phoneOperator = phoneOperator + "-" + String(phone!.first!)
                    }else{
                        phoneOperator = phoneOperator + String(phone!.first!)
                    }
                    phone?.removeFirst()
                }
            }else if !(phone?.contains("-"))! && phone != ""{
                phone = phone?.replacingOccurrences(of: " ", with: "")
                phone = phone?.replacingOccurrences(of: "-", with: "")
                phone = phone?.replacingOccurrences(of: ")", with: "")
                phone = phone?.replacingOccurrences(of: "(", with: "")
                for i in 0...11{
                    if i == 2{
                        phoneOperator = phoneOperator + " (" + String(phone!.first!)
                    }else if i == 5{
                        phoneOperator = phoneOperator + ") " + String(phone!.first!)
                    }else if i == 8{
                        phoneOperator = phoneOperator + "-" + String(phone!.first!)
                    }else if i == 10{
                        phoneOperator = phoneOperator + "-" + String(phone!.first!)
                    }else{
                        phoneOperator = phoneOperator + String(phone!.first!)
                    }
                    phone?.removeFirst()
                }
            }else{
                phoneOperator = phone!
            }
        }else{
            phoneOperator = phone!
        }
        if phoneOperator.contains(")"){
            callLbl1.text = String(phoneOperator.prefix(through: phoneOperator.index(of: ")")!))
            callLbl2.text = phoneOperator.replacingOccurrences(of: phoneOperator.prefix(through: phoneOperator.index(of: ")")!), with: "")
        }else if !phoneOperator.contains("+7"){
            callBtn.isHidden = true
            callBtnImg.isHidden = true
            callLbl1.isHidden = true
            callLbl2.isHidden = true
        }else{
            callLbl1.text = ""
            callLbl2.text = phoneOperator
        }
        callBtn.setTitle(phoneOperator, for: .normal)
        if defaults.object(forKey: "year") != nil && defaults.object(forKey: "month") != nil{
            currYear         = defaults.string(forKey: "year")!
            currMonth        = defaults.string(forKey: "month")!
        }else{
            let date = NSDate()
            let calendar = NSCalendar.current
            let resultDate = calendar.component(.year, from: date as Date)
            let resultMonth = calendar.component(.month, from: date as Date)
            defaults.setValue(resultMonth, forKey: "month")
            defaults.setValue(resultDate, forKey: "year")
            currYear = String(resultDate)
            currMonth = String(resultMonth)
        }
        
        if defaults.object(forKey: "date1") != nil && defaults.object(forKey: "date2") != nil{
            date1            = defaults.string(forKey: "date1")!
            date2            = defaults.string(forKey: "date2")!
        }
        if defaults.object(forKey: "can_count") != nil{
            can_edit         = defaults.string(forKey: "can_count")!
        }
        
        tableLS.delegate = self
        tableLS.dataSource = self
        tableNews.delegate = self
        tableNews.dataSource = self
        tableCounter.delegate = self
        tableCounter.dataSource = self
        tableApps.delegate = self
        tableApps.dataSource = self
        tableQuestion.delegate = self
        tableQuestion.dataSource = self
        tableWeb.delegate = self
        tableWeb.dataSource = self
        tableReceipts.delegate = self
        tableReceipts.dataSource = self
        
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
        #endif
        if view.frame.size.width == 320{
            ls_Title.font = ls_Title.font.withSize(12)
            news_Title.font = news_Title.font.withSize(13.0)
            counters_Title.font = counters_Title.font.withSize(13.0)
            apps_Title.font = apps_Title.font.withSize(13.0)
            questions_Title.font = questions_Title.font.withSize(13.0)
            webs_Title.font = webs_Title.font.withSize(13.0)
            services_Title.font = services_Title.font.withSize(13.0)
            receipts_Title.font = receipts_Title.font.withSize(13.0)
        }
        
        suppBtnImg.setImageColor(color: myColors.btnColor.uiColor())
        callBtnImg.setImageColor(color: myColors.btnColor.uiColor())
        callLbl1.textColor = myColors.btnColor.uiColor()
        callLbl2.textColor = myColors.btnColor.uiColor()
        suppBtn.tintColor = myColors.btnColor.uiColor()
        
        serviceIndicator.color = myColors.btnColor.uiColor()
        serviceIndicator.isHidden = true
        adIndicator.color = myColors.btnColor.uiColor()
        adIndicator.isHidden = true
        
        newsIndicator.color = myColors.btnColor.uiColor()
        appsIndicator.color = myColors.btnColor.uiColor()
        counterIndicator.color = myColors.btnColor.uiColor()
        questionIndicator.color = myColors.btnColor.uiColor()
        webIndicator.color = myColors.btnColor.uiColor()
        receiptsIndicator.color = myColors.btnColor.uiColor()
        fonLS.tintColor = myColors.btnColor.uiColor()
        fonNews.tintColor = myColors.btnColor.uiColor()
        fonCounter.tintColor = myColors.btnColor.uiColor()
        fonApps.tintColor = myColors.btnColor.uiColor()
        fonQuestion.tintColor = myColors.btnColor.uiColor()
        fonWeb.tintColor = myColors.btnColor.uiColor()
//        fonService.tintColor = myColors.btnColor.uiColor()
        fonReceipts.tintColor = myColors.btnColor.uiColor()
        
//        fonLS.isHidden = true
//        fonNews.isHidden = true
//        fonCounter.isHidden = true
//        fonApps.isHidden = true
//        fonQuestion.isHidden = true
//        fonWeb.isHidden = true
//        fonService.isHidden = true
//        fonReceipts.isHidden = true
        
        allAppsBtn.tintColor = myColors.btnColor.uiColor()
        allQuestionsBtn.tintColor = myColors.btnColor.uiColor()
        allNewsBtn.tintColor = myColors.btnColor.uiColor()
        allWebsBtn.tintColor = myColors.btnColor.uiColor()
        allCountersBtn.tintColor = myColors.btnColor.uiColor()
        allServicesBtn.tintColor = myColors.btnColor.uiColor()
        allReceiptsBtn.tintColor = myColors.btnColor.uiColor()
        allSaldoBtn.tintColor = myColors.btnColor.uiColor()
        allPayHistoryBtn.tintColor = myColors.btnColor.uiColor()
        btn_Add_LS.tintColor = myColors.btnColor.uiColor()
        btn_add_Apps.backgroundColor = myColors.btnColor.uiColor()
        elipseBackground.backgroundColor = myColors.btnColor.uiColor()
        let login = defaults.string(forKey: "login")
        let pass  = defaults.string(forKey: "pass")
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            scrollView.refreshControl = refreshControl
        } else {
            scrollView.addSubview(refreshControl!)
        }
        getDebt()
        getInsurance()
        //        getNews()
        getDataCounter()
//        updateListApps()
        getQuestions()
        getWebs()
        get_Services(login: login!, pass: pass!)
        getPaysFile()
        // Do any additional setup after loading the view.
    }
    
    var showAD = true
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(2)
            DispatchQueue.main.async {
                self.ls_View.isHidden = true
                self.news_View.isHidden = true
                self.counters_View.isHidden = true
                self.apps_View.isHidden = true
                self.questions_View.isHidden = true
                self.webs_View.isHidden = true
                self.services_View.isHidden = true
                self.receipts_View.isHidden = true
                self.backgroundView.isHidden = true
                let defaults = UserDefaults.standard
                if defaults.bool(forKey: "show_Ad") && self.showAD{
                    if defaults.integer(forKey: "ad_Type") == 2{
                        self.loadAd()
                    }else if defaults.integer(forKey: "ad_Type") == 3{
                        self.gadBannerView.load(self.request)
                    }
                }
                self.lsArr.removeAll()
                self.newsArr.removeAll()
                self.counterArr.removeAll()
                self.appsArr.removeAll()
                self.questionArr.removeAll()
                self.webArr.removeAll()
                self.serviceArr.removeAll()
                self.rowComms.removeAll()
                let login = UserDefaults.standard.string(forKey: "login")
                let pass  = UserDefaults.standard.string(forKey: "pass")
                self.getDebt()
                self.getNews()
                self.getDataCounter()
                self.updateListApps()
                self.getQuestions()
                self.getWebs()
                self.get_Services(login: login!, pass: pass!)
                self.getPaysFile()
                if #available(iOS 10.0, *) {
                    self.scrollView.refreshControl?.endRefreshing()
                } else {
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView){
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(bannerView)
        DispatchQueue.main.async {
            self.bottomViewHeight.constant = bannerView.frame.size.height
        }
        if #available(iOS 11.0, *) {
            let bannerView = bannerView
            let layoutGuide = self.backgroundView.safeAreaLayoutGuide
            let constraints = [
                bannerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
                bannerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
                bannerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 2)
            ]
            NSLayoutConstraint.activate(constraints)
        } else {
            let views = ["bannerView" : bannerView]
            let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[bannerView]-(10)-|",
                                                            options: [],
                                                            metrics: nil,
                                                            views: views)
            let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[bannerView]-(10)-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: views)
            self.backgroundView.addConstraints(horizontal)
            self.backgroundView.addConstraints(vertical)
        }
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        bottomViewHeight.constant = 0
        adTopConst.constant = 0
    }
    
    func loadAd() {
        self.adLoader.loadAd(with: nil)
    }
    
    func didLoadAd(_ ad: YMANativeGenericAd) {
        ad.delegate = self
        self.yaBannerView?.removeFromSuperview()
        let bannerView = YMANativeBannerView(frame: CGRect.zero)
        bannerView.ad = ad
        backgroundView.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.yaBannerView = bannerView
        DispatchQueue.main.async {
            self.bottomViewHeight.constant = bannerView.frame.size.height
        }
        
        if #available(iOS 11.0, *) {
            displayAdAtBottomOfSafeArea();
        } else {
            displayAdAtBottom();
        }
    }
    
    func displayAdAtBottom() {
        let views = ["bannerView" : self.yaBannerView!]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[bannerView]-(10)-|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[bannerView]-(10)-|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views)
        self.backgroundView.addConstraints(horizontal)
        self.backgroundView.addConstraints(vertical)
    }
    
    @available(iOS 11.0, *)
    func displayAdAtBottomOfSafeArea() {
        let bannerView = self.yaBannerView!
        let layoutGuide = self.backgroundView.safeAreaLayoutGuide
        let constraints = [
            bannerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            bannerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            bannerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 2)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - YMANativeAdDelegate
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeAppInstallAd) {
        print("Loaded App Install ad")
        didLoadAd(ad)
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeContentAd) {
        print("Loaded Content ad")
        didLoadAd(ad)
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didFailLoadingWithError error: Error) {
        print("Native ad loading error: \(error)")
    }
    
    func StopIndicators() {
        DispatchQueue.main.async{
            if self.newsIndicator != nil{
                self.newsIndicator.stopAnimating()
                self.newsIndicator.isHidden = true
                self.allNewsBtn.isHidden = false
            }
            if self.appsIndicator != nil{
                self.appsIndicator.stopAnimating()
                self.appsIndicator.isHidden = true
                self.allAppsBtn.isHidden = false
            }
            if self.questionIndicator != nil{
                self.questionIndicator.stopAnimating()
                self.questionIndicator.isHidden = true
                self.allQuestionsBtn.isHidden = false
            }
            if self.counterIndicator != nil{
                self.counterIndicator.stopAnimating()
                self.counterIndicator.isHidden = true
                self.allCountersBtn.isHidden = false
            }
            if self.webIndicator != nil{
                self.webIndicator.stopAnimating()
                self.webIndicator.isHidden = true
                self.allWebsBtn.isHidden = false
            }
            if self.serviceIndicator != nil{
                self.serviceIndicator.stopAnimating()
                self.serviceIndicator.isHidden = true
                self.allServicesBtn.isHidden = false
            }
            if self.receiptsIndicator != nil{
                self.receiptsIndicator.stopAnimating()
                self.receiptsIndicator.isHidden = true
                self.allReceiptsBtn.isHidden = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Crashlytics.sharedInstance().setObjectValue("HomePage", forKey: "last_UI_action")
        showAD = true
        if UserDefaults.standard.bool(forKey: "PaymentSucces") && oneCheck == 0{
            oneCheck = 1
            UserDefaults.standard.set(false, forKey: "PaymentSucces")
            if #available(iOS 10.3, *) {
                DispatchQueue.main.async{
                    SKStoreReviewController.requestReview()
                }
            } else {
                // Fallback on earlier versions
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
//        self.load_new_data()
        updateListApps()
        self.getNews()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func appMovedToBackground() {
        if showAD{
            showAD = false
        }else{
            showAD = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showAD = false
        self.StopIndicators()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
//        DispatchQueue.main.async{
        if UserDefaults.standard.synchronize(){
            UserDefaults.standard.set(true, forKey: "fromMenu")
        }
            //            UserDefaults.standard.synchronize()
//        }
//        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false;
    }
    
    var lsArr:[lsData] = []
    var newsArr: [News] = []
    var counterArr = ["123"]
    var appsArr = ["123"]
    var questionArr:[QuestionDataJson] = []
    var webArr:[Web_Camera_json] = []
    var serviceArr: [Services] = []
    var serviceAdBlock: [Services] = []
    var rowComms: [String : [Services]]  = [:]
    
    var dateOld = "01.01"
    func getDebt() {
        var debtIdent:[String] = []
        var debtSum:[String] = []
        var debtSumFine:[String] = []
        var debtDate:[String] = []
        var debtAddress:[String] = []
        var debtInsurance:[String] = []
        var debtHouse:[String] = []
        var debtINN:[String] = []
        let defaults = UserDefaults.standard
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        var sumObj = 0.00
        var u = 0
        let login = defaults.string(forKey: "login")
        //        let viewHeight = self.heigth_view.constant
        //        let backHeight = self.backgroundHeight.constant
        if (str_ls_arr?.count)! > 0{
            if str_ls_arr?[0] != ""{
                self.view_no_ls.isHidden = true
                //            str_ls_arr?.forEach{
                let urlPath = Server.SERVER + "MobileAPI/GetDebt.ashx?" + "phone=" + login!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
                let url: NSURL = NSURL(string: urlPath)!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "GET"
                print("DebtURL = ", request)
                
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
                                                                
                                                                if !responseStr.contains("error") && responseStr.containsIgnoringCase(find: "data"){
                                                                    var date1       = "0"
                                                                    var date2       = "0"
                                                                    var date        = "0"
                                                                    var sum         = "0"
                                                                    var sumFine     = "0"
                                                                    var insuranceSum = "0"
                                                                    var ls = "-"
                                                                    var address = "-"
                                                                    var houseId = "0"
                                                                    var inn = ""
                                                                    var dontShow = false
                                                                    //                                                                var sumOver     = ""
                                                                    //                                                                var sumFineOver = ""
                                                                    //                                                                    var sumAll      = ""
                                                                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
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
                                                                                    if obj.key == "InsuranceSum" {
                                                                                        if ((obj.value as? NSNull) == nil){
                                                                                            insuranceSum = String(describing: obj.value as! Double)
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
                                                                                    if obj.key == "HouseId" {
                                                                                        if ((obj.value as? NSNull) == nil){
                                                                                            houseId = String(describing: obj.value as! Int)
                                                                                        }else{
                                                                                            houseId = "0"
                                                                                        }
                                                                                    }
                                                                                    if obj.key == "DebtActualDate" {
                                                                                        if ((obj.value as? NSNull) == nil){
                                                                                            date = String(describing: obj.value as! String)
                                                                                        }
                                                                                    }
                                                                                    if obj.key == "MetersStartDay" {
                                                                                        if ((obj.value as? NSNull) == nil){
                                                                                            date1 = String(describing: obj.value as! Int)
                                                                                        }
                                                                                    }
                                                                                    if obj.key == "MetersEndDay" {
                                                                                        if ((obj.value as? NSNull) == nil){
                                                                                            date2 = String(describing: obj.value as! Int)
                                                                                        }
                                                                                    }
                                                                                    if obj.key == "INN" {
                                                                                        if ((obj.value as? NSNull) == nil){
                                                                                            inn = String(describing: obj.value as! String)
                                                                                        }
                                                                                    }
                                                                                    if obj.key == "DontShowInsurance" {
                                                                                        if ((obj.value as? NSNull) == nil){
                                                                                            dontShow = obj.value as! Bool
                                                                                        }
                                                                                    }
                                                                                }
                                                                                //                                                                                if date == ""{
                                                                                //                                                                                    let dateFormatter = DateFormatter()
                                                                                //                                                                                    dateFormatter.dateFormat = "dd.MM.yyyy"
                                                                                //                                                                                    date = dateFormatter.string(from: Date())
                                                                                //                                                                                }
                                                                                UserDefaults.standard.set(dontShow, forKey: "DontShowInsurance")
                                                                                debtIdent.append(ls)
                                                                                debtSum.append(sum)
                                                                                debtSumFine.append(sumFine)
                                                                                debtAddress.append(address)
                                                                                debtDate.append(date)
                                                                                debtInsurance.append(insuranceSum)
                                                                                debtHouse.append(houseId)
                                                                                debtINN.append(inn)
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
                                                                    self.date1 = date1
                                                                    self.date2 = date2
                                                                    defaults.setValue(date1, forKey: "date1")
                                                                    defaults.setValue(date2, forKey: "date2")
                                                                    defaults.synchronize()
                                                                    self.parse_Mobile(login: UserDefaults.standard.string(forKey: "login")!)
                                                                    DispatchQueue.main.async {
//                                                                        if (self.date1 == "0") && (self.date2 == "0") {
//                                                                            self.can_count_label.text = "Возможность передавать показания доступна в текущем месяце!"
//                                                                        } else {
//                                                                            self.can_count_label.text = "Возможность передавать показания доступна с " + self.date1 + " по " + self.date2 + " числа текущего месяца!"
//                                                                        }
                                                                        self.tableLS.reloadData()
                                                                        self.tableCounter.reloadData()
                                                                    }
                                                                }
                                                                
                                                            } catch let error as NSError {
                                                                print(error)
                                                            }
                                                            
                                                        }
                })
                task.resume()
            }
            //            }
        }else{
            self.view_no_ls.isHidden = false
            let str_menu_6 = UserDefaults.standard.string(forKey: "menu_6") ?? ""
            if (str_menu_6 != "") {
                var answer = str_menu_6.components(separatedBy: ";")
                if (answer[2] == "0") {
                }else{
                    DispatchQueue.main.async {
                        self.tableLSHeight.constant = 0
                        self.view_no_ls.isHidden = false
                    }
                }
            }
        }
    }
    
    var insuranceArr: [Insurance] = []
    func getInsurance(){
        var phone = ""
        if UserDefaults.standard.string(forKey: "login") != nil{
            phone = UserDefaults.standard.string(forKey: "login") ?? ""
        }else{
            return
        }
//        var request = URLRequest(url: URL(string: "http://uk-gkh.org/newjkh/MobileAPI/GetPaymentsRegistryInsuranceByMobAccount.ashx?phone=test")!)
        var request = URLRequest(url: URL(string: Server.SERVER + Server.MOBILE_API_PATH + Server.GET_INSURANCE + "phone=" + phone)!)
        request.httpMethod = "GET"
//        print("InsuranceURL", request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, error, responce in
                                                //                                                print("responseString = \(responseString)")
                                                
                                                //            if error != nil {
                                                //                print("ERROR")
                                                //                return
                                                //            }
                                                
                                                guard data != nil else { return }
//                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//                                                print("INSURANCE: ", responseString)
                                                var insuranceList: [Insurance] = []
                                                if let json = try? JSONSerialization.jsonObject(with: data!,
                                                                                                options: .allowFragments){
                                                    let unfilteredData = InsuranceJson(json: json as! JSON)?.data
                                                    
                                                    unfilteredData?.forEach { json in
                                                        let dataBeg: String = json.dataBeg ?? ""
                                                        let dataEnd: String = json.dataEnd ?? ""
                                                        let date: String = json.date ?? ""
                                                        let shopCode: String = json.shopCode ?? ""
                                                        let orgName: String = json.orgName ?? ""
                                                        let dateCredited: String = json.dateCredited ?? ""
                                                        let paymentId: String = json.paymentId ?? ""
                                                        let ident: String = json.ident ?? ""
                                                        let sumDecimal: String = json.sumDecimal ?? ""
                                                        let sumCreditedDecimal: String = json.sumCreditedDecimal ?? ""
                                                        let comissionDecimal: String = json.comissionDecimal ?? ""
                                                        let newsObj = Insurance(dataBeg:dataBeg,dataEnd:dataEnd,date:date,shopCode:shopCode,orgName:orgName,dateCredited:dateCredited,paymentId:paymentId,ident:ident,sumDecimal:sumDecimal,sumCreditedDecimal:sumCreditedDecimal,comissionDecimal:comissionDecimal)
                                                        insuranceList.append(newsObj)
                                                    }
                                                }
                                                if insuranceList.count != 0{
                                                    self.insuranceArr = insuranceList
                                                }
//                                                print("INSURANCE: ", self.insuranceArr)
                                                DispatchQueue.main.async {
                                                    self.tableLS.reloadData()
                                                }
        })
        task.resume()
    }
    
    private var values: [HistoryPayCellData] = []
    
    func parse_Mobile(login: String) {
        values.removeAll()
        let urlPath = Server.SERVER + "MobileAPI/GetPays.ashx?" + "phone=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                //                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                //                                                print("responseString = \(responseString)")
                                                
                                                if error != nil {
                                                    return
                                                } else {
                                                    do {
                                                        var bill_date    = ""
                                                        var bill_ident   = ""
                                                        var bill_sum = ""
                                                        var bill_status = ""
                                                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                        if let json_bills = json["data"] {
                                                            let int_end = (json_bills.count)!-1
                                                            if (int_end < 0) {
                                                                
                                                            } else {
                                                                
                                                                for index in 0...int_end {
                                                                    let json_bill = json_bills.object(at: index) as! [String:AnyObject]
                                                                    for obj in json_bill {
                                                                        if obj.key == "Date" {
                                                                            bill_date = obj.value as! String
                                                                        }
                                                                        if obj.key == "Ident" {
                                                                            bill_ident = obj.value as! String
                                                                        }
                                                                        if obj.key == "Sum" {
                                                                            bill_sum = String(describing: obj.value as! NSNumber)
                                                                        }
                                                                        if obj.key == "Status" {
                                                                            bill_status = obj.value as! String
                                                                        }
                                                                    }
                                                                    if bill_status == "Оплачен"{
                                                                        self.values.append(HistoryPayCellData(date: bill_date, id: "", ident: bill_ident, period: "", sum: bill_sum, width: 0, payType: 0))
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        DispatchQueue.main.async {
                                                            self.tableLS.reloadData()
                                                        }
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                }
        })
        task.resume()
    }
    
    func getNews(){
        self.newsArr.removeAll()
        var news_read = 0
        let phone = UserDefaults.standard.string(forKey: "login") ?? ""
        //        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "accID=" + id)!)
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_NEWS + "phone=" + phone)!)
        request.httpMethod = "GET"
        //        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, error, responce in
                                                //                                                print("responseString = \(responseString)")
                                                
                                                //            if error != nil {
                                                //                print("ERROR")
                                                //                return
                                                //            }
                                                
                                                guard data != nil else { return }
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                var newsList: [News] = []
                                                if !responseString.contains("error") && responseString.contains("data"){
                                                    if let json = try? JSONSerialization.jsonObject(with: data!,
                                                                                                    options: .allowFragments){
                                                        let unfilteredData = NewsJson(json: json as! JSON)?.data
                                                        
                                                        unfilteredData?.forEach { json in
                                                            if !json.readed! {
                                                                news_read += 1
                                                            }
                                                            let idNews = json.idNews
                                                            let Created = json.created
                                                            let Header = json.header
                                                            let Text = json.text
                                                            let IsReaded = json.readed
                                                            let newsObj = News(IdNews: String(idNews!), Created: Created!, Text: Text!, Header: Header!, Readed: IsReaded!)
                                                            newsList.append(newsObj)
                                                        }
                                                    }
                                                }
                                                var i = 0
                                                newsList.forEach{
                                                    if i < 2{
                                                        self.newsArr.append($0)
                                                    }
                                                    i += 1
                                                }
                                                if news_read > 0{
                                                     UserDefaults.standard.set(news_read, forKey: "newsKol")
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
                                                DispatchQueue.main.async {
                                                    self.tableNews.reloadData()
                                                }
        })
        task.resume()
    }
    
    var identArr         :[String] = []
    var tariffArr        :[String] = []
    var nameArr          :[String] = []
    var numberArr        :[String] = []
    var predArr          :[Float]  = []
    var teckArr          :[Float]  = []
    var diffArr          :[Float]  = []
    var predArr2         :[Float]  = []
    var teckArr2         :[Float]  = []
    var diffArr2         :[Float]  = []
    var predArr3         :[Float]  = []
    var teckArr3         :[Float]  = []
    var diffArr3         :[Float]  = []
    var unitArr          :[String] = []
    var dateOneArr       :[String] = []
    var dateTwoArr       :[String] = []
    var dateThreeArr     :[String] = []
    var ownerArr         :[String] = []
    var errorOneArr      :[Bool]   = []
    var errorTwoArr      :[Bool]   = []
    var errorThreeArr    :[Bool]   = []
    var errorTextOneArr  :[String] = []
    var errorTextTwoArr  :[String] = []
    var errorTextThreeArr:[String] = []
    var sendedArr        :[Bool]   = []
    
    var autoValueArr     :[Bool]   = []
    var recheckInterArr  :[String] = []
    var lastCheckArr     :[String] = []
    var numberDecimal    :[String] = []
    
    func getDataCounter(){
        let ident = "Все"
        identArr.removeAll()
        numberDecimal.removeAll()
        tariffArr.removeAll()
        nameArr.removeAll()
        numberArr.removeAll()
        predArr.removeAll()
        teckArr.removeAll()
        diffArr.removeAll()
        predArr2.removeAll()
        teckArr2.removeAll()
        diffArr2.removeAll()
        predArr3.removeAll()
        teckArr3.removeAll()
        diffArr3.removeAll()
        unitArr.removeAll()
        sendedArr.removeAll()
        dateOneArr.removeAll()
        dateTwoArr.removeAll()
        dateThreeArr.removeAll()
        ownerArr.removeAll()
        errorOneArr.removeAll()
        errorTwoArr.removeAll()
        errorThreeArr.removeAll()
        errorTextOneArr.removeAll()
        errorTextTwoArr.removeAll()
        errorTextThreeArr.removeAll()
        autoValueArr.removeAll()
        recheckInterArr.removeAll()
        lastCheckArr.removeAll()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Counters")
        fetchRequest.predicate = NSPredicate.init(format: "year <= %@", String(self.currYear))
        #if isRKC_Samara
        let sort = NSSortDescriptor(key: "count_name", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        #endif
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            var uniq_num = ""
            var tariffNumber = ""
            var dateOne = ""
            var numberOfDec = ""
            var valueOne:Float = 0.00
            var valueOne2:Float = 0.00
            var valueOne3:Float = 0.00
            var dateTwo = ""
            var valueTwo:Float = 0.00
            var valueTwo2:Float = 0.00
            var valueTwo3:Float = 0.00
            var dateThree = ""
            var valueThree:Float = 0.00
            var valueThree2:Float = 0.00
            var valueThree3:Float = 0.00
            var sendOne = false
            var sendTwo = false
            var sendThree = false
            var errorOne = ""
            var errorTwo = ""
            var errorThree = ""
            var count_name = ""
            var owner = ""
            var unit_name = ""
            var sended = true
            var identk = ""
            var autoSend = false
            var recheckInter = ""
            var lastCheck = ""
            var i = 0
            for result in results {
                let object = result as! NSManagedObject
                if ident != "Все"{
                    if (object.value(forKey: "ident") as! String) == ident{
                        if i == 0{
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            numberOfDec = (object.value(forKey: "numberOfDecimal") as! String)
                            tariffNumber = (object.value(forKey: "tariffNumber") as! String)
                            dateOne = (object.value(forKey: "num_month") as! String)
                            valueOne = (object.value(forKey: "value") as! Float)
                            valueOne2 = (object.value(forKey: "valueT2") as! Float)
                            valueOne3 = (object.value(forKey: "valueT3") as! Float)
                            identk = (object.value(forKey: "ident") as! String)
                            count_name = (object.value(forKey: "count_name") as! String)
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            owner = (object.value(forKey: "owner") as! String)
                            unit_name = (object.value(forKey: "unit_name") as! String)
                            sended = (object.value(forKey: "sended") as! Bool)
                            sendOne = (object.value(forKey: "sendError") as! Bool)
                            errorOne = (object.value(forKey: "sendErrorText") as! String)
                            autoSend = (object.value(forKey: "autoValueGettingOnly") as! Bool)
                            recheckInter = (object.value(forKey: "recheckInterval") as! String)
                            lastCheck = (object.value(forKey: "lastCheckupDate") as! String)
                            i = 1
                        }else if i == 1 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                            dateTwo = (object.value(forKey: "num_month") as! String)
                            numberOfDec = (object.value(forKey: "numberOfDecimal") as! String)
                            valueTwo = (object.value(forKey: "value") as! Float)
                            valueTwo2 = (object.value(forKey: "valueT2") as! Float)
                            valueTwo3 = (object.value(forKey: "valueT3") as! Float)
                            identk = (object.value(forKey: "ident") as! String)
                            count_name = (object.value(forKey: "count_name") as! String)
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            tariffNumber = (object.value(forKey: "tariffNumber") as! String)
                            owner = (object.value(forKey: "owner") as! String)
                            unit_name = (object.value(forKey: "unit_name") as! String)
                            sended = (object.value(forKey: "sended") as! Bool)
                            sendTwo = (object.value(forKey: "sendError") as! Bool)
                            errorTwo = (object.value(forKey: "sendErrorText") as! String)
                            i = 2
                        }else if i == 2 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                            dateThree = (object.value(forKey: "num_month") as! String)
                            valueThree = (object.value(forKey: "value") as! Float)
                            valueThree2 = (object.value(forKey: "valueT2") as! Float)
                            valueThree3 = (object.value(forKey: "valueT3") as! Float)
                            sendThree = (object.value(forKey: "sendError") as! Bool)
                            errorThree = (object.value(forKey: "sendErrorText") as! String)
                            identArr.append(object.value(forKey: "ident") as! String)
                            nameArr.append(object.value(forKey: "count_name") as! String)
                            numberArr.append(object.value(forKey: "uniq_num") as! String)
                            tariffArr.append(object.value(forKey: "tariffNumber") as! String)
                            numberDecimal.append(object.value(forKey: "numberOfDecimal") as! String)
                            ownerArr.append(object.value(forKey: "owner") as! String)
                            autoValueArr.append(object.value(forKey: "autoValueGettingOnly") as! Bool)
                            recheckInterArr.append(object.value(forKey: "recheckInterval") as! String)
                            lastCheckArr.append(object.value(forKey: "lastCheckupDate") as! String)
                            predArr.append(valueOne)
                            teckArr.append(valueTwo)
                            diffArr.append(valueThree)
                            predArr2.append(valueOne2)
                            teckArr2.append(valueTwo2)
                            diffArr2.append(valueThree2)
                            predArr3.append(valueOne3)
                            teckArr3.append(valueTwo3)
                            diffArr3.append(valueThree3)
                            dateOneArr.append(dateOne)
                            dateTwoArr.append(dateTwo)
                            dateThreeArr.append(dateThree)
                            unitArr.append(object.value(forKey: "unit_name") as! String)
                            sendedArr.append(object.value(forKey: "sended") as! Bool)
                            errorOneArr.append(sendOne)
                            errorTwoArr.append(sendTwo)
                            errorThreeArr.append(sendThree)
                            errorTextOneArr.append(errorOne)
                            errorTextTwoArr.append(errorTwo)
                            errorTextThreeArr.append(errorThree)
                            numberOfDec = ""
                            uniq_num = ""
                            tariffNumber = ""
                            dateOne = ""
                            valueOne = 0.00
                            valueOne2 = 0.00
                            valueOne3 = 0.00
                            dateTwo = ""
                            valueTwo = 0.00
                            valueTwo2 = 0.00
                            valueTwo3 = 0.00
                            dateThree = ""
                            valueThree = 0.00
                            valueThree2 = 0.00
                            valueThree3 = 0.00
                            count_name = ""
                            owner = ""
                            unit_name = ""
                            sended = true
                            sendOne = false
                            sendTwo = false
                            sendThree = false
                            autoSend = false
                            recheckInter = ""
                            lastCheck = ""
                            errorOne = ""
                            errorTwo = ""
                            errorThree = ""
                            identk = ""
                            i = 0
                        }else if uniq_num != (object.value(forKey: "uniq_num") as! String){
                            i = 1
                            identArr.append(identk)
                            nameArr.append(count_name)
                            numberArr.append(uniq_num)
                            numberDecimal.append(numberOfDec)
                            tariffArr.append(tariffNumber)
                            ownerArr.append(owner)
                            predArr.append(valueOne)
                            teckArr.append(valueTwo)
                            diffArr.append(valueThree)
                            predArr2.append(valueOne2)
                            teckArr2.append(valueTwo2)
                            diffArr2.append(valueThree2)
                            predArr3.append(valueOne3)
                            teckArr3.append(valueTwo3)
                            diffArr3.append(valueThree3)
                            dateOneArr.append(dateOne)
                            dateTwoArr.append(dateTwo)
                            dateThreeArr.append(dateThree)
                            unitArr.append(unit_name)
                            sendedArr.append(sended)
                            errorOneArr.append(sendOne)
                            errorTwoArr.append(sendTwo)
                            errorThreeArr.append(sendThree)
                            errorTextOneArr.append(errorOne)
                            errorTextTwoArr.append(errorTwo)
                            errorTextThreeArr.append(errorThree)
                            autoValueArr.append(autoSend)
                            recheckInterArr.append(recheckInter)
                            lastCheckArr.append(lastCheck)
                            tariffNumber = (object.value(forKey: "tariffNumber") as! String)
                            numberOfDec = (object.value(forKey: "numberOfDecimal") as! String)
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            dateOne = (object.value(forKey: "num_month") as! String)
                            valueOne = (object.value(forKey: "value") as! Float)
                            valueOne2 = (object.value(forKey: "valueT2") as! Float)
                            valueOne3 = (object.value(forKey: "valueT3") as! Float)
                            identk = (object.value(forKey: "ident") as! String)
                            count_name = (object.value(forKey: "count_name") as! String)
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            owner = (object.value(forKey: "owner") as! String)
                            unit_name = (object.value(forKey: "unit_name") as! String)
                            sended = (object.value(forKey: "sended") as! Bool)
                            sendOne = (object.value(forKey: "sendError") as! Bool)
                            errorOne = (object.value(forKey: "sendErrorText") as! String)
                            autoSend = (object.value(forKey: "autoValueGettingOnly") as! Bool)
                            recheckInter = (object.value(forKey: "recheckInterval") as! String)
                            lastCheck = (object.value(forKey: "lastCheckupDate") as! String)
                            
                            dateTwo = ""
                            valueTwo = 0.00
                            valueTwo2 = 0.00
                            valueTwo3 = 0.00
                            sendTwo = false
                            errorTwo = ""
                            dateThree = ""
                            valueThree = 0.00
                            valueThree2 = 0.00
                            valueThree3 = 0.00
                            sendThree = false
                            errorThree = ""
                        }
                    }
                }else{
                    if i == 0{
                        tariffNumber = (object.value(forKey: "tariffNumber") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        numberOfDec = (object.value(forKey: "numberOfDecimal") as! String)
                        dateOne = (object.value(forKey: "num_month") as! String)
                        valueOne = (object.value(forKey: "value") as! Float)
                        valueOne2 = (object.value(forKey: "valueT2") as! Float)
                        valueOne3 = (object.value(forKey: "valueT3") as! Float)
                        identk = (object.value(forKey: "ident") as! String)
                        count_name = (object.value(forKey: "count_name") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        owner = (object.value(forKey: "owner") as! String)
                        unit_name = (object.value(forKey: "unit_name") as! String)
                        sended = (object.value(forKey: "sended") as! Bool)
                        sendOne = (object.value(forKey: "sendError") as! Bool)
                        errorOne = (object.value(forKey: "sendErrorText") as! String)
                        autoSend = (object.value(forKey: "autoValueGettingOnly") as! Bool)
                        recheckInter = (object.value(forKey: "recheckInterval") as! String)
                        lastCheck = (object.value(forKey: "lastCheckupDate") as! String)
                        i = 1
                    }else if i == 1 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                        dateTwo = (object.value(forKey: "num_month") as! String)
                        valueTwo = (object.value(forKey: "value") as! Float)
                        valueTwo2 = (object.value(forKey: "valueT2") as! Float)
                        valueTwo3 = (object.value(forKey: "valueT3") as! Float)
                        identk = (object.value(forKey: "ident") as! String)
                        count_name = (object.value(forKey: "count_name") as! String)
                        tariffNumber = (object.value(forKey: "tariffNumber") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        numberOfDec = (object.value(forKey: "numberOfDecimal") as! String)
                        owner = (object.value(forKey: "owner") as! String)
                        unit_name = (object.value(forKey: "unit_name") as! String)
                        sended = (object.value(forKey: "sended") as! Bool)
                        sendTwo = (object.value(forKey: "sendError") as! Bool)
                        errorTwo = (object.value(forKey: "sendErrorText") as! String)
                        i = 2
                    }else if i == 2 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                        dateThree = (object.value(forKey: "num_month") as! String)
                        valueThree = (object.value(forKey: "value") as! Float)
                        valueThree2 = (object.value(forKey: "valueT2") as! Float)
                        valueThree3 = (object.value(forKey: "valueT3") as! Float)
                        sendThree = (object.value(forKey: "sendError") as! Bool)
                        errorThree = (object.value(forKey: "sendErrorText") as! String)
                        identArr.append(object.value(forKey: "ident") as! String)
                        numberDecimal.append(object.value(forKey: "numberOfDecimal") as! String)
                        nameArr.append(object.value(forKey: "count_name") as! String)
                        numberArr.append(object.value(forKey: "uniq_num") as! String)
                        tariffArr.append(object.value(forKey: "tariffNumber") as! String)
                        ownerArr.append(object.value(forKey: "owner") as! String)
                        autoValueArr.append(object.value(forKey: "autoValueGettingOnly") as! Bool)
                        recheckInterArr.append(object.value(forKey: "recheckInterval") as! String)
                        lastCheckArr.append(object.value(forKey: "lastCheckupDate") as! String)
                        predArr.append(valueOne)
                        teckArr.append(valueTwo)
                        diffArr.append(valueThree)
                        predArr2.append(valueOne2)
                        teckArr2.append(valueTwo2)
                        diffArr2.append(valueThree2)
                        predArr3.append(valueOne3)
                        teckArr3.append(valueTwo3)
                        diffArr3.append(valueThree3)
                        dateOneArr.append(dateOne)
                        dateTwoArr.append(dateTwo)
                        dateThreeArr.append(dateThree)
                        unitArr.append(object.value(forKey: "unit_name") as! String)
                        sendedArr.append(object.value(forKey: "sended") as! Bool)
                        errorOneArr.append(sendOne)
                        errorTwoArr.append(sendTwo)
                        errorThreeArr.append(sendThree)
                        errorTextOneArr.append(errorOne)
                        errorTextTwoArr.append(errorTwo)
                        errorTextThreeArr.append(errorThree)
                        uniq_num = ""
                        tariffNumber = ""
                        numberOfDec = ""
                        dateOne = ""
                        valueOne = 0.00
                        valueOne2 = 0.00
                        valueOne3 = 0.00
                        dateTwo = ""
                        valueTwo = 0.00
                        valueTwo2 = 0.00
                        valueTwo3 = 0.00
                        dateThree = ""
                        valueThree = 0.00
                        valueThree2 = 0.00
                        valueThree3 = 0.00
                        count_name = ""
                        owner = ""
                        unit_name = ""
                        sended = true
                        identk = ""
                        sendOne = false
                        sendThree = false
                        sendTwo = false
                        errorOne = ""
                        errorTwo = ""
                        errorThree = ""
                        autoSend = false
                        recheckInter = ""
                        lastCheck = ""
                        i = 0
                    }else if uniq_num != (object.value(forKey: "uniq_num") as! String){
                        i = 1
                        identArr.append(identk)
                        nameArr.append(count_name)
                        numberArr.append(uniq_num)
                        tariffArr.append(tariffNumber)
                        ownerArr.append(owner)
                        predArr.append(valueOne)
                        teckArr.append(valueTwo)
                        diffArr.append(valueThree)
                        predArr2.append(valueOne2)
                        teckArr2.append(valueTwo2)
                        diffArr2.append(valueThree2)
                        predArr3.append(valueOne3)
                        teckArr3.append(valueTwo3)
                        diffArr3.append(valueThree3)
                        dateOneArr.append(dateOne)
                        dateTwoArr.append(dateTwo)
                        dateThreeArr.append(dateThree)
                        unitArr.append(unit_name)
                        sendedArr.append(sended)
                        errorOneArr.append(sendOne)
                        errorTwoArr.append(sendTwo)
                        errorThreeArr.append(sendThree)
                        errorTextOneArr.append(errorOne)
                        errorTextTwoArr.append(errorTwo)
                        errorTextThreeArr.append(errorThree)
                        autoValueArr.append(autoSend)
                        recheckInterArr.append(recheckInter)
                        lastCheckArr.append(lastCheck)
                        numberDecimal.append(numberOfDec)
                        numberOfDec = (object.value(forKey: "numberOfDecimal") as! String)
                        tariffNumber = (object.value(forKey: "tariffNumber") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        dateOne = (object.value(forKey: "num_month") as! String)
                        valueOne = (object.value(forKey: "value") as! Float)
                        valueOne2 = (object.value(forKey: "valueT2") as! Float)
                        valueOne3 = (object.value(forKey: "valueT3") as! Float)
                        identk = (object.value(forKey: "ident") as! String)
                        count_name = (object.value(forKey: "count_name") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        owner = (object.value(forKey: "owner") as! String)
                        unit_name = (object.value(forKey: "unit_name") as! String)
                        sended = (object.value(forKey: "sended") as! Bool)
                        sendOne = (object.value(forKey: "sendError") as! Bool)
                        errorOne = (object.value(forKey: "sendErrorText") as! String)
                        autoSend = (object.value(forKey: "autoValueGettingOnly") as! Bool)
                        recheckInter = (object.value(forKey: "recheckInterval") as! String)
                        lastCheck = (object.value(forKey: "lastCheckupDate") as! String)
                        
                        dateTwo = ""
                        valueTwo = 0.00
                        valueTwo2 = 0.00
                        valueTwo3 = 0.00
                        sendTwo = false
                        errorTwo = ""
                        dateThree = ""
                        valueThree = 0.00
                        valueThree2 = 0.00
                        valueThree3 = 0.00
                        sendThree = false
                        errorThree = ""
                    }
                }
                
            }
            if i == 2 || i == 1{
                identArr.append(identk)
                nameArr.append(count_name)
                tariffArr.append(tariffNumber)
                numberDecimal.append(numberOfDec)
                numberArr.append(uniq_num)
                ownerArr.append(owner)
                predArr.append(valueOne)
                teckArr.append(valueTwo)
                diffArr.append(valueThree)
                predArr2.append(valueOne2)
                teckArr2.append(valueTwo2)
                diffArr2.append(valueThree2)
                predArr3.append(valueOne3)
                teckArr3.append(valueTwo3)
                diffArr3.append(valueThree3)
                dateOneArr.append(dateOne)
                dateTwoArr.append(dateTwo)
                dateThreeArr.append(dateThree)
                unitArr.append(unit_name)
                sendedArr.append(sended)
                errorOneArr.append(sendOne)
                errorTwoArr.append(sendTwo)
                errorThreeArr.append(sendThree)
                errorTextOneArr.append(errorOne)
                errorTextTwoArr.append(errorTwo)
                errorTextThreeArr.append(errorThree)
                autoValueArr.append(autoSend)
                recheckInterArr.append(recheckInter)
                lastCheckArr.append(lastCheck)
            }
            DispatchQueue.main.async(execute: {
                self.counterIndicator.stopAnimating()
                self.counterIndicator.isHidden = true
                self.allCountersBtn.isHidden = false
                self.tableCounter.reloadData()
            })
            
        } catch {
            print(error)
        }
    }
    
    func load_new_data() {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.global(qos: .background).async {
                sleep(2)
                DispatchQueue.main.async {
                    self.counterIndicator.startAnimating()
                    self.counterIndicator.isHidden = false
                    self.allCountersBtn.isHidden = true
                }
                DispatchQueue.main.sync {
                    // Экземпляр класса DB
                    let db = DB()
                    let defaults = UserDefaults.standard
                    let login = defaults.object(forKey: "login")
                    let pass = defaults.object(forKey: "pass")
                    let isCons = defaults.string(forKey: "isCons")
                    // ЗАЯВКИ С КОММЕНТАРИЯМИ
                    db.del_db(table_name: "Comments")
                    db.del_db(table_name: "Counters")
                    db.del_db(table_name: "Fotos")
                    db.del_db(table_name: "Applications")
                    db.parse_Countrers(login: login as! String, pass: pass as! String)
                    db.parse_Apps(login: login as! String, pass: pass as! String, isCons: isCons!, isLoad: false)
                    self.getDataCounter()
                    self.updateListApps()
                    
                }
            }
        }
    }
    
    func updateListApps() {
        load_data_Apps()
        DispatchQueue.main.async {
            self.tableApps.reloadData()
        }
    }
    
    func load_data_Apps() {
        //        if (switchCloseApps.isOn) {
        //            self.fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Applications", keysForSort: ["number"]) as? NSFetchedResultsController<Applications>
        //        } else {
        let close: NSNumber = 1
        let predicateFormat = String(format: "is_close = %@", close)
        self.fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Applications", keysForSort: ["id"], predicateFormat: predicateFormat, ascending: false) as? NSFetchedResultsController<Applications>
        //        }
        
        do {
            try fetchedResultsController!.performFetch()
        } catch {
            print(error)
        }
        DispatchQueue.main.async {
            self.tableApps.reloadData()
        }
    }
    var link: String = ""
    var fileList: [File] = []
    
    func getPaysFile() {
        let login = UserDefaults.standard.string(forKey: "login") ?? ""
        let pass = UserDefaults.standard.string(forKey: "pass") ?? ""
        let urlPath = Server.SERVER + Server.GET_BILLS_FILE + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        //        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, error, responce in
                                                //                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                //                                                print("responseString = \(responseString)")
                                                
                                                guard data != nil else {
                                                    self.endRefresh()
                                                    return }
                                                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                                                    let unfilteredData = PaysFileJson(json: json as! JSON)?.data
                                                    unfilteredData?.forEach { json in
                                                        let ident = json.ident
                                                        let year = json.year
                                                        let month = json.month
                                                        let link = json.link
                                                        let sum = json.sum
                                                        //                                                        var i = 0
                                                        let fileObj = File(month: month!, year: year!, ident: ident!, link: link!, sum: sum!)
                                                        //                                                        if (link?.contains(".png"))! || (link?.contains(".jpg"))! || (link?.contains(".pdf"))!{
                                                        //                                                            print(fileObj.sum, fileObj.month)
                                                        self.fileList.append(fileObj)
                                                        //                                                        }
                                                    }
                                                }
                                                self.endRefresh()
                                                
        })
        task.resume()
    }
    
    private func endRefresh(){
        DispatchQueue.main.async {
            self.fileList.reverse()
            
            var period = ""
            if self.fileList.count != 0{
                let m: Int = self.fileList.first!.month
                let y: Int = self.fileList.first!.year
                period = self.get_name_month(number_month: String(m)) + " \(String(y))"
            }
            UserDefaults.standard.set(period, forKey: "periodPays")
            self.tableReceipts.reloadData()
            self.ls_View.isHidden = false
            self.news_View.isHidden = false
            self.counters_View.isHidden = false
            self.apps_View.isHidden = false
            self.questions_View.isHidden = false
            self.webs_View.isHidden = false
            self.services_View.isHidden = false
            self.receipts_View.isHidden = false
            self.backgroundView.isHidden = false
        }
    }
    
    func getQuestions() {
        
        //        let id = UserDefaults.standard.string(forKey: "id_account") ?? ""
        var phone = ""
        if UserDefaults.standard.string(forKey: "login") != nil{
            phone = UserDefaults.standard.string(forKey: "login") ?? ""
        }else{
            return
        }
        //        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "accID=" + id)!)
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "phone=" + phone)!)
        request.httpMethod = "GET"
        //        print(request)
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
            //            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            //            print("responseString = \(responseString)")
            
            guard data != nil else { return }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            if responseString.containsIgnoringCase(find: "error"){
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data!,
                                                            options: .allowFragments){
                let unfilteredData = QuestionsJson(json: json as! JSON)?.data
                var filtered: [QuestionDataJson] = []
                var i = 0
                unfilteredData?.forEach { json in
                    
                    var isContains = true
                    json.questions?.forEach {
                        if !($0.isCompleteByUser)! {
                            isContains = false
                        }
                    }
                    if !isContains {
                        if i < 2{
                            filtered.append(json)
                        }
                    }
                    i += 1
                }
                self.questionArr = filtered
                DispatchQueue.main.async {
                    self.tableQuestion.reloadData()
                }
            }
            }.resume()
    }
    
    func getWebs() {
        
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_WEB_CAMERAS)!)
        request.httpMethod = "GET"
//        print("RequestWEB: ", request)
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
            defer {
                DispatchQueue.main.sync {
                    if self.webArr.count == 0 {
                        self.tableWeb.isHidden = true
                    } else {
                        self.tableWeb.isHidden = false
                    }
                }
            }
            guard data != nil else { return }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//            print("responseWEB = \(responseString)")
            
            if responseString.containsIgnoringCase(find: "error"){
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data!,
                                                            options: .allowFragments){
                let Data = Web_Cameras_json(json: json as! JSON)?.data
                self.webArr = Data!
                DispatchQueue.main.async {
                    self.tableWeb.reloadData()
                }
            }
            }.resume()
        
    }
    
    var mainScreenXml:  XML.Accessor?
    func get_Services(login: String, pass: String){
        serviceArr.removeAll()
//        let urlPath = "http://uk-gkh.org/gbu_lefortovo/GetAdditionalServices.ashx?login=qw&pwd=qw"
        let urlPath = Server.SERVER + Server.GET_ADDITIONAL_SERVICES + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        DispatchQueue.global(qos: .userInteractive).async {
            var request = URLRequest(url: URL(string: urlPath)!)
            request.httpMethod = "GET"
            print(request)
            
            URLSession.shared.dataTask(with: request) {
                data, error, responce in
                
                guard data != nil else {
                    DispatchQueue.main.async{
                        self.loadAdBanner()
                    }
                    return
                }
                //                let responseString = String(data: data!, encoding: .utf8) ?? ""
                //                #if DEBUG
                //                print("responseString = \(responseString)")
                //                #endif
                let xml = XML.parse(data!)
                self.mainScreenXml = xml
                let requests = xml["AdditionalServices"]
                let row = requests["Group"]
                row.forEach { row in
                    self.rowComms[row.attributes["name"]!] = []
                    row["AdditionalService"].forEach {
//                        self.rowComms[row.attributes["name"]!]?.append( Services(row: $0) )
                        self.serviceArr.append(Services(row: $0))
                    }
                }
//                for (key, value) in self.rowComms {
//                    self.serviceArr.append(Objects(sectionName: key, sectionObjects: value))
//                }
//                if self.serviceArr.count > self.rowComms.count{
//                    self.serviceArr.removeAll()
//                    for (key, value) in self.rowComms {
//                        self.serviceArr.append(Objects(sectionName: key, sectionObjects: value))
//                    }
//                }
                DispatchQueue.main.async{
                    if self.serviceArr.count == 0{
                        self.tableServiceHeight.constant = 0
                        self.menu_6_const.constant = 0
                        self.serviceHeight.constant = 0
                    }else{
                        self.serviceArr.forEach{
                            if $0.showinadblock == "mainpage"{
                                self.serviceAdBlock.append($0)
                            }
                        }
                        let str_menu_2 = UserDefaults.standard.string(forKey: "menu_8") ?? ""
                        if (str_menu_2 != "") {
                            let answer = str_menu_2.components(separatedBy: ";")
                            if (answer[2] == "0") {
                                self.menu_6_const.constant = 0
                                self.serviceHeight.constant = 0
                                self.tableServiceHeight.constant = 0
                            }else{
                                self.menu_6_const.constant = 15
                                self.serviceHeight.constant = 45
                                self.tableServiceHeight.constant = (self.view.frame.size.width - 30) / 2 + 4
                            }
                        }
                    }
                    self.servicePagerView.interitemSpacing = 20
                    self.servicePagerView.dataSource = self
                    self.servicePagerView.delegate   = self
                    self.servicePagerView.reloadData()
                    self.servicePagerView.automaticSlidingInterval = 3.0
                    self.loadAdBanner()
                }
                }.resume()
        }
    }
    
    func loadAdBanner(){
        if self.serviceAdBlock.count != 0{
            self.adPagerView.interitemSpacing = 20
            self.adPagerView.dataSource = self
            self.adPagerView.delegate   = self
            self.adPagerView.reloadData()
            self.adPagerView.automaticSlidingInterval = 10.0
            self.bottomViewHeight.constant = (self.view.frame.size.width - 30) / 2 + 4
        }else if UserDefaults.standard.bool(forKey: "show_Ad"){
            if UserDefaults.standard.integer(forKey: "ad_Type") == 2{
                let configuration = YMANativeAdLoaderConfiguration(blockID: UserDefaults.standard.string(forKey: "adsCode")!,
                                                                   imageSizes: [kYMANativeImageSizeMedium],
                                                                   loadImagesAutomatically: true)
                self.adLoader = YMANativeAdLoader(configuration: configuration)
                self.adLoader.delegate = self
                self.loadAd()
            }else if UserDefaults.standard.integer(forKey: "ad_Type") == 3{
                self.gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
                //                gadBannerView.adUnitID = "ca-app-pub-5483542352686414/5099103340"
                self.gadBannerView.adUnitID = UserDefaults.standard.string(forKey: "adsCode")
                self.gadBannerView.rootViewController = self
                self.addBannerViewToView(self.gadBannerView)
                self.gadBannerView.delegate = self
                self.gadBannerView.load(self.request)
            }
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (t) in
                if UserDefaults.standard.bool(forKey: "show_Ad") && self.showAD{
                    if UserDefaults.standard.integer(forKey: "ad_Type") == 2{
                        self.loadAd()
                    }else if UserDefaults.standard.integer(forKey: "ad_Type") == 3{
                        self.gadBannerView.load(self.request)
                    }
                }
            })
        }else{
            self.bottomViewHeight.constant = 0
            self.adTopConst.constant = 0
        }
    }
    
    @IBOutlet private weak var adPagerView:   FSPagerView! {
        didSet {
            self.adPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet private weak var servicePagerView:   FSPagerView! {
        didSet {
            self.servicePagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        if pagerView == servicePagerView{
            return serviceArr.count
        }else{
            return serviceAdBlock.count
        }
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if pagerView == servicePagerView{
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            let url:NSURL = NSURL(string: (serviceArr[index].logo)!)!
            let data = try? Data(contentsOf: url as URL)
            if UIImage(data: data!) == nil{
            //            imgWidth.constant = 0
            }else{
                cell.imageView?.image = UIImage(data: data!)
            }
            return cell
        }else{
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            let url:NSURL = NSURL(string: (serviceAdBlock[index].logo)!)!
            let data = try? Data(contentsOf: url as URL)
            if UIImage(data: data!) == nil{
            //            imgWidth.constant = 0
            }else{
                cell.imageView?.image = UIImage(data: data!)
            }
            return cell
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if pagerView == servicePagerView{
            if serviceArr[index].canbeordered == "1" && serviceArr[index].id_requesttype != "" && serviceArr[index].id_account != ""{
                self.addAppAction(checkService: index, allService: true)
            }
        }else{
            if serviceAdBlock[index].canbeordered == "1" && serviceAdBlock[index].id_requesttype != "" && serviceAdBlock[index].id_account != ""{
                self.addAppAction(checkService: index, allService: false)
            }
        }
        pagerView.deselectItem(at: index, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        self.tableLSHeight.constant = 1000
        self.tableNewsHeight.constant = 400
        self.tableCounterHeight.constant = 2000
        self.tableAppsHeight.constant = 400
        self.tableQuestionHeight.constant = 400
        self.tableWebHeight.constant = 400
        self.tableReceiptsHeight.constant = 1000
        if tableView == self.tableLS {
            count = lsArr.count
        }
        if tableView == self.tableNews {
            count =  newsArr.count
        }
        if tableView == self.tableCounter {
            count =  nameArr.count
        }
        if tableView == self.tableApps {
            if let sections = fetchedResultsController?.sections {
                count = sections[section].numberOfObjects
                if count! > 3{
                    count = 3
                }
            } else {
                count = 0
            }
        }
        if tableView == self.tableQuestion {
            count =  questionArr.count
        }
        if tableView == self.tableWeb {
            count =  webArr.count
            if count! > 2{
                count = 2
            }
        }
        if tableView == self.tableReceipts {
            count =  fileList.count
            if count! > 2{
                count = 2
            }
        }
        DispatchQueue.main.async {
            var height1: CGFloat = 0
            for cell in self.tableLS.visibleCells {
                height1 += cell.bounds.height
            }
            self.tableLSHeight.constant = height1
            var height2: CGFloat = 0
            for cell in self.tableNews.visibleCells {
                height2 += cell.bounds.height
            }
            if height2 == 0{
                self.menu_1_const.constant = 0
                self.newsHeight.constant = 0
                self.tableNewsHeight.constant = height2
            }else{
                let str_menu_0 = UserDefaults.standard.string(forKey: "menu_0") ?? ""
                if (str_menu_0 != "") {
                    var answer = str_menu_0.components(separatedBy: ";")
                    if (answer[2] == "0") {
                        self.menu_1_const.constant = 0
                        self.newsHeight.constant = 0
                        self.tableNewsHeight.constant = 0
                    }else{
                        self.menu_1_const.constant = 15
                        self.newsHeight.constant = 45
                        self.tableNewsHeight.constant = height2
                    }
                }
            }
            var height3: CGFloat = 0
            for cell in self.tableCounter.visibleCells {
                height3 += cell.bounds.height
            }
            if height3 == 0{
                self.menu_2_const.constant = 0
                self.counterHeight.constant = 0
//                self.canCountHeight.constant = 0
                self.tableCounterHeight.constant = height3
            }else{
                let str_menu_4 = UserDefaults.standard.string(forKey: "menu_4") ?? ""
                if (str_menu_4 != "") {
                    var answer = str_menu_4.components(separatedBy: ";")
                    if (answer[2] == "0") {
                        self.menu_2_const.constant = 0
                        self.counterHeight.constant = 0
//                        self.canCountHeight.constant = 0
                        self.tableCounterHeight.constant = 0
                    }else{
                        self.menu_2_const.constant = 15
                        self.counterHeight.constant = 45
//                        self.canCountHeight.constant = 30
                        self.tableCounterHeight.constant = height3
                    }
                }
            }
            var height4: CGFloat = 0
            for cell in self.tableApps.visibleCells {
                height4 += cell.bounds.height
            }
            if height4 == 0{
                let str_menu_2 = UserDefaults.standard.string(forKey: "menu_2") ?? ""
                if (str_menu_2 != "") {
                    var answer = str_menu_2.components(separatedBy: ";")
                    if (answer[2] == "0") {
                        self.menu_3_const.constant = 0
                        self.appsHeight.constant = 0
                        self.btn_Apps_Height.constant = 0
                        self.apps_View.isHidden = true
                        self.btn_add_Apps.isHidden = true
                    } else {
                        let str_ls = UserDefaults.standard.string(forKey: "str_ls")
                        let str_ls_arr = str_ls?.components(separatedBy: ",")
                        if str_ls_arr?.count == 0 || str_ls_arr![0] == ""{
                            self.menu_3_const.constant = 0
                            self.appsHeight.constant = 0
                            self.btn_Apps_Height.constant = 0
                            self.apps_View.isHidden = true
                            self.btn_add_Apps.isHidden = true
                        }else{
                            self.apps_View.isHidden = false
                            self.menu_3_const.constant = 15
                            self.appsHeight.constant = 45
                            self.btn_add_Apps.isHidden = false
                            self.btn_Apps_Height.constant = 36
                        }
                    }
                }
                self.tableAppsHeight.constant = height4
            }else{
                let str_menu_2 = UserDefaults.standard.string(forKey: "menu_2") ?? ""
                if (str_menu_2 != "") {
                    var answer = str_menu_2.components(separatedBy: ";")
                    if (answer[2] == "0") {
                        self.menu_3_const.constant = 0
                        self.appsHeight.constant = 0
                        self.btn_Apps_Height.constant = 0
                        self.apps_View.isHidden = true
                        self.btn_add_Apps.isHidden = true
                        self.tableAppsHeight.constant = 0
                    } else {
                        self.apps_View.isHidden = false
                        self.menu_3_const.constant = 15
                        self.appsHeight.constant = 45
                        self.btn_Apps_Height.constant = 36
                        let str_ls = UserDefaults.standard.string(forKey: "str_ls")
                        let str_ls_arr = str_ls?.components(separatedBy: ",")
                        if str_ls_arr?.count == 0{
                            self.btn_add_Apps.isHidden = true
                        }
                        self.tableAppsHeight.constant = height4
                    }
                }
            }
            var height5: CGFloat = 0
            for cell in self.tableQuestion.visibleCells {
                height5 += cell.bounds.height
            }
            if height5 == 0{
                let str_menu_2 = UserDefaults.standard.string(forKey: "menu_3") ?? ""
                if (str_menu_2 != "") {
                    var answer = str_menu_2.components(separatedBy: ";")
                    if (answer[2] == "0") {
                        self.menu_4_const.constant = 0
                        self.questionLSHeight.constant = 0
                    } else {
                    }
                }
                self.questionLSHeight.constant = 0
                self.tableQuestionHeight.constant = height5
            }else{
                let str_menu_2 = UserDefaults.standard.string(forKey: "menu_3") ?? ""
                if (str_menu_2 != "") {
                    var answer = str_menu_2.components(separatedBy: ";")
                    if (answer[2] == "0") {
                        self.menu_4_const.constant = 0
                        self.questionLSHeight.constant = 0
                        self.tableQuestionHeight.constant = 0
                    }else{
                        self.menu_4_const.constant = 15
                        self.questionLSHeight.constant = 45
                        self.tableQuestionHeight.constant = height5
                    }
                }
            }
            var height6: CGFloat = 0
            for cell in self.tableWeb.visibleCells {
                height6 += cell.bounds.height
            }
            if height6 == 0{
                self.menu_5_const.constant = 0
                self.webLSHeight.constant = 0
                self.tableWebHeight.constant = height6
            }else{
                let str_menu_2 = UserDefaults.standard.string(forKey: "menu_7") ?? ""
                if (str_menu_2 != "") {
                    var answer = str_menu_2.components(separatedBy: ";")
                    if (answer[2] == "0") {
                        self.menu_6_const.constant = 0
                        self.webLSHeight.constant = 0
                        self.tableWebHeight.constant = 0
                    }else{
                        self.menu_6_const.constant = 15
                        self.webLSHeight.constant = 45
                        self.tableWebHeight.constant = height6
                    }
                }
            }
            var height8: CGFloat = 0
            for cell in self.tableReceipts.visibleCells {
                height8 += cell.bounds.height
            }
            if height8 == 0{
                self.menu_7_const.constant = 0
                self.receipts1Height.constant = 0
                self.receipts2Height.constant = 0
                self.receipts_View.isHidden = true
                self.tableReceiptsHeight.constant = 0
            }else{
                self.menu_7_const.constant = 15
                self.receipts1Height.constant = 45
                self.receipts2Height.constant = 40
                self.receipts_View.isHidden = false
                self.tableReceiptsHeight.constant = height8
            }
            //            print("Отступы меню: ", self.menu_1_const.constant, self.menu_2_const.constant, self.menu_3_const.constant, self.menu_4_const.constant, self.menu_5_const.constant, self.menu_6_const.constant, self.menu_7_const.constant)
            //            print("Высота таблиц: ", self.tableNewsHeight.constant, self.tableCounterHeight.constant, self.tableAppsHeight.constant, self.tableQuestionHeight.constant, self.tableWebHeight.constant, self.tableServiceHeight.constant, self.tableReceiptsHeight.constant)
            //            print("Высота шапок: ", self.newsHeight.constant, self.counterHeight.constant, self.appsHeight.constant, self.questionLSHeight.constant, self.webLSHeight.constant, self.serviceHeight.constant, self.receipts1Height.constant + self.receipts2Height.constant)
        }
        if count! > 0{
            return count!
        }else{
            return 0
        }
    }
    
    func get_name_month(number_month: String) -> String {
        var rezult: String = ""
        
        if (number_month == "1") {
            rezult = "Январь"
        } else if (number_month == "2") {
            rezult = "Февраль"
        } else if (number_month == "3") {
            rezult = "Март"
        } else if (number_month == "4") {
            rezult = "Апрель"
        } else if (number_month == "5") {
            rezult = "Май"
        } else if (number_month == "6") {
            rezult = "Июнь"
        } else if (number_month == "7") {
            rezult = "Июль"
        } else if (number_month == "8") {
            rezult = "Август"
        } else if (number_month == "9") {
            rezult = "Сентябрь"
        } else if (number_month == "10") {
            rezult = "Октябрь"
        } else if (number_month == "11") {
            rezult = "Ноябрь"
        } else if (number_month == "12") {
            rezult = "Декабрь"
        }
        
        return rezult
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableLS {
            let cell = self.tableLS.dequeueReusableCell(withIdentifier: "HomeLSCell") as! HomeLSCell
            //            cell = shadowCell(cell: cell) as! HomeLSCell
//            #if isDJ
//            cell.del_ls_btn.isHidden = true
//            #endif
            cell.lsText.text = "№ " + lsArr[indexPath.row].ident!
            cell.separator.backgroundColor = myColors.btnColor.uiColor()
            cell.payDebt.backgroundColor = myColors.btnColor.uiColor()
            cell.insurance_btn.tintColor = myColors.btnColor.uiColor()
            cell.addressText.text = lsArr[indexPath.row].address!
            cell.sumInfo.text = "Сумма к оплате на " + lsArr[indexPath.row].date! + " г."
            cell.sumText.text = lsArr[indexPath.row].sum! + " руб."
            cell.sumText.textColor = myColors.btnColor.uiColor()
            if insuranceArr.count != 0{
                insuranceArr.forEach{
                    if $0.sumDecimal != "0.00" && $0.ident == lsArr[indexPath.row].ident!{
                        cell.insuranceLbl.text = "Подключено страхование от Абсолют Страхование с " + $0.dataBeg! + " по " + $0.dataEnd!
                        cell.insuranceLbl.isHidden = false
                        cell.insurance_btn.isHidden = false
                        cell.insuranceLblHeight.constant = heightForView(text: cell.insuranceLbl.text ?? "", font: cell.insuranceLbl.font, width: view.frame.size.width - 70)
                        cell.insurance_btnHeight.constant = 20
                    }else{
                        cell.insuranceLbl.isHidden = true
                        cell.insurance_btn.isHidden = true
                        cell.insuranceLblHeight.constant = 0
                        cell.insurance_btnHeight.constant = 0
                    }
                }
            }else{
                cell.insuranceLbl.isHidden = true
                cell.insurance_btn.isHidden = true
                cell.insuranceLblHeight.constant = 0
                cell.insurance_btnHeight.constant = 0
            }
            //            var sumAll = 0.00
            //            var isPayToDate = false
            //            var isPayBoDate = false
            //            var sumBoDate = 0.00
            //            self.values.forEach{
            //                    let dateFormatter = DateFormatter()
            //                    dateFormatter.dateFormat = "dd.MM.yyyy"
            //                    let date1: Date = dateFormatter.date(from: $0.date.replacingOccurrences(of: " 00:00:00", with: ""))!
            //                    let date2: Date = dateFormatter.date(from: lsArr[indexPath.row].date!)!
            //                    if date2 > date1{
            ////                        #if isMupRCMytishi
            ////                        let serviceP = self.sum / 0.992 - self.sum
            ////                        #else
            ////                        let serviceP = UserDefaults.standard.double(forKey: "servPercent") * Double($0.sum)! / 100
            ////                        #endif
            //                        sumAll = sumAll + Double($0.sum)!
            //                    }
            //            }
            //            let sum:Double = Double(lsArr[indexPath.row].sum!) as! Double
            //            if sumAll == sum{
            //                isPayToDate = true
            //            }else if sumAll > sum{
            //                sumBoDate = sumAll - sum
            //                isPayBoDate = true
            //            }
            //            print(sumAll, sumBoDate, sum)
            //            if (Double(lsArr[indexPath.row].sum!)! > 0.00 && isPayBoDate) || (Double(lsArr[indexPath.row].sum!)! < 0.00){
            if Double(lsArr[indexPath.row].sum!)! < 0.00{
                cell.noDebtText.isHidden = false
                cell.payDebt.isHidden = true
                cell.topPeriodConst.constant = 0
                cell.bottViewHeight.constant = 0
                cell.payDebtHeight.constant = 0
                cell.sumViewHeight.constant = 50
                cell.sumInfo.text = "Имеется переплата на " + lsArr[indexPath.row].date! + " на сумму"
                cell.sumText.text = lsArr[indexPath.row].sum!.replacingOccurrences(of: "-", with: "") + " руб."
                //            }else if Double(lsArr[indexPath.row].sum!)! > 0.00 && isPayToDate{
                //                cell.noDebtText.isHidden = false
                //                cell.payDebt.isHidden = true
                //                cell.topPeriodConst.constant = 20
                //                cell.sumViewHeight.constant = 0
                //                cell.payDebtHeight.constant = 0
                //                if self.view.frame.size.width > 320{
                //                    cell.bottViewHeight.constant = 50
                //                }else{
                //                    cell.bottViewHeight.constant = 70
                //                }
            }else if Double(lsArr[indexPath.row].sum!)! > 0.00{
                //                cell.separator.isHidden = true
                cell.noDebtText.isHidden = true
                cell.payDebt.isHidden = false
                cell.topPeriodConst.constant = 5
                if self.view.frame.size.width > 320{
                    cell.bottViewHeight.constant = 30
                }else{
                    cell.bottViewHeight.constant = 50
                }
            }else{
                cell.noDebtText.isHidden = true
                cell.payDebt.isHidden = true
                cell.periodPay.isHidden = true
                cell.allPayText.isHidden = false
                cell.allPayText.text = "Все квитанции оплачены на " + lsArr[indexPath.row].date! + " г."
                cell.sumViewHeight.constant = 0
                cell.payDebtHeight.constant = 0
                cell.bottViewHeight.constant = 50
            }
            cell.delegate = self
            cell.delegate2 = self
            if UserDefaults.standard.bool(forKey: "dontShowDebt"){
                cell.bottViewHeight.constant = 0
                cell.sumViewHeight.constant = 0
                cell.payDebtHeight.constant = 0
                cell.separator.isHidden = true
                cell.noDebtText.isHidden = true
                cell.payDebt.isHidden = true
                cell.periodPay.isHidden = true
                cell.allPayText.isHidden = true
            }
            return cell
        }else if tableView == self.tableNews {
            let cell = self.tableNews.dequeueReusableCell(withIdentifier: "HomeNewsCell") as! HomeNewsCell
            cell.textQuestion.text = newsArr[indexPath.row].header
            cell.openNews.tintColor = myColors.btnColor.uiColor()
            //            cell = shadowCell(cell: cell) as! HomeNewsCell
            //            cell.delegate = self
            return cell
        }else if tableView == self.tableCounter {
            let cell = self.tableCounter.dequeueReusableCell(withIdentifier: "HomeCounterCell") as! HomeCounterCell
            var countName = ""
            cell.tariffNumber     = tariffArr[indexPath.row]
            lsArr.forEach{
                if $0.ident == identArr[indexPath.row]{
                    cell.adress.text = $0.address!
                }
            }
            cell.ident = identArr[indexPath.row]
            if cell.adress.text == "" || cell.adress.text == " " || cell.adress.text == "-" || cell.adress.text == nil{
                cell.identView.isHidden = true
                cell.identHeight.constant = 0
            }else{
                cell.identView.isHidden = false
                cell.identHeight.constant = 24
                cell.identHeight.constant = heightForView(text: cell.adress.text!, font: cell.adress.font, width: view.frame.size.width - 135)
            }
            cell.name.text        = nameArr[indexPath.row] + ", " + unitArr[indexPath.row]
            cell.number.text      = ownerArr[indexPath.row]
            if ownerArr[indexPath.row] == "" || ownerArr[indexPath.row] == " " || ownerArr[indexPath.row] == "-" || ownerArr[indexPath.row] == nil{
                cell.numberView.isHidden = true
                cell.numberHeight.constant = 0
            }else{
                cell.numberView.isHidden = false
                cell.numberHeight.constant = 24
            }
            let formatDec:String = "%." + numberDecimal[indexPath.row] + "f"
            countName             = nameArr[indexPath.row] + ", " + unitArr[indexPath.row]
            cell.pred1.text        = String(format:formatDec, predArr[indexPath.row])
            cell.teck1.text        = String(format:formatDec, teckArr[indexPath.row])
            cell.diff1.text        = String(format:formatDec, diffArr[indexPath.row])
            cell.predLbl1.text     = dateOneArr[indexPath.row]
            cell.teckLbl1.text     = dateTwoArr[indexPath.row]
            cell.diffLbl1.text     = dateThreeArr[indexPath.row]
            
            // Проверка и интервал
            cell.checkup_date.text = lastCheckArr[indexPath.row]
            if lastCheckArr[indexPath.row] == "" || lastCheckArr[indexPath.row] == " " || lastCheckArr[indexPath.row] == "-" || lastCheckArr[indexPath.row] == nil{
                cell.checkView.isHidden = true
                cell.chechHeight.constant = 0
            }else{
                cell.checkView.isHidden = false
                cell.chechHeight.constant = 24
            }
            cell.recheckup_diff.text = recheckInterArr[indexPath.row] + getAge(age: recheckInterArr[indexPath.row])
            if recheckInterArr[indexPath.row] == "" || recheckInterArr[indexPath.row] == " " || recheckInterArr[indexPath.row] == "-" || recheckInterArr[indexPath.row] == nil{
                cell.recheckView.isHidden = true
                cell.recheckHeight.constant = 0
            }else{
                cell.recheckView.isHidden = false
                cell.recheckHeight.constant = 24
            }
            if (autoValueArr[indexPath.row]) {
//                cell.sendButton.setTitle("Автоматическое снятие", for: .normal)
                cell.sendBtnHeight.constant = 0
                cell.sendButton.isHidden = true
                cell.autoLbl.isHidden = false
                cell.autoLbl.textColor = myColors.btnColor.uiColor()
                cell.autoLblHeight.constant = 40
                cell.checkView.isHidden = true
                cell.chechHeight.constant = 0
                cell.recheckView.isHidden = true
                cell.recheckHeight.constant = 0
            }else{
                cell.sendButton.backgroundColor = myColors.btnColor.uiColor()
                cell.sendBtnHeight.constant = 36
                cell.sendButton.isHidden = false
                cell.autoLbl.isHidden = true
                cell.autoLblHeight.constant = 0
                let date = Date()
                let format = DateFormatter()
                format.dateFormat = "dd-MM-yyyy"
                let sendDate = format.date(from: dateOneArr[indexPath.row])
                let calendar = Calendar.current
                let currDay = calendar.component(.day, from: date)
                let currMonth = calendar.component(.month, from: date)
                let sendMonth = calendar.component(.month, from: sendDate!)
                var d1: Int = 0
                if Int(self.date1) != nil{
                    d1 = Int(self.date1)!
                }
                var d2: Int = 0
                if Int(self.date2) != nil{
                    d2 = Int(self.date2)!
                }
                if (self.date1 == "0") && (self.date2 == "0") {
                    if currMonth == sendMonth{
                        cell.can_count_label.text = "Показания переданы " + dateOneArr[indexPath.row]
                        cell.can_count_label.isHidden = false
                        cell.canCountHeight.constant = 17
                        cell.sendBtnHeight.constant = 20
                        cell.sendButton.setTitle("Исправить", for: .normal)
                        cell.sendButton.isHidden = false
                        cell.sendButton.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
                        cell.sendButton.backgroundColor = .white
                    }else{
                        cell.can_count_label.text = "Возможность передавать показания доступна в текущем месяце!"
                        cell.can_count_label.isHidden = true
                        cell.canCountHeight.constant = 0
                        cell.sendBtnHeight.constant = 36
                        cell.sendButton.setTitle("Передать показания", for: .normal)
                        cell.sendButton.isHidden = false
                        cell.sendButton.setTitleColor(.white, for: .normal)
                        cell.sendButton.backgroundColor = myColors.btnColor.uiColor()
                    }
                } else if (Int(self.date1) != nil) && (Int(self.date2) != nil) {
                    if currDay < d1 || currDay > d2{
                        cell.can_count_label.text = "Возможность передавать показания доступна с " + self.date1 + " по " + self.date2 + " числа текущего месяца!"
                        cell.can_count_label.isHidden = false
                        cell.canCountHeight.constant = 30
                        cell.sendBtnHeight.constant = 0
                        cell.sendButton.isHidden = true
                    }else{
                        if currMonth == sendMonth{
                            cell.can_count_label.text = "Показания переданы " + dateOneArr[indexPath.row]
                            cell.can_count_label.isHidden = false
                            cell.canCountHeight.constant = 17
                            cell.sendBtnHeight.constant = 20
                            cell.sendButton.setTitle("Исправить", for: .normal)
                            cell.sendButton.isHidden = false
                            cell.sendButton.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
                            cell.sendButton.backgroundColor = .white
                        }else{
                            cell.can_count_label.text = "Возможность передавать показания доступна в текущем месяце!"
                            cell.can_count_label.isHidden = true
                            cell.canCountHeight.constant = 0
                            cell.sendBtnHeight.constant = 36
                            cell.sendButton.setTitle("Передать показания", for: .normal)
                            cell.sendButton.isHidden = false
                            cell.sendButton.setTitleColor(.white, for: .normal)
                            cell.sendButton.backgroundColor = myColors.btnColor.uiColor()
                        }
                    }
                }
            }
            
            if Int(cell.tariffNumber) == 2{
                cell.pred2.text        = String(format:formatDec, predArr2[indexPath.row])
                cell.teck2.text        = String(format:formatDec, teckArr2[indexPath.row])
                cell.diff2.text        = String(format:formatDec, diffArr2[indexPath.row])
                cell.predLbl2.text     = dateOneArr[indexPath.row]
                cell.teckLbl2.text     = dateTwoArr[indexPath.row]
                cell.diffLbl2.text     = dateThreeArr[indexPath.row]
            }else if Int(cell.tariffNumber) == 3{
                cell.pred2.text        = String(format:formatDec, predArr2[indexPath.row])
                cell.teck2.text        = String(format:formatDec, teckArr2[indexPath.row])
                cell.diff2.text        = String(format:formatDec, diffArr2[indexPath.row])
                cell.predLbl2.text     = dateOneArr[indexPath.row]
                cell.teckLbl2.text     = dateTwoArr[indexPath.row]
                cell.diffLbl2.text     = dateThreeArr[indexPath.row]
                
                cell.pred3.text        = String(format:formatDec, predArr3[indexPath.row])
                cell.teck3.text        = String(format:formatDec, teckArr3[indexPath.row])
                cell.diff3.text        = String(format:formatDec, diffArr3[indexPath.row])
                cell.predLbl3.text     = dateOneArr[indexPath.row]
                cell.teckLbl3.text     = dateTwoArr[indexPath.row]
                cell.diffLbl3.text     = dateThreeArr[indexPath.row]
            }
            cell.imgCounter.image = UIImage(named: "coldWater")
            if (countName.lowercased().range(of: "гвс") != nil) || (countName.lowercased().range(of: "ф/в") != nil) || (countName.containsIgnoringCase(find: "гв")){
                cell.imgCounter.image = UIImage(named: "hotWater")
            }
            if (countName.lowercased().range(of: "хвс") != nil) || (countName.lowercased().range(of: "хвc") != nil) || (countName.lowercased().range(of: "х/в") != nil) || (countName.containsIgnoringCase(find: "хв")){
                cell.imgCounter.image = UIImage(named: "coldWater")
            }
            if (countName.lowercased().range(of: "газ") != nil){
                cell.imgCounter.image = UIImage(named: "fire")
                cell.imgCounter.setImageColor(color: .yellow)
            }
            if (countName.lowercased().range(of: "тепло") != nil){
                cell.imgCounter.image = UIImage(named: "fire")
                cell.imgCounter.setImageColor(color: .red)
            }
            if (countName.lowercased().range(of: "элект") != nil) || (countName.contains("кВт")){
                cell.imgCounter.image = UIImage(named: "lamp")
            }
            if dateTwoArr[indexPath.row] == ""{
                cell.lblHeight11.constant = 0
                cell.lblHeight13.constant = 0
                if Int(cell.tariffNumber) == 2{
                    cell.lblHeight21.constant = 0
                    cell.lblHeight23.constant = 0
                }else if Int(cell.tariffNumber) == 3{
                    cell.lblHeight21.constant = 0
                    cell.lblHeight23.constant = 0
                    
                    cell.lblHeight31.constant = 0
                    cell.lblHeight33.constant = 0
                }
            }else{
                cell.lblHeight11.constant = 16
                cell.lblHeight13.constant = 16
                if Int(cell.tariffNumber) == 2{
                    cell.lblHeight21.constant = 16
                    cell.lblHeight23.constant = 16
                }else if Int(cell.tariffNumber) == 3{
                    cell.lblHeight21.constant = 16
                    cell.lblHeight23.constant = 16
                    
                    cell.lblHeight31.constant = 16
                    cell.lblHeight33.constant = 16
                }
            }
            if dateThreeArr[indexPath.row] == ""{
                cell.lblHeight12.constant = 0
                cell.lblHeight14.constant = 0
                if Int(cell.tariffNumber) == 2{
                    cell.lblHeight22.constant = 0
                    cell.lblHeight24.constant = 0
                }else if Int(cell.tariffNumber) == 3{
                    cell.lblHeight22.constant = 0
                    cell.lblHeight24.constant = 0
                    
                    cell.lblHeight32.constant = 0
                    cell.lblHeight34.constant = 0
                }
            }else{
                cell.lblHeight12.constant = 16
                cell.lblHeight14.constant = 16
                if Int(cell.tariffNumber) == 2{
                    cell.lblHeight22.constant = 16
                    cell.lblHeight24.constant = 16
                }else if Int(cell.tariffNumber) == 3{
                    cell.lblHeight22.constant = 16
                    cell.lblHeight24.constant = 16
                    
                    cell.lblHeight32.constant = 16
                    cell.lblHeight34.constant = 16
                }
            }
            if errorOneArr[indexPath.row]{
                cell.nonCounterOne1.isHidden = false
                cell.nonCounterOne1.setImageColor(color: .red)
                cell.errorTextOne1.isHidden = false
                cell.errorTextOne1.text = errorTextOneArr[indexPath.row]
                cell.errorOneHeight1.constant = self.heightForView(text: errorTextOneArr[indexPath.row], font: cell.errorTextOne1.font, width: cell.errorTextOne1.frame.size.width)
                cell.nonCounterOne2.isHidden = true
                cell.errorTextOne2.isHidden = true
                cell.errorOneHeight2.constant = 0
                cell.nonCounterOne3.isHidden = true
                cell.errorTextOne3.isHidden = true
                cell.errorOneHeight3.constant = 0
            }else{
                cell.nonCounterOne1.isHidden = true
                cell.errorTextOne1.isHidden = true
                cell.errorOneHeight1.constant = 0
                cell.nonCounterOne2.isHidden = true
                cell.errorTextOne2.isHidden = true
                cell.errorOneHeight2.constant = 0
                cell.nonCounterOne3.isHidden = true
                cell.errorTextOne3.isHidden = true
                cell.errorOneHeight3.constant = 0
            }
            if errorTwoArr[indexPath.row]{
                cell.nonCounterTwo1.isHidden = false
                cell.nonCounterTwo1.setImageColor(color: .red)
                cell.errorTextTwo1.isHidden = false
                cell.errorTextTwo1.text = errorTextTwoArr[indexPath.row]
                cell.errorTwoHeight1.constant = self.heightForView(text: errorTextTwoArr[indexPath.row], font: cell.errorTextTwo1.font, width: cell.errorTextTwo1.frame.size.width)
                cell.nonCounterTwo2.isHidden = true
                cell.errorTextTwo2.isHidden = true
                cell.errorTwoHeight2.constant = 0
                cell.nonCounterTwo3.isHidden = true
                cell.errorTextTwo3.isHidden = true
                cell.errorTwoHeight3.constant = 0
            }else{
                cell.nonCounterTwo1.isHidden = true
                cell.errorTextTwo1.isHidden = true
                cell.errorTwoHeight1.constant = 0
                cell.nonCounterTwo2.isHidden = true
                cell.errorTextTwo2.isHidden = true
                cell.errorTwoHeight2.constant = 0
                cell.nonCounterTwo3.isHidden = true
                cell.errorTextTwo3.isHidden = true
                cell.errorTwoHeight3.constant = 0
            }
            if errorThreeArr[indexPath.row]{
                cell.nonCounterThree1.isHidden = false
                cell.nonCounterThree1.setImageColor(color: .red)
                cell.errorTextThree1.isHidden = false
                cell.errorTextThree1.text = errorTextThreeArr[indexPath.row]
                cell.errorThreeHeight1.constant = self.heightForView(text: errorTextThreeArr[indexPath.row], font: cell.errorTextThree1.font, width: cell.errorTextThree1.frame.size.width)
                cell.nonCounterThree2.isHidden = true
                cell.errorTextThree2.isHidden = true
                cell.errorThreeHeight2.constant = 0
                cell.nonCounterThree3.isHidden = true
                cell.errorTextThree3.isHidden = true
                cell.errorThreeHeight3.constant = 0
            }else{
                cell.nonCounterThree1.isHidden = true
                cell.errorTextThree1.isHidden = true
                cell.errorThreeHeight1.constant = 0
                cell.nonCounterThree2.isHidden = true
                cell.errorTextThree2.isHidden = true
                cell.errorThreeHeight2.constant = 0
                cell.nonCounterThree3.isHidden = true
                cell.errorTextThree3.isHidden = true
                cell.errorThreeHeight3.constant = 0
            }
            cell.tariffOne.textColor = myColors.btnColor.uiColor()
            cell.tariffTwo.textColor = myColors.btnColor.uiColor()
            cell.tariffThree.textColor = myColors.btnColor.uiColor()
            cell.separator.backgroundColor = myColors.btnColor.uiColor()
            if Int(cell.tariffNumber) == 0 || Int(cell.tariffNumber) == 1{
                cell.tariffHeight2.constant = 0
                cell.tariffHeight3.constant = 0
                cell.tariffOne.isHidden = true
                cell.tariffOneHeight.constant = 0
                cell.tariff2.isHidden = true
                cell.tariff3.isHidden = true
            }else if Int(cell.tariffNumber) == 2{
                cell.tariffOne.isHidden = false
                cell.tariffOneHeight.constant = 20
                cell.tariffHeight2.constant = 100
                cell.tariff2.isHidden = false
                cell.tariffHeight3.constant = 0
                cell.tariff3.isHidden = true
            }else if Int(cell.tariffNumber) == 3{
                cell.tariffOneHeight.constant = 20
                cell.tariffOne.isHidden = false
                cell.tariffHeight2.constant = 100
                cell.tariff2.isHidden = false
                cell.tariffHeight3.constant = 100
                cell.tariff3.isHidden = false
            }
            //            cell = shadowCell(cell: cell) as! HomeCounterCell
            cell.delegate = self
            return cell
        }else if tableView == self.tableApps {
            let cell = self.tableApps.dequeueReusableCell(withIdentifier: "HomeAppsCell") as! HomeAppsCell
            let app = (fetchedResultsController?.object(at: indexPath))! as Applications
            cell.goApp.tintColor = myColors.btnColor.uiColor()
            cell.img.setImageColor(color: myColors.btnColor.uiColor())
            if app.reqNumber != nil{
                cell.nameApp.text    = "Заявка №" + app.reqNumber!
            }
            if app.tema != nil{
                cell.comment.text    = app.tema
            }
            if app.serverStatus != nil{
                cell.statusText.text = app.serverStatus
            }
            //            cell.text_app.text  = app.text
            if app.date != nil{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                if dateFormatter.date(from: app.date!) != nil{
                    let date = dateFormatter.date(from: app.date!)
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                    cell.date.text  = dateFormatter.string(from: date!)
                }else{
                    cell.date.text = ""
                }
            }
            return cell
        }else if tableView == self.tableQuestion {
            let cell = self.tableQuestion.dequeueReusableCell(withIdentifier: "HomeQuestionsCell") as! HomeQuestionsCell
            cell.nameQuestion.text = questionArr[indexPath.row].name!
            cell.number.text = "Опрос №" + String(questionArr[indexPath.row].id!)
            cell.questionsCount.text = String(questionArr[indexPath.row].questions?.count as! Int) + " вопросов"
            cell.separator.backgroundColor = myColors.btnColor.uiColor()
            cell.goQuestion.tintColor = myColors.btnColor.uiColor()
            //            cell = shadowCell(cell: cell) as! HomeQuestionsCell
            cell.delegate = self
            return cell
        }else if tableView == self.tableWeb {
            let cell = self.tableWeb.dequeueReusableCell(withIdentifier: "HomeWebCell") as! HomeWebCell
            cell.goWeb.tintColor = myColors.btnColor.uiColor()
            cell.img.setImageColor(color: myColors.btnColor.uiColor())
            cell.webText.text = webArr[indexPath.row].name
            //            cell = shadowCell(cell: cell) as! HomeWebCell
            //            cell.delegate = self
            return cell
        }else if tableView == self.tableReceipts {
            let cell = self.tableReceipts.dequeueReusableCell(withIdentifier: "HomeReceiptsCell") as! HomeReceiptsCell
            cell.goReceipt.tintColor = myColors.btnColor.uiColor()
            if (fileList[indexPath.row].link.contains(".png")) || (fileList[indexPath.row].link.contains(".jpg")) || (fileList[indexPath.row].link.contains(".pdf")){
                cell.goReceipt.isHidden = false
            }else{
                cell.goReceipt.isHidden = true
            }
            cell.ident.text = "Л/сч.:  " + fileList[indexPath.row].ident
            cell.separator.backgroundColor = myColors.btnColor.uiColor()
            cell.receiptText.text = self.get_name_month(number_month: String(fileList[indexPath.row].month)) + " " + String(fileList[indexPath.row].year)
            cell.receiptSum.text = String(format:"%.2f", fileList[indexPath.row].sum) + " руб"
            cell.separator.text = fileList[indexPath.row].link
            cell.delegate2 = self
            cell.delegate = self
            return cell
        }else{
            return StockCell()
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        //        print(label.frame.height, width)
        return label.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableQuestion{
            indexQuestion = indexPath.row
            performSegue(withIdentifier: "go_answers", sender: self)
        }else if tableView == self.tableNews{
            performSegue(withIdentifier: "show_news", sender: self)
        }else if tableView == self.tableApps{
            if UserDefaults.standard.bool(forKey: "newApps"){
                self.performSegue(withIdentifier: "new_show_app", sender: self)
            }else{
                self.performSegue(withIdentifier: "show_app", sender: self)
            }
        }else if tableView == self.tableWeb{
            performSegue(withIdentifier: "show_webs", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    var indexQuestion = 0
    //    func shadowCell(cell: UITableViewCell) -> UITableViewCell{
    //        cell.layer.cornerRadius = 7
    //        cell.layer.masksToBounds = false
    //        cell.layer.shadowColor = UIColor.lightGray.cgColor
    //        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
    //        cell.layer.shadowRadius = 7
    //        cell.layer.shadowOpacity = 0.5
    //        cell.layer.shouldRasterize = true
    //        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
    //        return cell
    //    }
    var debtArr:[AnyObject] = []
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        if segue.identifier == "go_answers" {
            //            let vc = segue.destination as! QuestionAnswerVC
            //            vc.title = questionArr[indexQuestion].name
            //            vc.question_ = questionArr[indexQuestion]
            //            //            vc.delegate = delegate
            //            vc.questionDelegate = self
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! QuestionsTableVC
            vc.questionTitle = questionArr[indexQuestion].name!
            vc.question_ = questionArr[indexQuestion]
            //            vc.delegate = delegate
            vc.questionDelegate = self
        }
        if (segue.identifier == "show_news") {
            let indexPath = tableNews.indexPathForSelectedRow!
            let newsObj = newsArr[indexPath.row]
            let vc = segue.destination as! NewsView
            vc.newsTitle = newsObj.header
            vc.newsData  = newsObj.created
            vc.newsText  = newsObj.text
            vc.newsRead  = newsObj.readed
            vc.newsId    = newsObj.idNews
        }
        if segue.identifier == "show_webs" {
            let indexPath = tableWeb.indexPathForSelectedRow!
            let vc = segue.destination as! Web_Camera
            vc.title = webArr[indexPath.row].name
            vc.web_camera = webArr[indexPath.row]
            //            //            vc.delegate = delegate
            //            vc.questionDelegate = self
            //            performName_ = ""
        }
        if segue.identifier == "show_app" {
            let indexPath = tableApps.indexPathForSelectedRow!
            let app = fetchedResultsController!.object(at: indexPath)
            
            let AppUser             = segue.destination as! AppUser
            if app.number != nil{
                AppUser.title           = "Заявка №" + app.number!
            }
            AppUser.txt_tema   = app.tema!
            AppUser.str_type_app = app.type_app!
            AppUser.read = app.is_read_client
            AppUser.adress = app.adress!
            AppUser.flat = app.flat!
            AppUser.phone = app.phone!
            AppUser.paid_text = app.paid_text!
            AppUser.paid_sum = Double(app.paid_sum!) as! Double
            AppUser.isPay = app.is_pay
            AppUser.isPaid = app.is_paid
            AppUser.acc_ident = app.acc_ident!
            //            AppUser.txt_text   = app.text!
            AppUser.txt_date   = app.date!
            AppUser.id_app     = app.number!
            //            AppUser.delegate   = ShowAppDelegate()
            AppUser.App        = app
            //            AppUser.updDelegt = AppsUserUpdateDelegate()
        }
        if segue.identifier == "new_add_app" {
            let AppUser             = segue.destination as! NewAddAppUser
            AppUser.fromMenu = true
        }
        if segue.identifier == "add_app" {
            let AppUser             = segue.destination as! AddAppUser
            AppUser.fromMenu = true
        }
        if segue.identifier == "new_show_app" {
            let indexPath = tableApps.indexPathForSelectedRow!
            if let sections = fetchedResultsController?.sections {
                let count = sections[0].numberOfObjects
                if indexPath.row < count{
                    let app = fetchedResultsController!.object(at: indexPath)
                    
                    let AppUser             = segue.destination as! NewAppUser
                    if app.number != nil{
                       AppUser.title           = "Заявка №" + app.number!
                    }
                    if app.tema != nil{
                        AppUser.txt_tema   = app.tema!
                    }else{
                        AppUser.txt_tema   = ""
                    }
                    if app.type_app != nil{
                        AppUser.str_type_app   = app.type_app!
                    }else{
                        AppUser.str_type_app   = ""
                    }
                    AppUser.read = app.is_read_client
                    if app.adress != nil{
                        AppUser.adress   = app.adress!
                    }else{
                        AppUser.adress   = ""
                    }
                    if app.flat != nil{
                        AppUser.flat   = app.flat!
                    }else{
                        AppUser.flat   = ""
                    }
                    if app.phone != nil{
                        AppUser.phone   = app.phone!
                    }else{
                        AppUser.phone   = ""
                    }
                    if app.serverStatus != nil{
                        AppUser.txt_status = app.serverStatus!
                    }else{
                        AppUser.txt_status = ""
                    }
                    AppUser.fromMenu = true
                    if app.paid_text != nil{
                        AppUser.paid_text = app.paid_text!
                    }else{
                        AppUser.paid_text = ""
                    }
                    if app.paid_sum != nil{
                        AppUser.paid_sum = Double(app.paid_sum!)!
                        AppUser.isPay = app.is_pay
                        AppUser.isPaid = app.is_paid
                    }
                    if app.acc_ident != nil{
                       AppUser.acc_ident = app.acc_ident!
                    }

                    //            AppUser.txt_text   = app.text!
                    if app.date != nil{
                        AppUser.txt_date = app.date!
                    }else{
                        AppUser.txt_date = ""
                    }
                    if app.number != nil{
                        AppUser.id_app = app.number!
                    }else{
                        AppUser.id_app = ""
                    }
                    if app.reqNumber != nil{
                        AppUser.reqNumber  = app.reqNumber!
                    }else{
                        AppUser.reqNumber = ""
                    }
                    //            AppUser.delegate   = self
                    AppUser.App        = app
                    //            AppUser.updDelegt = self
                }
            }
        }
        if segue.identifier == "addCounters"{
            let payController             = segue.destination as! AddCountersController
            payController.counterNumber = selectedUniq
            payController.counterName = selectedUniqName
            payController.ident = countIdent
            payController.predValue1 = predVal1
            payController.predValue2 = predVal2
            payController.predValue3 = predVal3
            payController.metrId = metrID
            payController.autoSend = autoSend
            payController.recheckInter = recheckInter
            payController.lastCheckDate = lastCheckupDate
            payController.tariffNumber = selTariffNumber
            payController.numberDecimal = Int(selNumDec)!
        }
        
        if segue.identifier == "goCounter"{
            let payController             = segue.destination as! MupCounterController
            payController.serviceArr = self.serviceArr
            payController.lsArr = self.lsArr
        }
        
        #if isMupRCMytishi
        if segue.identifier == "paysMytishi2" {
            let payController             = segue.destination as! PaysMytishi2Controller
            if choiceIdent == ""{
                payController.saldoIdent = "Все"
            }else{
                payController.saldoIdent = choiceIdent
            }
            payController.serviceArr = self.serviceArr
            payController.debtArr = self.debtArr
        }
        #else
        if segue.identifier == "paysMytishi" {
            let payController             = segue.destination as! PaysMytishiController
            if choiceIdent == ""{
                payController.saldoIdent = "Все"
            }else{
                payController.saldoIdent = choiceIdent
            }
            payController.serviceArr = self.serviceArr
            payController.debtArr = self.debtArr
            payController.isHomePage = true
        }
        #endif
        if segue.identifier == "pays" {
            let payController             = segue.destination as! PaysController
            if choiceIdent == ""{
                payController.saldoIdent = "Все"
            }else{
                payController.saldoIdent = choiceIdent
            }
            payController.debtArr = self.debtArr
        }
        if segue.identifier == "openURL" {
            let payController             = segue.destination as! openSaldoController
            payController.urlLink = self.link
        }
        if segue.identifier == "goSaldo" {
            //            let payController             = segue.destination as! SaldoController
            //            print(self.debtArr.count)
            //            payController.debtArr = self.debtArr
        }
    }
    var selectedUniq = ""
    var selTariffNumber = 0
    var selectedUniqName = ""
    var selectedOwner = ""
    var autoSend = false
    var recheckInter = ""
    var lastCheckDate = ""
    var countIdent = ""
    var predVal1 = ""
    var predVal2 = ""
    var predVal3 = ""
    var metrID = ""
    var selNumDec = "0"
    var can_edit: String = ""
    var date1: String = ""
    var date2: String = ""
    func isEditable() -> Bool {
        return can_edit == "1"
    }
    
    func goUrlReceipt(url: String) {
        self.link = url
        self.performSegue(withIdentifier: "openURL", sender: self)
    }
    
    func сheckSend(uniq_num: String, count_name: String, ident: String, predValue: String, predValue2: String, predValue3: String, tariffNumber: String) {
        DispatchQueue.main.async{
            self.counterIndicator.startAnimating()
            self.counterIndicator.isHidden = false
            self.allCountersBtn.isHidden = true
        }
        let urlPath = Server.SERVER + "GetMeterAccessFlag.ashx?ident=" + ident.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        //            print(request)
        
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
                                                        self.counterIndicator.stopAnimating()
                                                        self.counterIndicator.isHidden = true
                                                        self.allCountersBtn.isHidden = false
                                                    })
                                                    return
                                                }
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                //                                                    print("responseString = \(responseString)")
                                                if (responseString == "0") {
                                                    DispatchQueue.main.async{
                                                        let alert = UIAlertController(title: "Ошибка", message: "Возможность передавать показания доступна с " + self.date1 + " по " + self.date2 + " числа текущего месяца!", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                        self.counterIndicator.stopAnimating()
                                                        self.counterIndicator.isHidden = true
                                                        self.allCountersBtn.isHidden = false
                                                    }
                                                } else if (responseString == "1") {
                                                    self.sendPressed(uniq_num: uniq_num, count_name: count_name, ident: ident, predValue: predValue, predValue2: predValue2, predValue3: predValue3, tariffNumber: tariffNumber)
                                                }
                                                
        })
        
        task.resume()
    }
    var lastCheckupDate = ""
    func sendPressed(uniq_num: String, count_name: String, ident: String, predValue: String, predValue2: String, predValue3: String, tariffNumber: String) {
        //        print(isEditable())
//        if isEditable(){
            var metrId = ""
            for i in 0...self.numberArr.count - 1{
                print(self.ownerArr[i], nameArr[i] + ", " + unitArr[i], self.identArr[i])
                if uniq_num == self.ownerArr[i] && count_name == (nameArr[i] + ", " + unitArr[i]) && ident == self.identArr[i]{
                    metrId = self.numberArr[i]
                    autoSend = autoValueArr[i]
                    recheckInter = recheckInterArr[i]
                    lastCheckupDate = lastCheckArr[i]
                    selNumDec = numberDecimal[i]
                }
            }
            selTariffNumber = Int(tariffNumber)!
            selectedUniq = uniq_num
            selectedUniqName = count_name
            countIdent = ident
            predVal1 = predValue
            predVal2 = predValue2
            predVal3 = predValue3
            self.metrID = metrId
            DispatchQueue.main.async{
                self.counterIndicator.stopAnimating()
                self.counterIndicator.isHidden = true
                self.allCountersBtn.isHidden = false
                self.performSegue(withIdentifier: "addCounters", sender: self)
            }
//        }else{
//            DispatchQueue.main.async{
//                let alert = UIAlertController(title: "Ошибка", message: "Возможность передавать показания доступна с " + self.date1 + " по " + self.date2 + " числа текущего месяца!", preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
//                alert.addAction(cancelAction)
//                self.present(alert, animated: true, completion: nil)
//                self.counterIndicator.stopAnimating()
//                self.counterIndicator.isHidden = true
//                self.allCountersBtn.isHidden = false
//            }
//        }
    }
    var choiceIdent = ""
    func goPaysPressed(ident: String) {
        choiceIdent = ident
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "paysMytishi2", sender: self)
        #else
        self.performSegue(withIdentifier: "paysMytishi", sender: self)
        #endif
        //        self.performSegue(withIdentifier: "pays", sender: self)
    }
    
    func update() {
        getQuestions()
    }
    
    var oneCheck = 0
    
    var descText:String = ""
    var temaText:String = ""
    var type:String = ""
    var name_account:String = ""
    var id_account:String = ""
    var edLogin:String = ""
    var edPass:String = ""
    
    func addAppAction(checkService: Int, allService: Bool) {
//        self.startAnimation()
        name_account = UserDefaults.standard.string(forKey: "name")!
        id_account   = UserDefaults.standard.string(forKey: "id_account")!
        edLogin      = UserDefaults.standard.string(forKey: "login")!
        edPass       = UserDefaults.standard.string(forKey: "pass")!
        var consId   = ""
        let ident: String = UserDefaults.standard.string(forKey: "login")!.stringByAddingPercentEncodingForRFC3986() ?? ""
        if allService{
            DispatchQueue.main.async{
                self.serviceIndicator.startAnimating()
                self.serviceIndicator.isHidden = false
                self.servicePagerView.isHidden = true
            }
            descText = "Ваш заказ принят. В ближайшее время сотрудник свяжется с Вами для уточнения деталей " + serviceArr[checkService].name!
            temaText = serviceArr[checkService].name!.stringByAddingPercentEncodingForRFC3986() ?? ""
            type = serviceArr[checkService].id_requesttype!.stringByAddingPercentEncodingForRFC3986() ?? ""
            consId = serviceArr[checkService].id_account!.stringByAddingPercentEncodingForRFC3986() ?? ""
        }else{
            DispatchQueue.main.async{
                self.adIndicator.startAnimating()
                self.adIndicator.isHidden = false
                self.adPagerView.isHidden = true
            }
            descText = "Ваш заказ принят. В ближайшее время сотрудник свяжется с Вами для уточнения деталей " + serviceAdBlock[checkService].name!
            temaText = serviceAdBlock[checkService].name!.stringByAddingPercentEncodingForRFC3986() ?? ""
            type = serviceAdBlock[checkService].id_requesttype!.stringByAddingPercentEncodingForRFC3986() ?? ""
            consId = serviceAdBlock[checkService].id_account!.stringByAddingPercentEncodingForRFC3986() ?? ""
        }
        descText = descText.stringByAddingPercentEncodingForRFC3986() ?? ""
        let urlPath = Server.SERVER + Server.ADD_APP +
            "ident=" + ident +
            "&name=" + temaText +
            "&text=" + descText +
            "&type=" + type +
            "&priority=" + "2" +
            "&phonenum=" + ident +
            "&consultantId=" + consId
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        print("RequestURL: ", request.url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
//                                                        self.stopAnimation()
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
                                                        self.view.isUserInteractionEnabled = true
                                                    })
                                                    if allService{
                                                        DispatchQueue.main.async{
                                                            self.serviceIndicator.stopAnimating()
                                                            self.serviceIndicator.isHidden = true
                                                            self.servicePagerView.isHidden = false
                                                        }
                                                    }else{
                                                        DispatchQueue.main.async{
                                                            self.adIndicator.stopAnimating()
                                                            self.adIndicator.isHidden = true
                                                            self.adPagerView.isHidden = false
                                                        }
                                                    }
                                                    return
                                                }
                                                
                                                self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(self.responseString)")
                                                
                                                self.choice(allService: allService)
        })
        task.resume()
        
    }
        
    func choice(allService: Bool) {
        if (responseString == "1") {
            DispatchQueue.main.async(execute: {
//                self.stopAnimation()
                let alert = UIAlertController(title: "Ошибка", message: "Не переданы обязательные параметры", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "2") {
            DispatchQueue.main.async(execute: {
//                self.stopAnimation()
                let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
//                self.stopAnimation()
                let alert = UIAlertController(title: "Ошибка", message: "Не удалось. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if Int(responseString) == nil || Int(responseString)! < 1{
            DispatchQueue.main.async(execute: {
//               self.stopAnimation()
               let alert = UIAlertController(title: "Ошибка", message: "Сервер не отвечает. Попробуйте позже", preferredStyle: .alert)
               let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
               alert.addAction(cancelAction)
               self.present(alert, animated: true, completion: nil)
            })
        } else {
//            if self.images.count != 0{
                self.sendEmailFile()
//            }
            DispatchQueue.main.async(execute: {
                
                // все ок - запишем заявку в БД (необходимо получить и записать авт. комментарий в БД
                // Запишем заявку в БД
                let db = DB()
                db.add_app(id: 1, number: self.responseString, text: self.descText, tema: self.temaText, date: self.date_teck()!, adress: "", flat: "", phone: "", owner: self.name_account, is_close: 1, is_read: 1, is_answered: 1, type_app: self.type, serverStatus: "новая заявка")
                db.getComByID(login: self.edLogin, pass: self.edPass, number: self.responseString)
                
//                self.stopAnimation()
                
                let alert = UIAlertController(title: "Успешно", message: "Создана заявка №" + self.responseString, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            })
        }
        DispatchQueue.main.async {
            if allService{
                self.serviceIndicator.stopAnimating()
                self.serviceIndicator.isHidden = true
                self.servicePagerView.isHidden = false
            }else{
                self.adIndicator.stopAnimating()
                self.adIndicator.isHidden = true
                self.adPagerView.isHidden = false
            }
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func date_teck() -> (String)? {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
        
    }
    
    var responseString = ""
    func sendEmailFile(){
        let reqID = responseString.stringByAddingPercentEncodingForRFC3986() ?? ""
        let urlPath = Server.SERVER + "MobileAPI/SendRequestToMail.ashx?" + "requestId=" + reqID
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        print(request)
    
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
//                                                        self.stopAnimation()
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
                                                        self.view.isUserInteractionEnabled = true
                                                    })
                                                    return
                                                }
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(responseString)")
                                                
        })
        task.resume()
    }
}

class HomeLSCell: UITableViewCell {
    
    var delegate: DebtCellDelegate?
    var delegate2: DelLSCellDelegate?
    
    @IBOutlet weak var lsText: UILabel!
    @IBOutlet weak var addressText: UILabel!
    
    @IBOutlet weak var noDebtText: UILabel!
    @IBOutlet weak var periodPay: UILabel!
    @IBOutlet weak var allPayText: UILabel!
    @IBOutlet weak var topPeriodConst: NSLayoutConstraint!
    @IBOutlet weak var bottViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sumInfo: UILabel!
    @IBOutlet weak var sumText: UILabel!
    @IBOutlet weak var sumViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var separator: UILabel!
    @IBOutlet weak var payDebt: UIButton!
    @IBOutlet weak var payDebtHeight: NSLayoutConstraint!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var del_ls_btn: UIButton!
    @IBOutlet weak var insurance_btn: UIButton!
    @IBOutlet weak var insuranceLbl: UILabel!
    @IBOutlet weak var insurance_btnHeight: NSLayoutConstraint!
    @IBOutlet weak var insuranceLblHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func insuranceAction(_ sender: UIButton) {
        let url  = NSURL(string: "http://sm-center.ru/vsk_polis.pdf")
        if UIApplication.shared.canOpenURL(url! as URL) == true  {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        let str = lsText.text!
        delegate?.goPaysPressed(ident: str.replacingOccurrences(of: "№ ", with: ""))
    }
    @IBAction func delAction(_ sender: UIButton) {
        let str = lsText.text!
        delegate2?.try_del_ls_from_acc(ls: str.replacingOccurrences(of: "№ ", with: ""))
    }
}

class HomeNewsCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var textQuestion: UILabel!
    @IBOutlet weak var openNews: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class HomeCounterCell: UITableViewCell {
    
    var delegate: CountersCellDelegate?
    var tariffNumber = "0"
    var ident = ""
    // Поверка и интервал
    @IBOutlet weak var checkup_date: UILabel!
    @IBOutlet weak var recheckup_diff: UILabel!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var imgCounter: UIImageView!
    @IBOutlet weak var viewImgCounter: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var numberView:  UIView!
    @IBOutlet weak var identView:   UIView!
    @IBOutlet weak var checkView:   UIView!
    @IBOutlet weak var recheckView: UIView!
    
    @IBOutlet weak var numberHeight:    NSLayoutConstraint!
    @IBOutlet weak var identHeight:     NSLayoutConstraint!
    @IBOutlet weak var chechHeight:     NSLayoutConstraint!
    @IBOutlet weak var recheckHeight:   NSLayoutConstraint!
    
    @IBOutlet weak var pred1: UILabel!
    @IBOutlet weak var teck1: UILabel!
    @IBOutlet weak var diff1: UILabel!
    
    @IBOutlet weak var predPoint1: UILabel!
    @IBOutlet weak var teckPoint1: UILabel!
    @IBOutlet weak var diffPoint1: UILabel!
    
    @IBOutlet weak var pred2: UILabel!
    @IBOutlet weak var teck2: UILabel!
    @IBOutlet weak var diff2: UILabel!
    
    @IBOutlet weak var predPoint2: UILabel!
    @IBOutlet weak var teckPoint2: UILabel!
    @IBOutlet weak var diffPoint2: UILabel!
    
    @IBOutlet weak var pred3: UILabel!
    @IBOutlet weak var teck3: UILabel!
    @IBOutlet weak var diff3: UILabel!
    
    @IBOutlet weak var predPoint3: UILabel!
    @IBOutlet weak var teckPoint3: UILabel!
    @IBOutlet weak var diffPoint3: UILabel!
    
    @IBOutlet weak var predLbl1: UILabel!
    @IBOutlet weak var teckLbl1: UILabel!
    @IBOutlet weak var diffLbl1: UILabel!
    
    @IBOutlet weak var predLbl2: UILabel!
    @IBOutlet weak var teckLbl2: UILabel!
    @IBOutlet weak var diffLbl2: UILabel!
    
    @IBOutlet weak var predLbl3: UILabel!
    @IBOutlet weak var teckLbl3: UILabel!
    @IBOutlet weak var diffLbl3: UILabel!
    
    @IBOutlet weak var nonCounterOne1: UIImageView!
    @IBOutlet weak var nonCounterTwo1: UIImageView!
    @IBOutlet weak var nonCounterThree1: UIImageView!
    
    @IBOutlet weak var nonCounterOne2: UIImageView!
    @IBOutlet weak var nonCounterTwo2: UIImageView!
    @IBOutlet weak var nonCounterThree2: UIImageView!
    
    @IBOutlet weak var nonCounterOne3: UIImageView!
    @IBOutlet weak var nonCounterTwo3: UIImageView!
    @IBOutlet weak var nonCounterThree3: UIImageView!
    
    @IBOutlet weak var tariff2: UIView!
    @IBOutlet weak var tariff3: UIView!
    
    @IBOutlet weak var tariffHeight2: NSLayoutConstraint!
    @IBOutlet weak var tariffHeight3: NSLayoutConstraint!
    
    @IBOutlet weak var tariffOneHeight: NSLayoutConstraint!
    @IBOutlet weak var tariffOne: UILabel!
    @IBOutlet weak var tariffTwo: UILabel!
    @IBOutlet weak var tariffThree: UILabel!
    
    @IBOutlet weak var errorTextOne1: UILabel!
    @IBOutlet weak var errorTextTwo1: UILabel!
    @IBOutlet weak var errorTextThree1: UILabel!
    @IBOutlet weak var errorTextOne2: UILabel!
    @IBOutlet weak var errorTextTwo2: UILabel!
    @IBOutlet weak var errorTextThree2: UILabel!
    @IBOutlet weak var errorTextOne3: UILabel!
    @IBOutlet weak var errorTextTwo3: UILabel!
    @IBOutlet weak var errorTextThree3: UILabel!
    
    @IBOutlet weak var errorOneHeight1: NSLayoutConstraint!
    @IBOutlet weak var errorTwoHeight1: NSLayoutConstraint!
    @IBOutlet weak var errorThreeHeight1: NSLayoutConstraint!
    @IBOutlet weak var errorOneHeight2: NSLayoutConstraint!
    @IBOutlet weak var errorTwoHeight2: NSLayoutConstraint!
    @IBOutlet weak var errorThreeHeight2: NSLayoutConstraint!
    @IBOutlet weak var errorOneHeight3: NSLayoutConstraint!
    @IBOutlet weak var errorTwoHeight3: NSLayoutConstraint!
    @IBOutlet weak var errorThreeHeight3: NSLayoutConstraint!
    
    @IBOutlet weak var separator: UILabel!
    
    @IBOutlet weak var lblHeight11: NSLayoutConstraint!
    @IBOutlet weak var lblHeight12: NSLayoutConstraint!
    @IBOutlet weak var lblHeight13: NSLayoutConstraint!
    @IBOutlet weak var lblHeight14: NSLayoutConstraint!
    
    @IBOutlet weak var lblHeight21: NSLayoutConstraint!
    @IBOutlet weak var lblHeight22: NSLayoutConstraint!
    @IBOutlet weak var lblHeight23: NSLayoutConstraint!
    @IBOutlet weak var lblHeight24: NSLayoutConstraint!
    
    @IBOutlet weak var lblHeight31: NSLayoutConstraint!
    @IBOutlet weak var lblHeight32: NSLayoutConstraint!
    @IBOutlet weak var lblHeight33: NSLayoutConstraint!
    @IBOutlet weak var lblHeight34: NSLayoutConstraint!
    @IBOutlet weak var sendBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var autoLbl: UILabel!
    @IBOutlet weak var autoLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var can_count_label: UILabel!
    @IBOutlet weak var canCountHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        delegate?.сheckSend(uniq_num: number.text!, count_name: name.text!, ident: ident, predValue: pred1.text!, predValue2: pred2.text!, predValue3: pred3.text!, tariffNumber: tariffNumber)
        //        delegate?.sendPressed(uniq_num: number.text!, count_name: name.text!, ident: ident.text!, predValue: pred.text!)
    }
}

class HomeAppsCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var nameApp: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var goApp: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class HomeQuestionsCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var nameQuestion: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var questionsCount: UILabel!
    @IBOutlet weak var goQuestion: UIButton!
    @IBOutlet weak var separator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func goQuestions(_ sender: UIButton) {
        delegate!.performSegue(withIdentifier: "go_answers", sender: self)
    }
}

class HomeWebCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var webText: UILabel!
    @IBOutlet weak var goWeb: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class HomeServiceCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var serviceText: UILabel!
    @IBOutlet weak var separator1: UILabel!
    @IBOutlet weak var urlHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneHeight: NSLayoutConstraint!
    @IBOutlet weak var imgUrlHeight: NSLayoutConstraint!
    @IBOutlet weak var imgPhoneHeight: NSLayoutConstraint!
    @IBOutlet weak var constant1: NSLayoutConstraint!
    @IBOutlet weak var constant2: NSLayoutConstraint!
    @IBOutlet weak var urlBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var imgUrl: UIImageView!
    @IBOutlet weak var imgPhone: UIImageView!
    @IBAction func urlBtnPressed(_ sender: UIButton) {
        let url = URL(string: (urlBtn.titleLabel?.text)!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @IBAction func phoneBtnPressed(_ sender: UIButton) {
        let newPhone = phoneBtn.titleLabel?.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        if let url = URL(string: "tel://" + newPhone!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

class HomeReceiptsCell: UITableViewCell {
    
    var delegate: UIViewController?
    var delegate2: GoUrlReceiptDelegate?
    
    @IBOutlet weak var receiptText: UILabel!
    @IBOutlet weak var goReceipt: UIButton!
    @IBOutlet weak var receiptSum: UILabel!
    @IBOutlet weak var separator: UILabel!
    @IBOutlet weak var ident:     UILabel!
    
    @IBAction func urlBtnPressed(_ sender: UIButton) {
        delegate2?.goUrlReceipt(url: separator.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class StockCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

struct lsData {
    
    let ident: String?
    let sum: String?
    let sumFine: String?
    let date: String?
    let address: String?
    let insuranceSum: String?
    let houseId: String?
    let inn: String?
    
    init(ident: String?, sum: String?, sumFine: String?, date:String?, address: String?, insuranceSum: String?, houseId: String?, inn: String?) {
        self.ident = ident
        self.sum = sum
        self.sumFine = sumFine
        self.date = date
        self.address = address
        self.insuranceSum = insuranceSum
        self.houseId = houseId
        self.inn = inn
    }
}

func getAge(age: String) -> String {
    
    if (age == "") {
        return "";
    } else {
        
        let age_int = Int(age)
        if (age_int == 1) {
            return " год"
        } else if (age_int == 2) {
            return " года"
        } else if (age_int == 2) {
            return " года"
        } else if (age_int == 2) {
            return " года"
        } else {
            return " лет"
        }
        
    }
    
}
