//
//  LsPassController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 27/02/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class LsPassController: UIViewController {

    @IBOutlet weak var lsLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var delLSBtn: UIButton!
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    @IBAction func editPassAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "editPass", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPass" {
            let editController = segue.destination as! editPassController
            editController.ls = self.ls
        }
    }
    
    public var ls = "123456768"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lsLbl.text = "У лицевого счёта \(ls) был изменён пароль"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func removeController(){
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
}
