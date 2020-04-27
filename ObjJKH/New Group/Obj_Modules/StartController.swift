//
//  StartController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 03.10.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Foundation

class StartController: UIViewController {
    
    var responseLS: String?
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var progress: UIProgressView!
    var progressValue = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "newApps")
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
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
        fon_top.image = UIImage(named: "Logo_Tafgai")
        #elseif isServiceKomfort
        fon_top.image = UIImage(named: "Logo_ServiceKomfort")
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
        #endif
//        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.standard.set("", forKey: "errorStringSupport")
        UserDefaults.standard.set(true, forKey: "can_tech")
        UserDefaults.standard.synchronize()
//        self.perform(#selector(updateProgress), with: nil, afterDelay: 0.01)
        UserDefaults.standard.set(false, forKey: "successParse")
        UserDefaults.standard.set(false, forKey: "NewMain")
        UserDefaults.standard.removeObject(forKey: "newsKol")
        UserDefaults.standard.removeObject(forKey: "appsKol")
        UserDefaults.standard.set(0, forKey: "newsKol")
        UserDefaults.standard.set(0, forKey: "appsKol")
        // Запустим подгрузку настроек
        getSettings()
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: Network.reachability)
        updateUserInterface()
    }
    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "Ошибка загрузки данных", message: "Проверьте соединение с интернетом", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Повторить", style: .default) { (_) -> Void in
                self.viewDidLoad()
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            })
        case .wifi: break
            
        case .wwan: break
            
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
//    @objc func updateProgress() {
//        progressValue = progressValue + 0.01
//        self.progress.progress = Float(progressValue)
//        if progressValue != 1.0 {
//            self.perform(#selector(updateProgress), with: nil, afterDelay: 0.01)
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .flagsChanged, object: Network.reachability)
    }

    
    // ЗАГРУЗИМ НАСТРОЙКИ С СЕРВЕРА
    func getSettings() {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        var urlPath = Server.SERVER + Server.GET_MOBILE_MENU + "appVersionIOS=" + version
        #if isUpravdomChe
        urlPath = Server.SERVER + Server.GET_MOBILE_MENU + "appVersionIOS=" + version + "&dontCheckAppBlocking=1"
        #endif
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                guard data != nil else { return }
                                                if error != nil {
                                                    return
                                                }
                                                
                                                self.responseLS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//                                                self.responseLS = "обновить"
                                                print("Response: \(self.responseLS!)")
                                                if (self.responseLS?.contains("обновить"))!{
                                                    self.updateApp = true
                                                    self.getSettings2()
                                                }else{
                                                    self.setSettings()
                                                }
        })
        task.resume()
        
    }
    
    func getSettings2() {
        var urlPath = Server.SERVER + Server.GET_MOBILE_MENU
        #if isUpravdomChe
        urlPath = Server.SERVER + Server.GET_MOBILE_MENU + "dontCheckAppBlocking=1"
        #endif
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        //        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    return
                                                }
                                                
                                                self.responseLS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("Response: \(self.responseLS!)")
                                                self.setSettings()
        })
        task.resume()
        
    }
    
    var updateApp = false
    var tech_now = false
    func setSettings() {
        DispatchQueue.main.sync {
            if (self.responseLS?.contains("color"))! && (self.responseLS?.contains("enableOSS"))! &&
                (self.responseLS?.contains("menu"))! && (self.responseLS?.contains("useDispatcherAuth"))! &&
                (self.responseLS?.contains("showAds"))! && (self.responseLS?.contains("adsType"))! &&
                (self.responseLS?.contains("servicePercent"))! && (self.responseLS?.contains("adsCodeIOS"))! &&
                (self.responseLS?.contains("DontShowDebt"))! && (self.responseLS?.contains("registerWithoutSMS"))! &&
                (self.responseLS?.contains("сheckCrashSystem"))!{
                let inputData = self.responseLS?.data(using: .utf8)!
                let decoder = JSONDecoder()
                let stat = try! decoder.decode(MenuData.self, from: inputData!)
                self.set_settings(oss: stat.enableOSS, color: stat.color, statMenu: stat.menu, useDispatcherAuth: stat.useDispatcherAuth, showAds: stat.showAds, adType: stat.adsType, servPercent: stat.servicePercent, adsCode: stat.adsCodeIOS, dontShowDebt: stat.DontShowDebt, registerWithoutSMS: stat.registerWithoutSMS, сheckCrashSystem: stat.сheckCrashSystem)//stat.showAds  stat.adsType
            } else if (self.responseLS?.contains("No enter - tech work"))! {
                
                self.tech_now = true
            
            } else {
                UserDefaults.standard.set(self.responseLS, forKey: "errorStringSupport")
                UserDefaults.standard.synchronize()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен. \nОтвет с сервера: <" + self.responseLS! + ">", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) ->
                    Void in
                    self.getSettings()
                }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            if tech_now {
                self.start_tech_work()
            } else {
                if updateApp{
                    self.update_app()
                }else{
                    self.start_app()
                }
            }
        }
    }
    
    func start_tech_work() {
        self.performSegue(withIdentifier: "start_tech_work", sender: self)
    }
    
    func set_settings(oss: Bool, color: String, statMenu: [Menu], useDispatcherAuth: Bool, showAds: Bool, adType: Int, servPercent: Double, adsCode: String, dontShowDebt: Bool, registerWithoutSMS: Bool, сheckCrashSystem: Bool) {
        let defaults = UserDefaults.standard
        let launchedBefore = defaults.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            defaults.set(true, forKey: "launchedBefore")
            defaults.set(true, forKey: "exit")
        }
        if defaults.bool(forKey: "dontSavePass"){
            defaults.setValue("", forKey: "pass")
            defaults.set(true, forKey: "exit")
        }
        defaults.set(servPercent, forKey: "servPercent")
        defaults.removeObject(forKey: "show_Ad")//удалить через месяц
        defaults.setValue(color, forKey: "hex_color")
        defaults.setValue(oss, forKey: "enable_OSS")
        defaults.set(showAds, forKey: "show_Ad")
        defaults.set(adsCode, forKey: "adsCode")
        defaults.set(adType, forKey: "ad_Type")
        defaults.set(dontShowDebt, forKey: "dontShowDebt")
        defaults.set(registerWithoutSMS, forKey: "registerWithoutSMS")
        defaults.set(сheckCrashSystem, forKey: "сheckCrashSystem")
        var numb: Int = 0
        statMenu.forEach {
            defaults.setValue(String($0.id) + ";" + $0.name_app + ";" + String($0.visible)  + ";" + $0.simple_name, forKey: "menu_" + String(numb))
            numb = numb + 1
        }
        defaults.setValue(useDispatcherAuth, forKey: "useDispatcherAuth")
        defaults.synchronize()
    }
    
    @objc func update_app() {
//        if progressValue < 1.0 {
//            self.perform(#selector(update_app), with: nil, afterDelay: 0.01)
//        } else {
            self.performSegue(withIdentifier: "update_app", sender: self)
//        }
    }
    
    @objc func start_app() {
//        if progressValue < 1.0 {
//            self.perform(#selector(start_app), with: nil, afterDelay: 0.01)
//        } else {
            let defaults = UserDefaults.standard
            let login = defaults.string(forKey: "login")
            #if isDemoUC
                self.performSegue(withIdentifier: "start_app_OBJ", sender: self)
            #else
                if login == "" || login == nil{
//                    if UserDefaults.standard.bool(forKey: "registerWithoutSMS"){
                    if UIImage(named: "iPhone_touch_1") != nil{
                        self.performSegue(withIdentifier: "goMockup", sender: self)
                    }else{
                        if UserDefaults.standard.bool(forKey: "registerWithoutSMS"){
                            self.performSegue(withIdentifier: "reg_app2", sender: self)
                        }else{
                            self.performSegue(withIdentifier: "reg_app", sender: self)
                        }
                    }
//                    }else{
//                        self.performSegue(withIdentifier: "reg_app", sender: self)
//                    }
                }else{
                    if (defaults.bool(forKey: "windowCons")) {
                        self.performSegue(withIdentifier: "start_app_cons", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "start_app", sender: self)
                    }
                }
            #endif
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reg_app" {
            let nav = segue.destination as! UINavigationController
            let payController             = nav.topViewController as! Registration
            payController.firstEnter = true
        }
        if segue.identifier == "reg_app2" {
            let nav = segue.destination as! UINavigationController
            let payController             = nav.topViewController as! NewRegistration
            payController.firstEnter = true
        }
        if segue.identifier == "goMockup" {
            let payController = segue.destination as! MockupController
//            let payController             = nav.topViewController as! MockupController
            payController.firstEnter = true
        }
    }
    
    struct MenuData: Decodable {
        let enableOSS:          Bool
        let color:              String
        let menu:              [Menu]
        let useDispatcherAuth:  Bool
        let showAds:            Bool
        let adsType:            Int
        let servicePercent:     Double
        let adsCodeIOS:         String
        let DontShowDebt:       Bool
        let registerWithoutSMS: Bool
        let сheckCrashSystem:   Bool
    }
    
    struct Menu: Decodable {
        let id: Int
        let name_app: String
        let visible: Int
        let simple_name: String
    }
    
}

public class targetSettings{
    var version = ""
    func getVersion() -> String{
        let dictionary = Bundle.main.infoDictionary!
        version = dictionary["CFBundleShortVersionString"] as! String
        return version
    }
}
