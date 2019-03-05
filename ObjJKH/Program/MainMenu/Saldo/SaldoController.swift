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
import Gloss

class SaldoController: UIViewController, DropperDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var btnPdf: UIButton!
    @IBOutlet weak var can_btn_pay: NSLayoutConstraint!
    @IBOutlet weak var LsLbl: UILabel!
    @IBOutlet weak var spinImg: UIImageView!
    
    @IBOutlet weak var addLs: UILabel!
    @IBOutlet weak var lsView: UIView!
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pdfClick(_ sender: UIButton) {
        let str_ls = UserDefaults.standard.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        if ls_button.titleLabel?.text == "Все" && (str_ls_arr?.count)! > 1{
            let alert = UIAlertController(title: "", message: "Выберите лицевой счёт", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.performSegue(withIdentifier: "openURL", sender: self)
    }
    
    @IBAction func updateConect(_ sender: UIButton) {
        self.viewDidLoad()
    }
    @IBOutlet weak var updateConectBtn: UIButton!
    @IBOutlet weak var nonConectView: UIView!
    
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
    var fileList: [File] = []
    var link: String = ""
    
    // название месяца для вывода в шапку
    var name_month: String = "";
    
    // Индекс сроки для группировки
    var selectedRow = -5;
    
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var tableOSV: UITableView!
    @IBOutlet weak var ls_button: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var prevMonthLabel: UILabel!
    @IBOutlet weak var nextMonthLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rigthButton: UIButton!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController<Saldo>?
    
    // Общие итоги
    var obj_col: Int = 0
    var obj_start: Double = 0
    var obj_plus: Double = 0
    var obj_minus: Double = 0
    var obj_end: Double = 0
    
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
        
        if choiceIdent == ""{
            updateFetchedResultsController()
            updateMonthLabel()
            updateTable()
            updateArrowsEnabled()
        }else{
            let ident = choiceIdent
            updateMonthLabel()
            getData(ident: ident)
            updateArrowsEnabled()
        }
    }
    
    @IBAction func PayBtnAction(_ sender: UIButton) {
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "paysMytishi", sender: self)
        #elseif isKlimovsk12
        self.performSegue(withIdentifier: "paysMytishi", sender: self)
        #else
        self.performSegue(withIdentifier: "pays", sender: self)
        #endif
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        #if isMupRCMytishi
        if segue.identifier == "paysMytishi" {
            let nav = segue.destination as! UINavigationController
            let payController             = nav.topViewController as! PaysMytishiController
            if choiceIdent == ""{
                payController.saldoIdent = "Все"
            }else{
                payController.saldoIdent = choiceIdent
            }
        }
        if segue.identifier == "openURL" {
            let payController             = segue.destination as! openSaldoController
            payController.urlLink = self.link
        }
        #else
        if segue.identifier == "pays" {
            let nav = segue.destination as! UINavigationController
            let payController             = nav.topViewController as! PaysController
            if choiceIdent == ""{
                payController.saldoIdent = "Все"
            }else{
                payController.saldoIdent = choiceIdent
            }
        }
        #endif
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
        if choiceIdent == ""{
            updateFetchedResultsController()
            updateMonthLabel()
            updateTable()
            updateArrowsEnabled()
        }else{
            let ident = choiceIdent
            updateMonthLabel()
            getData(ident: ident)
            updateArrowsEnabled()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Получим данные из глобальных сохраненных
        let defaults     = UserDefaults.standard
        currYear         = defaults.string(forKey: "year_osv")!
        currMonth        = defaults.string(forKey: "month_osv")!
        nonConectView.isHidden = true
        lsView.isHidden = true
        LsLbl.isHidden = false
        ls_button.isHidden = false
        monthLabel.isHidden = false
        monthView.isHidden = false
        tableOSV.isHidden = false
        spinImg.isHidden = false
        btnPay.isHidden = false
        iterMonth = currMonth
        iterYear = currYear
        btnPdf.isHidden = true
        
        // Заполним лиц. счетами отбор
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        
        // Логин и пароль
        login = defaults.string(forKey: "login")
        pass  = defaults.string(forKey: "pass")
        
        dropper.delegate = self
        dropper.items.append("Все")
        
        if ((str_ls_arr?.count)! > 0) && str_ls_arr![0] != ""{
            for i in 0..<(str_ls_arr?.count ?? 1 - 1) {
                dropper.items.append((str_ls_arr?[i])!)
            }
            lsView.isHidden = true
        }else{
            addLs.textColor = myColors.btnColor.uiColor()
            let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
            let underlineAttributedString = NSAttributedString(string: "Подключить лицевой счет", attributes: underlineAttribute)
            addLs.attributedText = underlineAttributedString
            let tap = UITapGestureRecognizer(target: self, action: #selector(lblTapped(_:)))
            addLs.isUserInteractionEnabled = true
            addLs.addGestureRecognizer(tap)
            lsView.isHidden = false
            LsLbl.isHidden = true
            ls_button.isHidden = true
            monthLabel.isHidden = true
            monthView.isHidden = true
            tableOSV.isHidden = true
            spinImg.isHidden = true
            btnPay.isHidden = true
        }
        
        dropper.showWithAnimation(0.001, options: Dropper.Alignment.center, button: ls_button)
        dropper.hideWithAnimation(0.001)
        
        // Установим значения текущие (если нет данных вообще)
        minMonth = iterMonth
        minYear = iterYear
        maxMonth = iterMonth
        maxYear = iterYear
        
        tableOSV.delegate = self
        tableOSV.dataSource = self
        
        updateBorderDates()
        updateFetchedResultsController()
        updateMonthLabel()
        updateTable()
        updateArrowsEnabled()
        
//        getData(login: login!, pass: pass!)
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        btnPdf.tintColor = myColors.btnColor.uiColor()
        btnPay.backgroundColor = myColors.btnColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        updateConectBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        let titles = Titles()
        self.title = titles.getTitle(numb: "5")
        #if isOur_Obj_Home
            btnPay.isHidden = true
            can_btn_pay.constant = 0
        #endif
        #if isMupRCMytishi
        //получение файлов
//        getPaysFile()
        #else
        btnPdf.isHidden = true
        #endif
        #if isUKKomfort
            btnPay.isHidden = true
            can_btn_pay.constant = 0
        #endif
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
            LsLbl.isHidden = true
            ls_button.isHidden = true
            monthLabel.isHidden = true
            monthView.isHidden = true
            tableOSV.isHidden = true
            spinImg.isHidden = true
            btnPay.isHidden = true
        case .wifi: break
            
        case .wwan: break
            
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
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
        self.updateFetchedResultsController()
    }
    
    var uslugaArr  :[String] = []
    var plusArr    :[String] = []
    var startArr   :[String] = []
    var minusArr   :[String] = []
    var endArr     :[String] = []
    
    func getData(ident: String){
        uslugaArr.removeAll()
        plusArr.removeAll()
        startArr.removeAll()
        minusArr.removeAll()
        endArr.removeAll()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Saldo")
        fetchRequest.predicate = NSPredicate.init(format: "num_month = %@ AND year = %@", String(self.iterMonth), String(self.iterYear))
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results {
                let object = result as! NSManagedObject
                #if isMupRCMytishi
                if ident != "Все"{
                    print("=\(object.value(forKey: "ident") as! String)", " =\(object.value(forKey: "usluga") as! String)")
                    if (object.value(forKey: "ident") as! String) == ident{
                        if (object.value(forKey: "usluga") as! String) == "Услуги ЖКУ"{
                            uslugaArr.append(object.value(forKey: "usluga") as! String)
                            plusArr.append(object.value(forKey: "plus") as! String)
                            startArr.append(object.value(forKey: "start") as! String)
                            minusArr.append(object.value(forKey: "minus") as! String)
                            endArr.append(object.value(forKey: "end") as! String)
                        }
                    }
                }else{
                    if (object.value(forKey: "usluga") as! String) == "Услуги ЖКУ"{
                        uslugaArr.append(object.value(forKey: "usluga") as! String)
                        plusArr.append(object.value(forKey: "plus") as! String)
                        startArr.append(object.value(forKey: "start") as! String)
                        minusArr.append(object.value(forKey: "minus") as! String)
                        endArr.append(object.value(forKey: "end") as! String)
                    }
                }
                #else
                if ident != "Все"{
                    if (object.value(forKey: "ident") as! String) == ident{
                        uslugaArr.append(object.value(forKey: "usluga") as! String)
                        plusArr.append(object.value(forKey: "plus") as! String)
                        startArr.append(object.value(forKey: "start") as! String)
                        minusArr.append(object.value(forKey: "minus") as! String)
                        endArr.append(object.value(forKey: "end") as! String)
                    }
                }
                #endif
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
        fetchedResultsController = CoreDataManager.instance.fetchedResultsControllerSaldo(entityName: "Saldo", keysForSort: ["usluga"], predicateFormat: predicateFormat) as NSFetchedResultsController<Saldo>
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        self.updateMonthLabel()
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
        #if isMupRCMytishi
        //получение файлов
//        var i = 0
//        fileList.forEach{
//            if String($0.month) == iterMonth && String($0.year) == iterYear && $0.link.contains(".pdf"){
//                self.link = $0.link
//                self.btnPdf.isHidden = false
//                i = 1
//            }else{
//                if i == 0{
//                    self.btnPdf.isHidden = true
//                }
//            }
//        }
        getData(ident: "Все")
        #else
        self.updateTable()
        #endif
    }
    
    func updateTable() {
        tableOSV.reloadData()
        self.updateArrowsEnabled()
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
        if choiceIdent == ""{
            #if isMupRCMytishi
            if uslugaArr.count != 0 {
                return uslugaArr.count
            } else {
                return 0
            }
            #else
            if let sections = fetchedResultsController?.sections {
                return sections[section].numberOfObjects
            } else {
                return 0
            }
            #endif
        }else{
            if uslugaArr.count != 0 {
                return uslugaArr.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableOSV.dequeueReusableCell(withIdentifier: "Cell") as! SaldoCell
        if choiceIdent == ""{
            #if isMupRCMytishi
            if (uslugaArr[indexPath.row] == "Я") {
                cell.usluga.text = "ИТОГО"
            } else {
                cell.usluga.text = uslugaArr[indexPath.row]
            }
            cell.start.text  = plusArr[indexPath.row]
            cell.plus.text   = startArr[indexPath.row]
            cell.minus.text  = minusArr[indexPath.row]
            cell.end.text    = endArr[indexPath.row]
            cell.totalSum.text = "Итого к оплате"
            cell.pays.isHidden = true
            cell.minus.isHidden = true
            cell.lblHeight1.constant = 8
            cell.lblHeight2.constant = 8
            #else
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
            #endif
        }else{
            if (uslugaArr[indexPath.row] == "Я") {
                cell.usluga.text = "ИТОГО"
            } else {
                cell.usluga.text = uslugaArr[indexPath.row]
            }
            cell.start.text  = plusArr[indexPath.row]
            cell.plus.text   = startArr[indexPath.row]
            cell.minus.text  = minusArr[indexPath.row]
            cell.end.text    = endArr[indexPath.row]
        }
        
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
    var choiceIdent = ""
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        ls_button.setTitle(contents, for: UIControlState.normal)
        if (contents == "Все")  || dropper.items.count == 2{
            choiceIdent = ""
            #if isMupRCMytishi
            choiceIdent = "Все"
            getData(ident: contents)
            #else
            updateTable()
            #endif
        } else {
            choiceIdent = contents
            
            //получение файлов
//            #if isMupRCMytishi
//            var k = 0
//            fileList.forEach{
//                if String($0.month) == iterMonth && String($0.year) == iterYear && $0.ident == choiceIdent && $0.link.contains(".pdf"){
//                    self.link = $0.link
//                    self.btnPdf.isHidden = false
//                    k = 1
//                }else{
//                    if k == 0{
//                        self.btnPdf.isHidden = true
//                    }
//                }
//            }
//            #endif
            getData(ident: contents)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
//        getData(login: login!, pass: pass!)
    }
    
    func getPaysFile() {
        let login = self.login
        let pass = self.pass
        let urlPath = Server.SERVER + Server.GET_BILLS_FILE + "login=" + login!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, error, responce in
//                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//                                                print("responseString = \(responseString)")
                                                
                                                guard data != nil else { return }
                                                let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                                                if json != nil{
                                                    let unfilteredData = PaysFileJson(json: json! as! JSON)?.data
                                                    unfilteredData?.forEach { json in
                                                        let ident = json.ident
                                                        let year = json.year
                                                        let month = json.month
                                                        let link = json.link
                                                        var i = 0
                                                        if self.currYear == String(json.year!) && self.currMonth == String(json.month!) && (json.link?.contains(".pdf"))!{
                                                            print(String(json.year!), String(json.month!))
                                                            self.link = json.link!
                                                            DispatchQueue.main.async {
                                                                self.btnPdf.isHidden = false
                                                            }
                                                            i = 1
                                                        }else{
                                                            if i == 0{
                                                                DispatchQueue.main.async {
                                                                    self.btnPdf.isHidden = true
                                                                }
                                                            }                                                    }
                                                        let fileObj = File(month: month!, year: year!, ident: ident!, link: link!)
                                                        self.fileList.append(fileObj)
                                                    }
                                                }
                                                
        })
        task.resume()
    }
}

class PayMupSaldoCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var usluga: UILabel!
    @IBOutlet weak var endL: UILabel!
    @IBOutlet weak var end: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

struct PaysFileJson: JSONDecodable {
    
    let data: [PaysFileJsonData]?
    
    init?(json: JSON) {
        data = "data" <~~ json
    }
    
}

struct PaysFileJsonData: JSONDecodable {
    
    let month:Int?
    let year:Int?
    let ident:String?
    let link:String?
    
    init?(json: JSON) {
        month    = "Month"   <~~ json
        year     = "Year"    <~~ json
        ident    = "Ident"   <~~ json
        link     = "Link"    <~~ json
    }
}

class File {
    let month:Int
    let year:Int
    let ident:String
    let link:String
    
    init(month:Int,year:Int,ident:String,link:String) {
        self.month = month
        self.year = year
        self.ident = ident
        self.link = link
    }
}
