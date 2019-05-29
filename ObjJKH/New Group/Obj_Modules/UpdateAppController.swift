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
        #elseif isUKGarant
        str = "itms-apps://itunes.apple.com/ru/app/id1420424696"
        #elseif isSoldatova1
        str = "" // Вставить адрес после выпуска
        #elseif isTafgai
        str = ""
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
