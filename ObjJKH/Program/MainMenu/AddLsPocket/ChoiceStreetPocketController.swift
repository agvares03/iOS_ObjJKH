//
//  ChoiceStreetPocketController.swift
//  JKH_Pocket
//
//  Created by Sergey Ivanov on 16/04/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class ChoiceStreetPocketController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var separator1: UILabel!
    @IBOutlet weak var separator2: UILabel!
    @IBOutlet weak var separator3: UILabel!
    @IBOutlet weak var nonorgConst: NSLayoutConstraint!
    
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    // Массивы для хранения данных
    var street_names: [String] = []
    var street_ids: [String] = []
    var teck_street: Int = -1
    var streetString: String?
    
    var number_names: [String] = []
    var number_ids: [String] = []
    var teck_number: Int = -1
    
    var orgCity_names: [String] = []
    var orgCity_ids: [String] = []
    var teck_flat: Int = -1
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnNext: UIButton!
    
    // Телефон, который регистрируется
    var phone: String = ""
    var response_add_ident: String?
    
    @IBOutlet weak var txtStreet: UILabel!
    @IBOutlet weak var edStreet: UITextField!
    @IBOutlet weak var indicator_street: UIActivityIndicatorView!
    @IBOutlet weak var imgStreet: UIImageView!
    
    @IBOutlet weak var txtNumber: UILabel!
    @IBOutlet weak var edNumber: UITextField!
    @IBOutlet weak var indicatorNumber: UIActivityIndicatorView!
    @IBOutlet weak var imgNumber: UIImageView!
    
    @IBOutlet weak var txtOrg: UILabel!
    @IBOutlet weak var edOrg: UITextField!
    @IBOutlet weak var indicatorOrg: UIActivityIndicatorView!
    @IBOutlet weak var imgOrg: UIImageView!
    @IBOutlet weak var orgLblHeight: NSLayoutConstraint!
    @IBOutlet weak var orgLbl: UILabel!
    
    @IBAction func NextAction(_ sender: UIButton){
        if teck_flat != -1{
            self.performSegue(withIdentifier: "nextStreet", sender: self)
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
        
        indicator_street.startAnimating()
        indicatorOrg.startAnimating()
        indicatorNumber.startAnimating()
        HideIndicators(num_ind: 1)
        
        let defaults = UserDefaults.standard
        phone = defaults.string(forKey: "phone")!
        
        initListeners()
        
        // Первый показ - подгрузим улицы сразу
        getStreets(id: idObject)
        edOrg.delegate = self
        edNumber.delegate = self
        edStreet.delegate = self
        // Установим цвета для элементов в зависимости от Таргета
        btnNext.backgroundColor = myColors.btnColor.uiColor()
        back.tintColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
        separator3.backgroundColor = myColors.labelColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        
        #if isOur_Obj_Home
        txtNumberLS.text = "Номер лицевого счета Сбербанка"
        #endif
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == edOrg || textField == edNumber || textField == edStreet {
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
        if UserDefaults.standard.bool(forKey: "NewMain"){
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    // Функции подгрузки информации
    func initListeners() {
        // УЛИЦА
        edStreet.isUserInteractionEnabled = true
        let tapStreet: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapStreet))
        edStreet.addGestureRecognizer(tapStreet)
        tapStreet.delegate = self as? UIGestureRecognizerDelegate
        
        txtStreet.isUserInteractionEnabled = true
        let tap_txtStreet: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapStreet))
        txtStreet.addGestureRecognizer(tap_txtStreet)
        tap_txtStreet.delegate = self as? UIGestureRecognizerDelegate
        
        imgStreet.isUserInteractionEnabled = true
        let tap_imgStreet: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapStreet))
        imgStreet.addGestureRecognizer(tap_imgStreet)
        tap_imgStreet.delegate = self as? UIGestureRecognizerDelegate
        
        // НОМЕР ДОМА
        edNumber.isUserInteractionEnabled = true
        let tapNumber: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapNumber))
        edNumber.addGestureRecognizer(tapNumber)
        tapNumber.delegate = self as? UIGestureRecognizerDelegate
        
        txtNumber.isUserInteractionEnabled = true
        let tap_txtNumber: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapNumber))
        txtNumber.addGestureRecognizer(tap_txtNumber)
        tap_txtNumber.delegate = self as? UIGestureRecognizerDelegate
        
        imgNumber.isUserInteractionEnabled = true
        let tap_imgNumber: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapNumber))
        imgNumber.addGestureRecognizer(tap_imgNumber)
        tap_imgNumber.delegate = self as? UIGestureRecognizerDelegate
        
        // КВАРТИРА
        edOrg.isUserInteractionEnabled = true
        let tapFlat: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapFlat))
        edOrg.addGestureRecognizer(tapFlat)
        tapFlat.delegate = self as? UIGestureRecognizerDelegate
        
        txtOrg.isUserInteractionEnabled = true
        let tap_txtOrg: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapFlat))
        txtOrg.addGestureRecognizer(tap_txtOrg)
        tap_txtOrg.delegate = self as? UIGestureRecognizerDelegate
        
        imgOrg.isUserInteractionEnabled = true
        let tap_imgOrg: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapFlat))
        imgOrg.addGestureRecognizer(tap_imgOrg)
        tap_imgOrg.delegate = self as? UIGestureRecognizerDelegate
    }
    
    func getStreets(id: String) {
        ShowIndicators(num_ind: 1)
        let urlPath = "http://88.99.252.202:8082/api/FiasSearch/GetAllStreetsByObject?objectGuid=" + id.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&json=true"
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    return
                                                }
                                                self.streetString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("street = \(String(describing: self.streetString))")
                                                do {
                                                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyObject]
                                                    
                                                    // Получим список улиц
                                                    if ((json.count) == 0) {
                                                    } else {
                                                        json.forEach{
                                                            self.street_names.append($0["FormalName"]!! as! String)
                                                            self.street_ids.append($0["AoGuid"]!! as! String)
                                                        }
                                                    }
                                                    self.end_choice(num: 1)
                                                    
                                                    
                                                } catch let error as NSError {
                                                    print(error)
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
        if (segue.identifier == "get_street_new") {
            
            prepare_seque_for_choice(teck: teck_street, names: street_names, segue: segue, numb: 1)
            
        } else if (segue.identifier == "get_number_new") {
            
            prepare_seque_for_choice(teck: teck_number, names: number_names, segue: segue, numb: 2)
            
        } else if (segue.identifier == "get_flat_new") {
            
            prepare_seque_for_choice(teck: teck_flat, names: orgCity_names, segue: segue, numb: 3)
            
        }
    }
    
    func prepare_seque_for_choice(teck: Int, names: [String], segue: UIStoryboardSegue, numb: Int) {
        let selectItemController = (segue.destination as! UINavigationController).viewControllers.first as! SelectItemController
        selectItemController.strings = names
        selectItemController.selectedIndex = teck
        selectItemController.selectHandler = { selectedIndex in
            
            if (numb == 1) {
                self.teck_street = selectedIndex
                self.ClearNumbers()
                self.ClearFlats()
                
                let choice_name_number   = self.street_ids[selectedIndex]
                self.AddNumber(name: choice_name_number)
            } else if (numb == 2) {
                self.teck_number = selectedIndex
                self.ClearFlats()
                
                let choice_id_number   = self.number_ids[selectedIndex]
                self.AddOrg(id: choice_id_number)
            } else {
                self.teck_flat = selectedIndex
            }
            
            self.edStreet.text   = self.appString(teck: self.teck_street, names: self.street_names)
            self.edNumber.text   = self.appString(teck: self.teck_number, names: self.number_names)
            self.edOrg.text     = self.appString(teck: self.teck_flat, names: self.orgCity_names)
            self.orgLbl.text    = self.appString(teck: self.teck_flat, names: self.orgCity_names)
            if self.teck_flat != -1{
                self.orgLblHeight.constant = self.heightForView(text: self.appString(teck: self.teck_flat, names: self.orgCity_names), font: self.orgLbl.font, width: self.orgLbl.frame.size.width)
                self.nonorgConst.constant = 43 + self.orgLblHeight.constant
            }
        }
    }
    
    // Очистка значений при перевыборе
    func ClearNumbers() {
        number_names = []
        number_ids = []
        teck_number = -1
    }
    
    func ClearFlats() {
        orgCity_names = []
        orgCity_ids = []
        teck_flat = -1
    }
    
    // Процедура отображения названий
    func appString(teck: Int, names: [String]) -> String {
        if teck == -1 {
            return "    "
        }
        if teck >= 0 && teck < names.count {
            return names[teck]
        }
        return "    "
    }
    
    func AddNumber(name: String) {
        ShowIndicators(num_ind: 2)
        let urlPath = "http://88.99.252.202:8082/api/FiasSearch/GetAllHousesByStreet?streetGuid=" + name.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&json=true"
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                self.streetString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("street = \(String(describing: self.streetString))")
                                                if error != nil {
                                                    return
                                                }
                                                
                                                do {
                                                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyObject]
                                                    
                                                    // Получим список улиц
                                                    if ((json.count) == 0) {
                                                    } else {
                                                        json.forEach{
                                                            self.number_names.append($0["Number"]!! as! String)
                                                            self.number_ids.append($0["HouseGuid"]!! as! String)
                                                        }
                                                    }
                                                } catch let error as NSError {
                                                    print(error)
                                                }
                                                self.end_choice(num: 2)
        })
        task.resume()
    }
    
    func AddOrg(id: String) {
        ShowIndicators(num_ind: 3)
        let urlPath = "http://88.99.252.202:8082/api/FiasSearch/GetOrgDataByHouse?houseGuid=" + id.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&json=true"
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                self.streetString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("street = \(String(describing: self.streetString))")
                                                if error != nil {
                                                    return
                                                }
                                                
                                                do {
                                                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyObject]
                                                    
                                                    // Получим список улиц
                                                    if ((json.count) == 0) {
                                                    } else {
                                                        json.forEach{
                                                            self.orgCity_names.append($0["FullName"]!! as! String)
                                                            self.orgCity_ids.append($0["Guid"]!! as! String)
                                                        }
                                                    }
                                                } catch let error as NSError {
                                                    print(error)
                                                }
                                                
                                                self.end_choice(num: 3)
                                                
        })
        task.resume()
    }
    
    // Показать индикаторы
    func HideIndicators(num_ind: Int) {
        
        if (num_ind == 1) {
            ShowHideStreets(show_hide: false)
            ShowHideNumbers(show_hide: false)
            ShowHideFlats(show_hide: false)
        } else if (num_ind == 2) {
            ShowHideNumbers(show_hide: false)
            ShowHideFlats(show_hide: false)
        } else if (num_ind == 3) {
            ShowHideFlats(show_hide: false)
            if (self.orgCity_ids.count == 0){
                self.txtOrg.isHidden = true
                self.edOrg.isHidden = true
                self.imgOrg.isHidden = true
                self.separator3.isHidden = true
                self.nonorgConst.constant = 15
                self.orgLbl.isHidden = true
            }else{
                self.nonorgConst.constant = 73
                self.separator3.isHidden = false
            }
        }
    }
    
    // Скрыть индикаторы
    func ShowIndicators(num_ind: Int) {
        if (num_ind == 1) {
            ShowHideStreets(show_hide: true)
            ShowHideNumbers(show_hide: true)
            ShowHideFlats(show_hide: true)
        } else if (num_ind == 2) {
            ShowHideNumbers(show_hide: true)
            ShowHideFlats(show_hide: true)
        } else if (num_ind == 3) {
            ShowHideFlats(show_hide: true)
        }
    }
    
    func ShowHideStreets(show_hide: Bool) {
        edStreet.isHidden         = show_hide
        txtStreet.isHidden        = show_hide
        imgStreet.isHidden        = show_hide
        
        indicator_street.isHidden = !show_hide
    }
    
    func ShowHideNumbers(show_hide: Bool) {
        edNumber.isHidden         = show_hide
        txtNumber.isHidden        = show_hide
        imgNumber.isHidden        = show_hide
        
        indicatorNumber.isHidden = !show_hide
    }
    
    func ShowHideFlats(show_hide: Bool) {
        edOrg.isHidden         = show_hide
        txtOrg.isHidden        = show_hide
        imgOrg.isHidden        = show_hide
        orgLbl.isHidden        = show_hide
        
        indicatorOrg.isHidden = !show_hide
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
