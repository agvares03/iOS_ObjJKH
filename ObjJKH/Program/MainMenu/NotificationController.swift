//
//  NotificationController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 25/06/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class NotificationController: UIViewController {

    @IBOutlet weak var targetName: UILabel!
    @IBOutlet weak var elipseBackground: UIView!
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var btn_name_1: UIButton!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    var phone: String?
    override func viewDidLoad() {
        super.viewDidLoad()
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
        #endif
        btn_name_1.setTitle(phoneOperator, for: .normal)
        targetName.text = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String)
        
        elipseBackground.backgroundColor = myColors.btnColor.uiColor()
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
