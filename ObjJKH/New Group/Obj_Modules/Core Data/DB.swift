//
//  DB.swift
//  ObjJKH
//
//  Created by Роман Тузин on 29.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import CoreData
import UIKit

class DB: NSObject, XMLParserDelegate {
    
    // Глобальные переменные для парсинга
    var parser = XMLParser()
    var currYear: String = "";
    var currMonth: String = "";
    var login: String = ""
    var request_read = 0
    var request_read_cons = 0
    // Вставить в Settings
    public func addSettings(id: Int64, name: String, diff: String) {
        let managedObject  = Settings()
        managedObject.id   = id
        managedObject.name = name
        managedObject.diff = diff
        CoreDataManager.instance.saveContext()
    }
    
    public func isNotification() -> Bool {
        var rezult: Bool = false
        var fetchedResultsSettings: NSFetchedResultsController<Settings>?
        let predicateFormat = String(format: "id = %@", "1")
        fetchedResultsSettings = CoreDataManager.instance.fetchedResultsSettings(entityName: "Settings", keysForSort: ["name"], predicateFormat: predicateFormat)
        do {
            try fetchedResultsSettings?.performFetch()
            
            fetchedResultsSettings?.fetchedObjects?.forEach({ (n) in
                if (n.diff == "true") {
                    rezult = true;
                }
            })
        } catch {
            print(error)
        }
        
        if (rezult) {
            del_db(table_name: "Settings")
        }
        
        return rezult;
    }
    var enter = false
    public func getDataByEnter(login: String, pass: String) {
//        var data:[String] = []
        enter = true
        // ПОКАЗАНИЯ СЧЕТЧИКОВ
        // Удалим данные из базы данных
        del_db(table_name: "Counters")
        del_db(table_name: "PaymentApp")
        del_db(table_name: "Applications")
        del_db(table_name: "Fotos")
        del_db(table_name: "Comments")
        del_db(table_name: "Saldo")
        // Получим данные в базу данных
        parse_Countrers(login: login, pass: pass)
    }
    
