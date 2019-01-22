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
        #endif
        updateBtn.backgroundColor = myColors.indicatorColor.uiColor()
        // Do any additional setup after loading the view.
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
