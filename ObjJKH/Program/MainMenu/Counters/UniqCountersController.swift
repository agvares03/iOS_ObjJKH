//
//  UniqCountersController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 28/02/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import CoreData
import Dropper

class UniqCountersController: UIViewController, DropperDelegate, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    // Глобальные переменные для парсинга
    var parser = XMLParser()

    public var uniq_num = ""
    public var uniq_name = ""
    public var ls = ""
    public var owner = ""
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var tableCounters: UITableView!
    @IBOutlet weak var uniqNum: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lsLbl: UILabel!
    @IBOutlet weak var uniqName: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendAction(_ sender: UIButton){
        if isEditable(){
            let alert = UIAlertController(title: uniq_name + "(" + owner + ")", message: "Введите текущие показания прибора", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in textField.placeholder = "Введите показание..."; textField.keyboardType = .decimalPad })
            let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                self.send_count(edLogin: self.login, edPass: self.pass, uniq_num: self.uniq_num, count: (alert.textFields?[0].text!)!)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            let date1            = UserDefaults.standard.string(forKey: "date1")!
            let date2            = UserDefaults.standard.string(forKey: "date2")!
            let alert = UIAlertController(title: "Ошибка", message: "Возможность передавать показания доступна с " + date1 + " по " + date2 + " числа текущего месяца!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    let dropper = Dropper(width: 150, height: 400)
    
    var fetchedResultsController: NSFetchedResultsController<Counters>?
    var choiceIdent = ""
    var responseString:NSString = ""
    var iterYear: String = "0"
    var currYear: String = ""
    var iterMonth: String = "0"
    var currMonth: String = ""
    var can_edit:String = ""
    
    var login: String = ""
    var pass: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableCounters.delegate = self
        tableCounters.dataSource = self
        lsLbl.text = "Л/с: " + ls
        
        uniqNum.text = owner
        uniqName.text = uniq_name
        StartIndicator()
        let defaults     = UserDefaults.standard
        login          = defaults.string(forKey: "login")!
        pass           = defaults.string(forKey: "pass")!
        currYear         = defaults.string(forKey: "year")!
        currMonth        = defaults.string(forKey: "month")!
        can_edit         = defaults.string(forKey: "can_count")!
        
        iterMonth = currMonth
        iterYear = currYear
        if ls == "Все"{
            ls = defaults.string(forKey: "login")!
            choiceIdent = "Все"
            let str_ls = defaults.string(forKey: "str_ls")
            let str_ls_arr = str_ls?.components(separatedBy: ",")
            if str_ls_arr?.count == 1{
                lsLbl.text = "Л/с: " + str_ls_arr![0]
            }
        }else{
            choiceIdent = ls
        }
        back.tintColor = myColors.indicatorColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        sendButton.backgroundColor = myColors.indicatorColor.uiColor()
        headerView.backgroundColor = myColors.indicatorColor.uiColor()
        DB().del_db(table_name: "Counters")
        // Получим данные в базу данных
        if ls == "Все"{
            parse_Countrers(login: login, pass: pass)
        }else{
            parse_Countrers(login: ls, pass: pass)
        }
//        if !isEditable(){
//            sendButton.isEnabled = false
//            sendButton.backgroundColor = sendButton.backgroundColor?.withAlphaComponent(0.5)
//        }
        // Do any additional setup after loading the view.
    }
    
    var identArr    :[String] = []
    var nameArr     :[String] = []
    var numberArr   :[String] = []
    var predArr     :[Float] = []
    var teckArr     :[Float] = []
    var diffArr     :[Float] = []
    var unitArr     :[String] = []
    var dateOneArr     :[String] = []
    var dateTwoArr     :[String] = []
    var dateThreeArr   :[String] = []
    
    func parse_Countrers(login: String, pass: String) {
        StartIndicator()
        // Получим данные из xml
        let urlPath:String = Server.SERVER + Server.GET_METERS_MUP + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&meter=" + self.uniq_num
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
    
    func getData(ident: String){
        identArr.removeAll()
        nameArr.removeAll()
        numberArr.removeAll()
        predArr.removeAll()
        teckArr.removeAll()
        diffArr.removeAll()
        unitArr.removeAll()
        sendedArr.removeAll()
        dateOneArr.removeAll()
        dateTwoArr.removeAll()
        dateThreeArr.removeAll()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Counters")
        fetchRequest.predicate = NSPredicate.init(format: "year <= %@", String(self.iterYear))
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results {
                let object = result as! NSManagedObject
                if ident != "Все"{
                    if (object.value(forKey: "ident") as! String) == ident{
                        if (object.value(forKey: "uniq_num") as! String) == self.uniq_num{
                            identArr.append(object.value(forKey: "ident") as! String)
                            nameArr.append(object.value(forKey: "count_name") as! String)
                            numberArr.append(object.value(forKey: "uniq_num") as! String)
                            teckArr.append(object.value(forKey: "value") as! Float)
                            dateOneArr.append(object.value(forKey: "num_month") as! String)
                            unitArr.append(object.value(forKey: "unit_name") as! String)
                            sendedArr.append(object.value(forKey: "sended") as! Bool)
                        }
                    }
                }else{
                    if (object.value(forKey: "uniq_num") as! String) == self.uniq_num{
                        identArr.append(object.value(forKey: "ident") as! String)
                        nameArr.append(object.value(forKey: "count_name") as! String)
                        numberArr.append(object.value(forKey: "uniq_num") as! String)
                        teckArr.append(object.value(forKey: "value") as! Float)
                        dateOneArr.append(object.value(forKey: "num_month") as! String)
                        unitArr.append(object.value(forKey: "unit_name") as! String)
                        sendedArr.append(object.value(forKey: "sended") as! Bool)
                    }
                }
                
            }
            DispatchQueue.main.async(execute: {
                self.updateTable()
            })
            
        } catch {
            print(error)
        }
    }
    
    func isEditable() -> Bool {
        //        if self.nextMonthLabel.isHidden == false{
        //            return false
        //        }
        return iterYear == currYear && iterMonth == currMonth && can_edit == "1"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = self.tableCounters.dequeueReusableCell(withIdentifier: "uniqCounterCell") as! UniqCounterCell
        var send = false
        cell.teck.text        = String(format:"%.2f", teckArr[indexPath.row])
        cell.teckLbl.text     = dateOneArr[indexPath.row]
        send = sendedArr[indexPath.row]
        //        if self.nextMonthLabel.isHidden == true{
        //            cell.sendCounter.isHidden = false
        //        }else{
        //            cell.sendCounter.isHidden = true
        //        }
        cell.delegate = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        selectedUniq = numberArr[indexPath.row]
        self.performSegue(withIdentifier: "uniqCounters", sender: self)
    }
    var selectedUniq = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uniqCounters" {
            let payController             = segue.destination as! UniqCountersController
            payController.uniq_num = selectedUniq
        }
    }
    
    func updateTable() {
        StopIndicator()
        tableCounters.reloadData()
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
        
        return rezult.uppercased()
    }
    
    func StartIndicator(){
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    var ident = ""
    var units = ""
    var name = ""
    var meterUniqueNum = ""
    var factoryNumber = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if (elementName == "Meter") {
            print(attributeDict)
            ident = attributeDict["Ident"]!
            units = attributeDict["Units"]!
            name = attributeDict["Name"]!
            meterUniqueNum = attributeDict["MeterUniqueNum"]!
            factoryNumber = attributeDict["FactoryNumber"]!
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
            managedObject.prev_value    = 123.53
            managedObject.value         = (attributeDict["Value"]!.replacingOccurrences(of: ",", with: ".") as NSString).floatValue
            managedObject.diff          = 6757.43
            if attributeDict["IsSended"] == "1"{
                managedObject.sended    = true
            }else{
                managedObject.sended    = false
            }
            
            CoreDataManager.instance.saveContext()
        }
        getData(ident: choiceIdent)
    }
    
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
                    self.parse_Countrers(login: self.ls, pass: self.pass)
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
}

class UniqCounterCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var teck: UILabel!
    @IBOutlet weak var teckLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
