//
//  editPassController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 27/02/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class editPassController: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var lsLbl: UILabel!
    @IBOutlet weak var passText: UITextField!
    
    public var ls = ""
    
    @IBAction func cancelAction(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lsLbl.text = "У лицевого счёта \(ls) был изменён пароль"
    }

}
