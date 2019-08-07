//
//  EditAccountController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 16/01/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class NewEditAccountController: UIViewController, UITableViewDelegate, UITableViewDataSource, DebtCellDelegate, DelLSCellDelegate {
    
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var elipseBackground: UIView!
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    @IBOutlet weak var noPrivLS: UILabel!
    @IBOutlet weak var privLS1: UILabel!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var separator: UILabel!
    @IBOutlet weak var separator1: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var fioText: UITextField!
    @IBOutlet weak var fioLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addLSBtn: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBOutlet weak var nonSaveSwitch: UISwitch!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var settingsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var settingsViewTop: NSLayoutConstraint!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        if (isModified) {
            let defaults = UserDefaults.standard
            var str_rezult: String = ""
            if (data.count > 0) {
                for i in 0..<data.count {
                    if (i == 0) {
                        str_rezult = data[i]
                    } else {
                        str_rezult = str_rezult + "," + data[i]
                    }
                }
            }
            
            // Запишем в память новый список лицевых счетов
            defaults.set(emailText.text, forKey: "mail")
            defaults.set(str_rezult, forKey: "str_ls")
            defaults.synchronize()
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func try_del_ls_from_acc(ls: String) {
        
        let defaults = UserDefaults.standard
        let phone = defaults.string(forKey: "phone")
        let ident =  ls
        
        if (phone == ident) {
            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Невозможно отвязать лицевой счет " + ident + ". Вы зашли, используя этот лицевой счет.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Отвязать лицевой счет " + ident + " от аккаунта?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
                
                var urlPath = Server.SERVER + Server.MOBILE_API_PATH + Server.DEL_IDENT_ACC
                urlPath = urlPath + "phone=" + phone! + "&ident=" + ident.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                let url: NSURL = NSURL(string: urlPath)!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "GET"
                
                let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                      completionHandler: {
                                                        data, response, error in
                                                        
                                                        if error != nil {
                                                            DispatchQueue.main.async(execute: {
                                                                UserDefaults.standard.set("Ошибка соединения с сервером", forKey: "errorStringSupport")
                                                                UserDefaults.standard.synchronize()
                                                                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                                                                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                                                                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                                                                    self.performSegue(withIdentifier: "support", sender: self)
                                                                }
                                                                alert.addAction(cancelAction)
                                                                alert.addAction(supportAction)
                                                                self.present(alert, animated: true, completion: nil)
                                                            })
                                                            return
                                                        }
                                                        
                                                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                        print("responseString = \(responseString)")
                                                        
                                                        DispatchQueue.main.async{
                                                            let defaults = UserDefaults.standard
                                                            
                                                            defaults.set(true, forKey: "go_to_app")
                                                            defaults.synchronize()
                                                            // Перейдем на главную страницу со входом в приложение
                                                            self.performSegue(withIdentifier: "go_to_app", sender: self)
                                                        }
                })
                task.resume()
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func AddLS(_ sender: UIButton) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "addLSMup", sender: self)
        #elseif isPocket
        self.performSegue(withIdentifier: "addLSPocket", sender: self)
        #elseif isRodnikMUP
        self.performSegue(withIdentifier: "addLSSimple", sender: self)
        #else
        self.performSegue(withIdentifier: "addLS", sender: self)
        #endif
    }
    
    @IBAction func SaveInfo(_ sender: UIButton) {
        let email:String = emailText.text!
        let validEmail = DB().isValidEmail(testStr: email)
        if validEmail{
            UserDefaults.standard.set(email, forKey: "mail")
            
            let defaults = UserDefaults.standard
            let phone:String = defaults.string(forKey: "phone")!
            let fio:String = fioText.text!
            var urlPath = Server.SERVER + Server.MOBILE_API_PATH + Server.SET_EMAIL_ACC
            urlPath = urlPath + "phone=" + phone + "&email=" + email + "&fio" + fio.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            print(request)
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        DispatchQueue.main.async(execute: {
                                                            UserDefaults.standard.set("Ошибка соединения с сервером", forKey: "errorStringSupport")
                                                            UserDefaults.standard.synchronize()
                                                            let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                                                            let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                                                            let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                                                                self.performSegue(withIdentifier: "support", sender: self)
                                                            }
                                                            alert.addAction(cancelAction)
                                                            alert.addAction(supportAction)
                                                            self.present(alert, animated: true, completion: nil)
                                                        })
                                                        return
                                                    }
                                                    
                                                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                    print("responseString = \(responseString)")
                                                    if responseString == "ok"{
                                                        DispatchQueue.main.async(execute: {
                                                            let alert = UIAlertController(title: "", message: "Данные успешно сохранены", preferredStyle: .alert)
                                                            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                            alert.addAction(cancelAction)
                                                            self.present(alert, animated: true, completion: nil)
                                                        })
                                                    }else{
                                                        DispatchQueue.main.async(execute: {
                                                            UserDefaults.standard.set("Ошибка соединения с сервером", forKey: "errorStringSupport")
                                                            UserDefaults.standard.synchronize()
                                                            let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                                                            let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                                                            let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                                                                self.performSegue(withIdentifier: "support", sender: self)
                                                            }
                                                            alert.addAction(cancelAction)
                                                            alert.addAction(supportAction)
                                                            self.present(alert, animated: true, completion: nil)
                                                        })
                                                    }
                                                    
            })
            task.resume()
        }else{
            let alert = UIAlertController(title: "Ошибка", message: "Укажите корректный e-mail!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    var data = [String]()
    var isModified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        #if isOur_Obj_Home
        fon_top.image = UIImage(named: "logo_Our_Obj_Home")
        #elseif isChist_Dom
        fon_top.image = UIImage(named: "Logo_Chist_Dom")
        #elseif isMupRCMytishi
        fon_top.image = UIImage(named: "logo_MupRCMytishi")
        #elseif isDJ
        fon_top.image = UIImage(named: "logo_DJ")
        #elseif isStolitsa
        fon_top.image = UIImage(named: "logo_Stolitsa")
        #elseif isKomeks
        fon_top.image = UIImage(named: "Logo_Komeks")
        #elseif isUKKomfort
        fon_top.image = UIImage(named: "logo_UK_Komfort")
        #elseif isKlimovsk12
        fon_top.image = UIImage(named: "logo_Klimovsk12")
        #elseif isPocket
        fon_top.image = UIImage(named: "Logo_Pocket")
        #elseif isReutKomfort
        fon_top.image = UIImage(named: "Logo_ReutKomfort")
        #elseif isUKGarant
        fon_top.image = UIImage(named: "Logo_UK_Garant")
        #elseif isSoldatova1
        fon_top.image = UIImage(named: "Logo_Soldatova1")
        #elseif isTafgai
        fon_top.image = UIImage(named: "Logo_Tafgai_White")
        #elseif isServiceKomfort
        fon_top.image = UIImage(named: "Logo_ServiceKomfort_White")
        #elseif isParitet
        fon_top.image = UIImage(named: "Logo_Paritet")
        #elseif isSkyfort
        fon_top.image = UIImage(named: "Logo_Skyfort")
        #elseif isStandartDV
        fon_top.image = UIImage(named: "Logo_StandartDV")
        #elseif isGarmonia
        fon_top.image = UIImage(named: "Logo_UkGarmonia")
        #elseif isUpravdomChe
        fon_top.image = UIImage(named: "Logo_UkUpravdomChe")
        #elseif isJKH_Pavlovskoe
        fon_top.image = UIImage(named: "Logo_JKH_Pavlovskoe")
        #elseif isPerspectiva
        fon_top.image = UIImage(named: "Logo_UkPerspectiva")
        #elseif isParus
        fon_top.image = UIImage(named: "Logo_Parus")
        #elseif isUyutService
        fon_top.image = UIImage(named: "Logo_UyutService")
        #elseif isElectroSbitSaratov
        fon_top.image = UIImage(named: "Logo_ElectrosbitSaratov")
        #elseif isServicekom
        fon_top.image = UIImage(named: "Logo_Servicekom")
        #elseif isTeplovodoresources
        fon_top.image = UIImage(named: "Logo_Teplovodoresources")
        #elseif isStroimBud
        fon_top.image = UIImage(named: "Logo_StroimBud")
        #elseif isRodnikMUP
        fon_top.image = UIImage(named: "Logo_RodnikMUP")
        #elseif isUKParitetKhab
        fon_top.image = UIImage(named: "Logo_Paritet")
        #elseif isADS68
        fon_top.image = UIImage(named: "Logo_ADS68")
        #elseif isAFregat
        fon_top.image = UIImage(named: "Logo_Fregat")
        #elseif isNewOpaliha
        fon_top.image = UIImage(named: "Logo_NewOpaliha")
        #elseif isPritomskoe
        fon_top.image = UIImage(named: "Logo_Pritomskoe")
        #endif
        
        if UserDefaults.standard.string(forKey: "mail") != ""{
            emailText.text = UserDefaults.standard.string(forKey: "mail")
        }
        if UserDefaults.standard.string(forKey: "mail") == "-"{
            emailText.text = ""
        }
        if UserDefaults.standard.string(forKey: "name") != ""{
            fioText.text = UserDefaults.standard.string(forKey: "name")
            fioLbl.text = UserDefaults.standard.string(forKey: "name")
        }
        //        noPrivLS.isHidden = true
        elipseBackground.backgroundColor = myColors.btnColor.uiColor()
        backBtn.tintColor = myColors.btnColor.uiColor()
        saveBtn.backgroundColor = myColors.btnColor.uiColor()
        addLSBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        separator.backgroundColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.btnColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        nonSaveSwitch.tintColor = myColors.btnColor.uiColor()
        nonSaveSwitch.onTintColor = myColors.btnColor.uiColor()
        #if isStolitsa
        if UserDefaults.standard.bool(forKey: "settSaveCard"){
            nonSaveSwitch.isOn = true
            UserDefaults.standard.set(true, forKey: "settSaveCard")
        }else{
            nonSaveSwitch.isOn = false
            UserDefaults.standard.set(false, forKey: "settSaveCard")
        }
        settingsViewHeight.constant = 110
        settingsViewTop.constant = 15
        settingsView.isHidden = false
        #elseif isUKKomfort
        if UserDefaults.standard.bool(forKey: "settSaveCard"){
            nonSaveSwitch.isOn = true
            UserDefaults.standard.set(true, forKey: "settSaveCard")
        }else{
            nonSaveSwitch.isOn = false
            UserDefaults.standard.set(false, forKey: "settSaveCard")
        }
        settingsViewHeight.constant = 110
        settingsViewTop.constant = 15
        settingsView.isHidden = false
        #else
        settingsViewHeight.constant = 0
        settingsViewTop.constant = 0
        settingsView.isHidden = true
        #endif
        if UserDefaults.standard.bool(forKey: "dontShowDebt"){
            settingsViewHeight.constant = 0
            settingsViewTop.constant = 0
            settingsView.isHidden = true
        }
        //        tableView.setEditing(true, animated: true)
    }
    
    @IBAction func switch_Go(_ sender: UISwitch) {
        if nonSaveSwitch.isOn{
            UserDefaults.standard.set(true, forKey: "settSaveCard")
        }else{
            UserDefaults.standard.set(false, forKey: "settSaveCard")
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = show ? 0 : 135
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.keyboardHeight.constant = CGFloat(changeInHeight)
        })
        
    }
    
    var lsArr:[lsData] = []
    var dateOld = "01.01"
    func getDebt() {
        var debtIdent:[String] = []
        var debtSum:[String] = []
        var debtSumFine:[String] = []
        var debtDate:[String] = []
        var debtAddress:[String] = []
        let defaults = UserDefaults.standard
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        var sumObj = 0.00
        var u = 0
        let login = defaults.string(forKey: "login")
        if (str_ls_arr?.count)! > 0 && str_ls_arr?[0] != ""{
            //            str_ls_arr?.forEach{
            let urlPath = Server.SERVER + "MobileAPI/GetDebt.ashx?" + "phone=" + login!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            print(request)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        return
                                                    } else {
                                                        do {
                                                            u += 1
                                                            let responseStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                            print(responseStr)
                                                            
                                                            if !responseStr.contains("error"){
                                                                var date        = ""
                                                                var sum         = ""
                                                                var sumFine     = ""
                                                                var ls = ""
                                                                var address = ""
                                                                
                                                                //                                                                var sumOver     = ""
                                                                //                                                                var sumFineOver = ""
                                                                //                                                                    var sumAll      = ""
                                                                var json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                                //                                                                                                                                        print(json)
                                                                
                                                                if let json_bills = json["data"] {
                                                                    let int_end = (json_bills.count)!-1
                                                                    if (int_end < 0) {
                                                                        
                                                                    } else {
                                                                        for index in 0...int_end {
                                                                            let json_bill = json_bills.object(at: index) as! [String:AnyObject]
                                                                            for obj in json_bill {
                                                                                if obj.key == "Sum" {
                                                                                    if ((obj.value as? NSNull) == nil){
                                                                                        sum = String(describing: obj.value as! Double)
                                                                                    }
                                                                                }
                                                                                if obj.key == "SumFine" {
                                                                                    if ((obj.value as? NSNull) == nil){
                                                                                        sumFine = String(describing: obj.value as! Double)
                                                                                    }
                                                                                }
                                                                                if obj.key == "Address" {
                                                                                    if ((obj.value as? NSNull) == nil){
                                                                                        address = String(describing: obj.value as! String)
                                                                                    }
                                                                                }
                                                                                if obj.key == "Ident" {
                                                                                    if ((obj.value as? NSNull) == nil){
                                                                                        ls = String(describing: obj.value as! String)
                                                                                    }
                                                                                }
                                                                                if obj.key == "DebtActualDate" {
                                                                                    if ((obj.value as? NSNull) == nil){
                                                                                        date = String(describing: obj.value as! String)
                                                                                    }
                                                                                }
                                                                                
                                                                            }
                                                                            //                                                                                if date == ""{
                                                                            //                                                                                    let dateFormatter = DateFormatter()
                                                                            //                                                                                    dateFormatter.dateFormat = "dd.MM.yyyy"
                                                                            //                                                                                    date = dateFormatter.string(from: Date())
                                                                            //                                                                                }
                                                                            debtIdent.append(ls)
                                                                            debtSum.append(sum)
                                                                            debtSumFine.append(sumFine)
                                                                            debtAddress.append(address)
                                                                            debtDate.append(date)
                                                                            self.lsArr.append(lsData.init(ident: ls, sum: sum, sumFine: sumFine, date: date, address: address))
                                                                        }
                                                                        
                                                                        //                                                                            defaults.set(date, forKey: "dateDebt")
                                                                        //                                                                            if Double(sumAll) != 0.00{
                                                                        //                                                                                let d = date.components(separatedBy: ".")
                                                                        //                                                                                let d1 = self.dateOld.components(separatedBy: ".")
                                                                        //                                                                                if (Int(d[0])! >= Int(d1[0])!) && (Int(d[1])! >= Int(d1[1])!){
                                                                        //                                                                                    DispatchQueue.main.async {
                                                                        //                                                                                        self.dateOld = date
                                                                        //                                                                                    }
                                                                        //                                                                                }
                                                                        //                                                                                sumObj = sumObj + Double(sumAll)!
                                                                        //                                                                            }
                                                                    }
                                                                }
                                                                //                                                                    defaults.set(sumObj, forKey: "sumDebt")
                                                                //                                                                    defaults.synchronize()
//                                                                self.parse_Mobile(login: UserDefaults.standard.string(forKey: "login")!)
                                                                DispatchQueue.main.async {
                                                                    self.tableView.reloadData()
                                                                }
                                                            }
                                                            
                                                        } catch let error as NSError {
                                                            print(error)
                                                        }
                                                        
                                                    }
            })
            task.resume()
            //            }
        }
    }
    
    private var values: [HistoryPayCellData] = []
    
    func parse_Mobile(login: String) {
        values.removeAll()
        let urlPath = Server.SERVER + "MobileAPI/GetPays.ashx?" + "phone=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(responseString)")
                                                
                                                if error != nil {
                                                    return
                                                } else {
                                                    do {
                                                        var bill_date    = ""
                                                        var bill_ident   = ""
                                                        var bill_sum = ""
                                                        var bill_status = ""
                                                        var json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                        if let json_bills = json["data"] {
                                                            let int_end = (json_bills.count)!-1
                                                            if (int_end < 0) {
                                                                
                                                            } else {
                                                                
                                                                for index in 0...int_end {
                                                                    let json_bill = json_bills.object(at: index) as! [String:AnyObject]
                                                                    for obj in json_bill {
                                                                        if obj.key == "Date" {
                                                                            bill_date = obj.value as! String
                                                                        }
                                                                        if obj.key == "Ident" {
                                                                            bill_ident = obj.value as! String
                                                                        }
                                                                        if obj.key == "Sum" {
                                                                            bill_sum = String(describing: obj.value as! NSNumber)
                                                                        }
                                                                        if obj.key == "Status" {
                                                                            bill_status = obj.value as! String
                                                                        }
                                                                    }
                                                                    if bill_status == "Оплачен"{
                                                                        self.values.append(HistoryPayCellData(date: bill_date, id: "", ident: bill_ident, period: "", sum: bill_sum, width: 0, payType: 0))
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        DispatchQueue.main.async {
                                                            self.tableView.reloadData()
                                                        }
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                }
        })
        task.resume()
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func get_name_month(number_month: String) -> String {
        var rezult: String = ""
        
        if (number_month == "1") {
            rezult = "Январь"
        } else if (number_month == "2") {
            rezult = "Февраль"
        } else if (number_month == "3") {
            rezult = "Март"
        } else if (number_month == "4") {
            rezult = "Апрель"
        } else if (number_month == "5") {
            rezult = "Май"
        } else if (number_month == "6") {
            rezult = "Июнь"
        } else if (number_month == "7") {
            rezult = "Июль"
        } else if (number_month == "8") {
            rezult = "Август"
        } else if (number_month == "9") {
            rezult = "Сентябрь"
        } else if (number_month == "10") {
            rezult = "Октябрь"
        } else if (number_month == "11") {
            rezult = "Ноябрь"
        } else if (number_month == "12") {
            rezult = "Декабрь"
        }
        
        return rezult
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        DispatchQueue.main.async {
            self.tableHeight.constant = 400
            var height1: CGFloat = 0
            for cell in self.tableView.visibleCells {
                height1 = cell.bounds.height * CGFloat(self.lsArr.count)
            }
            self.tableHeight.constant = height1
        }
        
        return lsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "HomeLSCell1") as! HomeLSCell
        //            cell = shadowCell(cell: cell) as! HomeLSCell
        #if isDJ
        cell.del_ls_btn.isHidden = true
        #endif
        cell.lsText.text = "Лицевой счет:№ " + lsArr[indexPath.row].ident!
        cell.separator.backgroundColor = myColors.btnColor.uiColor()
        cell.payDebt.backgroundColor = myColors.btnColor.uiColor()
        cell.addressText.text = lsArr[indexPath.row].address!
        cell.sumInfo.text = "Сумма к оплате на " + lsArr[indexPath.row].date! + " г."
        cell.sumText.text = lsArr[indexPath.row].sum! + " руб."
        cell.sumText.textColor = myColors.btnColor.uiColor()
        //            var sumAll = 0.00
        //            var isPayToDate = false
        //            var isPayBoDate = false
        //            var sumBoDate = 0.00
        //            self.values.forEach{
        //                    let dateFormatter = DateFormatter()
        //                    dateFormatter.dateFormat = "dd.MM.yyyy"
        //                    let date1: Date = dateFormatter.date(from: $0.date.replacingOccurrences(of: " 00:00:00", with: ""))!
        //                    let date2: Date = dateFormatter.date(from: lsArr[indexPath.row].date!)!
        //                    if date2 > date1{
        ////                        #if isMupRCMytishi
        ////                        let serviceP = self.sum / 0.992 - self.sum
        ////                        #else
        ////                        let serviceP = UserDefaults.standard.double(forKey: "servPercent") * Double($0.sum)! / 100
        ////                        #endif
        //                        sumAll = sumAll + Double($0.sum)!
        //                    }
        //            }
        //            let sum:Double = Double(lsArr[indexPath.row].sum!) as! Double
        //            if sumAll == sum{
        //                isPayToDate = true
        //            }else if sumAll > sum{
        //                sumBoDate = sumAll - sum
        //                isPayBoDate = true
        //            }
        //            print(sumAll, sumBoDate, sum)
        //            if (Double(lsArr[indexPath.row].sum!)! > 0.00 && isPayBoDate) || (Double(lsArr[indexPath.row].sum!)! < 0.00){
        if Double(lsArr[indexPath.row].sum!)! < 0.00{
            cell.noDebtText.isHidden = false
            cell.payDebt.isHidden = true
            cell.topPeriodConst.constant = 0
            cell.bottViewHeight.constant = 0
            cell.payDebtHeight.constant = 0
            cell.sumViewHeight.constant = 50
            cell.sumInfo.text = "Имеется переплата на " + lsArr[indexPath.row].date! + " на сумму"
            cell.sumText.text = lsArr[indexPath.row].sum!.replacingOccurrences(of: "-", with: "") + " руб."
            //            }else if Double(lsArr[indexPath.row].sum!)! > 0.00 && isPayToDate{
            //                cell.noDebtText.isHidden = false
            //                cell.payDebt.isHidden = true
            //                cell.topPeriodConst.constant = 20
            //                cell.sumViewHeight.constant = 0
            //                cell.payDebtHeight.constant = 0
            //                if self.view.frame.size.width > 320{
            //                    cell.bottViewHeight.constant = 50
            //                }else{
            //                    cell.bottViewHeight.constant = 70
            //                }
        }else if Double(lsArr[indexPath.row].sum!)! > 0.00{
            //                cell.separator.isHidden = true
            cell.noDebtText.isHidden = true
            cell.payDebt.isHidden = false
            cell.topPeriodConst.constant = 5
            if self.view.frame.size.width > 320{
                cell.bottViewHeight.constant = 30
            }else{
                cell.bottViewHeight.constant = 50
            }
        }else{
            cell.noDebtText.isHidden = true
            cell.payDebt.isHidden = true
            cell.periodPay.isHidden = true
            cell.allPayText.isHidden = false
            cell.allPayText.text = "Все квитанции оплачены на " + lsArr[indexPath.row].date! + " г."
            cell.sumViewHeight.constant = 0
            cell.payDebtHeight.constant = 0
            cell.bottViewHeight.constant = 50
        }
        cell.delegate = self
        cell.delegate2 = self
        if UserDefaults.standard.bool(forKey: "dontShowDebt"){
            cell.bottViewHeight.constant = 0
            cell.sumViewHeight.constant = 0
            cell.payDebtHeight.constant = 0
            cell.separator.isHidden = true
            cell.noDebtText.isHidden = true
            cell.payDebt.isHidden = true
            cell.periodPay.isHidden = true
            cell.allPayText.isHidden = true
        }
        return cell
    }
    var debtArr:[AnyObject] = []
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debtArr.removeAll()
        var debt:[String:String] = [:]
        if lsArr.count != 0{
            for i in 0...lsArr.count - 1{
                debt["Ident"] = lsArr[i].ident
                debt["Sum"] = lsArr[i].sum
                debt["SumFine"] = lsArr[i].sumFine
                debtArr.append(debt as AnyObject)
            }
        }
        if segue.identifier == "paysMytishi" {
            let payController             = segue.destination as! PaysMytishiController
            if choiceIdent == ""{
                payController.saldoIdent = "Все"
            }else{
                payController.saldoIdent = choiceIdent
            }
            payController.debtArr = self.debtArr
            payController.isHomePage = true
        }
        #if isMupRCMytishi
        if segue.identifier == "paysMytishi2" {
            let payController             = segue.destination as! PaysMytishi2Controller
            if choiceIdent == ""{
                payController.saldoIdent = "Все"
            }else{
                payController.saldoIdent = choiceIdent
            }
            payController.debtArr = self.debtArr
        }
        #endif
        if segue.identifier == "pays" {
            let payController             = segue.destination as! PaysController
            if choiceIdent == ""{
                payController.saldoIdent = "Все"
            }else{
                payController.saldoIdent = choiceIdent
            }
            payController.debtArr = self.debtArr
        }
    }
    
    var choiceIdent = ""
    func goPaysPressed(ident: String) {
        choiceIdent = ident
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "paysMytishi2", sender: self)
        #else
        self.performSegue(withIdentifier: "paysMytishi", sender: self)
        #endif
    }
    
    // Override to support conditional editing of the table view.
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        // Return false if you do not want the specified item to be editable.
    //        return true
    //    }
    
    // Override to support editing the table view.
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            try_del_ls_from_acc(ls: data[indexPath.row], row: indexPath)
    //        } else if editingStyle == .insert {
    //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //        }
    //    }
    
    func try_del_ls_from_acc(ls: String, row: IndexPath) {
        
        let defaults = UserDefaults.standard
        let phone = defaults.string(forKey: "phone")
        let ident =  ls
        
        if (phone == ident) {
            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Невозможно отвязать лицевой счет " + ls + ". Вы зашли, используя этот лицевой счет.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Отвязать лицевой счет " + ls + " от аккаунта?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
                
                var urlPath = Server.SERVER + Server.MOBILE_API_PATH + Server.DEL_IDENT_ACC
                urlPath = urlPath + "phone=" + phone! + "&ident=" + ident
                let url: NSURL = NSURL(string: urlPath)!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "GET"
                
                let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                      completionHandler: {
                                                        data, response, error in
                                                        
                                                        if error != nil {
                                                            UserDefaults.standard.set("Ошибка соединения с сервером", forKey: "errorStringSupport")
                                                            UserDefaults.standard.synchronize()
                                                            DispatchQueue.main.async(execute: {
                                                                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                                                                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                                                                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                                                                    self.performSegue(withIdentifier: "support", sender: self)
                                                                }
                                                                alert.addAction(cancelAction)
                                                                alert.addAction(supportAction)
                                                                self.present(alert, animated: true, completion: nil)
                                                            })
                                                            return
                                                        }
                                                        
                                                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                        print("responseString = \(responseString)")
                                                        
                                                        self.del_ls_from_acc(indexPath: row)
                })
                task.resume()
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func del_ls_from_acc(indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
            self.data.remove(at: indexPath.row)
            self.isModified = true
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.bool(forKey: "NewMain"){
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        lsArr.removeAll()
        getDebt()
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
