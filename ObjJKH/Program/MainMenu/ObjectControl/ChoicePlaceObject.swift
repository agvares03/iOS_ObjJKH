//
//  ChoicePlaceObject.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 25/10/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import Crashlytics

class ChoicePlaceObject: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var separator1:      UILabel!
    @IBOutlet weak var separator2:      UILabel!
    @IBOutlet weak var separator3:      UILabel!
    @IBOutlet weak var EntranceHeight:  NSLayoutConstraint!
    @IBOutlet weak var PremiseHeight:   NSLayoutConstraint!
    @IBOutlet weak var indicator:       UIActivityIndicatorView!
    
    @IBOutlet weak var support:         UIImageView!
    @IBOutlet weak var supportBtn:      UIButton!
    
    // Массивы для хранения данных
    var home_names: [String]    = []
    var home_ids: [String]      = []
    var teck_home: Int          = -1
    var homeString: String?
    
    var entrance_names: [String] = []
    var entrance_ids: [String]   = []
    var teck_entrance: Int       = -1
    
    var premise_names: [String]  = []
    var premise_ids: [String]    = []
    var teck_premise: Int        = -1
    
    var object_names: [String]   = []
    var object_ids: [String]     = []
    var object_check: [Bool]     = []
    
    @IBOutlet weak var back:            UIBarButtonItem!
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnNext:         UIButton!
    
    // Телефон, который регистрируется
    var phone: String = ""
    var response_add_ident: String?
    
    @IBOutlet weak var txtHome:         UILabel!
    @IBOutlet weak var edHome:          UITextField!
    @IBOutlet weak var indicator_home:  UIActivityIndicatorView!
    @IBOutlet weak var imgHome:         UIImageView!
    
    @IBOutlet weak var txtEntrance:     UILabel!
    @IBOutlet weak var edEntrance:      UITextField!
    @IBOutlet weak var indicator_entrance: UIActivityIndicatorView!
    @IBOutlet weak var imgEntrance:     UIImageView!
    
    @IBOutlet weak var txtPremise:      UILabel!
    @IBOutlet weak var edPremise:       UITextField!
    @IBOutlet weak var indicator_premise: UIActivityIndicatorView!
    @IBOutlet weak var imgPremise:      UIImageView!
    
    @IBOutlet weak var objectLbl: UILabel!
    
    @IBAction func NextAction(_ sender: UIButton){
        if teck_premise != -1 || teck_home != -1 || teck_entrance != -1{
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            self.btnNext.isHidden = true
            getObject()
        }else{
            let alert = UIAlertController(title: "Ошибка", message: "Вы не выбрали Организацию", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func supportBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "support", sender: self)
    }
    var idObject = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("ChoicePlaceObject", forKey: "last_UI_action")
        indicator_home.startAnimating()
        indicator_premise.startAnimating()
        indicator_entrance.startAnimating()
        indicator.stopAnimating()
        indicator.isHidden = true
        HideIndicators(num_ind: 1)
        ShowHideEntrance(show_hide: true)
        ShowHidePremise(show_hide: true)
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "phone") != nil{
            phone = defaults.string(forKey: "phone")!
        }
        
        initListeners()
        
        // Первый показ - подгрузим дома сразу
//        let id = UserDefaults.standard.string(forKey: "id_account")?.stringByAddingPercentEncodingForRFC3986() ?? ""
        let id = UserDefaults.standard.string(forKey: "login_cons")?.stringByAddingPercentEncodingForRFC3986() ?? ""
        getHome(id: id)
        edPremise.delegate = self
        edEntrance.delegate = self
        edHome.delegate = self
        // Установим цвета для элементов в зависимости от Таргета
        btnNext.backgroundColor = myColors.btnColor.uiColor()
        back.tintColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
        separator3.backgroundColor = myColors.labelColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        indicator.color = myColors.btnColor.uiColor()
        
