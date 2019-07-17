//
//  MupCounterController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 27/02/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import CoreData
import Dropper
import YandexMobileMetrica
import StoreKit

protocol CountersCellDelegate: class {
    func сheckSend(uniq_num: String, count_name: String, ident: String, predValue: String, predValue2: String, predValue3: String, tariffNumber: String)
//    func sendPressed(uniq_num: String, count_name: String, ident: String, predValue: String)
}

class MupCounterController:UIViewController, DropperDelegate, CountersCellDelegate, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    // Глобальные переменные для парсинга
    var parser = XMLParser()
    
    
    var Count: Counters? = nil
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBAction func updateConect(_ sender: UIButton) {
        self.viewDidLoad()
    }
    
    @IBOutlet weak var updateConectBtn: UIButton!
    @IBOutlet weak var nonConectView: UIView!
    
    @IBOutlet weak var addLS: UILabel!
    @IBOutlet weak var lsView: UIView!
    var edLogin: String = ""
    var edPass: String = ""
    
    let dropper = Dropper(width: 150, height: 400)
    
    var currYear: String = ""
    var currMonth: String = ""
    var date1: String = ""
    var date2: String = ""
    var can_edit: String = ""
    var iterYear: String = "0"
    var iterMonth: String = "0"
    var minYear: String = ""
    var minMonth: String = ""
    var maxYear: String = ""
    var maxMonth: String = ""
    var choiceIdent = "Все"
    
    var responseString:NSString = ""
    
    // название месяца для вывода в шапку
    var name_month: String = "";
    
    var fetchedResultsController: NSFetchedResultsController<Counters>?
    
    @IBOutlet weak var spinImg: UIImageView!
    @IBOutlet weak var ls_lbl: UILabel!
    @IBOutlet weak var ls_Button: UIButton!
    @IBOutlet weak var tableCounters: UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var can_count_label: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
//        if UserDefaults.standard.bool(forKey: "NewMain"){
            navigationController?.popViewController(animated: true)
