//
//  AddLSSimple.swift
//  ObjJKH
//
//  Created by Роман Тузин on 04/08/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class AddLSSimple: UIViewController {

    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendTech(_ sender: UIButton) {
        self.performSegue(withIdentifier: "support", sender: self)
    }
    
    @IBOutlet weak var imgTech: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgTech.setImageColor(color: myColors.btnColor.uiColor())
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
