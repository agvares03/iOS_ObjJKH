//
//  ChoiceRegionController.swift
//  JKH_Pocket
//
//  Created by Sergey Ivanov on 15/04/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class ChoiceRegionController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var separator1: UILabel!
    @IBOutlet weak var separator2: UILabel!
    @IBOutlet weak var separator3: UILabel!
    @IBOutlet weak var nonAreaConst: NSLayoutConstraint!
    
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    // Массивы для хранения данных
    var region_names: [String] = []
    var region_ids: [String] = []
    var teck_street: Int = -1
    var streetString: String?
    
    var districs_names: [String] = []
    var districs_ids: [String] = []
    var teck_number: Int = -1
    
    var areaCity_names: [String] = []
    var areaCity_ids: [String] = []
    var teck_flat: Int = -1
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var btnNext: UIButton!
    
    // Телефон, который регистрируется
    var phone: String = ""
    var response_add_ident: String?
    
    @IBOutlet weak var txtRegion: UILabel!
    @IBOutlet weak var edRegion: UITextField!
    @IBOutlet weak var indicator_region: UIActivityIndicatorView!
    @IBOutlet weak var imgRegion: UIImageView!
    
    @IBOutlet weak var txtDistrict: UILabel!
    @IBOutlet weak var edDistrict: UITextField!
    @IBOutlet weak var indicatorDistrict: UIActivityIndicatorView!
    @IBOutlet weak var imgDistrict: UIImageView!
    
    @IBOutlet weak var txtArea: UILabel!
    @IBOutlet weak var edArea: UITextField!
    @IBOutlet weak var indicatorArea: UIActivityIndicatorView!
    @IBOutlet weak var imgArea: UIImageView!
    
    @IBAction func NextAction(_ sender: UIButton){
        if teck_number != -1{
            self.performSegue(withIdentifier: "nextStreet", sender: self)
        }else{
            let alert = UIAlertController(title: "Ошибка", message: "Вы не выбрали Город/Район региона", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func supportBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "support", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator_region.startAnimating()
        indicatorArea.startAnimating()
        indicatorDistrict.startAnimating()
        HideIndicators(num_ind: 1)
        
        let defaults = UserDefaults.standard
        phone = defaults.string(forKey: "phone")!
        
        initListeners()
        
        // Первый показ - подгрузим улицы сразу
        getStreets()
        edArea.delegate = self
        edDistrict.delegate = self
        edRegion.delegate = self
        // Установим цвета для элементов в зависимости от Таргета
        btnNext.backgroundColor = myColors.btnColor.uiColor()
        back.tintColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
        separator3.backgroundColor = myColors.labelColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        
        #if isOur_Obj_Home
        txtDistrictLS.text = "Номер лицевого счета Сбербанка"
        #endif
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == edArea || textField == edDistrict || textField == edRegion {
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
        edRegion.isUserInteractionEnabled = true
        let tapStreet: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapStreet))
        edRegion.addGestureRecognizer(tapStreet)
        tapStreet.delegate = self as? UIGestureRecognizerDelegate
        
        txtRegion.isUserInteractionEnabled = true
        let tap_txtRegion: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapStreet))
        txtRegion.addGestureRecognizer(tap_txtRegion)
        tap_txtRegion.delegate = self as? UIGestureRecognizerDelegate
        
        imgRegion.isUserInteractionEnabled = true
        let tap_imgRegion: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapStreet))
        imgRegion.addGestureRecognizer(tap_imgRegion)
        tap_imgRegion.delegate = self as? UIGestureRecognizerDelegate
        
        // НОМЕР ДОМА
        edDistrict.isUserInteractionEnabled = true
        let tapNumber: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapNumber))
        edDistrict.addGestureRecognizer(tapNumber)
        tapNumber.delegate = self as? UIGestureRecognizerDelegate
        
        txtDistrict.isUserInteractionEnabled = true
        let tap_txtDistrict: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapNumber))
        txtDistrict.addGestureRecognizer(tap_txtDistrict)
        tap_txtDistrict.delegate = self as? UIGestureRecognizerDelegate
        
        imgDistrict.isUserInteractionEnabled = true
        let tap_imgDistrict: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapNumber))
        imgDistrict.addGestureRecognizer(tap_imgDistrict)
        tap_imgDistrict.delegate = self as? UIGestureRecognizerDelegate
        
        // КВАРТИРА
        edArea.isUserInteractionEnabled = true
        let tapFlat: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapFlat))
        edArea.addGestureRecognizer(tapFlat)
        tapFlat.delegate = self as? UIGestureRecognizerDelegate
        
        txtArea.isUserInteractionEnabled = true
        let tap_txtArea: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapFlat))
        txtArea.addGestureRecognizer(tap_txtArea)
        tap_txtArea.delegate = self as? UIGestureRecognizerDelegate
        
        imgArea.isUserInteractionEnabled = true
        let tap_imgArea: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapFlat))
        imgArea.addGestureRecognizer(tap_imgArea)
        tap_imgArea.delegate = self as? UIGestureRecognizerDelegate
    }
    
    func getStreets() {
        ShowIndicators(num_ind: 1)
        let urlPath = "http://88.99.252.202:8082/api/FiasSearch/GetAllRegions?json=true"
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
//        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    return
                                                }
                                                
                                                self.streetString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("REGION = \(String(describing: self.streetString))")
                                                do {
                                                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyObject]
                                                    
                                                    // Получим список улиц
                                                    if ((json.count) == 0) {
                                                    } else {
                                                        json.forEach{
                                                            if $0["FormalName"]!! as! String != ""{
                                                                self.region_names.append($0["FormalName"]!! as! String)
                                                                self.region_ids.append($0["AoGuid"]!! as! String)
                                                            }
                                                            
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
            
            prepare_seque_for_choice(teck: teck_street, names: region_names, segue: segue, numb: 1)
            
        } else if (segue.identifier == "get_number_new") {
            
            prepare_seque_for_choice(teck: teck_number, names: districs_names, segue: segue, numb: 2)
            
        } else if (segue.identifier == "get_flat_new") {
            
            prepare_seque_for_choice(teck: teck_flat, names: areaCity_names, segue: segue, numb: 3)
            
        }else if (segue.identifier == "nextStreet") {
            let selectItemController = segue.destination as! ChoiceStreetPocketController
            if teck_flat == -1{
                selectItemController.idObject = districs_ids[teck_number]
            }else{
                selectItemController.idObject = areaCity_ids[teck_flat]
            }
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
                
                let choice_name_district   = self.region_ids[selectedIndex]
                self.AddCity(name: choice_name_district)
            } else if (numb == 2) {
                self.teck_number = selectedIndex
                self.ClearFlats()
                if self.districs_names[selectedIndex].contains(" г"){
                    self.txtArea.text = "Район города"
                }else{
                    self.txtArea.text = "Населённый пункт"
                }
                let choice_id_number   = self.districs_ids[selectedIndex]
                self.AddArea(id: choice_id_number)
            } else {
                self.teck_flat = selectedIndex
            }
            
            self.edRegion.text   = self.appString(teck: self.teck_street, names: self.region_names)
            self.edDistrict.text   = self.appString(teck: self.teck_number, names: self.districs_names)
            self.edArea.text     = self.appString(teck: self.teck_flat, names: self.areaCity_names)
            
        }
    }
    
    // Очистка значений при перевыборе
    func ClearNumbers() {
        districs_names = []
        districs_ids = []
        teck_number = -1
    }
    
    func ClearFlats() {
        areaCity_names = []
        areaCity_ids = []
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
    
    func AddCity(name: String) {
        ShowIndicators(num_ind: 2)
        let urlPath = "http://88.99.252.202:8082/api/FiasSearch/GetAllCitiesByRegion?regionGuid=" + name.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&json=true"
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                self.streetString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("CITY = \(String(describing: self.streetString))")
                                                if error != nil {
                                                    return
                                                }
                                                
                                                do {
                                                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyObject]
                                                    
                                                    // Получим список улиц
                                                    if ((json.count) == 0) {
                                                    } else {
                                                        json.forEach{
                                                            self.districs_names.append($0["FormalName"]!! as! String)
                                                            self.districs_ids.append($0["AoGuid"]!! as! String)
                                                        }
                                                    }
                                                } catch let error as NSError {
                                                    print(error)
                                                }
                                                self.AddDistrics(name: name)
        })
        task.resume()
    }
    
    // Подтягивание данных динамически
    func AddDistrics(name: String) {
        let urlPath = "http://88.99.252.202:8082/api/FiasSearch/GetAllDistricsByRegion?regionGuid=" + name.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&json=true"
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
                                                do {
                                                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyObject]
                                                    
                                                    // Получим список улиц
                                                    if ((json.count) == 0) {
                                                    } else {
                                                        json.forEach{
                                                            if $0["FormalName"]!! as! String != ""{
                                                                self.districs_names.append($0["FormalName"]!! as! String)
                                                                self.districs_ids.append($0["AoGuid"]!! as! String)
                                                            }
                                                            
                                                        }
                                                    }
                                                } catch let error as NSError {
                                                    print(error)
                                                }
                                                
                                                self.end_choice(num: 2)
                                                
        })
        task.resume()
    }
    
    func AddArea(id: String) {
        ShowIndicators(num_ind: 3)
        let urlPath = "http://88.99.252.202:8082/api/FiasSearch/GetAllObjectsInsideDistrictOrCity?objectGuid=" + id.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&json=true"
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                self.streetString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("REGION = \(String(describing: self.streetString))")
                                                if error != nil {
                                                    return
                                                }
                                                
                                                do {
                                                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyObject]
                                                    
                                                    // Получим список улиц
                                                    if ((json.count) == 0) {
                                                    } else {
                                                        json.forEach{
                                                            if $0["FormalName"]!! as! String != ""{
                                                                self.areaCity_names.append($0["FormalName"]!! as! String)
                                                                self.areaCity_ids.append($0["AoGuid"]!! as! String)
                                                            }
                                                            
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
            if (self.areaCity_ids.count == 0){
                self.txtArea.isHidden = true
                self.edArea.isHidden = true
                self.imgArea.isHidden = true
                self.separator3.isHidden = true
                self.nonAreaConst.constant = 15
            }else{
                self.nonAreaConst.constant = 73
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
        edRegion.isHidden         = show_hide
        txtRegion.isHidden        = show_hide
        imgRegion.isHidden        = show_hide
        
        indicator_region.isHidden = !show_hide
    }
    
    func ShowHideNumbers(show_hide: Bool) {
        edDistrict.isHidden         = show_hide
        txtDistrict.isHidden        = show_hide
        imgDistrict.isHidden        = show_hide
        
        indicatorDistrict.isHidden = !show_hide
    }
    
    func ShowHideFlats(show_hide: Bool) {
        edArea.isHidden         = show_hide
        txtArea.isHidden        = show_hide
        imgArea.isHidden        = show_hide
        
        indicatorArea.isHidden = !show_hide
    }
    
}