//        }else{
//            navigationController?.dismiss(animated: true, completion: nil)
//        }
    }
    
    @objc private func lblTapped(_ sender: UITapGestureRecognizer) {
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "addLSMup", sender: self)
        #elseif isPocket
        self.performSegue(withIdentifier: "addLSPocket", sender: self)
        #else
        self.performSegue(withIdentifier: "addLS", sender: self)
        #endif
    }
    
    @IBAction func ls_button_choice(_ sender: UIButton) {
        if dropper.status == .hidden {
            
            dropper.theme = Dropper.Themes.white
            //            dropper.cornerRadius = 3
            dropper.showWithAnimation(0.15, options: Dropper.Alignment.center, button: ls_Button)
            view.addSubview(dropper)
        } else {
            dropper.hideWithAnimation(0.1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "PaymentSucces")
        UserDefaults.standard.synchronize()
        let defaults     = UserDefaults.standard
        let params : [String : Any] = ["Переход на страницу": "Показания приборов"]
        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { (error) in
            //            print("DID FAIL REPORT EVENT: %@", message)
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        nonConectView.isHidden = true
        lsView.isHidden = false
        ls_lbl.isHidden = false
        ls_Button.isHidden = false
        monthLabel.isHidden = false
        can_count_label.isHidden = false
        tableCounters.isHidden = false
        spinImg.isHidden = false
        // Получим данные из глобальных сохраненных
        edLogin          = defaults.string(forKey: "login")!
        edPass           = defaults.string(forKey: "pass")!
        if defaults.object(forKey: "year") != nil && defaults.object(forKey: "month") != nil{
            currYear         = defaults.string(forKey: "year")!
            currMonth        = defaults.string(forKey: "month")!
        }else{
            let date = NSDate()
            let calendar = NSCalendar.current
            let resultDate = calendar.component(.year, from: date as Date)
            let resultMonth = calendar.component(.month, from: date as Date)
            defaults.setValue(resultMonth, forKey: "month")
            defaults.setValue(resultDate, forKey: "year")
            currYear = String(resultDate)
            currMonth = String(resultMonth)
        }
        if defaults.object(forKey: "date1") != nil && defaults.object(forKey: "date2") != nil{
            date1            = defaults.string(forKey: "date1")!
            date2            = defaults.string(forKey: "date2")!
        }
        if defaults.object(forKey: "can_count") != nil{
            can_edit         = defaults.string(forKey: "can_count")!
        }
        
        iterMonth = currMonth
        iterYear = currYear
        
        // Установим значения текущие (если нет показаний вообще)
        minMonth = iterMonth
        minYear = iterYear
        maxMonth = iterMonth
        maxYear = iterYear
        
        // Установим значения в шапке
        if (date1 == "0") && (date2 == "0") {
            can_count_label.text = "Возможность передавать показания доступна в текущем месяце!"
        } else {
            can_count_label.text = "Возможность передавать показания доступна с " + date1 + " по " + date2 + " числа текущего месяца!"
        }
        
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        
        dropper.delegate = self
        dropper.items.append("Все")
        if ((str_ls_arr?.count)! > 0) && str_ls_arr![0] != ""{
            for i in 0..<(str_ls_arr?.count ?? 1 - 1) {
                dropper.items.append((str_ls_arr?[i])!)
            }
            lsView.isHidden = true
        }else{
            addLS.textColor = myColors.btnColor.uiColor()
            let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
            let underlineAttributedString = NSAttributedString(string: "Подключить лицевой счет", attributes: underlineAttribute)
            addLS.attributedText = underlineAttributedString
            let tap = UITapGestureRecognizer(target: self, action: #selector(lblTapped(_:)))
            addLS.isUserInteractionEnabled = true
            addLS.addGestureRecognizer(tap)
            lsView.isHidden = false
            ls_lbl.isHidden = true
            ls_Button.isHidden = true
            monthLabel.isHidden = true
            can_count_label.isHidden = true
            tableCounters.isHidden = true
            spinImg.isHidden = true
        }
        
        dropper.showWithAnimation(0.001, options: Dropper.Alignment.center, button: ls_Button)
        dropper.hideWithAnimation(0.001)
        
        tableCounters.delegate = self
        tableCounters.dataSource = self
        monthLabel.text = get_name_month(number_month: iterMonth) + " " + iterYear
        StopIndicator()
//        DB().del_db(table_name: "Counters")
//        // Получим данные в базу данных
//        parse_Countrers(login: edLogin, pass: edPass)
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        updateConectBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        let titles = Titles()
        self.title = titles.getTitle(numb: "4")
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: Network.reachability)
        updateUserInterface()
    }
    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            nonConectView.isHidden = false
            lsView.isHidden = true
            ls_lbl.isHidden = true
            ls_Button.isHidden = true
            monthLabel.isHidden = true
            can_count_label.isHidden = true
            tableCounters.isHidden = true
            spinImg.isHidden = true
        case .wifi: break
            
        case .wwan: break
            
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    func parse_Countrers(login: String, pass: String) {
        // Получим данные из xml
        self.StartIndicator()
        let urlPath:String = Server.SERVER + Server.GET_METERS_MUP + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let url: NSURL = NSURL(string: urlPath)!
        print(url)
        
        parser = XMLParser(contentsOf: url as URL)!
        parser.delegate = self
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
        } else {
            self.StopIndicator()
            print("parse failure!")
        }
        
    }
    
    var identArr         :[String] = []
    var nameArr          :[String] = []
    var numberArr        :[String] = []
    var predArr          :[Float]  = []
    var teckArr          :[Float]  = []
    var diffArr          :[Float]  = []
    var predArr2         :[Float]  = []
    var teckArr2         :[Float]  = []
    var diffArr2         :[Float]  = []
    var predArr3         :[Float]  = []
    var teckArr3         :[Float]  = []
    var diffArr3         :[Float]  = []
    var unitArr          :[String] = []
    var dateOneArr       :[String] = []
    var dateTwoArr       :[String] = []
    var dateThreeArr     :[String] = []
    var ownerArr         :[String] = []
    var errorOneArr      :[Bool]   = []
    var errorTwoArr      :[Bool]   = []
    var errorThreeArr    :[Bool]   = []
    var errorTextOneArr  :[String] = []
    var errorTextTwoArr  :[String] = []
    var errorTextThreeArr:[String] = []
    var tariffArr        :[String] = []
    
    func getData(ident: String){
        let ident = "Все"
        identArr.removeAll()
        tariffArr.removeAll()
        nameArr.removeAll()
        numberArr.removeAll()
        predArr.removeAll()
        teckArr.removeAll()
        diffArr.removeAll()
        predArr2.removeAll()
        teckArr2.removeAll()
        diffArr2.removeAll()
        predArr3.removeAll()
        teckArr3.removeAll()
        diffArr3.removeAll()
        unitArr.removeAll()
        sendedArr.removeAll()
        dateOneArr.removeAll()
        dateTwoArr.removeAll()
        dateThreeArr.removeAll()
        ownerArr.removeAll()
        errorOneArr.removeAll()
        errorTwoArr.removeAll()
        errorThreeArr.removeAll()
        errorTextOneArr.removeAll()
        errorTextTwoArr.removeAll()
        errorTextThreeArr.removeAll()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Counters")
        fetchRequest.predicate = NSPredicate.init(format: "year <= %@", String(self.currYear))
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            var uniq_num = ""
            var tariffNumber = ""
            var dateOne = ""
            var valueOne:Float = 0.00
            var valueOne2:Float = 0.00
            var valueOne3:Float = 0.00
            var dateTwo = ""
            var valueTwo:Float = 0.00
            var valueTwo2:Float = 0.00
            var valueTwo3:Float = 0.00
            var dateThree = ""
            var valueThree:Float = 0.00
            var valueThree2:Float = 0.00
            var valueThree3:Float = 0.00
            var sendOne = false
            var sendTwo = false
            var sendThree = false
            var errorOne = ""
            var errorTwo = ""
            var errorThree = ""
            var count_name = ""
            var owner = ""
            var unit_name = ""
            var sended = true
            var identk = ""
            var i = 0
            for result in results {
                let object = result as! NSManagedObject
                if ident != "Все"{
                    if (object.value(forKey: "ident") as! String) == ident{
                        if i == 0{
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            tariffNumber = (object.value(forKey: "tariffNumber") as! String)
                            dateOne = (object.value(forKey: "num_month") as! String)
                            valueOne = (object.value(forKey: "value") as! Float)
                            valueOne2 = (object.value(forKey: "valueT2") as! Float)
                            valueOne3 = (object.value(forKey: "valueT3") as! Float)
                            identk = (object.value(forKey: "ident") as! String)
                            count_name = (object.value(forKey: "count_name") as! String)
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            owner = (object.value(forKey: "owner") as! String)
                            unit_name = (object.value(forKey: "unit_name") as! String)
                            sended = (object.value(forKey: "sended") as! Bool)
                            sendOne = (object.value(forKey: "sendError") as! Bool)
                            errorOne = (object.value(forKey: "sendErrorText") as! String)
                            i = 1
                        }else if i == 1 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                            dateTwo = (object.value(forKey: "num_month") as! String)
                            valueTwo = (object.value(forKey: "value") as! Float)
                            valueTwo2 = (object.value(forKey: "valueT2") as! Float)
                            valueTwo3 = (object.value(forKey: "valueT3") as! Float)
                            identk = (object.value(forKey: "ident") as! String)
                            count_name = (object.value(forKey: "count_name") as! String)
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            tariffNumber = (object.value(forKey: "tariffNumber") as! String)
                            owner = (object.value(forKey: "owner") as! String)
                            unit_name = (object.value(forKey: "unit_name") as! String)
                            sended = (object.value(forKey: "sended") as! Bool)
                            sendTwo = (object.value(forKey: "sendError") as! Bool)
                            errorTwo = (object.value(forKey: "sendErrorText") as! String)
                            i = 2
                        }else if i == 2 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                            dateThree = (object.value(forKey: "num_month") as! String)
                            valueThree = (object.value(forKey: "value") as! Float)
                            valueThree2 = (object.value(forKey: "valueT2") as! Float)
                            valueThree3 = (object.value(forKey: "valueT3") as! Float)
                            sendThree = (object.value(forKey: "sendError") as! Bool)
                            errorThree = (object.value(forKey: "sendErrorText") as! String)
                            identArr.append(object.value(forKey: "ident") as! String)
                            nameArr.append(object.value(forKey: "count_name") as! String)
                            numberArr.append(object.value(forKey: "uniq_num") as! String)
                            tariffArr.append(object.value(forKey: "tariffNumber") as! String)
                            ownerArr.append(object.value(forKey: "owner") as! String)
                            predArr.append(valueOne)
                            teckArr.append(valueTwo)
                            diffArr.append(valueThree)
                            predArr2.append(valueOne2)
                            teckArr2.append(valueTwo2)
                            diffArr2.append(valueThree2)
                            predArr3.append(valueOne3)
                            teckArr3.append(valueTwo3)
                            diffArr3.append(valueThree3)
                            dateOneArr.append(dateOne)
                            dateTwoArr.append(dateTwo)
                            dateThreeArr.append(dateThree)
                            unitArr.append(object.value(forKey: "unit_name") as! String)
                            sendedArr.append(object.value(forKey: "sended") as! Bool)
                            errorOneArr.append(sendOne)
                            errorTwoArr.append(sendTwo)
                            errorThreeArr.append(sendThree)
                            errorTextOneArr.append(errorOne)
                            errorTextTwoArr.append(errorTwo)
                            errorTextThreeArr.append(errorThree)
                            uniq_num = ""
                            tariffNumber = ""
                            dateOne = ""
                            valueOne = 0.00
                            valueOne2 = 0.00
                            valueOne3 = 0.00
                            dateTwo = ""
                            valueTwo = 0.00
                            valueTwo2 = 0.00
                            valueTwo3 = 0.00
                            dateThree = ""
                            valueThree = 0.00
                            valueThree2 = 0.00
                            valueThree3 = 0.00
                            count_name = ""
                            owner = ""
                            unit_name = ""
                            sended = true
                            sendOne = false
                            sendTwo = false
                            sendThree = false
                            errorOne = ""
                            errorTwo = ""
                            errorThree = ""
                            identk = ""
                            i = 0
                        }else if uniq_num != (object.value(forKey: "uniq_num") as! String){
                            i = 1
                            identArr.append(identk)
                            nameArr.append(count_name)
                            numberArr.append(uniq_num)
                            tariffArr.append(tariffNumber)
                            ownerArr.append(owner)
                            predArr.append(valueOne)
                            teckArr.append(valueTwo)
                            diffArr.append(valueThree)
                            predArr2.append(valueOne2)
                            teckArr2.append(valueTwo2)
                            diffArr2.append(valueThree2)
                            predArr3.append(valueOne3)
                            teckArr3.append(valueTwo3)
                            diffArr3.append(valueThree3)
                            dateOneArr.append(dateOne)
                            dateTwoArr.append(dateTwo)
                            dateThreeArr.append(dateThree)
                            unitArr.append(unit_name)
                            sendedArr.append(sended)
                            errorOneArr.append(sendOne)
                            errorTwoArr.append(sendTwo)
                            errorThreeArr.append(sendThree)
                            errorTextOneArr.append(errorOne)
                            errorTextTwoArr.append(errorTwo)
                            errorTextThreeArr.append(errorThree)
                            tariffNumber = (object.value(forKey: "tariffNumber") as! String)
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            dateOne = (object.value(forKey: "num_month") as! String)
                            valueOne = (object.value(forKey: "value") as! Float)
                            valueOne2 = (object.value(forKey: "valueT2") as! Float)
                            valueOne3 = (object.value(forKey: "valueT3") as! Float)
                            identk = (object.value(forKey: "ident") as! String)
                            count_name = (object.value(forKey: "count_name") as! String)
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            owner = (object.value(forKey: "owner") as! String)
                            unit_name = (object.value(forKey: "unit_name") as! String)
                            sended = (object.value(forKey: "sended") as! Bool)
                            sendOne = (object.value(forKey: "sendError") as! Bool)
                            errorOne = (object.value(forKey: "sendErrorText") as! String)
                            
                            dateTwo = ""
                            valueTwo = 0.00
                            valueTwo2 = 0.00
                            valueTwo3 = 0.00
                            sendTwo = false
                            errorTwo = ""
                            dateThree = ""
                            valueThree = 0.00
                            valueThree2 = 0.00
                            valueThree3 = 0.00
                            sendThree = false
                            errorThree = ""
                        }
                    }
                }else{
                    if i == 0{
                        tariffNumber = (object.value(forKey: "tariffNumber") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        dateOne = (object.value(forKey: "num_month") as! String)
                        valueOne = (object.value(forKey: "value") as! Float)
                        valueOne2 = (object.value(forKey: "valueT2") as! Float)
                        valueOne3 = (object.value(forKey: "valueT3") as! Float)
                        identk = (object.value(forKey: "ident") as! String)
                        count_name = (object.value(forKey: "count_name") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        owner = (object.value(forKey: "owner") as! String)
                        unit_name = (object.value(forKey: "unit_name") as! String)
                        sended = (object.value(forKey: "sended") as! Bool)
                        sendOne = (object.value(forKey: "sendError") as! Bool)
                        errorOne = (object.value(forKey: "sendErrorText") as! String)
                        i = 1
                    }else if i == 1 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                        dateTwo = (object.value(forKey: "num_month") as! String)
                        valueTwo = (object.value(forKey: "value") as! Float)
                        valueTwo2 = (object.value(forKey: "valueT2") as! Float)
                        valueTwo3 = (object.value(forKey: "valueT3") as! Float)
                        identk = (object.value(forKey: "ident") as! String)
                        count_name = (object.value(forKey: "count_name") as! String)
                        tariffNumber = (object.value(forKey: "tariffNumber") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        owner = (object.value(forKey: "owner") as! String)
                        unit_name = (object.value(forKey: "unit_name") as! String)
                        sended = (object.value(forKey: "sended") as! Bool)
                        sendTwo = (object.value(forKey: "sendError") as! Bool)
                        errorTwo = (object.value(forKey: "sendErrorText") as! String)
                        i = 2
                    }else if i == 2 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                        dateThree = (object.value(forKey: "num_month") as! String)
                        valueThree = (object.value(forKey: "value") as! Float)
                        valueThree2 = (object.value(forKey: "valueT2") as! Float)
                        valueThree3 = (object.value(forKey: "valueT3") as! Float)
                        sendThree = (object.value(forKey: "sendError") as! Bool)
                        errorThree = (object.value(forKey: "sendErrorText") as! String)
                        identArr.append(object.value(forKey: "ident") as! String)
                        nameArr.append(object.value(forKey: "count_name") as! String)
                        numberArr.append(object.value(forKey: "uniq_num") as! String)
                        tariffArr.append(object.value(forKey: "tariffNumber") as! String)
                        ownerArr.append(object.value(forKey: "owner") as! String)
                        predArr.append(valueOne)
                        teckArr.append(valueTwo)
                        diffArr.append(valueThree)
                        predArr2.append(valueOne2)
                        teckArr2.append(valueTwo2)
                        diffArr2.append(valueThree2)
                        predArr3.append(valueOne3)
                        teckArr3.append(valueTwo3)
                        diffArr3.append(valueThree3)
                        dateOneArr.append(dateOne)
                        dateTwoArr.append(dateTwo)
                        dateThreeArr.append(dateThree)
                        unitArr.append(object.value(forKey: "unit_name") as! String)
                        sendedArr.append(object.value(forKey: "sended") as! Bool)
                        errorOneArr.append(sendOne)
                        errorTwoArr.append(sendTwo)
                        errorThreeArr.append(sendThree)
                        errorTextOneArr.append(errorOne)
                        errorTextTwoArr.append(errorTwo)
                        errorTextThreeArr.append(errorThree)
                        uniq_num = ""
                        tariffNumber = ""
                        dateOne = ""
                        valueOne = 0.00
                        valueOne2 = 0.00
                        valueOne3 = 0.00
                        dateTwo = ""
                        valueTwo = 0.00
                        valueTwo2 = 0.00
                        valueTwo3 = 0.00
                        dateThree = ""
                        valueThree = 0.00
                        valueThree2 = 0.00
                        valueThree3 = 0.00
                        count_name = ""
                        owner = ""
                        unit_name = ""
                        sended = true
                        identk = ""
                        sendOne = false
                        sendThree = false
                        sendTwo = false
                        errorOne = ""
                        errorTwo = ""
                        errorThree = ""
                        i = 0
                    }else if uniq_num != (object.value(forKey: "uniq_num") as! String){
                        i = 1
                        identArr.append(identk)
                        nameArr.append(count_name)
                        numberArr.append(uniq_num)
                        tariffArr.append(tariffNumber)
                        ownerArr.append(owner)
                        predArr.append(valueOne)
                        teckArr.append(valueTwo)
                        diffArr.append(valueThree)
                        predArr2.append(valueOne2)
                        teckArr2.append(valueTwo2)
                        diffArr2.append(valueThree2)
                        predArr3.append(valueOne3)
                        teckArr3.append(valueTwo3)
                        diffArr3.append(valueThree3)
                        dateOneArr.append(dateOne)
                        dateTwoArr.append(dateTwo)
                        dateThreeArr.append(dateThree)
                        unitArr.append(unit_name)
                        sendedArr.append(sended)
                        errorOneArr.append(sendOne)
                        errorTwoArr.append(sendTwo)
                        errorThreeArr.append(sendThree)
                        errorTextOneArr.append(errorOne)
                        errorTextTwoArr.append(errorTwo)
                        errorTextThreeArr.append(errorThree)
                        tariffNumber = (object.value(forKey: "tariffNumber") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        dateOne = (object.value(forKey: "num_month") as! String)
                        valueOne = (object.value(forKey: "value") as! Float)
                        valueOne2 = (object.value(forKey: "value") as! Float)
                        valueOne3 = (object.value(forKey: "value") as! Float)
                        identk = (object.value(forKey: "ident") as! String)
                        count_name = (object.value(forKey: "count_name") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        owner = (object.value(forKey: "owner") as! String)
                        unit_name = (object.value(forKey: "unit_name") as! String)
                        sended = (object.value(forKey: "sended") as! Bool)
                        sendOne = (object.value(forKey: "sendError") as! Bool)
                        errorOne = (object.value(forKey: "sendErrorText") as! String)
                        
                        dateTwo = ""
                        valueTwo = 0.00
                        valueTwo2 = 0.00
                        valueTwo3 = 0.00
                        sendTwo = false
                        errorTwo = ""
                        dateThree = ""
                        valueThree = 0.00
                        valueThree2 = 0.00
                        valueThree3 = 0.00
                        sendThree = false
                        errorThree = ""
                    }
                }
                
            }
            if i == 2 || i == 1{
                identArr.append(identk)
                nameArr.append(count_name)
                tariffArr.append(tariffNumber)
                numberArr.append(uniq_num)
                ownerArr.append(owner)
                predArr.append(valueOne)
                teckArr.append(valueTwo)
                diffArr.append(valueThree)
                predArr2.append(valueOne2)
                teckArr2.append(valueTwo2)
                diffArr2.append(valueThree2)
                predArr3.append(valueOne3)
                teckArr3.append(valueTwo3)
                diffArr3.append(valueThree3)
                dateOneArr.append(dateOne)
                dateTwoArr.append(dateTwo)
                dateThreeArr.append(dateThree)
                unitArr.append(unit_name)
                sendedArr.append(sended)
                errorOneArr.append(sendOne)
                errorTwoArr.append(sendTwo)
                errorThreeArr.append(sendThree)
                errorTextOneArr.append(errorOne)
                errorTextTwoArr.append(errorTwo)
                errorTextThreeArr.append(errorThree)
            }
            DispatchQueue.main.async(execute: {
                self.updateTable()
            })
            
        } catch {
            print(error)
        }
    }
    
    typealias curentMonthAndYear = (month:Int, year:Int)
    
    func getCurentMonthAndYear () -> curentMonthAndYear {
        let m = Int(iterMonth)!
        let y = Int(iterYear)!
        return (m , y)
    }
    
    func isValidNextMonth() -> Bool {
        let curentMonthAndYear = self.getCurentMonthAndYear()
        let maxM = Int(maxMonth)!
        let maxY = Int(maxYear)!
        return !(curentMonthAndYear.month >= maxM && curentMonthAndYear.year >= maxY);
    }
    
    func isValidPrevMonth() -> Bool {
        let curentMonthAndYear = self.getCurentMonthAndYear()
        let minM = Int(minMonth)!
        let minY = Int(minYear)!
        return !(curentMonthAndYear.month <= minM && curentMonthAndYear.year <= minY);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isEditable() -> Bool {
//        if self.nextMonthLabel.isHidden == false{
//            return false
//        }
        return iterYear == currYear && iterMonth == currMonth && can_edit == "1"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            if nameArr.count != 0 {
                return nameArr.count
            } else {
                return 0
            }
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 170.0
    //    }
    
    var sendedArr:[Bool] = []
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableCounters.dequeueReusableCell(withIdentifier: "MupCounterCell") as! MupCounterCell
        var send = false
        var countName = ""
        cell.tariffNumber     = tariffArr[indexPath.row]
        cell.ident.text       = identArr[indexPath.row]
        cell.name.text        = nameArr[indexPath.row] + ", " + unitArr[indexPath.row]
        cell.number.text      = ownerArr[indexPath.row]
        countName             = nameArr[indexPath.row] + ", " + unitArr[indexPath.row]
        cell.pred1.text        = String(format:"%.3f", predArr[indexPath.row])
        cell.teck1.text        = String(format:"%.3f", teckArr[indexPath.row])
        cell.diff1.text        = String(format:"%.3f", diffArr[indexPath.row])
        cell.predLbl1.text     = dateOneArr[indexPath.row]
        cell.teckLbl1.text     = dateTwoArr[indexPath.row]
        cell.diffLbl1.text     = dateThreeArr[indexPath.row]
        if Int(cell.tariffNumber) == 2{
            cell.pred2.text        = String(format:"%.3f", predArr2[indexPath.row])
            cell.teck2.text        = String(format:"%.3f", teckArr2[indexPath.row])
            cell.diff2.text        = String(format:"%.3f", diffArr2[indexPath.row])
            cell.predLbl2.text     = dateOneArr[indexPath.row]
            cell.teckLbl2.text     = dateTwoArr[indexPath.row]
            cell.diffLbl2.text     = dateThreeArr[indexPath.row]
        }else if Int(cell.tariffNumber) == 3{
            cell.pred2.text        = String(format:"%.3f", predArr2[indexPath.row])
            cell.teck2.text        = String(format:"%.3f", teckArr2[indexPath.row])
            cell.diff2.text        = String(format:"%.3f", diffArr2[indexPath.row])
            cell.predLbl2.text     = dateOneArr[indexPath.row]
            cell.teckLbl2.text     = dateTwoArr[indexPath.row]
            cell.diffLbl2.text     = dateThreeArr[indexPath.row]
            
            cell.pred3.text        = String(format:"%.3f", predArr3[indexPath.row])
            cell.teck3.text        = String(format:"%.3f", teckArr3[indexPath.row])
            cell.diff3.text        = String(format:"%.3f", diffArr3[indexPath.row])
            cell.predLbl3.text     = dateOneArr[indexPath.row]
            cell.teckLbl3.text     = dateTwoArr[indexPath.row]
            cell.diffLbl3.text     = dateThreeArr[indexPath.row]
        }
        send = sendedArr[indexPath.row]
        cell.sendButton.backgroundColor = myColors.btnColor.uiColor()
        cell.imgCounter.image = UIImage(named: "water")
        if (countName.lowercased().range(of: "гвс") != nil) || (countName.lowercased().range(of: "ф/в") != nil){
            cell.viewImgCounter.backgroundColor = .red
        }
        if (countName.lowercased().range(of: "хвс") != nil) || (countName.lowercased().range(of: "хвc") != nil) || (countName.lowercased().range(of: "х/в") != nil){
            cell.viewImgCounter.backgroundColor = .blue
        }
        if (countName.lowercased().range(of: "газ") != nil){
            cell.imgCounter.image = UIImage(named: "fire")
            cell.viewImgCounter.backgroundColor = .yellow
        }
        if (countName.lowercased().range(of: "тепло") != nil){
            cell.imgCounter.image = UIImage(named: "fire")
            cell.viewImgCounter.backgroundColor = .red
        }
        if (countName.lowercased().range(of: "элект") != nil) || (countName.contains("кВт")){
            cell.imgCounter.image = UIImage(named: "lamp")
            cell.viewImgCounter.backgroundColor = .yellow
        }
        if dateTwoArr[indexPath.row] == ""{
            cell.lblHeight11.constant = 0
            cell.lblHeight13.constant = 0
            if Int(cell.tariffNumber) == 2{
                cell.lblHeight21.constant = 0
                cell.lblHeight23.constant = 0
            }else if Int(cell.tariffNumber) == 3{
                cell.lblHeight21.constant = 0
                cell.lblHeight23.constant = 0
                
                cell.lblHeight31.constant = 0
                cell.lblHeight33.constant = 0
            }
        }else{
            cell.lblHeight11.constant = 16
            cell.lblHeight13.constant = 16
            if Int(cell.tariffNumber) == 2{
                cell.lblHeight21.constant = 16
                cell.lblHeight23.constant = 16
            }else if Int(cell.tariffNumber) == 3{
                cell.lblHeight21.constant = 16
                cell.lblHeight23.constant = 16
                
                cell.lblHeight31.constant = 16
                cell.lblHeight33.constant = 16
            }
        }
        if dateThreeArr[indexPath.row] == ""{
            cell.lblHeight12.constant = 0
            cell.lblHeight14.constant = 0
            if Int(cell.tariffNumber) == 2{
                cell.lblHeight22.constant = 0
                cell.lblHeight24.constant = 0
            }else if Int(cell.tariffNumber) == 3{
                cell.lblHeight22.constant = 0
                cell.lblHeight24.constant = 0
                
                cell.lblHeight32.constant = 0
                cell.lblHeight34.constant = 0
            }
        }else{
            cell.lblHeight12.constant = 16
            cell.lblHeight14.constant = 16
            if Int(cell.tariffNumber) == 2{
                cell.lblHeight22.constant = 16
                cell.lblHeight24.constant = 16
            }else if Int(cell.tariffNumber) == 3{
                cell.lblHeight22.constant = 16
                cell.lblHeight24.constant = 16
                
                cell.lblHeight32.constant = 16
                cell.lblHeight34.constant = 16
            }
        }
        if errorOneArr[indexPath.row]{
            cell.nonCounter.isHidden = false
            cell.nonCounterHeight.constant = 16
            cell.sendButton.setTitle("Передать ещё раз", for: .normal)
            cell.nonCounterOne1.isHidden = false
            cell.nonCounterOne1.setImageColor(color: .red)
            cell.errorTextOne1.isHidden = false
            cell.errorTextOne1.text = errorTextOneArr[indexPath.row]
            cell.errorOneHeight1.constant = self.heightForView(text: errorTextOneArr[indexPath.row], font: cell.errorTextOne1.font, width: cell.errorTextOne1.frame.size.width)
            cell.nonCounterOne2.isHidden = true
            cell.errorTextOne2.isHidden = true
            cell.errorOneHeight2.constant = 0
            cell.nonCounterOne3.isHidden = true
            cell.errorTextOne3.isHidden = true
            cell.errorOneHeight3.constant = 0
        }else{
            cell.nonCounter.isHidden = true
            cell.nonCounterHeight.constant = 0
            cell.sendButton.setTitle("Передать показания", for: .normal)
            cell.nonCounterOne1.isHidden = true
            cell.errorTextOne1.isHidden = true
            cell.errorOneHeight1.constant = 0
            cell.nonCounterOne2.isHidden = true
            cell.errorTextOne2.isHidden = true
            cell.errorOneHeight2.constant = 0
            cell.nonCounterOne3.isHidden = true
            cell.errorTextOne3.isHidden = true
            cell.errorOneHeight3.constant = 0
        }
        if errorTwoArr[indexPath.row]{
            cell.nonCounterTwo1.isHidden = false
            cell.nonCounterTwo1.setImageColor(color: .red)
            cell.errorTextTwo1.isHidden = false
            cell.errorTextTwo1.text = errorTextTwoArr[indexPath.row]
            cell.errorTwoHeight1.constant = self.heightForView(text: errorTextTwoArr[indexPath.row], font: cell.errorTextTwo1.font, width: cell.errorTextTwo1.frame.size.width)
            cell.nonCounterTwo2.isHidden = true
            cell.errorTextTwo2.isHidden = true
            cell.errorTwoHeight2.constant = 0
            cell.nonCounterTwo3.isHidden = true
            cell.errorTextTwo3.isHidden = true
            cell.errorTwoHeight3.constant = 0
        }else{
            cell.nonCounterTwo1.isHidden = true
            cell.errorTextTwo1.isHidden = true
            cell.errorTwoHeight1.constant = 0
            cell.nonCounterTwo2.isHidden = true
            cell.errorTextTwo2.isHidden = true
            cell.errorTwoHeight2.constant = 0
            cell.nonCounterTwo3.isHidden = true
            cell.errorTextTwo3.isHidden = true
            cell.errorTwoHeight3.constant = 0
        }
        if errorThreeArr[indexPath.row]{
            cell.nonCounterThree1.isHidden = false
            cell.nonCounterThree1.setImageColor(color: .red)
            cell.errorTextThree1.isHidden = false
            cell.errorTextThree1.text = errorTextThreeArr[indexPath.row]
            cell.errorThreeHeight1.constant = self.heightForView(text: errorTextThreeArr[indexPath.row], font: cell.errorTextThree1.font, width: cell.errorTextThree1.frame.size.width)
            cell.nonCounterThree2.isHidden = true
            cell.errorTextThree2.isHidden = true
            cell.errorThreeHeight2.constant = 0
            cell.nonCounterThree3.isHidden = true
            cell.errorTextThree3.isHidden = true
            cell.errorThreeHeight3.constant = 0
        }else{
            cell.nonCounterThree1.isHidden = true
            cell.errorTextThree1.isHidden = true
            cell.errorThreeHeight1.constant = 0
            cell.nonCounterThree2.isHidden = true
            cell.errorTextThree2.isHidden = true
            cell.errorThreeHeight2.constant = 0
            cell.nonCounterThree3.isHidden = true
            cell.errorTextThree3.isHidden = true
            cell.errorThreeHeight3.constant = 0
        }
        cell.tariffOne.textColor = myColors.btnColor.uiColor()
        cell.tariffTwo.textColor = myColors.btnColor.uiColor()
        cell.tariffThree.textColor = myColors.btnColor.uiColor()
        if Int(cell.tariffNumber) == 0 || Int(cell.tariffNumber) == 1{
            cell.tariffHeight2.constant = 0
            cell.tariffHeight3.constant = 0
            cell.tariffOne.isHidden = true
            cell.tariffOneHeight.constant = 0
            cell.tariff2.isHidden = true
            cell.tariff3.isHidden = true
        }else if Int(cell.tariffNumber) == 2{
            cell.tariffOne.isHidden = false
            cell.tariffOneHeight.constant = 20
            cell.tariffHeight2.constant = 100
            cell.tariff2.isHidden = false
            cell.tariffHeight3.constant = 0
            cell.tariff3.isHidden = true
        }else if Int(cell.tariffNumber) == 3{
            cell.tariffOne.isHidden = false
            cell.tariffOneHeight.constant = 20
            cell.tariffHeight2.constant = 100
            cell.tariff2.isHidden = false
            cell.tariffHeight3.constant = 100
            cell.tariff3.isHidden = false
        }
//        if isEditable(){
            cell.sendButton.isEnabled = true
            cell.sendButton.backgroundColor = cell.sendButton.backgroundColor?.withAlphaComponent(1.0)
//        }else{
//            cell.sendButton.isEnabled = false
//            cell.sendButton.backgroundColor = cell.sendButton.backgroundColor?.withAlphaComponent(0.5)
//        }
        cell.delegate = self
        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        selectedUniq = numberArr[indexPath.row]
        selectedUniqName = nameArr[indexPath.row] + ", " + unitArr[indexPath.row]
        selTariffNumber = Int(tariffArr[indexPath.row])!
        selectedOwner = ownerArr[indexPath.row]
        self.performSegue(withIdentifier: "uniqCounters", sender: self)
    }
    
    var selectedUniq = ""
    var selectedUniqName = ""
    var selTariffNumber = 0
    var selectedOwner = ""
    var countIdent = ""
    var predVal1 = ""
    var predVal2 = ""
    var predVal3 = ""
    var metrID = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "support" {
            UserDefaults.standard.set(true, forKey: "fromMenu")
            UserDefaults.standard.synchronize()
        }
        if segue.identifier == "uniqCounters" {
            let payController             = segue.destination as! UniqCountersController
            payController.uniq_num = selectedUniq
            payController.uniq_name = selectedUniqName
            payController.owner = selectedOwner
            payController.ls = choiceIdent
            payController.countIdent = countIdent
            payController.selTariffNumber = selTariffNumber
        }
        if segue.identifier == "addCounters"{
            let payController             = segue.destination as! AddCountersController
            payController.counterNumber = selectedUniq
            payController.counterName = selectedUniqName
            payController.ident = countIdent
            payController.predValue1 = predVal1
            payController.predValue2 = predVal2
            payController.predValue3 = predVal3
            payController.metrId = metrID
            payController.tariffNumber = selTariffNumber
        }
    }
    
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        ls_Button.setTitle(contents, for: UIControlState.normal)
        choiceIdent = contents
        print(contents)
        getData(ident: contents)
    }
    
    func updateTable() {
        StopIndicator()
        tableCounters.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        ls_Button.setTitle("Все", for: UIControlState.normal)
//        choiceIdent = "Все"
//        UserDefaults.standard.set(false, forKey: "fromMenu")
//        UserDefaults.standard.synchronize()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        if UserDefaults.standard.bool(forKey: "PaymentSucces") && oneCheck == 0{
            oneCheck = 1
            UserDefaults.standard.set(false, forKey: "PaymentSucces")
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        }
        DB().del_db(table_name: "Counters")
        parse_Countrers(login: edLogin, pass: edPass)
    }
    
    func сheckSend(uniq_num: String, count_name: String, ident: String, predValue: String, predValue2: String, predValue3: String, tariffNumber: String) {
        StartIndicator()
        let urlPath = Server.SERVER + "GetMeterAccessFlag.ashx?ident=" + ident.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
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
                                                        self.StopIndicator()
                                                    })
                                                    return
                                                }
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(responseString)")
                                                if (responseString == "0") {
                                                    DispatchQueue.main.async{
                                                        let alert = UIAlertController(title: "Ошибка", message: "Возможность передавать показания доступна с " + self.date1 + " по " + self.date2 + " числа текущего месяца!", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                        self.StopIndicator()
                                                    }
                                                } else if (responseString == "1") {
                                                    self.sendPressed(uniq_num: uniq_num, count_name: count_name, ident: ident, predValue: predValue, predValue2: predValue2, predValue3: predValue3, tariffNumber: tariffNumber)
                                                }
        
        })
        
        task.resume()
    }
    
    func sendPressed(uniq_num: String, count_name: String, ident: String, predValue: String, predValue2: String, predValue3: String, tariffNumber: String) {
        print(isEditable())
        if isEditable(){
//            let alert = UIAlertController(title: count_name + "(" + uniq_num + ")", message: "Введите текущие показания прибора", preferredStyle: .alert)
//            alert.addTextField(configurationHandler: { (textField) in textField.placeholder = "Введите показание..."; textField.keyboardType = .decimalPad })
//            let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
//            alert.addAction(cancelAction)
//            let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
//                var metrID = ""
//                for i in 0...self.numberArr.count - 1{
//                    if uniq_num == self.ownerArr[i]{
//                        metrID = self.numberArr[i]
//                    }
//                }
//                self.send_count(edLogin: self.edLogin, edPass: self.edPass, uniq_num: metrID, count: (alert.textFields?[0].text!.replacingOccurrences(of: ".", with: ","))!)
//            }
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
            var metrId = ""
            for i in 0...self.numberArr.count - 1{
                if uniq_num == self.ownerArr[i] && count_name == (nameArr[i] + ", " + unitArr[i]){
                    metrId = self.numberArr[i]
                }
            }
            selTariffNumber = Int(tariffNumber)!
            selectedUniq = uniq_num
            selectedUniqName = count_name
            countIdent = ident
            predVal1 = predValue
            predVal2 = predValue2
            predVal3 = predValue3
            self.metrID = metrId
            DispatchQueue.main.async{
                self.StopIndicator()
                self.performSegue(withIdentifier: "addCounters", sender: self)
            }
        }else{
            DispatchQueue.main.async{
                let alert = UIAlertController(title: "Ошибка", message: "Возможность передавать показания доступна с " + self.date1 + " по " + self.date2 + " числа текущего месяца!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                self.StopIndicator()
            }
        }
    }
    
    func get_name_month(number_month: String) -> String {
        var number_month = number_month
        var rezult: String = ""
        let date = NSDate()
        let calendar = NSCalendar.current
        let resultMonth = calendar.component(.month, from: date as Date)
        number_month = String(resultMonth)
        if number_month.first == "0"{
            number_month = number_month.replacingOccurrences(of: "0", with: "")
        }
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
        
        return rezult.uppercased()
    }
    
    // Передача показаний
    func send_count(edLogin: String, edPass: String, uniq_num: String, count: String) {
        if (count != "") {
            StartIndicator()
            
            let strNumber: String = uniq_num
            
            let urlPath = Server.SERVER + "AddMeterValueEverydayMode.ashx?"
                + "login=" + edLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&pwd=" + edPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&meterID=" + strNumber.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&val=" + count.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            
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
                                                    
                                                    self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                                                    print("responseString = \(self.responseString)")
                                                    
                                                    self.choice()
                                                    
            })
            
            task.resume()
            
        }
    }
    
    func choice() {
        if (responseString == "0") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Переданы не все параметры. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Не пройдена авторизация. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "2") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Не найден прибор у пользователя. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "3") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Передача показаний невозможна.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "5") {
            DispatchQueue.main.async(execute: {
                // Успешно - обновим значения в БД
                
                self.StopIndicator()
                let alert = UIAlertController(title: "Успешно", message: "Показания переданы", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    DB().del_db(table_name: "Counters")
                    self.parse_Countrers(login: self.edLogin, pass: self.edPass)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: self.responseString as String, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    var ident = ""
    var units = ""
    var name = ""
    var meterUniqueNum = ""
    var factoryNumber = ""
    var tariffNumber = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if (elementName == "Meter") {
            print(attributeDict)
            ident = attributeDict["Ident"]!
            units = attributeDict["Units"]!
            name = attributeDict["Name"]!
            meterUniqueNum = attributeDict["MeterUniqueNum"]!
            factoryNumber = attributeDict["FactoryNumber"]!
            if attributeDict["TariffNumber"]! != ""{
                tariffNumber = attributeDict["TariffNumber"]!
            }else{
                tariffNumber = "0"
            }
            // Запишем показание прибора
        }
        if (elementName == "MeterValue"){
            print(attributeDict)
            let date = attributeDict["PeriodDate"]!.components(separatedBy: ".")
//            self.currYear = date[2]
            let managedObject = Counters()
            managedObject.id            = 1
            managedObject.uniq_num      = meterUniqueNum
            managedObject.owner         = factoryNumber
            managedObject.num_month     = attributeDict["PeriodDate"]!
            managedObject.unit_name     = units
            managedObject.year          = date[2]
            managedObject.ident         = ident
            managedObject.count_name    = name
            managedObject.count_ed_izm  = units
            managedObject.tariffNumber  = tariffNumber
            managedObject.prev_value    = 123.53
            managedObject.value         = (attributeDict["Value"]!.replacingOccurrences(of: ",", with: ".") as NSString).floatValue
            managedObject.valueT2         = (attributeDict["ValueT2"]!.replacingOccurrences(of: ",", with: ".") as NSString).floatValue
            managedObject.valueT3         = (attributeDict["ValueT3"]!.replacingOccurrences(of: ",", with: ".") as NSString).floatValue
            managedObject.diff          = 6757.43
            if attributeDict["IsSended"] == "1"{
                managedObject.sended    = true
            }else{
                managedObject.sended    = false
            }
            if attributeDict["SendError"] == "1"{
                managedObject.sendError = true
            }else{
                managedObject.sendError = false
            }
            managedObject.sendErrorText = attributeDict["SendErrorText"]!
//            print(managedObject.uniq_num!, managedObject.owner!, managedObject.num_month!, managedObject.unit_name!, managedObject.year!, managedObject.ident!, managedObject.count_name!, managedObject.count_ed_izm!, managedObject.prev_value, managedObject.value, managedObject.diff)
            CoreDataManager.instance.saveContext()
        }
        getData(ident: choiceIdent)
    }
    
    func StartIndicator(){
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }

    var oneCheck = 0
}

class MupCounterCell: UITableViewCell {
    
    var delegate: CountersCellDelegate?
    var tariffNumber = "0"
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var ident: UILabel!
    @IBOutlet weak var imgCounter: UIImageView!
    @IBOutlet weak var viewImgCounter: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var pred1: UILabel!
    @IBOutlet weak var teck1: UILabel!
    @IBOutlet weak var diff1: UILabel!
    
    @IBOutlet weak var pred2: UILabel!
    @IBOutlet weak var teck2: UILabel!
    @IBOutlet weak var diff2: UILabel!
    
    @IBOutlet weak var pred3: UILabel!
    @IBOutlet weak var teck3: UILabel!
    @IBOutlet weak var diff3: UILabel!
    
    @IBOutlet weak var predLbl1: UILabel!
    @IBOutlet weak var teckLbl1: UILabel!
    @IBOutlet weak var diffLbl1: UILabel!
    
    @IBOutlet weak var predLbl2: UILabel!
    @IBOutlet weak var teckLbl2: UILabel!
    @IBOutlet weak var diffLbl2: UILabel!
    
    @IBOutlet weak var predLbl3: UILabel!
    @IBOutlet weak var teckLbl3: UILabel!
    @IBOutlet weak var diffLbl3: UILabel!
    
    @IBOutlet weak var nonCounterOne1: UIImageView!
    @IBOutlet weak var nonCounterTwo1: UIImageView!
    @IBOutlet weak var nonCounterThree1: UIImageView!
    
    @IBOutlet weak var nonCounterOne2: UIImageView!
    @IBOutlet weak var nonCounterTwo2: UIImageView!
    @IBOutlet weak var nonCounterThree2: UIImageView!
    
    @IBOutlet weak var nonCounterOne3: UIImageView!
    @IBOutlet weak var nonCounterTwo3: UIImageView!
    @IBOutlet weak var nonCounterThree3: UIImageView!
    
    @IBOutlet weak var tariff2: UIView!
    @IBOutlet weak var tariff3: UIView!
    
    @IBOutlet weak var tariffHeight2: NSLayoutConstraint!
    @IBOutlet weak var tariffHeight3: NSLayoutConstraint!
    
    @IBOutlet weak var tariffOneHeight: NSLayoutConstraint!
    @IBOutlet weak var tariffOne: UILabel!
    @IBOutlet weak var tariffTwo: UILabel!
    @IBOutlet weak var tariffThree: UILabel!
    
    @IBOutlet weak var errorTextOne1: UILabel!
    @IBOutlet weak var errorTextTwo1: UILabel!
    @IBOutlet weak var errorTextThree1: UILabel!
    @IBOutlet weak var errorTextOne2: UILabel!
    @IBOutlet weak var errorTextTwo2: UILabel!
    @IBOutlet weak var errorTextThree2: UILabel!
    @IBOutlet weak var errorTextOne3: UILabel!
    @IBOutlet weak var errorTextTwo3: UILabel!
    @IBOutlet weak var errorTextThree3: UILabel!
    
    @IBOutlet weak var errorOneHeight1: NSLayoutConstraint!
    @IBOutlet weak var errorTwoHeight1: NSLayoutConstraint!
    @IBOutlet weak var errorThreeHeight1: NSLayoutConstraint!
    @IBOutlet weak var errorOneHeight2: NSLayoutConstraint!
    @IBOutlet weak var errorTwoHeight2: NSLayoutConstraint!
    @IBOutlet weak var errorThreeHeight2: NSLayoutConstraint!
    @IBOutlet weak var errorOneHeight3: NSLayoutConstraint!
    @IBOutlet weak var errorTwoHeight3: NSLayoutConstraint!
    @IBOutlet weak var errorThreeHeight3: NSLayoutConstraint!
    
    @IBOutlet weak var separator: UILabel!
    
    @IBOutlet weak var lblHeight11: NSLayoutConstraint!
    @IBOutlet weak var lblHeight12: NSLayoutConstraint!
    @IBOutlet weak var lblHeight13: NSLayoutConstraint!
    @IBOutlet weak var lblHeight14: NSLayoutConstraint!
    
    @IBOutlet weak var lblHeight21: NSLayoutConstraint!
    @IBOutlet weak var lblHeight22: NSLayoutConstraint!
    @IBOutlet weak var lblHeight23: NSLayoutConstraint!
    @IBOutlet weak var lblHeight24: NSLayoutConstraint!
    
    @IBOutlet weak var lblHeight31: NSLayoutConstraint!
    @IBOutlet weak var lblHeight32: NSLayoutConstraint!
    @IBOutlet weak var lblHeight33: NSLayoutConstraint!
    @IBOutlet weak var lblHeight34: NSLayoutConstraint!
    
    @IBOutlet weak var nonCounter: UILabel!
    
    @IBOutlet weak var nonCounterHeight: NSLayoutConstraint!
    
    @IBAction func sendAction(_ sender: UIButton) {
        delegate?.сheckSend(uniq_num: number.text!, count_name: name.text!, ident: ident.text!, predValue: pred1.text!, predValue2: pred2.text!, predValue3: pred3.text!, tariffNumber: tariffNumber)
//        delegate?.sendPressed(uniq_num: number.text!, count_name: name.text!, ident: ident.text!, predValue: pred.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
