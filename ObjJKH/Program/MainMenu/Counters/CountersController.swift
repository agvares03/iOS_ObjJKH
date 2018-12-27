//
//  CountersController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 29.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import CoreData
import Dropper

class CountersController: UIViewController, DropperDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var Count: Counters? = nil
    
    @IBOutlet weak var back: UIBarButtonItem!
    
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
    var choiceIdent = ""
    
    
    var responseString:NSString = ""
    
    // название месяца для вывода в шапку
    var name_month: String = "";
    
    var fetchedResultsController: NSFetchedResultsController<Counters>?

    @IBOutlet weak var ls_Button: UIButton!
    @IBOutlet weak var tableCounters: UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var can_count_label: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var prevMonthLabel: UILabel!
    @IBOutlet weak var nextMonthLabel: UILabel!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
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
    
    @IBAction func leftButtonDidPress(_ sender: Any) {
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
        
        if choiceIdent == ""{
            updateFetchedResultsController()
            updateMonthLabel()
            updateTable()
            updateArrowsEnabled()
            updateEditInfoLabel()
        }else{
            let ident = identArr[0]
            updateMonthLabel()
            getData(ident: ident)
            updateArrowsEnabled()
        }
    }
    
    @IBAction func rightButtonDidPress(_ sender: Any) {
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
        
        if choiceIdent == ""{
            updateFetchedResultsController()
            updateMonthLabel()
            updateTable()
            updateArrowsEnabled()
            updateEditInfoLabel()
        }else{
            let ident = identArr[0]
            updateMonthLabel()
            getData(ident: ident)
            updateArrowsEnabled()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Получим данные из глобальных сохраненных
        let defaults     = UserDefaults.standard
        edLogin          = defaults.string(forKey: "login")!
        edPass           = defaults.string(forKey: "pass")!
        currYear         = defaults.string(forKey: "year")!
        currMonth        = defaults.string(forKey: "month")!
        date1            = defaults.string(forKey: "date1")!
        date2            = defaults.string(forKey: "date2")!
        can_edit         = defaults.string(forKey: "can_count")!
        
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
        
        if ((str_ls_arr?.count)! > 0) {
            for i in 0..<(str_ls_arr?.count ?? 1 - 1) {
                dropper.items.append((str_ls_arr?[i])!)
            }
        }
        
        dropper.showWithAnimation(0.001, options: Dropper.Alignment.center, button: ls_Button)
        dropper.hideWithAnimation(0.001)
        
        tableCounters.delegate = self
        
        StopIndicator()
        
        updateBorderDates()
        updateFetchedResultsController()
        updateMonthLabel()
        updateTable()
        updateArrowsEnabled()
        updateEditInfoLabel()
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        
        let titles = Titles()
        self.title = titles.getTitle(numb: "4")
        
    }
    
    func updateBorderDates() {
        fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Counters", keysForSort: ["year"], predicateFormat: nil)
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        
        if (fetchedResultsController?.sections?.count)! > 0 {
            if (fetchedResultsController?.sections?.first?.numberOfObjects)! > 0 {
                let leftCounter = fetchedResultsController?.sections?.first?.objects?.first as! Counters
                let rightCounter = fetchedResultsController?.sections?.first?.objects?.last as! Counters
                
                minMonth = leftCounter.num_month!
                minYear = leftCounter.year!
                maxMonth = rightCounter.num_month!
                maxYear = rightCounter.year!
            }
        }
    }
    var identArr    :[String] = []
    var nameArr     :[String] = []
    var numberArr   :[String] = []
    var predArr     :[Float] = []
    var teckArr     :[Float] = []
    var diffArr     :[Float] = []
    
    func getData(ident: String){
        identArr.removeAll()
        nameArr.removeAll()
        numberArr.removeAll()
        predArr.removeAll()
        teckArr.removeAll()
        diffArr.removeAll()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Counters")
        fetchRequest.predicate = NSPredicate.init(format: "num_month = %@ AND year = %@", String(self.iterMonth), String(self.iterYear))
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results {
                let object = result as! NSManagedObject
                if ident != "Все"{
                    if (object.value(forKey: "ident") as! String) == ident{
                        identArr.append(object.value(forKey: "ident") as! String)
                        nameArr.append(object.value(forKey: "count_name") as! String)
                        numberArr.append(object.value(forKey: "uniq_num") as! String)
                        predArr.append(object.value(forKey: "prev_value") as! Float)
                        teckArr.append(object.value(forKey: "value") as! Float)
                        diffArr.append(object.value(forKey: "diff") as! Float)
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
    
    func updateFetchedResultsController() {
        let predicateFormat = String(format: "num_month = %@ AND year = %@", iterMonth, iterYear)
        fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Counters", keysForSort: ["count_name"], predicateFormat: predicateFormat)
        
        do {
            try fetchedResultsController?.performFetch()
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
    
    func updateArrowsEnabled() {
        
        leftButton.isEnabled = self.isValidPrevMonth()
        rightButton.isEnabled = self.isValidNextMonth()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMonthLabel() {
        monthLabel.text = get_name_month(number_month: iterMonth) + " " + iterYear
        
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
    
    func isEditable() -> Bool {
        return iterYear == currYear && iterMonth == currMonth && can_edit == "1"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if choiceIdent == ""{
            if let sections = fetchedResultsController?.sections {
                return sections[section].numberOfObjects
            } else {
                return 0
            }
        }else{
            if nameArr.count != 0 {
                return nameArr.count
            } else {
                return 0
            }
        }
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 154.0
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableCounters.dequeueReusableCell(withIdentifier: "CounterCell") as! CounterCell
        if choiceIdent == ""{
            let counter = (fetchedResultsController?.object(at: indexPath))! as Counters
            self.Count = counter
            
            cell.ident.text       = counter.ident
            cell.name.text        = counter.count_name
            cell.number.text      = counter.uniq_num
            cell.pred.text        = counter.prev_value.description
            cell.teck.text        = counter.value.description
            cell.diff.text        = counter.diff.description
        }else{
            cell.ident.text       = identArr[indexPath.row]
            cell.name.text        = nameArr[indexPath.row]
            cell.number.text      = numberArr[indexPath.row]
            cell.pred.text        = predArr[indexPath.row].description
            cell.teck.text        = teckArr[indexPath.row].description
            cell.diff.text        = diffArr[indexPath.row].description
        }
        
        
        cell.delegate = self
        return cell

    }
    
    func updateEditInfoLabel() {
        // Возможно пригодится функция для изменения чего-нибудь еще
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if (isEditable()) {
            let counter = (fetchedResultsController?.object(at: indexPath))! as Counters
            let alert = UIAlertController(title: counter.count_name! + "(" + counter.uniq_num! + ")", message: "Введите текущие показания прибора", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in textField.placeholder = "Введите показание..."; textField.keyboardType = .numberPad })
            let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                self.send_count(edLogin: self.edLogin, edPass: self.edPass, counter: counter, count: (alert.textFields?[0].text!)!)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        ls_Button.setTitle(contents, for: UIControlState.normal)
        if (contents == "Все") {
            choiceIdent = ""
            updateTable()
        } else {
            choiceIdent = contents
            getData(ident: contents)
        }
    }
    
    func updateTable() {
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

    // Передача показаний
    func send_count(edLogin: String, edPass: String, counter: Counters, count: String) {
        if (count != "") {
            StartIndicator()
            
            let strNumber: String = counter.uniq_num!
            
            let urlPath = Server.SERVER + Server.ADD_METER
                + "login=" + edLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&pwd=" + edPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&meterID=" + strNumber.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&val=" + count.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        DispatchQueue.main.async(execute: {
                                                            let alert = UIAlertController(title: "Ошибка сервера", message: "Попробуйте позже", preferredStyle: .alert)
                                                            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                            alert.addAction(cancelAction)
                                                            self.present(alert, animated: true, completion: nil)
                                                        })
                                                        return
                                                    }
                                                    
                                                    self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                                                    print("responseString = \(self.responseString)")
                                                    
                                                    self.choice(counter: counter, prev: counter.prev_value, teck: Float(count)!)
                                                    
            })
            
            task.resume()
            
        }
    }
    
    func choice(counter: Counters, prev: Float, teck: Float) {
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
                counter.value = teck
                counter.diff = teck - prev
                counter.prev_value = teck - (teck - prev)
                CoreDataManager.instance.saveContext()
                
                self.StopIndicator()
                let alert = UIAlertController(title: "Успешно", message: "Показания переданы", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    self.updateBorderDates()
                    self.updateFetchedResultsController()
                    self.updateMonthLabel()
                    self.updateTable()
                    self.updateArrowsEnabled()
                    self.updateEditInfoLabel()
                    
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    func StartIndicator(){
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }

}
