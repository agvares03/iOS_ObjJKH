//
//  UpdateAppController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 22/01/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class UpdateAppController: UIViewController {

    @IBOutlet weak var imageApp: UIImageView!
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var goLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        imageApp.image = UIImage(named: "Logo_ReutKomfort")
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
        #elseif isADS68
        imageApp.image = UIImage(named: "Logo_ADS68")
        #elseif isAFregat
        imageApp.image = UIImage(named: "Logo_Fregat")
        #elseif isNewOpaliha
        imageApp.image = UIImage(named: "Logo_NewOpaliha")
        #elseif isStroiDom
        imageApp.image = UIImage(named: "Logo_StroiDom")
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
        #elseif isVodSergPosad
        imageApp.image = UIImage(named: "Logo_VodSergPosad")
        #elseif isMobileMIR
        imageApp.image = UIImage(named: "Logo_MobileMIR")
        #elseif isZarinsk
        imageApp.image = UIImage(named: "Logo_Zarinsk")
        #elseif isPedagog
        imageApp.image = UIImage(named: "Logo_Pedagog")
        #elseif isGorAntenService
        imageApp.image = UIImage(named: "Logo_GorAntenService")
        #elseif isElectroTech
        imageApp.image = UIImage(named: "Logo_ElectroTech")
        #elseif isTSJ_Lider
        imageApp.image = UIImage(named: "Logo_TSJLider")
        #elseif isUK_Drujba
        imageApp.image = UIImage(named: "Logo_UkDrujba")
        #elseif isKFH_Ryab
        imageApp.image = UIImage(named: "Logo_KFHRyab")
        #elseif isDOM24
        imageApp.image = UIImage(named: "Logo_DOM24")
        #elseif isLefortovo
        imageApp.image = UIImage(named: "Logo_Lefortovo")
        #elseif isERC_UDM
        imageApp.image = UIImage(named: "Logo_ERC_UDM")
        #elseif isAvalon
        imageApp.image = UIImage(named: "Logo_Avalon")
        #elseif isDoka
        imageApp.image = UIImage(named: "Logo_Doka")
        #elseif isInvest
        imageApp.image = UIImage(named: "Logo_Invest")
        #elseif isUniversSol
        imageApp.image = UIImage(named: "Logo_UniversSol")
        #elseif isClearCity
        imageApp.image = UIImage(named: "Logo_ClearCity")
        #elseif isAlternative
        imageApp.image = UIImage(named: "Logo_Alternative")
        #elseif isMUP_Severnoe
        imageApp.image = UIImage(named: "Logo_MUP_Severnoe")
        #elseif isAlphaJKH
        imageApp.image = UIImage(named: "Logo_AlphaJKH")
        #elseif isSuhanovo
        imageApp.image = UIImage(named: "Logo_Suhanovo")
        #elseif isMaximum
        imageApp.image = UIImage(named: "Logo_Maximum")
        #elseif isEJF
        imageApp.image = UIImage(named: "Logo_EJF")
        #elseif isClean_Tid
        imageApp.image = UIImage(named: "Logo_Clean_Tid")
        #elseif isJilUpravKom
        imageApp.image = UIImage(named: "Logo_JilUpravKom")
        #elseif isTihGavan
        imageApp.image = UIImage(named: "Logo_TihGavan")
        #elseif isOptimumService
        imageApp.image = UIImage(named: "Logo_OptimumService")
        #elseif isSibir
        imageApp.image = UIImage(named: "Logo_Sibir")
        #elseif isNovogorskoe
        imageApp.image = UIImage(named: "Logo_Novogorskoe")
        #elseif isION
        imageApp.image = UIImage(named: "Logo_ION")
        #elseif isGrinvay
        imageApp.image = UIImage(named: "Logo_Grinvay")
        #elseif isGumse
        imageApp.image = UIImage(named: "Logo_Gumse")
        #elseif isSV14
        imageApp.image = UIImage(named: "Logo_SV14")
        #elseif isTSJ_Life
        imageApp.image = UIImage(named: "Logo_TSJ_Life")
        #elseif isSouthValley
        imageApp.image = UIImage(named: "Logo_SouthValley")
        #elseif isRamenLefortovo
        imageApp.image = UIImage(named: "Logo_RamenLefortovo")
        #elseif isVestSnab
        imageApp.image = UIImage(named: "Logo_VestSnab")
        #endif
        updateBtn.backgroundColor = myColors.indicatorColor.uiColor()
        goLbl.textColor = myColors.indicatorColor.uiColor()
        let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "ПРОДОЛЖИТЬ РАБОТУ В ТЕКУЩЕЙ ВЕРСИИ", attributes: underlineAttribute)
        goLbl.attributedText = underlineAttributedString
        let tap = UITapGestureRecognizer(target: self, action: #selector(lblTapped(_:)))
        goLbl.isUserInteractionEnabled = true
        goLbl.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc private func lblTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "start_app", sender: self)
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
        #elseif isStroiDom
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
        str = "itms-apps://itunes.apple.com/ru/app/id1506706207"
        #elseif isEnergoProgress
        str = "itms-apps://itunes.apple.com/ru/app/id1484298695"
        #elseif isMurmanskPartnerPlus
        str = "itms-apps://itunes.apple.com/ru/app/id1484594347"
        #elseif isEasyLife
        str = "itms-apps://itunes.apple.com/ru/app/id1485818907"
        #elseif isRIC
        str = "itms-apps://itunes.apple.com/ru/app/id1486766639"
        #elseif isMonolit
        str = "itms-apps://itunes.apple.com/ru/app/id1487039783"
        #elseif isVodSergPosad
        str = "itms-apps://itunes.apple.com/ru/app/id1489273745"
        #elseif isMobileMIR
        str = "itms-apps://itunes.apple.com/ru/app/id1490057602"
        #elseif isZarinsk
        str = "itms-apps://itunes.apple.com/ru/app/id1490533229"
        #elseif isPedagog
        str = "itms-apps://itunes.apple.com/ru/app/id1490557237"
        #elseif isGorAntenService
        str = "itms-apps://itunes.apple.com/ru/app/id1492064766"
        #elseif isElectroTech
        str = "itms-apps://itunes.apple.com/ru/app/id1496749470"
        #elseif isTSJ_Lider
        str = "itms-apps://itunes.apple.com/ru/app/id1496750652"
        #elseif isUK_Drujba
        str = "itms-apps://itunes.apple.com/ru/app/id1496751363"
        #elseif isKFH_Ryab
        str = "itms-apps://itunes.apple.com/ru/app/id1496752748"
        #elseif isDOM24
        str = "itms-apps://itunes.apple.com/ru/app/id1497257910"
        #elseif isLefortovo
        str = "itms-apps://itunes.apple.com/ru/app/id1497293040"
        #elseif isERC_UDM
        str = "itms-apps://itunes.apple.com/ru/app/id1498589004"
        #elseif isAvalon
        str = "itms-apps://itunes.apple.com/ru/app/id1498589295"
        #elseif isDoka
        str = "itms-apps://itunes.apple.com/ru/app/id1500730892"
        #elseif isInvest
        str = "itms-apps://itunes.apple.com/ru/app/id1501656936"
        #elseif isUniversSol
        str = "itms-apps://itunes.apple.com/ru/app/id1501657000"
        #elseif isClearCity
        str = "itms-apps://itunes.apple.com/ru/app/id1501658364"
        #elseif isAlternative
        str = "itms-apps://itunes.apple.com/ru/app/id1502953021"
        #elseif isMUP_Severnoe
        str = "itms-apps://itunes.apple.com/ru/app/id1504031191"
        #elseif isAlphaJKH
        str = "itms-apps://itunes.apple.com/ru/app/id1504417660"
        #elseif isSuhanovo
        str = "itms-apps://itunes.apple.com/ru/app/id1505286500"
        #elseif isMaximum
        str = "itms-apps://itunes.apple.com/ru/app/id1505985526"
        #elseif isEJF
        str = "itms-apps://itunes.apple.com/ru/app/id1505990646"
        #elseif isClean_Tid
        str = "itms-apps://itunes.apple.com/ru/app/id1506004920"
        #elseif isJilUpravKom
        str = "itms-apps://itunes.apple.com/ru/app/id1506021980"
        #elseif isTihGavan
        str = "itms-apps://itunes.apple.com/ru/app/id1506917131"
        #elseif isOptimumService
        str = "itms-apps://itunes.apple.com/ru/app/id1507156564"
        #elseif isSibir
        str = "itms-apps://itunes.apple.com/ru/app/id1508963988"
        #elseif isNovogorskoe
        str = "itms-apps://itunes.apple.com/ru/app/id1509196166"
        #elseif isION
        str = "itms-apps://itunes.apple.com/ru/app/id1509419405"
        #elseif isGrinvay
        str = "itms-apps://itunes.apple.com/ru/app/id1515075006"
        #elseif isGumse
        str = "itms-apps://itunes.apple.com/ru/app/id1515083553"
        #elseif isSV14
        str = "itms-apps://itunes.apple.com/ru/app/id1515083991"
        #elseif isTSJ_Life
        str = "itms-apps://itunes.apple.com/ru/app/id1517749626"
        #elseif isSouthValley
        str = "itms-apps://itunes.apple.com/ru/app/id1516805704"
        #elseif isRamenLefortovo
        str = "itms-apps://itunes.apple.com/ru/app/id1521236227"
        #elseif isVestSnab
        str = "itms-apps://itunes.apple.com/ru/app/id1521235023"
        #endif
        let url  = NSURL(string: str)
        if UIApplication.shared.canOpenURL(url! as URL) == true  {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
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
