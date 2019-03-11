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
    var choiceIdent = ""
    
    
    var responseString:NSString = ""
    
    // название месяца для вывода в шапку
    var name_month: String = "";
    
    var fetchedResultsController: NSFetchedResultsController<Counters>?

    @IBOutlet weak var spinImg: UIImageView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var ls_lbl: UILabel!
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
    
    @objc private func lblTapped(_ sender: UITapGestureRecognizer) {
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "addLSMup", sender: self)
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
            let ident = choiceIdent
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
            let ident = choiceIdent
            updateMonthLabel()
            getData(ident: ident)
            updateArrowsEnabled()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nonConectView.isHidden = true
        lsView.isHidden = false
        ls_lbl.isHidden = false
        ls_Button.isHidden = false
        monthLabel.isHidden = false
        monthView.isHidden = false
        can_count_label.isHidden = false
        tableCounters.isHidden = false
        spinImg.isHidden = false
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
            monthView.isHidden = true
            can_count_label.isHidden = true
            tableCounters.isHidden = true
            spinImg.isHidden = true
        }
        
        dropper.showWithAnimation(0.001, options: Dropper.Alignment.center, button: ls_Button)
        dropper.hideWithAnimation(0.001)
        
        tableCounters.delegate = self
        tableCounters.dataSource = self
        
        StopIndicator()
        
        updateBorderDates()
//        updateFetchedResultsController()
//        updateMonthLabel()
//        updateTable()
//        updateArrowsEnabled()
//        updateEditInfoLabel()
        
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
            monthView.isHidden = true
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
        updateFetchedResultsController()
    }
    var identArr    :[String] = []
    var nameArr     :[String] = []
    var numberArr   :[String] = []
    var predArr     :[Float] = []
    var teckArr     :[Float] = []
    var diffArr     :[Float] = []
    var unitArr     :[String] = []
    
    func getData(ident: String){
        identArr.removeAll()
        nameArr.removeAll()
        numberArr.removeAll()
        predArr.removeAll()
        teckArr.removeAll()
        diffArr.removeAll()
        unitArr.removeAll()
        sendedArr.removeAll()
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
    
    func updateFetchedResultsController() {
        let predicateFormat = String(format: "num_month = %@ AND year = %@", iterMonth, iterYear)
        fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Counters", keysForSort: ["count_name"], predicateFormat: predicateFormat)
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        updateMonthLabel()
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
        updateEditInfoLabel()
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
        if self.nextMonthLabel.isHidden{
            if (date1 == "0") && (date2 == "0") {
                can_count_label.text = "Возможность передавать показания доступна в текущем месяце!"
            } else {
                can_count_label.text = "Возможность передавать показания доступна с " + date1 + " по " + date2 + " числа текущего месяца!"
            }
        }else{
            let monthYear:String = monthLabel.text!
            can_count_label.text = "За \(monthYear) передавать показания уже нельзя, перейдите в \(get_name_month(number_month: maxMonth)) для передачи текущих показаний"
        }
        self.prevMonthLabel.isHidden = !self.isValidPrevMonth()
        updateTable()
    }
    
    func isEditable() -> Bool {
        if self.nextMonthLabel.isHidden == false{
            return false
        }
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
//        return 170.0
//    }
    
    var sendedArr:[Bool] = []
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableCounters.dequeueReusableCell(withIdentifier: "CounterCell") as! CounterCell
        var send = false
        var countName = ""
        if choiceIdent == ""{
            let counter = (fetchedResultsController?.object(at: indexPath))! as Counters
            self.Count = counter
            cell.ident.text       = counter.ident
            cell.name.text        = String(counter.count_name! + ", " + counter.unit_name!)
            countName             = counter.count_name!
            cell.number.text      = counter.owner
            cell.pred.text        = String(format:"%.2f", counter.prev_value)
            cell.teck.text        = String(format:"%.2f", counter.value)
            cell.diff.text        = String(format:"%.2f", counter.diff)
            send = counter.sended
        }else{
            cell.ident.text       = identArr[indexPath.row]
            cell.name.text        = nameArr[indexPath.row] + ", " + unitArr[indexPath.row]
            cell.number.text      = numberArr[indexPath.row]
            countName             = nameArr[indexPath.row]
            cell.pred.text        = String(format:"%.2f", predArr[indexPath.row])
            cell.teck.text        = String(format:"%.2f", teckArr[indexPath.row])
            cell.diff.text        = String(format:"%.2f", diffArr[indexPath.row])
            send = sendedArr[indexPath.row]
        }
        if send{
            cell.nonCounter.text = "Показания переданы"
            cell.sendCounter.textColor = myColors.indicatorColor.uiColor()
            let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
            let underlineAttributedString = NSAttributedString(string: "Изменить показания", attributes: underlineAttribute)
            cell.sendCounter.attributedText = underlineAttributedString
            cell.pred.isHidden = false
            cell.teck.isHidden = false
            cell.diff.isHidden = false
            cell.predLbl.isHidden = false
            cell.teckLbl.isHidden = false
            cell.diffLbl.isHidden = false
            cell.lblHeight2.constant = 16
            cell.lblHeight3.constant = 16
            cell.lblHeight5.constant = 16
            cell.lblHeight6.constant = 16
        }else{
            cell.nonCounter.text = "Показания не переданы"
            cell.sendCounter.textColor = myColors.indicatorColor.uiColor()
            let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
            let underlineAttributedString = NSAttributedString(string: "Передать показания", attributes: underlineAttribute)
            cell.sendCounter.attributedText = underlineAttributedString
            cell.teck.isHidden = true
            cell.diff.isHidden = true
            cell.teckLbl.isHidden = true
            cell.diffLbl.isHidden = true
            cell.lblHeight2.constant = 0
            cell.lblHeight3.constant = 0
            cell.lblHeight5.constant = 0
            cell.lblHeight6.constant = 0
        }
        cell.imgCounter.image = UIImage(named: "water")
        if (countName.lowercased().range(of: "гвс") != nil){
            cell.viewImgCounter.backgroundColor = .red
        }
        if (countName.lowercased().range(of: "хвс") != nil) || (countName.lowercased().range(of: "хвc") != nil){
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
        if (countName.lowercased().range(of: "элект") != nil){
            cell.imgCounter.image = UIImage(named: "lamp")
            cell.viewImgCounter.backgroundColor = .yellow
        }
        if self.nextMonthLabel.isHidden == true{
//            if isEditable(){
                cell.sendCounter.isHidden = false
//            }else{
//                cell.sendCounter.isHidden = true
//            }
        }else{
            cell.sendCounter.isHidden = true
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
        }else{
            let alert = UIAlertController(title: "Ошибка", message: "Возможность передавать показания доступна с " + date1 + " по " + date2 + " числа текущего месяца!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        ls_Button.setTitle(contents, for: UIControlState.normal)
        if (contents == "Все") {
            choiceIdent = ""
            sendedArr.removeAll()
            updateTable()
        } else {
            choiceIdent = contents
            getData(ident: contents)
        }
    }
    
    func updateTable() {
        tableCounters.reloadData()
        updateArrowsEnabled()
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
    
    func StartIndicator(){
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }

}
