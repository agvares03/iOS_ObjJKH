//
//  SupportUpdate.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 19/07/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class SupportUpdate: UIViewController {
    
    @IBOutlet weak var imageApp:        UIImageView!
    @IBOutlet weak var updateBtn:       UIButton!
    @IBOutlet weak var indicatorUpd:    UIActivityIndicatorView!
    @IBOutlet weak var updLbl:          UILabel!
    @IBOutlet weak var updView:         UIView!
    @IBOutlet weak var goLbl:           UILabel!
    @IBOutlet weak var infoLbl:         UILabel!
    
    public var fromMenu = false
    public var fromAuth = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorUpd.color = myColors.indicatorColor.uiColor()
        updLbl.textColor = myColors.indicatorColor.uiColor()
        self.imageApp.isHidden = true
        self.updateBtn.isHidden = true
        self.goLbl.isHidden = true
        self.infoLbl.isHidden = true
        self.updView.isHidden = false
        
        self.indicatorUpd.startAnimating()
        self.indicatorUpd.isHidden = false
        #if isOur_Obj_Home
        imageApp.image = UIImage(named: "logo_Our_Obj_Home_white")
        #elseif isChist_Dom
        imageApp.image = UIImage(named: "Logo_Chist_Dom_White")
        #elseif isMupRCMytishi
        imageApp.image = UIImage(named: "logo_MupRCMytishi_White")
        #elseif isDJ
        imageApp.image = UIImage(named: "logo_DJ_White")
        #elseif isStolitsa
        imageApp.image = UIImage(named: "logo_Stolitsa_white")
        #elseif isKomeks
        imageApp.image = UIImage(named: "Logo_Komeks_White")
        #elseif isUKKomfort
        imageApp.image = UIImage(named: "logo_UK_Komfort_white")
        #elseif isKlimovsk12
        imageApp.image = UIImage(named: "logo_Klimovsk12_White")
        #elseif isPocket
        imageApp.image = UIImage(named: "Logo_Pocket_White")
        #elseif isReutKomfort
        imageApp.image = UIImage(named: "Logo_ReutKomfort_White")
        #elseif isUKGarant
        imageApp.image = UIImage(named: "Logo_UK_Garant_White")
        #elseif isSoldatova1
        imageApp.image = UIImage(named: "Logo_Soldatova_White")
        #elseif isTafgai
        imageApp.image = UIImage(named: "Logo_Tafgai_White")
        #elseif isServiceKomfort
        imageApp.image = UIImage(named: "Logo_ServiceKomfort_White")
        #elseif isParitet
        imageApp.image = UIImage(named: "Logo_Paritet")
        #elseif isSkyfort
        imageApp.image = UIImage(named: "Logo_Skyfort")
        #elseif isStandartDV
        imageApp.image = UIImage(named: "Logo_StandartDV")
        #elseif isGarmonia
        imageApp.image = UIImage(named: "Logo_UkGarmonia")
        #elseif isUpravdomChe
        imageApp.image = UIImage(named: "Logo_UkUpravdomChe")
        #elseif isJKH_Pavlovskoe
        imageApp.image = UIImage(named: "Logo_JKH_Pavlovskoe")
        #elseif isPerspectiva
        imageApp.image = UIImage(named: "Logo_UkPerspectiva")
        #elseif isParus
        imageApp.image = UIImage(named: "Logo_Parus")
        #elseif isUyutService
        imageApp.image = UIImage(named: "Logo_UyutService")
        #elseif isElectroSbitSaratov
        imageApp.image = UIImage(named: "Logo_ElectrosbitSaratov")
        #elseif isServicekom
        imageApp.image = UIImage(named: "Logo_Servicekom")
        #elseif isTeplovodoresources
        imageApp.image = UIImage(named: "Logo_Teplovodoresources")
        #elseif isStroimBud
        imageApp.image = UIImage(named: "Logo_StroimBud")
        #elseif isRodnikMUP
        imageApp.image = UIImage(named: "Logo_RodnikMUP")
        #elseif isUKParitetKhab
        imageApp.image = UIImage(named: "Logo_Paritet")
        #elseif isAFregat
        imageApp.image = UIImage(named: "Logo_Fregat")
        #elseif isNewOpaliha
        imageApp.image = UIImage(named: "Logo_NewOpaliha")
        #elseif isPritomskoe
        imageApp.image = UIImage(named: "Logo_Pritomskoe")
        #elseif isDJVladimir
        imageApp.image = UIImage(named: "Logo_DJVladimir")
        #elseif isTSN_Dnestr
        imageApp.image = UIImage(named: "Logo_TSN_Dnestr")
        #elseif isCristall
        imageApp.image = UIImage(named: "Logo_Cristall")
        #elseif isNarianMarEl
        imageApp.image = UIImage(named: "Logo_Narian_Mar_El")
        #elseif isSibAliance
        imageApp.image = UIImage(named: "Logo_SibAliance")
        #elseif isSpartak
        imageApp.image = UIImage(named: "Logo_Spartak")
        #elseif isTSN_Ruble40
        imageApp.image = UIImage(named: "Logo_Ruble40")
        #elseif isKosm11
        imageApp.image = UIImage(named: "Logo_Kosm11")
        #elseif isTSJ_Rachangel
        imageApp.image = UIImage(named: "Logo_TSJ_Archangel")
        #elseif isMUP_IRKC
        imageApp.image = UIImage(named: "Logo_MUP_IRKC")
        #elseif isUK_First
        imageApp.image = UIImage(named: "Logo_Uk_First")
        #elseif isRKC_Samara
        imageApp.image = UIImage(named: "Logo_Samara")
        #elseif isEnergoProgress
        imageApp.image = UIImage(named: "Logo_EnergoProgress")
        #elseif isMurmanskPartnerPlus
        imageApp.image = UIImage(named: "Logo_Murmansk")
        #elseif isEasyLife
        imageApp.image = UIImage(named: "Logo_EasyLife")
        #elseif isRIC
        imageApp.image = UIImage(named: "Logo_RIC")
        #elseif isMonolit
        imageApp.image = UIImage(named: "Logo_Monolit")
        #endif
        updateBtn.backgroundColor = myColors.indicatorColor.uiColor()
        goLbl.textColor = myColors.indicatorColor.uiColor()
        let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Вернуться назад", attributes: underlineAttribute)
        goLbl.attributedText = underlineAttributedString
        let tap = UITapGestureRecognizer(target: self, action: #selector(lblTapped(_:)))
        goLbl.isUserInteractionEnabled = true
        goLbl.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        checkUpd()
    }
    
    func checkUpd(){
        DispatchQueue.main.async {
            self.imageApp.isHidden = true
            self.updateBtn.isHidden = true
            self.goLbl.isHidden = true
            self.infoLbl.isHidden = true
            self.updView.isHidden = false
            
            self.indicatorUpd.startAnimating()
            self.indicatorUpd.isHidden = false
        }
        self.getSettings()
    }
    
    func falseUpd(){
        DispatchQueue.main.async {
            self.imageApp.isHidden = false
            self.updateBtn.isHidden = false
            self.goLbl.isHidden = false
            self.infoLbl.isHidden = false
            self.updView.isHidden = true
            
            self.indicatorUpd.stopAnimating()
            self.indicatorUpd.isHidden = true
        }
    }
    
    func getSettings() {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let urlPath = Server.SERVER + Server.GET_MOBILE_MENU + "appVersionIOS=" + version
        //        let urlPath = Server.SERVER + Server.GET_MOBILE_MENU + "appVersionIOS=1.01"
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    return
                                                }
                                                
                                                let responseLS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("Response: \(responseLS)")
                                                
                                                if (responseLS.contains("обновить")){
                                                    self.falseUpd()
                                                }else{
//                                                    self.falseUpd()
                                                    DispatchQueue.main.async {
                                                        self.updView.isHidden = true
                                                        self.goSupport = true
                                                        self.performSegue(withIdentifier: "goSupport", sender: self)
                                                    }
                                                }
        })
        task.resume()
        
    }
    var goSupport = false
    @objc private func lblTapped(_ sender: UITapGestureRecognizer) {
        if UserDefaults.standard.bool(forKey: "fromMenu") || fromMenu{
            navigationController?.popViewController(animated: true)
            
        } else if UserDefaults.standard.bool(forKey: "fromTech") {
            
            navigationController?.popViewController(animated: true)
            
        }else{
            navigationController?.dismiss(animated: true, completion: nil)
        }
//        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if goSupport{
            if UserDefaults.standard.bool(forKey: "fromMenu") || fromMenu{
                navigationController?.popViewController(animated: true)
                
            } else if UserDefaults.standard.bool(forKey: "fromTech") {
                
                navigationController?.popViewController(animated: true)
                
            }else{
                navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func BtnAction(_ sender: UIButton) {
        var str = "itms-apps://itunes.apple.com/ru/app/id1244651746"
        
        #if isOur_Obj_Home
        str = "itms-apps://itunes.apple.com/ru/app/id1416407000"
        #elseif isChist_Dom
        str = "itms-apps://itunes.apple.com/ru/app/id1367428705"
        #elseif isMupRCMytishi
        str = "itms-apps://itunes.apple.com/us/app/id1435033312"
        #elseif isDJ
        str = "itms-apps://itunes.apple.com/ru/app/id1159204339"
        #elseif isStolitsa
        str = "itms-apps://itunes.apple.com/ru/app/id1437129214"
        #elseif isKomeks
        str = "itms-apps://itunes.apple.com/ru/app/id1339478561"
        #elseif isUKKomfort
        str = "itms-apps://itunes.apple.com/ru/app/id1369729534"
        #elseif isKlimovsk12
        str = "itms-apps://itunes.apple.com/ru/app/id1420424696"
        #elseif isPocket
        str = "itms-apps://itunes.apple.com/ru/app/id1290134819"
        #elseif isReutKomfort
        str = "itms-apps://itunes.apple.com/ru/app/id1454260301"
        #elseif isUKGarant
        str = "itms-apps://itunes.apple.com/ru/app/id1420424696"
        #elseif isSoldatova1
        str = "itms-apps://itunes.apple.com/ru/app/id1458565611"
        #elseif isTafgai
        str = "itms-apps://itunes.apple.com/ru/app/id1458579800"
        #elseif isServiceKomfort
        str = "itms-apps://itunes.apple.com/ru/app/id1460346469"
        #elseif isParitet
        str = "itms-apps://itunes.apple.com/ru/app/id1460356773"
        #elseif isSkyfort
        str = "itms-apps://itunes.apple.com/ru/app/id1460771757"
        #elseif isStandartDV
        str = "itms-apps://itunes.apple.com/ru/app/id1300217674"
        #elseif isGarmonia
        str = "itms-apps://itunes.apple.com/ru/app/id1464487701"
        #elseif isUpravdomChe
        str = "itms-apps://itunes.apple.com/ru/app/id1465368359"
        #elseif isJKH_Pavlovskoe
        str = "itms-apps://itunes.apple.com/ru/app/id1465871964"
        #elseif isPerspectiva
        str = "itms-apps://itunes.apple.com/ru/app/id1466899004"
        #elseif isParus
        str = "itms-apps://itunes.apple.com/ru/app/id1468735380"
        #elseif isUyutService
        str = "itms-apps://itunes.apple.com/ru/app/id1470932332"
        #elseif isElectroSbitSaratov
        str = "itms-apps://itunes.apple.com/ru/app/id1471595995"
        #elseif isServicekom
        str = "itms-apps://itunes.apple.com/ru"
        #elseif isTeplovodoresources
        str = "itms-apps://itunes.apple.com/ru/app/id1472868933"
        #elseif isStroimBud
        str = "itms-apps://itunes.apple.com/ru/app/id1473006651"
        #elseif isRodnikMUP
        str = "itms-apps://itunes.apple.com/ru/app/id1473009928"
        #elseif isUKParitetKhab
        str = "itms-apps://itunes.apple.com/ru/app/id1473393166"
        #elseif isADS68
        str = "itms-apps://itunes.apple.com/ru/app/id1473823262"
        #elseif isAFregat
        str = "itms-apps://itunes.apple.com/ru/app/id1474068547"
        #elseif isNewOpaliha
        str = "itms-apps://itunes.apple.com/ru/app/id1475455954"
        #elseif isPritomskoe
        str = "itms-apps://itunes.apple.com/ru/app/id1475863546"
        #elseif isDJVladimir
        str = "itms-apps://itunes.apple.com/ru/app/id1475739790"
        #elseif isTSN_Dnestr
        str = "itms-apps://itunes.apple.com/ru/app/id1475868876"
        #elseif isCristall
        str = "itms-apps://itunes.apple.com/ru/app/id1476048883"
        #elseif isNarianMarEl
        str = "itms-apps://itunes.apple.com/ru/app/id1476050205"
        #elseif isSibAliance
        str = "itms-apps://itunes.apple.com/ru/app/id1476223562"
        #elseif isSpartak
        str = "itms-apps://itunes.apple.com/ru/app/id1476227641"
        #elseif isTSN_Ruble40
        str = "itms-apps://itunes.apple.com/ru/app/id1475867400"
        #elseif isKosm11
        str = "itms-apps://itunes.apple.com/ru/app/id1476653129"
        #elseif isTSJ_Rachangel
        str = "itms-apps://itunes.apple.com/ru/app/id1476643331"
        #elseif isMUP_IRKC
        str = "itms-apps://itunes.apple.com/ru/app/id1477304362"
        #elseif isUK_First
        str = "itms-apps://itunes.apple.com/ru/app/id1478072913"
        #elseif isRKC_Samara
        str = "itms-apps://itunes.apple.com/ru/app/id1479682216"
        #endif
        let url  = NSURL(string: str)
        if UIApplication.shared.canOpenURL(url! as URL) == true  {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goSupport") {
            let AddApp = segue.destination as! SupportController
            AddApp.fromAuth = true
        }
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
