//
//  QuestionFinal.swift
//  ObjJKH
//
//  Created by Роман Тузин on 03.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class QuestionFinal: UIViewController {

    @IBOutlet weak var btnOk: UIButton!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func goButtonPressed(_ sender: UIButton) {        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        // Установим цвета для элементов в зависимости от Таргета
        btnOk.backgroundColor = myColors.btnColor.uiColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
