//
//  MainMenuCons.swift
//  ObjJKH
//
//  Created by Роман Тузин on 05.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class MainMenuCons: UIViewController {

    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var LabelTime: UILabel!
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var notice: UIImageView!
    @IBOutlet weak var application: UIImageView!
    @IBOutlet weak var webs_img: UIImageView!
    @IBOutlet weak var exit_img: UIImageView!
    
    @IBAction func goExit(_ sender: UIButton)
    {
        exit(0)
        //UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        // Приветствие
        LabelTime.text = "Здравствуйте,"
        LabelName.text = defaults.string(forKey: "name")
        
        notice.image = myImages.notice_image
        application.image = myImages.application_image
        webs_img.image = myImages.application_image
        exit_img.image = myImages.application_image
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false;
    }

}