    // Удалить комментарии по заявке
    public func del_comms_by_app(number_app: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Comments")
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results {
                if ((result as! Comments).id_app == Int64(number_app)){
                    CoreDataManager.instance.managedObjectContext.delete(result as! NSManagedObject)
                }
            }
        } catch {
            print(error)
        }
        CoreDataManager.instance.saveContext()
    }
    
    // Получение комментарий по отдельной заявке
    func getComByID(login: String, pass: String, number: String) {
        let urlPath = Server.SERVER + Server.GET_COMM_ID +
            "id=" + number.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! +
            "&login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! +
            "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        let url: NSURL = NSURL(string: urlPath)!
        print(url)
        
        parser = XMLParser(contentsOf: url as URL)!
        parser.delegate = self
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
        } else {
            print("parse failure!")
        }
    }
    
    // Добавить комментарий
    func add_comm(ID: Int64, id_request: Int64, text: String, added: String, id_Author: String, name: String, id_account: String) {
        let managedObject = Comments()
        managedObject.id              = ID
        managedObject.id_app          = id_request
        managedObject.text            = text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        managedObject.dateK           = dateFormatter.date(from: added)
        managedObject.id_author       = id_Author
        managedObject.author          = name
        managedObject.id_account      = id_account
        CoreDataManager.instance.saveContext()
        
    }
    
    // Удалить записи из таблиц	
    public func del_db(table_name: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: table_name)
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results {
                CoreDataManager.instance.managedObjectContext.delete(result as! NSManagedObject)
            }
        } catch {
            print(error)
        }
        CoreDataManager.instance.saveContext()
    }
    
    // Обращение к серверу - получение данных
    func parse_Countrers(login: String, pass: String) {
        // Получим данные из xml
        var urlPath:String = ""
//        #if isMupRCMytishi
        urlPath = Server.SERVER + Server.GET_METERS_MUP + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
//        #elseif isUKKomfort
//        urlPath = Server.SERVER + Server.GET_METERS_MUP + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
//        #else
//        urlPath = Server.SERVER + Server.GET_METERS + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
//        #endif
        let url: NSURL = NSURL(string: urlPath)!
        print(url)
        
        parser = XMLParser(contentsOf: url as URL)!
        parser.delegate = self
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
        } else {
            print("parse failure!")
        }
        if enter{
            save_month_year(month: self.currMonth, year: self.currYear)
            let str_menu_2 = UserDefaults.standard.string(forKey: "menu_2") ?? ""
            if (str_menu_2 != "") {
                var answer = str_menu_2.components(separatedBy: ";")
                if (answer[2] == "0") {
                    // ВЕДОМОСТЬ
                    // Удалим данные из базы данных
                    del_db(table_name: "Saldo")
                    // Получим данные в базу данных
                    parse_OSV(login: login, pass: pass)
                }else{
                    // ЗАЯВКИ С КОММЕНТАРИЯМИ
                    del_db(table_name: "Applications")
                    del_db(table_name: "Comments")
                    del_db(table_name: "Fotos")
                    let isCons = UserDefaults.standard.string(forKey: "isCons")
                    parse_Apps(login: login, pass: pass, isCons: isCons!, isLoad: true)
                }
            }
        }
        
        // сохраним последние значения Месяц-Год в глобальных переменных
    }
    
    // СОХРАНЕНИЕ ЗНАЧЕНИЙ ДЛЯ ПЕРЕДАЧИ В КОНТРОЛЛЕРЫ
    func save_month_year(month: String, year: String) {
        
        // Если нет данных о показаниях - введем текущую дату и год
        let date = NSDate()
        let calendar = NSCalendar.current
        let resultDate = calendar.component(.year, from: date as Date)
        let resultMonth = calendar.component(.month, from: date as Date)
        
        let defaults = UserDefaults.standard
        print(month)
        
        if (month == "") {
            defaults.setValue(resultMonth, forKey: "month")
        } else {
            defaults.setValue(month, forKey: "month")
        }
//        #if isMupRCMytishi
        defaults.setValue(resultMonth, forKey: "month")
        defaults.setValue(resultDate, forKey: "year")
//        #elseif isUKKomfort
//        defaults.setValue(resultMonth, forKey: "month")
//        defaults.setValue(resultDate, forKey: "year")
//        #else
//        if (year == "") {
//            defaults.setValue(resultDate, forKey: "year")
//        } else {
//            defaults.setValue(year, forKey: "year")
//        }
//        #endif
        defaults.synchronize()
    }
    
    var ident = ""
    var units = ""
    var name = ""
    var meterUniqueNum = ""
    var factoryNumber = ""
    var tariffNumber = ""
    var autoValueGettingOnly = false
    var recheckInterval = ""
    var lastCheckDate = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
//        var k = 0
//        #if isMupRCMytishi
//        k = 1
//        #elseif isUKKomfort
//        k = 1
//        #else
//        k = 0
//        #endif
//        if k == 1{
            if (elementName == "Meter") {
//                print(attributeDict)
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
                if attributeDict["AutoValueGettingOnly"]! == "1"{
                    autoValueGettingOnly = true
                }else{
                    autoValueGettingOnly = false
                }
                recheckInterval = attributeDict["RecheckInterval"]!
                if attributeDict["LastCheckupDate"] != nil{
                    lastCheckDate = attributeDict["LastCheckupDate"]!
                }else{
                    lastCheckDate = "0"
                }
                // Запишем показание прибора
            }
            if (elementName == "MeterValue"){
//                print(attributeDict)
                let date = attributeDict["PeriodDate"]!.components(separatedBy: ".")
                
                let managedObject = Counters()
                managedObject.id            = 1
                managedObject.autoValueGettingOnly = autoValueGettingOnly
                managedObject.lastCheckupDate = lastCheckDate
                managedObject.recheckInterval = recheckInterval
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
                if attributeDict["IsSended"] != nil && attributeDict["IsSended"] == "1"{
                    managedObject.sended    = true
                }else{
                    managedObject.sended    = false
                }
                if attributeDict["SendError"] != nil && attributeDict["SendError"] == "1"{
                    managedObject.sendError = true
                }else{
                    managedObject.sendError = false
                }
                if attributeDict["SendErrorText"] != nil{
                    managedObject.sendErrorText = attributeDict["SendErrorText"]!
                }else{
                    managedObject.sendErrorText = ""
                }
                CoreDataManager.instance.saveContext()
            }
