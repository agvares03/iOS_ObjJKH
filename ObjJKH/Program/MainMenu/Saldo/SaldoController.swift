//
//  SaldoController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 30.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import CoreData
import Dropper

class SaldoController: UIViewController, DropperDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var btnPay: UIButton!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    let dropper = Dropper(width: 150, height: 400)
    
    var login: String?
    var pass: String?
    
    var currYear: String = ""
    var currMonth: String = ""
    var iterYear: String = "0"
    var iterMonth: String = "0"
    var minYear: String = ""
    var minMonth: String = ""
    var maxYear: String = ""
    var maxMonth: String = ""
    
    // название месяца для вывода в шапку
    var name_month: String = "";
    
    // Индекс сроки для группировки
    var selectedRow = -5;
    
    @IBOutlet weak var tableOSV: UITableView!
    @IBOutlet weak var ls_button: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var prevMonthLabel: UILabel!
    @IBOutlet weak var nextMonthLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rigthButton: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController<Saldo>?
    
    // Общие итоги
    var obj_col: Int = 0
    var obj_start: Double = 0
    var obj_plus: Double = 0
    var obj_minus: Double = 0
    var obj_end: Double = 0
    
    @IBAction func ls_button_choice(_ sender: UIButton) {
        if dropper.status == .hidden {
            
            dropper.theme = Dropper.Themes.white
//            dropper.cornerRadius = 3
            dropper.showWithAnimation(0.15, options: Dropper.Alignment.center, button: ls_button)
            view.addSubview(dropper)
        } else {
            dropper.hideWithAnimation(0.1)
        }
    }
    
    @IBAction func leftButtonDidPressed(_ sender: UIButton) {
        var m = Int(iterMonth)!
        var y = Int(iterYear)!
        
        if m > 1 {
            m = m - 1
        }
        else {
            m = 12
            y = y - 1
        }
        
        iterMonth = String(m)
        iterYear = String(y)
        
        updateFetchedResultsController()
        updateMonthLabel()
        updateTable()
        updateArrowsEnabled()
    }
    
    @IBAction func rigthButtonDidPressed(_ sender: UIButton) {
        var m = Int(iterMonth)!
        var y = Int(iterYear)!
        
        if m < 12 {
            m = m + 1
        }
        else {
            m = 1
            y = y + 1
        }
        
        iterMonth = String(m)
        iterYear = String(y)
        
        updateFetchedResultsController()
        updateMonthLabel()
        updateTable()
        updateArrowsEnabled()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Получим данные из глобальных сохраненных
        let defaults     = UserDefaults.standard
        currYear         = defaults.string(forKey: "year_osv")!
        currMonth        = defaults.string(forKey: "month_osv")!
        
        iterMonth = currMonth
        iterYear = currYear
        
        // Заполним лиц. счетами отбор
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        
        // Логин и пароль
        login = defaults.string(forKey: "login")
        pass  = defaults.string(forKey: "pass")
        
        dropper.delegate = self
        dropper.items.append("Все")
        
        if ((str_ls_arr?.count)! > 0) {
            for i in 0..<(str_ls_arr?.count ?? 1 - 1) {
                dropper.items.append((str_ls_arr?[i])!)
            }
        }
        
        dropper.showWithAnimation(0.001, options: Dropper.Alignment.center, button: ls_button)
        dropper.hideWithAnimation(0.001)
        
        // Установим значения текущие (если нет данных вообще)
        minMonth = iterMonth
        minYear = iterYear
        maxMonth = iterMonth
        maxYear = iterYear
        
        tableOSV.delegate = self
        
        updateBorderDates()
        updateFetchedResultsController()
        updateMonthLabel()
        updateTable()
        updateArrowsEnabled()
        
//        getData(login: login!, pass: pass!)
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        btnPay.backgroundColor = myColors.btnColor.uiColor()
        
        let titles = Titles()
        self.title = titles.getTitle(numb: "5")
        
        #if isOur_Obj_Home
            btnPay.isHidden = true
        #endif
        
    }
    
    func updateBorderDates() {
        fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Saldo", keysForSort: ["year"], predicateFormat: nil) as? NSFetchedResultsController<Saldo>
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        
        if (fetchedResultsController?.sections?.count)! > 0 {
            if (fetchedResultsController?.sections?.first?.numberOfObjects)! > 0 {
                let leftCounter = fetchedResultsController?.sections?.first?.objects?.first as! Saldo
                let rightCounter = fetchedResultsController?.sections?.first?.objects?.last as! Saldo
                
                minMonth = leftCounter.num_month!
                minYear = leftCounter.year!
                maxMonth = rightCounter.num_month!
                maxYear = rightCounter.year!
            }
        }
    }
    
    func updateFetchedResultsController() {
        let predicateFormat = String(format: "num_month = %@ AND year = %@", iterMonth, iterYear)
        fetchedResultsController = CoreDataManager.instance.fetchedResultsControllerSaldo(entityName: "Saldo", keysForSort: ["usluga"], predicateFormat: predicateFormat) as NSFetchedResultsController<Saldo>
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
    }
    
    func updateMonthLabel() {
        monthLabel.text = get_name_month(number_month: iterMonth) + " " + (iterYear == "0" ? "-" : iterYear)
        
        var month = Int(iterMonth)! - 1 < 1 ? 12 : Int(iterMonth)! - 1
        var monthStr = "<" + get_name_month(number_month: String(month))
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize:17.0),
                          NSAttributedStringKey.foregroundColor : myColors.btnColor.uiColor(),
                          NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any]
        
        var attributedtext = NSAttributedString.init(string: monthStr.uppercased(), attributes: attributes)
        self.prevMonthLabel.attributedText = attributedtext
        
        month = Int(iterMonth)! + 1 > 12 ? 1 : Int(iterMonth)! + 1
        monthStr = get_name_month(number_month: String(month)) + ">"
        
        attributedtext = NSAttributedString.init(string: monthStr.uppercased(), attributes: attributes)
        self.nextMonthLabel.attributedText = attributedtext
        
        self.nextMonthLabel.isHidden = !self.isValidNextMonth()
        self.prevMonthLabel.isHidden = !self.isValidPrevMonth()
    }
    
    func updateTable() {
        tableOSV.reloadData()
    }
    
    typealias curentMonthAndYear = (month:Int, year:Int)
    
    func getCurentMonthAndYear () -> curentMonthAndYear {
        let m = Int(iterMonth)!
        let y = Int(iterYear)!
        return (m , y)
    }
    
    func isValidNextMonth() -> Bool {
        let curentMonthAndYear = self.getCurentMonthAndYear()
        if (maxMonth == "") {
            maxMonth = "0"
        }
        if (maxYear == "") {
            maxYear = "0"
        }
        let maxM = Int(maxMonth)!
        let maxY = Int(maxYear)!
        return !(curentMonthAndYear.month >= maxM && curentMonthAndYear.year >= maxY);
    }
    
    func isValidPrevMonth() -> Bool {
        let curentMonthAndYear = self.getCurentMonthAndYear()
        if (minMonth == "") {
            minMonth = "0"
        }
        if (minYear == "") {
            minYear = "0"
        }
        let minM = Int(minMonth)!
        let minY = Int(minYear)!
        return !(curentMonthAndYear.month <= minM && curentMonthAndYear.year <= minY);
    }
    
    func updateArrowsEnabled() {
        leftButton.isEnabled = self.isValidPrevMonth()
        rigthButton.isEnabled = self.isValidNextMonth()
    }
    
    func updateEditInfoLabel() {
        // Возможно пригодится функция для изменения чего-нибудь еще
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
        if let sections = fetchedResultsController?.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableOSV.dequeueReusableCell(withIdentifier: "Cell") as! SaldoCell
        let osv = fetchedResultsController!.object(at: indexPath)
        if (osv.usluga == "Я") {
            cell.usluga.text = "ИТОГО"
        } else {
            cell.usluga.text = osv.usluga
        }
        cell.start.text  = osv.plus
        cell.plus.text   = osv.start
        cell.minus.text  = osv.minus
        cell.end.text    = osv.end
        cell.delegate = self
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 138
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (selectedRow == -5)   //значит сейчас не выбрана никакая ячейка
        {
            selectedRow = indexPath.row;    //сохранили индекс ячейки
        }
        else if (selectedRow == indexPath.row)    //значит нажали на выбраную ячейку
        {
            selectedRow = -5;    //так мы закроем ее, если это не нужно - этот if можно пропустить
        }
        else
        {
            selectedRow = indexPath.row    //сделали выбранной другую ячейку
        }
        
        tableOSV.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        ls_button.setTitle(contents, for: UIControlState.normal)
        if (contents == "Все") {
            getData(login: login!, pass: pass!)
        } else {
            getData(login: contents, pass: pass!)
        }
    }
    
    func getData(login: String, pass: String) {
        // Экземпляр класса DB
        let db = DB()
        // Удалим данные из базы данных
        db.del_db(table_name: "Saldo")
        // Получим данные в базу данных
        parse_OSV(login: login, pass: pass)
    }
    
    // Дубль - получение ведомостей по лиц. счетам
    // Ведомость
    func parse_OSV(login: String, pass: String) {
        
        var sum:Double = 0
        
        let urlPath = Server.SERVER + Server.GET_BILLS_SERVICES + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    return
                                                } else {
                                                    var i_month: Int = 0
                                                    var i_year: Int = 0
                                                    do {
                                                        DB().del_db(table_name: "Saldo")
                                                        var bill_month    = ""
                                                        var bill_year     = ""
                                                        var bill_service  = ""
                                                        var bill_acc      = ""
                                                        var bill_debt     = ""
                                                        var bill_pay      = ""
                                                        var bill_total    = ""
                                                        var json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                        print(json)
                                                        
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
                                                                            bill_month = String(describing: obj.value as! NSNumber)
                                                                        }
                                                                        if obj.key == "Year" {
                                                                            bill_year = String(describing: obj.value as! NSNumber)
                                                                        }
                                                                    }
                                                                    if (Int(bill_month)! > i_month) || ((Int(bill_month) == 1) && (i_month == 12)) {
                                                                        if (itsFirst) {
                                                                            itsFirst = false
                                                                        } else {
                                                                            self.add_data_saldo(usluga: "Я", num_month: String(i_month), year: String(i_year), start: String(format: "%.2f", obj_plus), plus: String(format: "%.2f", obj_start), minus: String(format: "%.2f", obj_minus), end: String(format: "%.2f", obj_end))
                                                                            obj_start = 0.00
                                                                            obj_plus  = 0.00
                                                                            obj_minus = 0.00
                                                                            obj_end   = 0.00
                                                                        }
                                                                        
                                                                        i_month = Int(bill_month)!
                                                                        
                                                                    }
                                                                    if (Int(bill_year)! > i_year) {
                                                                        i_year = Int(bill_year)!
                                                                    }
                                                                    
                                                                    for obj in json_bill {
                                                                        if obj.key == "Month" {
                                                                            bill_month = String(describing: obj.value as! NSNumber)
                                                                        }
                                                                        if obj.key == "Year" {
                                                                            bill_year = String(describing: obj.value as! NSNumber)
                                                                        }
                                                                        if obj.key == "Service" {
                                                                            bill_service = obj.value as! String
                                                                        }
                                                                        if obj.key == "Accured" {
                                                                            bill_acc = String(format: "%.2f", (obj.value as! Double))//String(describing: obj.value as! NSNumber)
                                                                            obj_plus += (obj.value as! Double)
                                                                        }
                                                                        if obj.key == "Debt" {
                                                                            bill_debt = String(format: "%.2f", (obj.value as! Double))//String(describing: obj.value as! NSNumber)
                                                                            obj_start += (obj.value as! Double)
                                                                        }
                                                                        if obj.key == "Payed" {
                                                                            bill_pay = String(format: "%.2f", (obj.value as! Double))//String(describing: obj.value as! NSNumber)
                                                                            obj_minus += (obj.value as! Double)
                                                                        }
                                                                        if obj.key == "Total" {
                                                                            bill_total = String(format: "%.2f", (obj.value as! Double))//String(describing: obj.value as! NSNumber)
                                                                            obj_end += (obj.value as! Double)
                                                                        }
                                                                    }
                                                                    self.add_data_saldo(usluga: bill_service, num_month: bill_month, year: bill_year, start: bill_acc, plus: bill_debt, minus: bill_pay, end: bill_total)
                                                                }
                                                            }
                                                        }
                                                        
                                                        self.add_data_saldo(usluga: "Я", num_month: String(i_month), year: bill_year, start: String(format: "%.2f", obj_plus), plus: String(format: "%.2f", obj_start), minus: String(format: "%.2f", obj_minus), end: String(format: "%.2f", obj_end))
                                                        
                                                        self.end_osv()
                                                        
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                    
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
                                                    
                                                    let defaults = UserDefaults.standard
                                                    defaults.setValue(String(i_month), forKey: "month_osv")
                                                    defaults.setValue(String(i_year), forKey: "year_osv")
                                                    defaults.setValue(String(describing: sum), forKey: "sum")
                                                    defaults.synchronize()
                                                    
                                                }
                                                
        })
        task.resume()
        
    }
    
    func add_data_saldo(usluga: String, num_month: String, year: String, start: String, plus: String, minus: String, end: String) {
        #if isMupRCMytishi
//        print(usluga)
        if usluga == "Услуги ЖКУ"{
            let managedObject = Saldo()
            managedObject.id               = 1
            managedObject.usluga           = usluga
            managedObject.num_month        = num_month
            managedObject.year             = year
            managedObject.start            = start
            managedObject.plus             = plus
            managedObject.minus            = minus
            managedObject.end              = end
        }
        
        #else
        let managedObject = Saldo()
        managedObject.id               = 1
        managedObject.usluga           = usluga
        managedObject.num_month        = num_month
        managedObject.year             = year
        managedObject.start            = start
        managedObject.plus             = plus
        managedObject.minus            = minus
        managedObject.end              = end
        #endif
        CoreDataManager.instance.saveContext()
    }
    
    func end_osv() {
        // Выборка из БД последней ведомости - посчитаем сумму к оплате
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Saldo")
        fetchRequest.predicate = NSPredicate.init(format: "num_month = %@ AND year = %@", String(self.iterMonth), String(self.iterYear))
        DispatchQueue.main.async(execute: {
            self.updateBorderDates()
            self.updateFetchedResultsController()
            self.updateMonthLabel()
            self.updateTable()
            self.updateArrowsEnabled()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        getData(login: login!, pass: pass!)
    }
    
}
