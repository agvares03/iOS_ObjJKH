//
//  TechWorkController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 18/08/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class TechWorkController: UIViewController {

    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var btn_tech: UIButton!
    @IBOutlet weak var btn_close: UIButton!
    
    @IBAction func push_tech(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "fromTech")
    }
    
    @IBAction func push_close(_ sender: UIButton) {
        exit(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        #if isOur_Obj_Home
        fon_top.image = UIImage(named: "logo_Our_Obj_Home_white")
        #elseif isChist_Dom
        fon_top.image = UIImage(named: "Logo_Chist_Dom_White")
        #elseif isMupRCMytishi
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
        fon_top.image = UIImage(named: "logo_Klimovsk12_White")
        #elseif isPocket
        fon_top.image = UIImage(named: "Logo_Pocket_White")
        #elseif isReutKomfort
        fon_top.image = UIImage(named: "Logo_ReutKomfort")
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
        #elseif isTeplovodoresources
        fon_top.image = UIImage(named: "Logo_Teplovodoresources")
        #elseif isStroimBud
        fon_top.image = UIImage(named: "Logo_StroimBud")
        #elseif isRodnikMUP
        fon_top.image = UIImage(named: "Logo_RodnikMUP")
        #elseif isUKParitetKhab
        fon_top.image = UIImage(named: "Logo_Paritet")
        #elseif isAFregat
        fon_top.image = UIImage(named: "Logo_Fregat")
        #elseif isNewOpaliha
        fon_top.image = UIImage(named: "Logo_NewOpaliha")
        #elseif isPritomskoe
        fon_top.image = UIImage(named: "Logo_Pritomskoe")
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
        #endif
        
        btn_tech.backgroundColor = myColors.indicatorColor.uiColor()
        btn_close.backgroundColor = myColors.indicatorColor.uiColor()
        
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
