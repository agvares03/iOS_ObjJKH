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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.string(forKey: "titleNotifi") != nil{
            titleText.text = UserDefaults.standard.string(forKey: "titleNotifi")
        }
        if UserDefaults.standard.string(forKey: "bodyNotifi") != nil{
            bodyText.text = UserDefaults.standard.string(forKey: "bodyNotifi")
        }
        UserDefaults.standard.set(false, forKey: "newNotifi")
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
