//
//  NotificationController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 25/06/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import Crashlytics
import Gloss
import SwiftyXMLParser

class NotificationController: UIViewController, QuestionTableDelegate {
    func update() {
        print("")
    }

    @IBOutlet weak var targetName: UILabel!
    @IBOutlet weak var elipseBackground: UIView!
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var btn_name_1: UIButton!
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var btnApp: UIButton!
    @IBOutlet weak var img_mail: UIImageView!
    
    @IBOutlet weak var serviceBtn: UIButton!
    @IBOutlet weak var serviceHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceIMG: UIImageView!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    var phone: String?
    var questionID: Int?
    var serviceID: Int?
    private var questions: [QuestionDataJson]? = []
    
    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    
    @IBAction func goAnswers(_ sender: UIButton) {
        startAnimation()
        DispatchQueue.main.async{
            self.questionBtn.isHidden = false
        }
        getQuestions()
    }
    
    @IBAction func goService(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goService", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("Notifi", forKey: "last_UI_action")
        let defaults = UserDefaults.standard
        phone = defaults.string(forKey: "phone_operator")
        var phone1 = defaults.string(forKey: "phone_operator")
        if phone1?.first == "8" && phone1!.count > 10{
            phone1?.removeFirst()
            phone1 = "+7" + phone1!
        }
        var phoneOperator = ""
        if phone1!.count > 10{
            phone1 = phone1?.replacingOccurrences(of: " ", with: "")
            phone1 = phone1?.replacingOccurrences(of: "-", with: "")
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
            }else{
                phoneOperator = phone1!
            }
        }else{
            phoneOperator = phone1!
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
        #elseif isTSJ_Life
        fon_top.image = UIImage(named: "Logo_TSJ_Life")
        #elseif isSouthValley
        fon_top.image = UIImage(named: "Logo_SouthValley")
        #elseif isRamenLefortovo
        fon_top.image = UIImage(named: "Logo_RamenLefortovo")
        #elseif isVestSnab
        fon_top.image = UIImage(named: "Logo_VestSnab")
        #endif
        loader.color = myColors.btnColor.uiColor()
        questionBtn.backgroundColor = myColors.btnColor.uiColor()
        questionID = UserDefaults.standard.integer(forKey: "notifiQuestID")
        serviceID = UserDefaults.standard.integer(forKey: "notifiServiceID")
        if serviceID! > 0{
            let login = UserDefaults.standard.string(forKey: "login")
            let pass  = UserDefaults.standard.string(forKey: "pass")
            if login != nil && pass != nil{
                get_Services(login: login ?? "", pass: pass ?? "")
                loader.isHidden = false
                loader.startAnimating()
            }
        }else{
            self.serviceHeight.constant = 0
            self.serviceIMG.isHidden = true
            self.serviceBtn.isHidden = true
        }
        if questionID! > 0{
            questionBtn.isHidden = false
            btnHeight.constant = 40
            loader.isHidden = true
        }else{
            questionBtn.isHidden = true
            btnHeight.constant = 0
            loader.isHidden = true
        }
        btn_name_1.setTitle(phoneOperator, for: .normal)
        targetName.text = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String)
        