//        #if isOur_Obj_Home
//        txtEntranceLS.text = "Номер лицевого счета Сбербанка"
//        #endif
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == edPremise || textField == edEntrance || textField == edHome {
            return false; //do not show keyboard nor cursor
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    @objc func TapStreet(sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "get_home_new", sender: self)
    }
    
    @objc func TapNumber(sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "get_entrance_new", sender: self)
    }
    
    @objc func TapFlat(sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "get_premise_new", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        if UserDefaults.standard.bool(forKey: "NewMain"){
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    // Функции подгрузки информации
    func initListeners() {
        // ДОМ
        edHome.isUserInteractionEnabled = true
        let tapStreet: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapStreet))
        edHome.addGestureRecognizer(tapStreet)
        tapStreet.delegate = self as? UIGestureRecognizerDelegate
        
        txtHome.isUserInteractionEnabled = true
        let tap_txtHome: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapStreet))
        txtHome.addGestureRecognizer(tap_txtHome)
        tap_txtHome.delegate = self as? UIGestureRecognizerDelegate
        
        imgHome.isUserInteractionEnabled = true
        let tap_imgHome: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapStreet))
        imgHome.addGestureRecognizer(tap_imgHome)
        tap_imgHome.delegate = self as? UIGestureRecognizerDelegate
        
        // ПОДЪЕЗД
        edEntrance.isUserInteractionEnabled = true
        let tapNumber: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapNumber))
        edEntrance.addGestureRecognizer(tapNumber)
        tapNumber.delegate = self as? UIGestureRecognizerDelegate
        
        txtEntrance.isUserInteractionEnabled = true
        let tap_txtEntrance: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapNumber))
        txtEntrance.addGestureRecognizer(tap_txtEntrance)
        tap_txtEntrance.delegate = self as? UIGestureRecognizerDelegate
        
        imgEntrance.isUserInteractionEnabled = true
        let tap_imgEntrance: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapNumber))
        imgEntrance.addGestureRecognizer(tap_imgEntrance)
        tap_imgEntrance.delegate = self as? UIGestureRecognizerDelegate
        
        // КВАРТИРА
        edPremise.isUserInteractionEnabled = true
        let tapFlat: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapFlat))
        edPremise.addGestureRecognizer(tapFlat)
        tapFlat.delegate = self as? UIGestureRecognizerDelegate
        
        txtPremise.isUserInteractionEnabled = true
        let tap_txtPremise: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapFlat))
        txtPremise.addGestureRecognizer(tap_txtPremise)
        tap_txtPremise.delegate = self as? UIGestureRecognizerDelegate
        
        imgPremise.isUserInteractionEnabled = true
        let tap_imgPremise: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapFlat))
        imgPremise.addGestureRecognizer(tap_imgPremise)
        tap_imgPremise.delegate = self as? UIGestureRecognizerDelegate
    }
    
    func getHome(id: String) {
        ShowIndicators(num_ind: 1)
        let urlPath = Server.SERVER + "MobileAPI/ControlObjects/GetHouses.ashx?login=" + id.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                guard data != nil else { return }
                                                
                                                self.homeString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("street = \(String(describing: self.homeString))")
                                                if (self.homeString?.containsIgnoringCase(find: "Address"))!{
                                                    do {
                                                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                        if let json_bills = json["data"] {
                                                            print(json_bills.count!)
                                                        
                                                            if ((json_bills as? NSNull) == nil) && json_bills.count != 0{
                                                                let int_end = (json_bills.count)!-1
                                                                if (int_end < 0) {
                                                                    
                                                                } else {
                                                                    for index in 0...int_end {
                                                                        let json_bill = json_bills.object(at: index) as! [String:AnyObject]
                                                                        for obj in json_bill {
                                                                            if obj.key == "Address" {
                                                                                if ((obj.value as? NSNull) == nil){
                                                                                    let sum = String(describing: obj.value as! String)
                                                                                    self.home_names.append(sum)
                                                                                }
                                                                            }
                                                                            if obj.key == "ID" {
                                                                                if ((obj.value as? NSNull) == nil){
                                                                                    let sum = String(describing: obj.value as! Int)
                                                                                    self.home_ids.append(sum)
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        self.end_choice(num: 1)
                                                        
                                                        
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                }else{
                                                    DispatchQueue.main.async{
                                                        let alert = UIAlertController(title: "Ошибка", message: "Объекты осмотра отсутствуют", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                                                            self.navigationController?.popViewController(animated: true)
                                                        }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    }
                                                }
                                                
        })
        task.resume()
    }
    
    func end_choice(num: Int) {
        DispatchQueue.main.async(execute: {
            self.HideIndicators(num_ind: num)
            //            self.update_view()
        })
    }
    
    // Переходы - выбор
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "choicePlace") {
            let controller = segue.destination as! AllObjectPlace
            if teck_home != -1{
                controller.choiceHome = home_ids[teck_home]
            }
            if teck_entrance != -1{
                controller.choiceEntrance = entrance_ids[teck_entrance]
            }
            if teck_premise != -1{
                controller.choicePremise = premise_ids[teck_premise]
            }
            controller.object_names = object_names
            controller.object_ids = object_ids
            controller.object_check = object_check
        }else if (segue.identifier == "get_home_new") {
            
            prepare_seque_for_choice(teck: teck_home, names: home_names, segue: segue, numb: 1)
            
        } else if (segue.identifier == "get_entrance_new") {
            
            prepare_seque_for_choice(teck: teck_entrance, names: entrance_names, segue: segue, numb: 2)
            
        } else if (segue.identifier == "get_premise_new") {
            
            prepare_seque_for_choice(teck: teck_premise, names: premise_names, segue: segue, numb: 3)
            
        }
    }
    
    func prepare_seque_for_choice(teck: Int, names: [String], segue: UIStoryboardSegue, numb: Int) {
        let selectItemController = (segue.destination as! UINavigationController).viewControllers.first as! SelectItemController
        selectItemController.strings = names
        selectItemController.selectedIndex = teck
        selectItemController.selectHandler = { selectedIndex in
            
            if (numb == 1) {
                self.teck_home = selectedIndex
                self.ClearEntrance()
                self.ClearPremise()
                
                let choice_name_number   = self.home_ids[selectedIndex]
                self.getEntrance(id: choice_name_number)
                self.objectLbl.isHidden = false
            } else if (numb == 2) {
                self.teck_entrance = selectedIndex
                self.ClearPremise()
                
                let choice_id_number   = self.entrance_ids[selectedIndex]
                self.getPremise(id: choice_id_number)
                self.objectLbl.isHidden = false
            } else {
                self.teck_premise = selectedIndex
                self.objectLbl.isHidden = true
            }
            DispatchQueue.main.async{
                self.edHome.text = self.appString(teck: self.teck_home, names: self.home_names)
                self.edEntrance.text = self.appString(teck: self.teck_entrance, names: self.entrance_names)
                self.edPremise.text = self.appString(teck: self.teck_premise, names: self.premise_names)
            }
//            self.objectLbl.text    = self.appString(teck: self.teck_premise, names: self.premise_names)
        }
    }
    
    // Очистка значений при перевыборе
    func ClearEntrance() {
        entrance_names = []
        entrance_ids = []
        teck_entrance = -1
    }
    
    func ClearPremise() {
        premise_names = []
        premise_ids = []
        teck_premise = -1
    }
    
    // Процедура отображения названий
    func appString(teck: Int, names: [String]) -> String {
        print(teck, names)
        if teck == -1 {
            return "    "
        }
        if teck >= 0 && teck < names.count {
            return names[teck]
        }
        return "    "
    }
    
    func getEntrance(id: String) {
        ShowIndicators(num_ind: 2)
        let urlPath = Server.SERVER + "MobileAPI/ControlObjects/GetEntrances.ashx?houseId=" + id.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                guard data != nil else { return }
                                                
                                                self.homeString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//                                                print("entrance = \(String(describing: self.homeString))")
                                                if (self.homeString?.containsIgnoringCase(find: "Number"))!{
                                                    do {
                                                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                        if let json_bills = json["data"] {
                                                            print(json_bills.count!)
                                                        
                                                            if ((json_bills as? NSNull) == nil) && json_bills.count != 0{
                                                                let int_end = (json_bills.count)!-1
                                                                if (int_end < 0) {
                                                                    
                                                                } else {
                                                                    for index in 0...int_end {
                                                                        let json_bill = json_bills.object(at: index) as! [String:AnyObject]
                                                                        for obj in json_bill {
                                                                            if obj.key == "Number" {
                                                                                if ((obj.value as? NSNull) == nil){
                                                                                    let sum = String(describing: obj.value as! String)
                                                                                    self.entrance_names.append(sum)
                                                                                }
                                                                            }
                                                                            if obj.key == "ID" {
                                                                                if ((obj.value as? NSNull) == nil){
                                                                                    let sum = String(describing: obj.value as! Int)
                                                                                    self.entrance_ids.append(sum)
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                }
                                                self.end_choice(num: 2)
        })
        task.resume()
    }
    
    func getPremise(id: String) {
        ShowIndicators(num_ind: 3)
        let urlPath = Server.SERVER + "MobileAPI/ControlObjects/GetPremises.ashx?entranceId=" + id.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                guard data != nil else { return }
                                                
                                                self.homeString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//                                                print("entrance = \(String(describing: self.homeString))")
                                                if (self.homeString?.containsIgnoringCase(find: "Number"))!{
                                                    do {
                                                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                        if let json_bills = json["data"] {
                                                            print(json_bills.count!)
                                                        
                                                            if ((json_bills as? NSNull) == nil) && json_bills.count != 0{
                                                                let int_end = (json_bills.count)!-1
                                                                if (int_end < 0) {
                                                                    
                                                                } else {
                                                                    for index in 0...int_end {
                                                                        let json_bill = json_bills.object(at: index) as! [String:AnyObject]
                                                                        for obj in json_bill {
                                                                            if obj.key == "Number" {
                                                                                if ((obj.value as? NSNull) == nil){
                                                                                    let sum = String(describing: obj.value as! String)
                                                                                    self.premise_names.append(sum)
                                                                                }
                                                                            }
                                                                            if obj.key == "ID" {
                                                                                if ((obj.value as? NSNull) == nil){
                                                                                    let sum = String(describing: obj.value as! Int)
                                                                                    self.premise_ids.append(sum)
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                }
                                                self.end_choice(num: 3)
        })
        task.resume()
    }
    
    func getObject() {
        object_check.removeAll()
        object_ids.removeAll()
        object_names.removeAll()
        var urlPath = Server.SERVER + "MobileAPI/ControlObjects/GetControlObjects.ashx?"
        
        if teck_premise != -1{
            urlPath = urlPath + "premiseId=" + premise_ids[teck_premise].addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        }else if teck_entrance != -1{
            urlPath = urlPath + "entranceId=" + entrance_ids[teck_entrance].addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        }else if teck_home != -1{
            urlPath = urlPath + "houseId=" + home_ids[teck_home].addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        }
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                guard data != nil else { return }
                                                if error != nil {
                                                    return
                                                }
                                                let objectString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//                                                print("object = \(String(describing: objectString))")
                                                if (objectString.containsIgnoringCase(find: "Name")){
                                                    do {
                                                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                        if let json_bills = json["data"] {
                                                            print(json_bills.count!)
                                                        
                                                            if ((json_bills as? NSNull) == nil) && json_bills.count != 0{
                                                                let int_end = (json_bills.count)!-1
                                                                if (int_end < 0) {
                                                                    
                                                                } else {
                                                                    for index in 0...int_end {
                                                                        let json_bill = json_bills.object(at: index) as! [String:AnyObject]
                                                                        for obj in json_bill {
                                                                            if obj.key == "Name" {
                                                                                if ((obj.value as? NSNull) == nil){
                                                                                    let sum = String(describing: obj.value as! String)
                                                                                    self.object_names.append(sum)
                                                                                }
                                                                            }
                                                                            if obj.key == "ID" {
                                                                                if ((obj.value as? NSNull) == nil){
                                                                                    let sum = String(describing: obj.value as! Int)
                                                                                    self.object_ids.append(sum)
                                                                                }
                                                                            }
                                                                            if obj.key == "IsInspected" {
                                                                                if ((obj.value as? NSNull) == nil){
                                                                                    let sum = obj.value as! Bool
                                                                                    self.object_check.append(sum)
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        DispatchQueue.main.async{
                                                            self.indicator.isHidden = true
                                                            self.indicator.stopAnimating()
                                                            self.btnNext.isHidden = false
                                                            self.performSegue(withIdentifier: "choicePlace", sender: self)
                                                        }
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                }else{
                                                    DispatchQueue.main.async{
                                                        self.indicator.isHidden = true
                                                        self.indicator.stopAnimating()
                                                        self.btnNext.isHidden = false
                                                        let alert = UIAlertController(title: "Ошибка", message: "Отсутствуют объекты контроля", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                                                            
                                                        }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    }
                                                }
                                                
        })
        task.resume()
    }
    
    // Показать индикаторы
    func HideIndicators(num_ind: Int) {
        DispatchQueue.main.async{
            if (num_ind == 1) {
                self.ShowHideHome(show_hide: false)
                self.ShowHideEntrance(show_hide: true)
                self.ShowHidePremise(show_hide: true)
                self.indicator_entrance.isHidden = true
                self.indicator_premise.isHidden = true
            } else if (num_ind == 2) {
                self.ShowHideEntrance(show_hide: false)
                self.ShowHidePremise(show_hide: true)
                self.indicator_premise.isHidden = true
            } else if (num_ind == 3) {
                self.ShowHidePremise(show_hide: false)
    //            if (self.premise_ids.count == 0){
    //                self.txtPremise.isHidden = true
    //                self.edPremise.isHidden = true
    //                self.imgPremise.isHidden = true
    //                self.separator3.isHidden = true
    //                self.objectLbl.isHidden = true
    //            }else{
    //                self.separator3.isHidden = false
    //            }
            }
        }
    }
    
    // Скрыть индикаторы
    func ShowIndicators(num_ind: Int) {
        DispatchQueue.main.async{
            if (num_ind == 1) {
                self.objectLbl.isHidden = false
                self.objectLbl.text = "Выберите дом"
                self.ShowHideHome(show_hide: true)
                self.indicator_entrance.isHidden = true
                self.indicator_premise.isHidden = true
    //            ShowHideEntrance(show_hide: true)
    //            ShowHidePremise(show_hide: true)
            } else if (num_ind == 2) {
                self.ShowHideEntrance(show_hide: true)
    //            ShowHidePremise(show_hide: true)
            } else if (num_ind == 3) {
                self.ShowHidePremise(show_hide: true)
            }
        }
    }
    
    func ShowHideHome(show_hide: Bool) {
        edHome.isHidden         = show_hide
        txtHome.isHidden        = show_hide
        imgHome.isHidden        = show_hide
        
        indicator_home.isHidden = !show_hide
    }
    
    func ShowHideEntrance(show_hide: Bool) {
        edEntrance.isHidden         = show_hide
        txtEntrance.isHidden        = show_hide
        imgEntrance.isHidden        = show_hide
        separator2.isHidden         = show_hide
        if show_hide{
            EntranceHeight.constant = 0
        }else{
            EntranceHeight.constant = 56
            objectLbl.text = "Выберите подъезд или нажмите Далее"
        }
        indicator_entrance.isHidden = !show_hide
    }
    
    func ShowHidePremise(show_hide: Bool) {
        edPremise.isHidden         = show_hide
        txtPremise.isHidden        = show_hide
        imgPremise.isHidden        = show_hide
        separator3.isHidden        = show_hide
        if show_hide{
            PremiseHeight.constant = 0
        }else{
            PremiseHeight.constant = 56
            objectLbl.text = "Выберите квартиру или нажмите Далее"
        }
        indicator_premise.isHidden = !show_hide
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        print(label.frame.height, width)
        return label.frame.height
    }
}
