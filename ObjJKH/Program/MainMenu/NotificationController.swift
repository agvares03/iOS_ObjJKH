//
//  NotificationController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 25/06/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import Crashlytics

class NotificationController: UIViewController {

    @IBOutlet weak var targetName: UILabel!
    @IBOutlet weak var elipseBackground: UIView!
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var btn_name_1: UIButton!
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var btnApp: UIButton!
    @IBOutlet weak var img_mail: UIImageView!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    var phone: String?
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
        #endif
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