        img_mail.setImageColor(color: myColors.btnColor.uiColor())
        elipseBackground.backgroundColor = myColors.btnColor.uiColor()
        btnGo.backgroundColor = myColors.btnColor.uiColor()
        btnApp.backgroundColor = myColors.btnColor.uiColor()
        supportBtn.tintColor = myColors.btnColor.uiColor()
        if self.view.frame.size.width < 375{
            btnApp.setTitle("   Зайти в приложение", for: .normal)
        }else{
            btnApp.setTitle("Зайти в приложение", for: .normal)
        }
        if UserDefaults.standard.string(forKey: "titleNotifi") != nil{
            titleText?.text = UserDefaults.standard.string(forKey: "titleNotifi")!
        }
        if UserDefaults.standard.string(forKey: "bodyNotifi") != nil{
            bodyText?.text = UserDefaults.standard.string(forKey: "bodyNotifi")!
        }
        UserDefaults.standard.set("", forKey: "bodyNotifi")
        UserDefaults.standard.set("", forKey: "titleNotifi")
        UserDefaults.standard.synchronize()
        // Do any additional setup after loading the view.
    }
    
    func startAnimation(){
        DispatchQueue.main.async{
            self.loader.startAnimating()
            self.loader.isHidden = false
//            self.questionBtn.isHidden = true
        }
    }
    
    func stopAnimation(){
        DispatchQueue.main.async{
            self.loader.stopAnimating()
            self.loader.isHidden = true
//            self.questionBtn.isHidden = false
        }
    }
    
    func getQuestions() {
//        let id = UserDefaults.standard.string(forKey: "id_account") ?? ""
        let phone = UserDefaults.standard.string(forKey: "phone") ?? ""
    //        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "accID=" + id)!)
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "phone=" + phone)!)
        request.httpMethod = "GET"
        print(request)
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
            guard data != nil else { return }
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//            print("responseString = \(responseString)")

            if let json = try? JSONSerialization.jsonObject(with: data!,
                                                            options: .allowFragments){
                let unfilteredData = QuestionsJson(json: json as! JSON)?.data
                var filtered: [QuestionDataJson] = []
                unfilteredData?.forEach { json in

                    var isContains = true
                    json.questions?.forEach {
                        if !$0.isCompleteByUser! {
                            isContains = false
                        }
                    }
                    if !isContains {
                        filtered.append(json)
                    }
                }
                self.questions = filtered
            }
            var questTrue = false
            self.questions!.forEach{
                if $0.id! == self.questionID{
                    questTrue = true
                    self.stopAnimation()
                    DispatchQueue.main.async{
                        self.questionBtn.isHidden = false
                        self.performSegue(withIdentifier: "go_answers", sender: self)
                    }
                }
            }
            if !questTrue{
                self.stopAnimation()
                DispatchQueue.main.async{
                    self.questionBtn.isHidden = false
                    let alert = UIAlertController(title: "Ошибка", message: "Опрос не найден", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            }.resume()
    }
    
    var serviceArr: [Services] = []
    var currService = -1
    var mainScreenXml:  XML.Accessor?
    func get_Services(login: String, pass: String){
        serviceArr.removeAll()
//            let urlPath = "http://uk-gkh.org/gbu_lefortovo/GetAdditionalServices.ashx?login=qw&pwd=qw"
        let urlPath = Server.SERVER + Server.GET_ADDITIONAL_SERVICES + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        DispatchQueue.global(qos: .userInteractive).async {
            var request = URLRequest(url: URL(string: urlPath)!)
            request.httpMethod = "GET"
            print(request)
            
            URLSession.shared.dataTask(with: request) {
                data, error, responce in
                
                guard data != nil else { return }
                //                let responseString = String(data: data!, encoding: .utf8) ?? ""
                //                #if DEBUG
                //                print("responseString = \(responseString)")
                //                #endif
                let xml = XML.parse(data!)
                self.mainScreenXml = xml
                let requests = xml["AdditionalServices"]
                let row = requests["Group"]
                row.forEach { row in
                    row["AdditionalService"].forEach {
                        self.serviceArr.append(Services(row: $0))
                    }
                }
                for i in 0...self.serviceArr.count - 1{
                    if Int(self.serviceArr[i].id ?? "") == self.serviceID{
                        let url:NSURL = NSURL(string: (self.serviceArr[i].logo)!)!
                        let data = try? Data(contentsOf: url as URL)
                        if UIImage(data: data!) == nil{
                            DispatchQueue.main.async{
                                self.serviceHeight.constant = 0
                                self.serviceIMG.isHidden = true
                                self.serviceBtn.isHidden = true
                            }
                        }else{
                            DispatchQueue.main.async{
                                self.currService = i
                                self.serviceIMG.isHidden = false
                                if self.serviceArr[i].canbeordered == "1" && self.serviceArr[i].id_requesttype != "" && self.serviceArr[i].id_account != ""{
                                    self.serviceBtn.isHidden = false
                                }else{
                                    self.serviceBtn.isHidden = true
                                }
                                self.serviceHeight.constant = (self.view.frame.size.width - 30) / 2
                                self.serviceIMG.image = UIImage(data: data!)
                            }
                        }
                    }
                }
                DispatchQueue.main.async{
                    self.loader.stopAnimating()
                    self.loader.isHidden = true
                }
            }.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go_answers" {
            //            let vc = segue.destination as! QuestionAnswerVC
            //            vc.title = questionArr[indexQuestion].name
            //            vc.question_ = questionArr[indexQuestion]
            //            //            vc.delegate = delegate
            //            vc.questionDelegate = self
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! QuestionsTableVC
            var question: QuestionDataJson?
            questions!.forEach{
                if $0.id! == questionID{
                    question = $0
                }
            }
            vc.questionTitle = question?.name ?? ""
            vc.question_ = question
            //            vc.delegate = delegate
            vc.questionDelegate = self
        }
        if (segue.identifier == "goService") {
            let AddApp = segue.destination as! AdditionalVC
            AddApp.item = serviceArr[currService]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func go_exit(_ sender: UIButton) {
        exit(0)
    }
    
    @IBAction func go_app(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goApp", sender: self)
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