//        }else{
//            // ПОКАЗАНИЯ ПРИБОРОВ
//            if (elementName == "Period") {
//                self.currYear = attributeDict["Year"]!
//                self.currMonth = attributeDict["NumMonth"]!
//            } else if (elementName == "MeterValue") {
//                print(attributeDict)
//
//                // Запишем показание прибора
//                let managedObject = Counters()
//                managedObject.id            = 1
//                managedObject.uniq_num      = attributeDict["MeterUniqueNum"]!
//                managedObject.owner         = attributeDict["FactoryNumber"]!
//                managedObject.num_month     = self.currMonth
//                managedObject.unit_name     = attributeDict["Units"]
//                managedObject.year          = self.currYear
//                managedObject.ident         = attributeDict["Ident"]
//                managedObject.count_name    = attributeDict["Name"]
//                managedObject.count_ed_izm  = attributeDict["Units"]
//                managedObject.prev_value    = (attributeDict["PreviousValue"]! as NSString).floatValue
//                managedObject.value         = (attributeDict["Value"]! as NSString).floatValue
//                managedObject.diff          = (attributeDict["Difference"]! as NSString).floatValue
//                if attributeDict["IsSended"] == "1"{
//                    managedObject.sended    = true
//                }else{
//                    managedObject.sended    = false
//                }
//
//                CoreDataManager.instance.saveContext()
//            }
//        }
        
        
        
        
        
        // Заявки с комментариями (xml)
        var id_app: String = ""
        if (elementName == "Row") {
//            print(attributeDict)
            
            // Запишем заявку в БД
            let managedObject = Applications()
            managedObject.id              = 1
            managedObject.number          = attributeDict["ID"]
            managedObject.text            = attributeDict["text"]
            managedObject.tema            = attributeDict["name"]
            managedObject.date            = attributeDict["added"]
            managedObject.adress          = attributeDict["HouseAddress"]
            managedObject.flat            = attributeDict["FlatNumber"]
            managedObject.phone           = attributeDict["Phone"]
            managedObject.acc_ident       = attributeDict["AccountIdent"]
            if attributeDict["PaidSumm"] == ""{
                managedObject.paid_sum        = "0.00"
            }else{
                managedObject.paid_sum        = attributeDict["PaidSumm"]?.replacingOccurrences(of: ",", with: ".")
            }
            if attributeDict["PaidServiceText"] != nil{
                managedObject.paid_text       = attributeDict["PaidServiceText"]
            }else{
                managedObject.paid_text       = ""
            }
            managedObject.owner           = login
            if attributeDict["IsPay"] != nil && (attributeDict["IsPay"] == "1") {
                managedObject.is_pay   = true
            } else {
                managedObject.is_pay    = false
            }
            if attributeDict["IsPaid"] != nil && (attributeDict["IsPaid"] == "1") {
                managedObject.is_paid   = true
            } else {
                managedObject.is_paid    = false
            }
            if (attributeDict["isActive"] == "1") {
                managedObject.is_close    = 1
            } else {
                managedObject.is_close    = 0
            }
            if (attributeDict["IsReadedByClient"] == "1") {
                managedObject.is_read_client     = 1
            } else {
                if (attributeDict["isActive"] == "1"){
                    managedObject.is_read_client     = 0
                    request_read += 1
//                    DispatchQueue.main.async {
//                        if self.request_read >= 0{
//                            UserDefaults.standard.setValue(self.request_read, forKey: "request_read")
//                            UserDefaults.standard.synchronize()
//                        }else{
//                            UserDefaults.standard.setValue(0, forKey: "request_read")
//                            UserDefaults.standard.synchronize()
//                        }
//                    }
                }
            }
            if (attributeDict["IsReaded"] == "1") {
                managedObject.is_read     = 1
            } else {
                if (attributeDict["isActive"] == "1"){
                    managedObject.is_read     = 0
                    request_read_cons += 1
                }
            }
            if (attributeDict["IsAnswered"] == "1") {
                managedObject.is_answered = 1
            } else {
                managedObject.is_answered = 0
            }
            managedObject.type_app        = attributeDict["id_type"]
            CoreDataManager.instance.saveContext()
            id_app                        = attributeDict["ID"]!
            
        } else if (elementName == "Comm") {
            // Запишем комментарии в БД
//            print(attributeDict)
            
            if UserDefaults.standard.string(forKey: "isCons") == "1"{
                let managedObject = Comments()
                managedObject.id              = Int64(attributeDict["ID"]!)!
                managedObject.id_app          = Int64(attributeDict["id_request"]!)!
                managedObject.text            = attributeDict["text"]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                managedObject.dateK           = dateFormatter.date(from: attributeDict["added"]!)
                managedObject.id_author       = attributeDict["id_Author"]
                managedObject.author          = attributeDict["Name"]
                managedObject.id_account      = attributeDict["id_account"]
                if attributeDict["isHidden"] == "1"{
                    managedObject.is_hidden   = true
                }else{
                    managedObject.is_hidden   = false
                }
                CoreDataManager.instance.saveContext()
            }else{
                let managedObject = Comments()
                if attributeDict["isHidden"] == "1"{
//                    managedObject.is_hidden   = true
                }else{
                    managedObject.id              = Int64(attributeDict["ID"]!)!
                    managedObject.id_app          = Int64(attributeDict["id_request"]!)!
                    managedObject.text            = attributeDict["text"]
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                    managedObject.dateK           = dateFormatter.date(from: attributeDict["added"]!)
                    managedObject.id_author       = attributeDict["id_Author"]
                    managedObject.author          = attributeDict["Name"]
                    managedObject.id_account      = attributeDict["id_account"]
                    managedObject.is_hidden   = false
                    CoreDataManager.instance.saveContext()
                }
            }
        } else if (elementName == "File") {
            // Запишем файл в БД
            let managedObject = Fotos()
            managedObject.id              = Int64(attributeDict["FileID"]!)!
            managedObject.name            = attributeDict["FileName"]
            managedObject.number          = id_app
            managedObject.date            = attributeDict["DateTime"]
            CoreDataManager.instance.saveContext()
        } else if (elementName == "Payment"){
            let managedObject = PaymentApp()
            if Int64(String(attributeDict["ID"]!)) != nil{
                managedObject.id              = Int64(String(attributeDict["ID"]!))!
            }else{
                managedObject.id              = 0
            }
            if Int64(String(attributeDict["ID_Pay"]!)) != nil{
                managedObject.id_pay          = Int64(String(attributeDict["ID_Pay"]!))!
            }else{
                managedObject.id_pay          = 0
            }
            managedObject.date            = String(attributeDict["Date"]!)
            managedObject.ident           = String(attributeDict["Ident"]!)
            managedObject.status          = String(attributeDict["Status"]!)
            managedObject.desc            = String(attributeDict["Desc"]!)
            managedObject.sum             = String(attributeDict["Sum"]!)
            CoreDataManager.instance.saveContext()
        }
        UserDefaults.standard.set(self.request_read, forKey: "appsKol")
        DispatchQueue.main.async {
            let updatedBadgeNumber = UserDefaults.standard.integer(forKey: "appsKol") + UserDefaults.standard.integer(forKey: "newsKol")
            if (updatedBadgeNumber > -1) {
                UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
            }
            //                if request_read >= 0{
            //                    UserDefaults.standard.setValue(request_read, forKey: "request_read")
            //                    UserDefaults.standard.synchronize()
            //                }else{
            //                    UserDefaults.standard.setValue(0, forKey: "request_read")
            //                    UserDefaults.standard.synchronize()
            //                }
            
        }
    }
    
    // Ведомость
    func parse_OSV(login: String, pass: String) {
        var sum:Double = 0
        
        let urlPath = Server.SERVER + Server.GET_BILLS_SERVICES_FULL + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
//                                                if error != nil {
//                                                    return
//                                                } else {
                                                    var i_month: Int = 0
                                                    var i_year: Int = 0
                                                    var i_ident: String = ""
                                                    do {
                                                        var bill_id       = 0
                                                        var bill_month    = ""
                                                        var bill_year     = ""
                                                        var bill_service  = ""
                                                        var bill_acc      = ""
                                                        var bill_debt     = ""
                                                        var bill_pay      = ""
                                                        var bill_total    = ""
                                                        var bill_ident    = ""
                                                        var json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
//                                                        print(json)
                                                        
                                                        // Общие итоговые значения
                                                        var obj_start: Double = 0
                                                        var obj_plus: Double = 0
                                                        var obj_minus: Double = 0
                                                        var obj_end: Double = 0
                                                        
                                                        if let json_bills = json["data"] {
                                                            let int_end = (json_bills.count)!-1
                                                            if (int_end < 0) {
                                                                
                                                            } else {
                                                                var itsFirst: Bool = true
                                                                for index in 0...int_end {
                                                                    let json_bill = json_bills.object(at: index) as! [String:AnyObject]
                                                                    for obj in json_bill {
                                                                        if obj.key == "Month" {
                                                                            if ((obj.value as? NSNull) == nil){
                                                                                bill_month = String(describing: obj.value as! NSNumber)
                                                                            }
                                                                        }
                                                                        if obj.key == "Year" {
                                                                            if ((obj.value as? NSNull) == nil) {
                                                                                bill_year = String(describing: obj.value as! NSNumber)
                                                                            }
                                                                        }
                                                                        if obj.key == "Ident" {
                                                                            if ((obj.value as? NSNull) == nil) {
                                                                                bill_ident = obj.value as! String
                                                                            }
                                                                        }
                                                                    }
                                                                    if (Int(bill_month)! > i_month) || ((Int(bill_month)! == i_month) && (bill_ident != i_ident)) || ((Int(bill_month) == 1) && (i_month == 12)) {
                                                                        if (itsFirst) {
                                                                            itsFirst = false
                                                                        } else {
                                                                            DispatchQueue.main.sync {
                                                                                self.add_data_saldo(id: 1, usluga: "Я", num_month: String(i_month), year: String(i_year), start: String(format: "%.2f", obj_plus), plus: String(format: "%.2f", obj_start), minus: String(format: "%.2f", obj_minus), end: String(format: "%.2f", obj_end), ident: i_ident)
                                                                            }
                                                                            
                                                                            obj_start = 0.00
                                                                            obj_plus  = 0.00
                                                                            obj_minus = 0.00
                                                                            obj_end   = 0.00
                                                                        }
                                                                        i_ident = bill_ident
                                                                        i_month = Int(bill_month)!
                                                                        
                                                                    }
                                                                    if (Int(bill_year)! > i_year) {
                                                                        i_year = Int(bill_year)!
                                                                    }
                                                                    for obj in json_bill {
                                                                        if obj.key == "Ident" {
                                                                            bill_ident = obj.value as! String
                                                                        }
//                                                                        if bill_ident != "Все"{
                                                                            if obj.key == "Month" {
                                                                                if ((obj.value as? NSNull) == nil) {
                                                                                    bill_month = String(describing: obj.value as! NSNumber)
                                                                                }
                                                                            }
                                                                            if obj.key == "Year" {
                                                                                if ((obj.value as? NSNull) == nil) {
                                                                                    bill_year = String(describing: obj.value as! NSNumber)
                                                                                }
                                                                            }
                                                                            if obj.key == "ServiceTypeId" {
                                                                                if ((obj.value as? NSNull) == nil) {
                                                                                    bill_id = Int(truncating: obj.value as! NSNumber)
                                                                                }else{
                                                                                    bill_id = 0
                                                                                }
                                                                            }
                                                                            if obj.key == "Service" {
                                                                                if ((obj.value as? NSNull) == nil) {
                                                                                    bill_service = obj.value as! String
                                                                                }
                                                                            }
                                                                            if obj.key == "Accured" {
                                                                                if ((obj.value as? NSNull) == nil) {
                                                                                    bill_acc = String(format: "%.2f", (obj.value as! Double))//String(describing: obj.value as! NSNumber)
                                                                                    obj_plus += (obj.value as! Double)
                                                                                }
                                                                                
                                                                            }
                                                                            if obj.key == "Debt" {
                                                                                if ((obj.value as? NSNull) == nil) {
                                                                                    bill_debt = String(format: "%.2f", (obj.value as! Double))//String(describing: obj.value as! NSNumber)
                                                                                    obj_start += (obj.value as! Double)
                                                                                }
                                                                                
                                                                            }
                                                                            if obj.key == "Payed" {
                                                                                if ((obj.value as? NSNull) == nil) {
                                                                                    bill_pay = String(format: "%.2f", (obj.value as! Double))//String(describing: obj.value as! NSNumber)
                                                                                    obj_minus += (obj.value as! Double)
                                                                                }
                                                                                
                                                                            }
                                                                            if obj.key == "Total" {
                                                                                if ((obj.value as? NSNull) == nil) {
                                                                                    bill_total = String(format: "%.2f", (obj.value as! Double))//String(describing: obj.value as! NSNumber)
                                                                                    obj_end += (obj.value as! Double)
                                                                                }
                                                                            }
                                                                        }                                                                        
//                                                                    }
//                                                                    if bill_ident != "Все"{
                                                                    DispatchQueue.main.sync {
                                                                        self.add_data_saldo(id: Int64(bill_id), usluga: bill_service, num_month: bill_month, year: bill_year, start: bill_acc, plus: bill_debt, minus: bill_pay, end: bill_total, ident: bill_ident)
                                                                    }
                                                                    
//                                                                    }
                                                                }
                                                            }
                                                        }
                                                        DispatchQueue.main.sync {
                                                            self.add_data_saldo(id: 1, usluga: "Я", num_month: String(i_month), year: bill_year, start: String(format: "%.2f", obj_plus), plus: String(format: "%.2f", obj_start), minus: String(format: "%.2f", obj_minus), end: String(format: "%.2f", obj_end), ident: bill_ident)
                                                        }                                                        
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                DispatchQueue.main.sync {
                                                    // Выборка из БД последней ведомости - посчитаем сумму к оплате
                                                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Saldo")
                                                    fetchRequest.predicate = NSPredicate.init(format: "num_month = %@ AND year = %@", String(i_month), String(i_year))
                                                    do {
                                                        let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
                                                        for result in results {
                                                            let object = result as! NSManagedObject
                                                            sum = sum + Double(object.value(forKey: "end") as! String)!
                                                        }
                                                    } catch {
                                                        print(error)
                                                    }
                                                    UserDefaults.standard.set(true, forKey: "successParse")
                                                    let defaults = UserDefaults.standard
                                                    defaults.setValue(String(i_month), forKey: "month_osv")
                                                    defaults.setValue(String(i_year), forKey: "year_osv")
                                                    defaults.setValue(String(describing: sum), forKey: "sum")
                                                    defaults.synchronize()
                                                }
                                                
//                                                }
                                                
        })
        task.resume()
        
    }
    
    func add_data_saldo(id: Int64, usluga: String?, num_month: String?, year: String?, start: String?, plus: String?, minus: String?, end: String?, ident: String?) {
//        print(id, usluga, num_month, year, start, plus, minus, end, ident)
        let managedObject = Saldo()
        managedObject.id               = id
        managedObject.usluga           = usluga
        managedObject.num_month        = num_month
        managedObject.year             = year
        managedObject.start            = start
        managedObject.plus             = plus
        managedObject.minus            = minus
        managedObject.end              = end
        managedObject.ident            = ident
        
        CoreDataManager.instance.saveContext()
    }

    // Заявки с комментариями
    func parse_Apps(login: String, pass: String, isCons: String, isLoad: Bool) {
        request_read = 0
        // Если в БД нет заявок - получаем все заявки
        //        let fetchedResultsController: NSFetchedResultsController<Applications>?
        //        fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Applications", keysForSort: ["date"], predicateFormat: nil) as? NSFetchedResultsController<Applications>
        //        if (fetchedResultsController?.sections?.count)! > 0 {
        //
        //        } else {
        request_read = 0
        request_read_cons = 0
        self.login = login
        let pass  = pass
        var TextCons = ""
        if (isCons == "1") {
            TextCons = "&isConsultant=true&isActive=1;isPerformed=0"
        }
        let urlPath = Server.SERVER + Server.GET_APPS_COMM + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + TextCons;
        let url: NSURL = NSURL(string: urlPath)!
        parser = XMLParser(contentsOf: url as URL)!
        parser.delegate = self
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
        } else {
            print("parse failure!")
        }
        if enter{
            if isLoad{
                //            if UserDefaults.standard.bool(forKey: "isCons"){
                //                if self.request_read_cons > -1{
                //                    UserDefaults.standard.set(self.request_read_cons, forKey: "request_read_cons")
                //                }else{
                //                    UserDefaults.standard.set(0, forKey: "request_read_cons")
                //                }
                //            }
                //
                //            UserDefaults.standard.synchronize()
                // ВЕДОМОСТЬ
                // Удалим данные из базы данных
                del_db(table_name: "Saldo")
                // Получим данные в базу данных
                parse_OSV(login: login, pass: pass)
            }
        }
        
        //        }
    }
    
    // Добавить заявку
    func add_app(id: Int64, number: String, text: String, tema: String, date: String, adress: String, flat: String, phone: String, owner: String, is_close: Int64, is_read: Int64, is_answered: Int64, type_app: String) {
        
        let managedObject = Applications()
        managedObject.id              = 1
        managedObject.number          = number
        managedObject.text            = text
        managedObject.tema            = tema
        managedObject.date            = date
        managedObject.adress          = adress
        managedObject.flat            = flat
        managedObject.phone           = phone
        managedObject.owner           = owner
        managedObject.is_close        = is_close
        managedObject.is_read         = is_read
        managedObject.is_answered     = is_answered
        managedObject.type_app        = type_app
        CoreDataManager.instance.saveContext()
    }
    
    // Удалить заявку
    func del_app(number: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Applications")
        fetchRequest.predicate = NSPredicate.init(format: "number==\(number)")
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results {
                CoreDataManager.instance.managedObjectContext.delete(result as! NSManagedObject)
            }
        } catch {
            print(error)
        }
        CoreDataManager.instance.saveContext()
    }
    
    func isValidEmail(testStr: String) -> Bool{
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidLogin(testStr: String) -> Bool{
        let RegEx = "\\w{0,26}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: testStr)
    }
}
