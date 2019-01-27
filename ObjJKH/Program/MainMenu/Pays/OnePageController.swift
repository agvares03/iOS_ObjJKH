//
//  OnePageController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 25/01/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class OnePageController: UIViewController {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var sumLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var alertLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var widthBtn: NSLayoutConstraint!
    @IBOutlet weak var fioLbl: UILabel!
    
    @IBAction func nextAction(_ sender: UIButton) {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    var back = false
    var date = ""
    var sum  = 0.00
    override func viewDidLoad() {
        super.viewDidLoad()
        date = UserDefaults.standard.string(forKey: "dateDebt")!
        sum = UserDefaults.standard.double(forKey: "sumDebt")
        
        if sum < 10000{
            dateLbl.text = "Сумма к оплате по Вашему лицевому счету на \(date) составляет:"
            sumLbl.text = "- за жилищно-коммунальные услуги - \(sum) руб."
            alertLbl.isHidden = true
            nextBtn.setTitle("Перейти к оплате", for: .normal)
            widthBtn.constant = 140
            if view.frame.height == 568{
                dateLbl.font = dateLbl.font.withSize(16)
                sumLbl.font = sumLbl.font.withSize(16)
                messageLbl.font = messageLbl.font.withSize(14)
                fioLbl.font = fioLbl.font.withSize(15)
            }
        }else{
            dateLbl.text = "У Вас имеется задолженность на \(date):"
            sumLbl.text = "- за жилищно-коммунальные услуги в размере \(sum) руб."
            messageLbl.text = "Вы внесены в список на ограничение предоставления ЖКУ."
            alertLbl.isHidden = false
        }
        fioLbl.text = UserDefaults.standard.string(forKey: "name")
        nextBtn.backgroundColor = myColors.indicatorColor.uiColor()
        // Do any additional setup after loading the view.
    }
    
    func removeController(){
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
}
