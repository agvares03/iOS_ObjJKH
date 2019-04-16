//
//  ChoiceLsPocketController.swift
//  JKH_Pocket
//
//  Created by Sergey Ivanov on 16/04/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class ChoiceLsPocketController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var separator1: UILabel!
    
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnAdd: UIButton!
    
    // Телефон, который регистрируется
    var phone: String = ""
    var response_add_ident: String?
    
    @IBOutlet weak var txtNumberLS: UILabel!
    
    @IBOutlet weak var edLS: UITextField!
    
    @IBAction func supportBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "support", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        phone = defaults.string(forKey: "phone")!
        
        edLS.delegate = self
        // Установим цвета для элементов в зависимости от Таргета
        btnAdd.backgroundColor = myColors.btnColor.uiColor()
        back.tintColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.labelColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        
        #if isOur_Obj_Home
        txtNumberLS.text = "Номер лицевого счета Сбербанка"
        #endif
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        edLS.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    @objc func TapStreet(sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "get_street_new", sender: self)
    }
    
    @objc func TapNumber(sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "get_number_new", sender: self)
    }
    
    @objc func TapFlat(sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "get_flat_new", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Переходы - выбор
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
