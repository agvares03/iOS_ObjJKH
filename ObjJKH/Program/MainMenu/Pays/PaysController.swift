//
//  PaysController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 30.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Dropper
import CoreData

private protocol MainDataProtocol:  class {}

class PaysController: UIViewController, DropperDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var servicePay: UILabel!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var historyPay: UIButton!
    @IBOutlet weak var sendView: UIView!
    
    var fetchedResultsController: NSFetchedResultsController<Saldo>?
    var iterYear: String = "0"
    var iterMonth: String = "0"
    
    var sum: Double = 0
    var totalSum: Double = 0
    var selectedRow = 0
    var checkBox:[Bool] = []
    var sumOSV:[Double] = []
    var osvc:[String] = []
    
    var login: String?
    var pass: String?
    var currPoint = CGFloat()
    let dropper = Dropper(width: 150, height: 400)
    
    
    @IBOutlet weak var ls_button: UIButton!
    @IBOutlet weak var txt_sum_jkh: UILabel!
    @IBOutlet weak var txt_sum_obj: UITextField!
    
    @IBAction func choice_ls_button(_ sender: UIButton) {
        if dropper.status == .hidden {
            
            dropper.theme = Dropper.Themes.white
            //            dropper.cornerRadius = 3
            dropper.showWithAnimation(0.15, options: Dropper.Alignment.center, button: ls_button)
            view.addSubview(dropper)
        } else {
            dropper.hideWithAnimation(0.1)
        }
    }
    var items:[Any] = []
    
    // Нажатие в оплату
    @IBAction func Payed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "mail")! == "" || defaults.string(forKey: "mail")! == "-"{
            let alert = UIAlertController(title: "Ошибка", message: "Укажите e-mail", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "e-mail..."
            }
            let cancelAction = UIAlertAction(title: "Сохранить", style: .default) { (_) -> Void in
                let textField = alert.textFields![0]
                let str = textField.text
                if ((str?.contains("@"))! && (str?.contains(".ru"))!) || ((str?.contains("@"))! && (str?.contains(".com"))!){
                    UserDefaults.standard.set(str, forKey: "mail")
                    self.payed()
                }else{
                    textField.text = ""
                    textField.placeholder = "e-mail..."
                    let alert = UIAlertController(title: "Ошибка", message: "Укажите корректный e-mail!", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            payed()
        }
    }
    
    func payed(){
        let k:String = txt_sum_jkh.text!
        self.totalSum = Double(k.replacingOccurrences(of: " .руб", with: ""))!
        if (self.totalSum <= 0) {
            let alert = UIAlertController(title: "Ошибка", message: "Нет суммы к оплате", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            #if isMupRCMytishi
            items.removeAll()
            var sum = 0.00
            sumOSV.forEach{
                sum = sum + $0
            }
            var sumO:[Double] = []
            let servicePay = totalSum - self.sum
            //            if sum + servicePay != self.totalSum{
            for i in 0...sumOSV.count - 1{
                let p = sumOSV[i] * 100 / (sum)
                sumO.append(self.sum * p / 100)
            }
            //            }
            var i = 0
            checkBox.forEach{
                if $0 == true && sumO[i] > 0.00{
                    let ItemsData = ["Name" : osvc[i], "Price" : Int(sumO[i] * 100), "Quantity" : Double(1.00), "Amount" : Int(sumO[i] * 100), "Tax" : "none"] as [String : Any]
                    items.append(ItemsData)
                }
                i += 1
            }
            let ItemsData = ["Name" : "Сервисный сбор", "Price" : Int(servicePay * 100), "Quantity" : Double(1.00), "Amount" : Int(servicePay * 100), "Tax" : "none"] as [String : Any]
            items.append(ItemsData)
            var Data:[String:String] = [:]
            if selectLS == "Все"{
                let str_ls = UserDefaults.standard.string(forKey: "str_ls")!
                let str_ls_arr = str_ls.components(separatedBy: ",")
                for i in 0...str_ls_arr.count - 1{
                    Data["ls\(i + 1)"] = str_ls_arr[0]
                }
            }else{
                Data["ls1"] = selectLS
            }
            let defaults = UserDefaults.standard
            let receiptData = ["Items" : items, "Email" : defaults.string(forKey: "mail")!, "Phone" : defaults.object(forKey: "login")! as? String ?? "", "Taxation" : "osn"] as [String : Any]
            let name = "Оплата услуг ЖКХ"
            let amount = NSNumber(floatLiteral: self.totalSum)
            
            print(receiptData)
            PayController.buyItem(withName: name, description: nil, amount: amount, recurrent: false, makeCharge: false, additionalPaymentData: Data, receiptData: receiptData, email: defaults.object(forKey: "mail")! as? String, from: self, success: { (paymentInfo) in
                
            }, cancelled: {
                
            }) { (error) in
                let alert = UIAlertController(title: "Ошибка", message: "Сервер оплаты не отвечает. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            #else
            let defaults = UserDefaults.standard
            defaults.setValue(String(describing: self.sum), forKey: "sum")
            defaults.synchronize()
            self.performSegue(withIdentifier: "CostPay_New", sender: self)
            #endif
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currPoint = sendView.frame.origin.y
        let defaults     = UserDefaults.standard
        // Логин и пароль
        login = defaults.string(forKey: "login")
        pass  = defaults.string(forKey: "pass")
        
        // Заполним тек. год и тек. месяц
        iterYear         = defaults.string(forKey: "year_osv")!
        iterMonth        = defaults.string(forKey: "month_osv")!
        
        // Заполним лиц. счетами отбор
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        tableView.delegate = self
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        dropper.delegate = self
        dropper.items.append("Все")
        if ((str_ls_arr?.count)! > 0) {
            for i in 0..<(str_ls_arr?.count ?? 1 - 1) {
                dropper.items.append((str_ls_arr?[i])!)
            }
        }
        selectLS = "Все"
        dropper.showWithAnimation(0.001, options: Dropper.Alignment.center, button: ls_button)
        dropper.hideWithAnimation(0.001)
        
        getSum(login: login!, pass: pass!)
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        btnPay.backgroundColor = myColors.btnColor.uiColor()
        historyPay.backgroundColor = myColors.btnColor.uiColor()
        viewTop.constant = getPoint()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        sendView.isUserInteractionEnabled = true
        sendView.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectLS = ""
    
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        ls_button.setTitle(contents, for: UIControlState.normal)
        self.sum = 0
        if (contents == "Все") {
            selectLS = "Все"
            getSum(login: login!, pass: pass!)
        } else {
            selectLS = contents
            getSum(login: contents, pass: pass!)
        }
    }
    
    func getSum(login: String, pass: String) {
        // Экземпляр класса DB
        let db = DB()
        // Удалим данные из базы данных
        db.del_db(table_name: "Saldo")
        // Получим данные в базу данных
        parse_OSV(login: login, pass: pass)
        
    }
    
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
        
        let managedObject = Saldo()
        managedObject.id               = 1
        managedObject.usluga           = usluga
        managedObject.num_month        = num_month
        managedObject.year             = year
        managedObject.start            = start
        managedObject.plus             = plus
        managedObject.minus            = minus
        managedObject.end              = end
        CoreDataManager.instance.saveContext()
    }
    
    func end_osv() {
        self.sum = 0
        select = false
        checkBox.removeAll()
        sumOSV.removeAll()
        osvc.removeAll()
        var endSum = 0.00
        // Выборка из БД последней ведомости - посчитаем сумму к оплате
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Saldo")
        fetchRequest.predicate = NSPredicate.init(format: "num_month = %@ AND year = %@", String(self.iterMonth), String(self.iterYear))
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results {
                let object = result as! NSManagedObject
//                #if isMupRCMytishi
//                if (object.value(forKey: "usluga") as! String) == "Услуги ЖКУ"{
//                    osvc.append(object.value(forKey: "usluga") as! String)
//                    self.sum = self.sum + Double(object.value(forKey: "end") as! String)!
//                    sumOSV.append(Double(object.value(forKey: "end") as! String)!)
//                }
//                #else
                self.sum = self.sum + Double(object.value(forKey: "end") as! String)!
                endSum = Double(object.value(forKey: "end") as! String)!
//                #endif
            }
            self.sum = self.sum - endSum
            DispatchQueue.main.async(execute: {
                if (self.sum != 0) {
                    //                    self.txt_sum_jkh.text = String(format:"%.2f", self.sum) + " р."
                    let serviceP = self.sum / 0.992 - self.sum
                    self.servicePay.text  = String(format:"%.2f", serviceP) + " .руб"
                    self.totalSum = self.sum + serviceP
                    self.txt_sum_obj.text = String(format:"%.2f", self.sum)
                    self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " .руб"
                    
                } else {
                    //                    self.txt_sum_jkh.text = "0,00 р."
                    self.txt_sum_obj.text = "0,00"
                    self.txt_sum_jkh.text = "0,00 .руб"
                    self.servicePay.text  = "0,00 .руб"
                }
                self.updateFetchedResultsController()
                self.updateTable()
                
            })
            
        } catch {
            print(error)
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
    
    func updateTable() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        #if isMupRCMytishi
//        return osvc.count
//        #else
        if let sections = fetchedResultsController?.sections {
            return sections[section].numberOfObjects - 1
        } else {
            return 0
        }
//        #endif
    }
    
    var select = false
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        #if isMupRCMytishi
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PayCell") as! PaySaldoCell
//        if select == false{
//            cell.check.setImage(UIImage(named: "Check.png"), for: .normal)
//        }else{
//            if checkBox[selectedRow]{
//                cell.check.setImage(UIImage(named: "unCheck.png"), for: .normal)
//                checkBox[selectedRow] = false
//            }else{
//                cell.check.setImage(UIImage(named: "Check.png"), for: .normal)
//                checkBox[selectedRow] = true
//            }
//        }
//        cell.check.tintColor = myColors.btnColor.uiColor()
//        cell.check.backgroundColor = .white
//        if select == false{
//            checkBox.append(true)
//        }
//        cell.usluga.text = osvc[0]
//        cell.end.text    = String(sumOSV[0])
//
//        cell.delegate = self
//        select = false
//        #else
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayCell") as! PaySaldoCell
        let osv = fetchedResultsController!.object(at: indexPath)
        if select == false{
            cell.check.setImage(UIImage(named: "Check.png"), for: .normal)
        }else{
            if checkBox[selectedRow]{
                cell.check.setImage(UIImage(named: "unCheck.png"), for: .normal)
                checkBox[selectedRow] = false
            }else{
                cell.check.setImage(UIImage(named: "Check.png"), for: .normal)
                checkBox[selectedRow] = true
            }
        }
        cell.check.tintColor = myColors.btnColor.uiColor()
        cell.check.backgroundColor = .white
        if select == false{
            let sum:String = osv.end!
            osvc.append(osv.usluga!)
            checkBox.append(true)
            sumOSV.append(Double(sum)!)
        }
        
        if (osv.usluga == "Я") {
            cell.usluga.text = "ИТОГО"
        } else {
            cell.usluga.text = osv.usluga
        }
        cell.end.text    = osv.end
        
        cell.delegate = self
        select = false
//        #endif
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        select = true
        tableView.reloadRows(at: [indexPath], with: .automatic)
        setSumm()
    }
    
    func setSumm(){
        var sum = 0.00
        for i in 0 ... sumOSV.count - 1 {
            if checkBox[i] == true{
                sum = sum + sumOSV[i]
            }
        }
        self.sum = sum
        let serviceP = self.sum / 0.992 - self.sum
        self.servicePay.text  = String(format:"%.2f", serviceP) + " .руб"
        self.totalSum = self.sum + serviceP
        self.txt_sum_obj.text = String(format:"%.2f", self.sum)
        self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " .руб"
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let str: String = textField.text!
        if str != ""{
            self.sum = Double(str)!
            let serviceP = self.sum / 0.992 - self.sum
            self.servicePay.text  = String(format:"%.2f", serviceP) + " .руб"
            self.totalSum = self.sum + serviceP
            self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " .руб"
        }else{
            self.sum = 0.00
            let serviceP = self.sum / 0.992 - self.sum
            self.servicePay.text  = String(format:"%.2f", serviceP) + " .руб"
            self.totalSum = self.sum + serviceP
            self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " .руб"
        }
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification?) {
        let viewHeight = view.frame.size.height
        if viewHeight == 667{
            viewTop.constant = getPoint() - 210
            return
            
        }else if viewHeight == 736{
            viewTop.constant = getPoint() - 220
            return
        }else if viewHeight == 568{
            viewTop.constant = getPoint() - 210
        }else{
            viewTop.constant = getPoint() - 240
        }
    }
    
    // И вниз при исчезновении
    @objc func keyboardWillHide(sender: NSNotification?) {
        viewTop.constant = getPoint()
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func getPoint() -> CGFloat {
        let viewHeight = view.frame.size.height
        if viewHeight == 568{
            return currPoint - 100
        }else if viewHeight == 736{
            return currPoint + 70
        } else if viewHeight == 667{
            return currPoint
        }else {
            return currPoint + 90
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Подхватываем показ клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        txt_sum_obj.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        txt_sum_obj.removeTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
}

class PaySaldoCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var usluga: UILabel!
    @IBOutlet weak var end: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.end.adjustsFontSizeToFitWidth = true
    }
    
    func display(_ item: Web_Camera_json) {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.end.text = nil
        self.usluga.text = nil
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
