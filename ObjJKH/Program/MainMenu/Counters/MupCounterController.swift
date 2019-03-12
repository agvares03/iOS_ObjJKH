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

protocol CountersCellDelegate: class {
    func sendPressed(uniq_num: String, count_name: String)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nonConectView.isHidden = true
        lsView.isHidden = false
        ls_lbl.isHidden = false
        ls_Button.isHidden = false
        monthLabel.isHidden = false
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
            print("parse failure!")
        }
        
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
    var ownerArr    :[String] = []
    
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
        ownerArr.removeAll()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Counters")
        fetchRequest.predicate = NSPredicate.init(format: "year <= %@", String(self.iterYear))
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            var uniq_num = ""
            var dateOne = ""
            var valueOne:Float = 0.00
            var dateTwo = ""
            var valueTwo:Float = 0.00
            var dateThree = ""
            var valueThree:Float = 0.00
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
                            dateOne = (object.value(forKey: "num_month") as! String)
                            valueOne = (object.value(forKey: "value") as! Float)
                            identk = (object.value(forKey: "ident") as! String)
                            count_name = (object.value(forKey: "count_name") as! String)
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            owner = (object.value(forKey: "owner") as! String)
                            unit_name = (object.value(forKey: "unit_name") as! String)
                            sended = (object.value(forKey: "sended") as! Bool)
                            i = 1
                        }else if i == 1 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                            dateTwo = (object.value(forKey: "num_month") as! String)
                            valueTwo = (object.value(forKey: "value") as! Float)
                            identk = (object.value(forKey: "ident") as! String)
                            count_name = (object.value(forKey: "count_name") as! String)
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            owner = (object.value(forKey: "owner") as! String)
                            unit_name = (object.value(forKey: "unit_name") as! String)
                            sended = (object.value(forKey: "sended") as! Bool)
                            i = 2
                        }else if i == 2 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                            dateThree = (object.value(forKey: "num_month") as! String)
                            valueThree = (object.value(forKey: "value") as! Float)
                            identArr.append(object.value(forKey: "ident") as! String)
                            nameArr.append(object.value(forKey: "count_name") as! String)
                            numberArr.append(object.value(forKey: "uniq_num") as! String)
                            ownerArr.append(object.value(forKey: "owner") as! String)
                            predArr.append(valueOne)
                            teckArr.append(valueTwo)
                            diffArr.append(valueThree)
                            dateOneArr.append(dateOne)
                            dateTwoArr.append(dateTwo)
                            dateThreeArr.append(dateThree)
                            unitArr.append(object.value(forKey: "unit_name") as! String)
                            sendedArr.append(object.value(forKey: "sended") as! Bool)
                            uniq_num = ""
                            dateOne = ""
                            valueOne = 0.00
                            dateTwo = ""
                            valueTwo = 0.00
                            dateThree = ""
                            valueThree = 0.00
                            count_name = ""
                            owner = ""
                            unit_name = ""
                            sended = true
                            identk = ""
                            i = 0
                        }else if uniq_num != (object.value(forKey: "uniq_num") as! String){
                            i = 1
                            identArr.append(identk)
                            nameArr.append(count_name)
                            numberArr.append(uniq_num)
                            ownerArr.append(owner)
                            predArr.append(valueOne)
                            teckArr.append(valueTwo)
                            diffArr.append(valueThree)
                            dateOneArr.append(dateOne)
                            dateTwoArr.append(dateTwo)
                            dateThreeArr.append(dateThree)
                            unitArr.append(unit_name)
                            sendedArr.append(sended)
                            
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            dateOne = (object.value(forKey: "num_month") as! String)
                            valueOne = (object.value(forKey: "value") as! Float)
                            identk = (object.value(forKey: "ident") as! String)
                            count_name = (object.value(forKey: "count_name") as! String)
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            owner = (object.value(forKey: "owner") as! String)
                            unit_name = (object.value(forKey: "unit_name") as! String)
                            sended = (object.value(forKey: "sended") as! Bool)
                            
                            dateTwo = ""
                            valueTwo = 0.00
                            dateThree = ""
                            valueThree = 0.00
                        }
                    }
                }else{
                    if i == 0{
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        dateOne = (object.value(forKey: "num_month") as! String)
                        valueOne = (object.value(forKey: "value") as! Float)
                        identk = (object.value(forKey: "ident") as! String)
                        count_name = (object.value(forKey: "count_name") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        owner = (object.value(forKey: "owner") as! String)
                        unit_name = (object.value(forKey: "unit_name") as! String)
                        sended = (object.value(forKey: "sended") as! Bool)
                        i = 1
                    }else if i == 1 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                        dateTwo = (object.value(forKey: "num_month") as! String)
                        valueTwo = (object.value(forKey: "value") as! Float)
                        identk = (object.value(forKey: "ident") as! String)
                        count_name = (object.value(forKey: "count_name") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        owner = (object.value(forKey: "owner") as! String)
                        unit_name = (object.value(forKey: "unit_name") as! String)
                        sended = (object.value(forKey: "sended") as! Bool)
                        i = 2
                    }else if i == 2 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                        dateThree = (object.value(forKey: "num_month") as! String)
                        valueThree = (object.value(forKey: "value") as! Float)
                        identArr.append(object.value(forKey: "ident") as! String)
                        nameArr.append(object.value(forKey: "count_name") as! String)
                        numberArr.append(object.value(forKey: "uniq_num") as! String)
                        ownerArr.append(object.value(forKey: "owner") as! String)
                        predArr.append(valueOne)
                        teckArr.append(valueTwo)
                        diffArr.append(valueThree)
                        dateOneArr.append(dateOne)
                        dateTwoArr.append(dateTwo)
                        dateThreeArr.append(dateThree)
                        unitArr.append(object.value(forKey: "unit_name") as! String)
                        sendedArr.append(object.value(forKey: "sended") as! Bool)
                        uniq_num = ""
                        dateOne = ""
                        valueOne = 0.00
                        dateTwo = ""
                        valueTwo = 0.00
                        dateThree = ""
                        valueThree = 0.00
                        count_name = ""
                        owner = ""
                        unit_name = ""
                        sended = true
                        identk = ""
                        i = 0
                    }else if uniq_num != (object.value(forKey: "uniq_num") as! String){
                        i = 1
                        identArr.append(identk)
                        nameArr.append(count_name)
                        numberArr.append(uniq_num)
                        ownerArr.append(owner)
                        predArr.append(valueOne)
                        teckArr.append(valueTwo)
                        diffArr.append(valueThree)
                        dateOneArr.append(dateOne)
                        dateTwoArr.append(dateTwo)
                        dateThreeArr.append(dateThree)
                        unitArr.append(unit_name)
                        sendedArr.append(sended)
                        
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        dateOne = (object.value(forKey: "num_month") as! String)
                        valueOne = (object.value(forKey: "value") as! Float)
                        identk = (object.value(forKey: "ident") as! String)
                        count_name = (object.value(forKey: "count_name") as! String)
                        uniq_num = (object.value(forKey: "uniq_num") as! String)
                        owner = (object.value(forKey: "owner") as! String)
                        unit_name = (object.value(forKey: "unit_name") as! String)
                        sended = (object.value(forKey: "sended") as! Bool)
                        
                        dateTwo = ""
                        valueTwo = 0.00
                        dateThree = ""
                        valueThree = 0.00
                    }
                }
                
            }
            if i == 2 || i == 1{
                identArr.append(identk)
                nameArr.append(count_name)
                numberArr.append(uniq_num)
                ownerArr.append(owner)
                predArr.append(valueOne)
                teckArr.append(valueTwo)
                diffArr.append(valueThree)
                dateOneArr.append(dateOne)
                dateTwoArr.append(dateTwo)
                dateThreeArr.append(dateThree)
                unitArr.append(unit_name)
                sendedArr.append(sended)
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
        cell.ident.text       = identArr[indexPath.row]
        cell.name.text        = nameArr[indexPath.row] + ", " + unitArr[indexPath.row]
        cell.number.text      = ownerArr[indexPath.row]
        countName             = nameArr[indexPath.row]
        cell.pred.text        = String(format:"%.2f", predArr[indexPath.row])
        cell.teck.text        = String(format:"%.2f", teckArr[indexPath.row])
        cell.diff.text        = String(format:"%.2f", diffArr[indexPath.row])
        cell.predLbl.text     = dateOneArr[indexPath.row]
        cell.teckLbl.text     = dateTwoArr[indexPath.row]
        cell.diffLbl.text     = dateThreeArr[indexPath.row]
        send = sendedArr[indexPath.row]
        cell.sendButton.backgroundColor = myColors.btnColor.uiColor()
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
        if dateTwoArr[indexPath.row] == ""{
            cell.lblHeight2.constant = 0
            cell.lblHeight5.constant = 0
        }else{
            cell.lblHeight2.constant = 16
            cell.lblHeight5.constant = 16
        }
        if dateThreeArr[indexPath.row] == ""{
            cell.lblHeight3.constant = 0
            cell.lblHeight6.constant = 0
        }else{
            cell.lblHeight3.constant = 16
            cell.lblHeight6.constant = 16
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        selectedUniq = numberArr[indexPath.row]
        selectedUniqName = nameArr[indexPath.row] + ", " + unitArr[indexPath.row]
        selectedOwner = ownerArr[indexPath.row]
        self.performSegue(withIdentifier: "uniqCounters", sender: self)
    }
    
    var selectedUniq = ""
    var selectedUniqName = ""
    var selectedOwner = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uniqCounters" {
            let payController             = segue.destination as! UniqCountersController
            payController.uniq_num = selectedUniq
            payController.uniq_name = selectedUniqName
            payController.owner = selectedOwner
            payController.ls = choiceIdent
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
        ls_Button.setTitle("Все", for: UIControlState.normal)
        choiceIdent = "Все"
        DB().del_db(table_name: "Counters")
        parse_Countrers(login: edLogin, pass: edPass)
    }
    
    func sendPressed(uniq_num: String, count_name: String) {
        print(isEditable())
        if isEditable(){
            let alert = UIAlertController(title: count_name + "(" + uniq_num + ")", message: "Введите текущие показания прибора", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in textField.placeholder = "Введите показание..."; textField.keyboardType = .numberPad })
            let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                var metrID = ""
                for i in 0...self.numberArr.count - 1{
                    if uniq_num == self.ownerArr[i]{
                        metrID = self.numberArr[i]
                    }
                }
                self.send_count(edLogin: self.edLogin, edPass: self.edPass, uniq_num: metrID, count: (alert.textFields?[0].text!)!)
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
            managedObject.value         = (attributeDict["Value"]! as NSString).floatValue
            managedObject.diff          = 6757.43
            if attributeDict["IsSended"] == "1"{
                managedObject.sended    = true
            }else{
                managedObject.sended    = false
            }
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

}

class MupCounterCell: UITableViewCell {
    
    var delegate: CountersCellDelegate?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var ident: UILabel!
    @IBOutlet weak var imgCounter: UIImageView!
    @IBOutlet weak var viewImgCounter: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var pred: UILabel!
    @IBOutlet weak var teck: UILabel!
    @IBOutlet weak var diff: UILabel!
    
    @IBOutlet weak var predLbl: UILabel!
    @IBOutlet weak var teckLbl: UILabel!
    @IBOutlet weak var diffLbl: UILabel!
    
    @IBOutlet weak var nonCounter: UILabel!
    @IBOutlet weak var sendCounter: UILabel!
    
    @IBOutlet weak var lblHeight1: NSLayoutConstraint!
    @IBOutlet weak var lblHeight2: NSLayoutConstraint!
    @IBOutlet weak var lblHeight3: NSLayoutConstraint!
    @IBOutlet weak var lblHeight4: NSLayoutConstraint!
    @IBOutlet weak var lblHeight5: NSLayoutConstraint!
    @IBOutlet weak var lblHeight6: NSLayoutConstraint!
    
    @IBAction func sendAction(_ sender: UIButton) {
        delegate?.sendPressed(uniq_num: number.text!, count_name: name.text!)
        print("SEND")
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
