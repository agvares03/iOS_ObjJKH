//
//  NewMainMenu.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 14/03/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import Gloss
import CoreData
import SwiftyXMLParser

protocol DebtCellDelegate: class {
    func goPaysPressed(ident: String)
}
protocol DelLSCellDelegate: class {
    func try_del_ls_from_acc(ls: String)
}

class NewHomePage: UIViewController, UITableViewDelegate, UITableViewDataSource, QuestionTableDelegate, CountersCellDelegate, DebtCellDelegate, DelLSCellDelegate {
    
    
    @IBOutlet weak var newsIndicator: UIActivityIndicatorView!
    @IBOutlet weak var appsIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webIndicator: UIActivityIndicatorView!
    @IBOutlet weak var serviceIndicator: UIActivityIndicatorView!
    @IBOutlet weak var questionIndicator: UIActivityIndicatorView!
    @IBOutlet weak var counterIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var fon_top: UIImageView!
    @IBOutlet weak var elipseBackground: UIView!
    
    @IBOutlet weak var ls_View: UIView!
    @IBOutlet weak var news_View: UIView!
    @IBOutlet weak var counters_View: UIView!
    @IBOutlet weak var apps_View: UIView!
    @IBOutlet weak var questions_View: UIView!
    @IBOutlet weak var webs_View: UIView!
    @IBOutlet weak var services_View: UIView!
    
    @IBOutlet weak var btn_Add_LS: UIButton!
    
    @IBOutlet weak var tableLS: UITableView!
    @IBOutlet weak var tableLSHeight: NSLayoutConstraint!
    @IBOutlet weak var tableNews: UITableView!
    @IBOutlet weak var tableNewsHeight: NSLayoutConstraint!
    @IBOutlet weak var tableCounter: UITableView!
    @IBOutlet weak var tableCounterHeight: NSLayoutConstraint!
    @IBOutlet weak var tableApps: UITableView!
    @IBOutlet weak var tableAppsHeight: NSLayoutConstraint!
    @IBOutlet weak var tableQuestion: UITableView!
    @IBOutlet weak var tableQuestionHeight: NSLayoutConstraint!
    @IBOutlet weak var tableWeb: UITableView!
    @IBOutlet weak var tableWebHeight: NSLayoutConstraint!
    @IBOutlet weak var tableService: UITableView!
    @IBOutlet weak var tableServiceHeight: NSLayoutConstraint!
    
    @IBOutlet weak var newsHeight: NSLayoutConstraint!
    @IBOutlet weak var counterHeight: NSLayoutConstraint!
    @IBOutlet weak var appsHeight: NSLayoutConstraint!
    @IBOutlet weak var questionLSHeight: NSLayoutConstraint!
    @IBOutlet weak var webLSHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceHeight: NSLayoutConstraint!
    
    @IBOutlet weak var can_count_label: UILabel!
    @IBOutlet weak var canCountHeight: NSLayoutConstraint!
    
    @IBOutlet weak var menu_1_const: NSLayoutConstraint!
    @IBOutlet weak var menu_2_const: NSLayoutConstraint!
    @IBOutlet weak var menu_3_const: NSLayoutConstraint!
    @IBOutlet weak var menu_4_const: NSLayoutConstraint!
    @IBOutlet weak var menu_5_const: NSLayoutConstraint!
    @IBOutlet weak var menu_6_const: NSLayoutConstraint!
    
    // Размеры для настройки меню
    // Звонок диспетчеру
    @IBOutlet weak var callBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var callBtnImg: UIImageView!
    // Письмо в техподдержку
    @IBOutlet weak var suppBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var suppBtn: UIButton!
    @IBOutlet weak var suppBtnImg: UIImageView!
    
    @IBOutlet weak var targetName: UILabel!
    
    @IBOutlet weak var allNewsBtn: UIButton!
    @IBOutlet weak var allLSBtn: UIButton!
    @IBOutlet weak var allCountersBtn: UIButton!
    @IBOutlet weak var allAppsBtn: UIButton!
    @IBOutlet weak var allQuestionsBtn: UIButton!
    @IBOutlet weak var allWebsBtn: UIButton!
    @IBOutlet weak var allServicesBtn: UIButton!
    
    var phone: String?
    var fetchedResultsController: NSFetchedResultsController<Applications>?
    
    @IBAction func goNewsAction(_ sender: UIButton) {
        self.newsIndicator.startAnimating()
        self.newsIndicator.isHidden = false
        self.allNewsBtn.isHidden = true
    }
    @IBAction func goAppsAction(_ sender: UIButton) {
        self.appsIndicator.startAnimating()
        self.appsIndicator.isHidden = false
        self.allAppsBtn.isHidden = true
    }
    @IBAction func goCounterAction(_ sender: UIButton) {
        self.counterIndicator.startAnimating()
        self.counterIndicator.isHidden = false
        self.allCountersBtn.isHidden = true
    }
    @IBAction func goQuestionAction(_ sender: UIButton) {
        self.questionIndicator.startAnimating()
        self.questionIndicator.isHidden = false
        self.allQuestionsBtn.isHidden = true
    }
    @IBAction func goWebAction(_ sender: UIButton) {
        self.webIndicator.startAnimating()
        self.webIndicator.isHidden = false
        self.allWebsBtn.isHidden = true
    }
    @IBAction func goServiceAction(_ sender: UIButton) {
        self.serviceIndicator.startAnimating()
        self.serviceIndicator.isHidden = false
        self.allServicesBtn.isHidden = true
    }
    
    @IBAction func AddLS(_ sender: UIButton) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "addLS_Mup", sender: self)
        #else
        self.performSegue(withIdentifier: "addLS", sender: self)
        #endif
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
                urlPath = urlPath + "phone=" + phone! + "&ident=" + ident
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
                                                        
                                                        self.getDebt()
                })
                task.resume()
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    var currYear: String = ""
    var currMonth: String = ""
    
    @IBAction func phone_operator(_ sender: UIButton) {
        let newPhone = UserDefaults.standard.string(forKey: "phone_operator")!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        if let url = URL(string: "tel://" + newPhone) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StopIndicators()
        let defaults = UserDefaults.standard
        var phone = defaults.string(forKey: "phone_operator")
        if phone?.first == "8"{
            phone?.removeFirst()
            phone = "+7" + phone!
        }
        var phoneOperator = ""
        if !(phone?.contains(")"))! && phone != ""{
            for i in 0...11{
                if i == 2{
                    phoneOperator = phoneOperator + " (" + String(phone!.first!)
                }else if i == 5{
                    phoneOperator = phoneOperator + ") " + String(phone!.first!)
                }else if i == 8{
                    phoneOperator = phoneOperator + "-" + String(phone!.first!)
                }else if i == 10{
                    phoneOperator = phoneOperator + "-" + String(phone!.first!)
                }else{
                    phoneOperator = phoneOperator + String(phone!.first!)
                }
                phone?.removeFirst()
            }
        }else{
            phoneOperator = phone!
        }
        callBtn.setTitle(phoneOperator, for: .normal)
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
        if (date1 == "0") && (date2 == "0") {
            can_count_label.text = "Возможность передавать показания доступна в текущем месяце!"
        } else {
            can_count_label.text = "Возможность передавать показания доступна с " + date1 + " по " + date2 + " числа текущего месяца!"
        }
        tableLS.delegate = self
        tableLS.dataSource = self
        tableNews.delegate = self
        tableNews.dataSource = self
        tableCounter.delegate = self
        tableCounter.dataSource = self
        tableApps.delegate = self
        tableApps.dataSource = self
        tableQuestion.delegate = self
        tableQuestion.dataSource = self
        tableWeb.delegate = self
        tableWeb.dataSource = self
        tableService.delegate = self
        tableService.dataSource = self
        
        targetName.text = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String)
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
        #endif
        UITabBar.appearance().tintColor = myColors.btnColor.uiColor()
        suppBtnImg.setImageColor(color: myColors.btnColor.uiColor())
        suppBtn.tintColor = myColors.btnColor.uiColor()
        
        newsIndicator.color = myColors.btnColor.uiColor()
        appsIndicator.color = myColors.btnColor.uiColor()
        counterIndicator.color = myColors.btnColor.uiColor()
        questionIndicator.color = myColors.btnColor.uiColor()
        webIndicator.color = myColors.btnColor.uiColor()
        serviceIndicator.color = myColors.btnColor.uiColor()
        
        allAppsBtn.tintColor = myColors.btnColor.uiColor()
        allQuestionsBtn.tintColor = myColors.btnColor.uiColor()
        allNewsBtn.tintColor = myColors.btnColor.uiColor()
        allWebsBtn.tintColor = myColors.btnColor.uiColor()
        allCountersBtn.tintColor = myColors.btnColor.uiColor()
        allServicesBtn.tintColor = myColors.btnColor.uiColor()
        btn_Add_LS.tintColor = myColors.btnColor.uiColor()
        elipseBackground.backgroundColor = myColors.btnColor.uiColor()
        
        let login = defaults.string(forKey: "login")
        let pass  = defaults.string(forKey: "pass")
        getDebt()
        getNews()
        getDataCounter()
        updateListApps()
        getQuestions()
        getWebs()
        get_Services(login: login!, pass: pass!)
        // Do any additional setup after loading the view.
    }
    
    func StopIndicators() {
        self.newsIndicator.stopAnimating()
        self.newsIndicator.isHidden = true
        self.appsIndicator.stopAnimating()
        self.appsIndicator.isHidden = true
        self.questionIndicator.stopAnimating()
        self.questionIndicator.isHidden = true
        self.counterIndicator.stopAnimating()
        self.counterIndicator.isHidden = true
        self.webIndicator.stopAnimating()
        self.webIndicator.isHidden = true
        self.serviceIndicator.stopAnimating()
        self.serviceIndicator.isHidden = true
        self.allNewsBtn.isHidden = false
        self.allAppsBtn.isHidden = false
        self.allCountersBtn.isHidden = false
        self.allQuestionsBtn.isHidden = false
        self.allWebsBtn.isHidden = false
        self.allServicesBtn.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.StopIndicators()
        UserDefaults.standard.set(true, forKey: "fromMenu")
    }
    
    var lsArr:[lsData] = []
    var newsArr: [News] = []
    var counterArr = ["123"]
    var appsArr = ["123"]
    var questionArr:[QuestionDataJson] = []
    var webArr:[Web_Camera_json] = []
    var serviceArr = [Objects]()
    var rowComms: [String : [Services]]  = [:]
    
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
//        let viewHeight = self.heigth_view.constant
//        let backHeight = self.backgroundHeight.constant
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
                                                                    var sumAll      = ""
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
                                                                                    
                                                                                }
                                                                                if date == ""{
                                                                                    let dateFormatter = DateFormatter()
                                                                                    dateFormatter.dateFormat = "dd.MM.yyyy"
                                                                                    date = dateFormatter.string(from: Date())
                                                                                }
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
                                                                    DispatchQueue.main.async {
                                                                        self.tableLS.reloadData()
                                                                    }
                                                                }
                                                                
                                                            } catch let error as NSError {
                                                                print(error)
                                                            }
                                                            
                                                        }
                })
                task.resume()
//            }
        }else{
            let str_menu_6 = UserDefaults.standard.string(forKey: "menu_6") ?? ""
            if (str_menu_6 != "") {
                var answer = str_menu_6.components(separatedBy: ";")
                if (answer[2] == "0") {
                }else{
                    DispatchQueue.main.async {
                        self.tableLSHeight.constant = 0
                    }
                }
            }
        }
    }
    
    func getNews(){
        var news_read = 0
        let phone = UserDefaults.standard.string(forKey: "login") ?? ""
        //        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "accID=" + id)!)
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_NEWS + "phone=" + phone)!)
        request.httpMethod = "GET"
//        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, error, responce in
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//                                                print("responseString = \(responseString)")
                                                
                                                //            if error != nil {
                                                //                print("ERROR")
                                                //                return
                                                //            }
                                                
                                                guard data != nil else { return }
                                                var newsList: [News] = []
                                                if !responseString.contains("error"){
                                                    let json = try? JSONSerialization.jsonObject(with: data!,
                                                                                                 options: .allowFragments)
                                                    let unfilteredData = NewsJson(json: json! as! JSON)?.data
                                                    
                                                    unfilteredData?.forEach { json in
                                                        if !json.readed! {
                                                            news_read += 1
                                                            UserDefaults.standard.setValue(news_read, forKey: "news_read")
                                                            UserDefaults.standard.synchronize()
                                                        }
                                                        let idNews = json.idNews
                                                        let Created = json.created
                                                        let Header = json.header
                                                        let Text = json.text
                                                        let IsReaded = json.readed
                                                        let newsObj = News(IdNews: String(idNews!), Created: Created!, Text: Text!, Header: Header!, Readed: IsReaded!)
                                                        newsList.append(newsObj)
                                                    }
                                                }
                                                var i = 0
                                                newsList.forEach{
                                                    if i < 2{
                                                        self.newsArr.append($0)
                                                    }
                                                    i += 1
                                                }
                                                DispatchQueue.main.async {
                                                    self.tableNews.reloadData()
                                                }
        })
        task.resume()
    }
    
    var identArr    :[String] = []
    var nameArr     :[String] = []
    var numberArr   :[String] = []
    var predArr     :[Float] = []
    var teckArr     :[Float] = []
    var diffArr     :[Float] = []
    var unitArr     :[String] = []
    var dateOneArr  :[String] = []
    var dateTwoArr  :[String] = []
    var dateThreeArr:[String] = []
    var ownerArr    :[String] = []
    var errorOneArr:[Bool] = []
    var errorTwoArr:[Bool] = []
    var errorThreeArr:[Bool] = []
    var sendedArr:[Bool] = []
    func getDataCounter(){
        let ident = "Все"
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
        errorOneArr.removeAll()
        errorTwoArr.removeAll()
        errorThreeArr.removeAll()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Counters")
        fetchRequest.predicate = NSPredicate.init(format: "year <= %@", String(self.currYear))
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            var uniq_num = ""
            var dateOne = ""
            var valueOne:Float = 0.00
            var dateTwo = ""
            var valueTwo:Float = 0.00
            var dateThree = ""
            var valueThree:Float = 0.00
            var sendOne = false
            var sendTwo = false
            var sendThree = false
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
                                sendOne = (object.value(forKey: "sendError") as! Bool)
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
                                sendTwo = (object.value(forKey: "sendError") as! Bool)
                                i = 2
                            }else if i == 2 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                                dateThree = (object.value(forKey: "num_month") as! String)
                                valueThree = (object.value(forKey: "value") as! Float)
                                sendThree = (object.value(forKey: "sendError") as! Bool)
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
                                errorOneArr.append(sendOne)
                                errorTwoArr.append(sendTwo)
                                errorThreeArr.append(sendThree)
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
                                sendOne = false
                                sendTwo = false
                                sendThree = false
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
                                errorOneArr.append(sendOne)
                                errorTwoArr.append(sendTwo)
                                errorThreeArr.append(sendThree)
                                
                                uniq_num = (object.value(forKey: "uniq_num") as! String)
                                dateOne = (object.value(forKey: "num_month") as! String)
                                valueOne = (object.value(forKey: "value") as! Float)
                                identk = (object.value(forKey: "ident") as! String)
                                count_name = (object.value(forKey: "count_name") as! String)
                                uniq_num = (object.value(forKey: "uniq_num") as! String)
                                owner = (object.value(forKey: "owner") as! String)
                                unit_name = (object.value(forKey: "unit_name") as! String)
                                sended = (object.value(forKey: "sended") as! Bool)
                                sendOne = (object.value(forKey: "sendError") as! Bool)
                                
                                dateTwo = ""
                                valueTwo = 0.00
                                sendTwo = false
                                dateThree = ""
                                valueThree = 0.00
                                sendThree = false
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
                            sendOne = (object.value(forKey: "sendError") as! Bool)
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
                            sendTwo = (object.value(forKey: "sendError") as! Bool)
                            i = 2
                        }else if i == 2 && uniq_num == (object.value(forKey: "uniq_num") as! String){
                            dateThree = (object.value(forKey: "num_month") as! String)
                            valueThree = (object.value(forKey: "value") as! Float)
                            sendThree = (object.value(forKey: "sendError") as! Bool)
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
                            errorOneArr.append(sendOne)
                            errorTwoArr.append(sendTwo)
                            errorThreeArr.append(sendThree)
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
                            sendOne = false
                            sendThree = false
                            sendTwo = false
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
                            errorOneArr.append(sendOne)
                            errorTwoArr.append(sendTwo)
                            errorThreeArr.append(sendThree)
                            
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            dateOne = (object.value(forKey: "num_month") as! String)
                            valueOne = (object.value(forKey: "value") as! Float)
                            identk = (object.value(forKey: "ident") as! String)
                            count_name = (object.value(forKey: "count_name") as! String)
                            uniq_num = (object.value(forKey: "uniq_num") as! String)
                            owner = (object.value(forKey: "owner") as! String)
                            unit_name = (object.value(forKey: "unit_name") as! String)
                            sended = (object.value(forKey: "sended") as! Bool)
                            sendOne = (object.value(forKey: "sendError") as! Bool)
                            
                            dateTwo = ""
                            valueTwo = 0.00
                            dateThree = ""
                            valueThree = 0.00
                            sendTwo = false
                            sendThree = false
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
                errorOneArr.append(sendOne)
                errorTwoArr.append(sendTwo)
                errorThreeArr.append(sendThree)
            }
            
            DispatchQueue.main.async(execute: {
                self.tableCounter.reloadData()
            })
            
        } catch {
            print(error)
        }
    }
    
    func updateListApps() {
        load_data_Apps()
        self.tableApps.reloadData()
    }
    
    func load_data_Apps() {
//        if (switchCloseApps.isOn) {
//            self.fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Applications", keysForSort: ["number"]) as? NSFetchedResultsController<Applications>
//        } else {
            let close: NSNumber = 1
            let predicateFormat = String(format: " is_close =%@ ", close)
            self.fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Applications", keysForSort: ["number"], predicateFormat: predicateFormat) as? NSFetchedResultsController<Applications>
//        }
    
        do {
            try fetchedResultsController!.performFetch()
        } catch {
            print(error)
        }
    }
    
    func getQuestions() {
        
//        let id = UserDefaults.standard.string(forKey: "id_account") ?? ""
        let phone = UserDefaults.standard.string(forKey: "phone") ?? ""
        //        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "accID=" + id)!)
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "phone=" + phone)!)
        request.httpMethod = "GET"
//        print(request)
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//            print("responseString = \(responseString)")
            
            guard data != nil else { return }
            let json = try? JSONSerialization.jsonObject(with: data!,
                                                         options: .allowFragments)
            let unfilteredData = QuestionsJson(json: json! as! JSON)?.data
            var filtered: [QuestionDataJson] = []
            var i = 0
            unfilteredData?.forEach { json in
                
                var isContains = false
                json.questions?.forEach {
                    if !($0.isCompleteByUser ?? false) {
                        isContains = false
                    }
                }
                if !isContains {
                    if i < 2{
                       filtered.append(json)
                    }
                }
                i += 1
            }
            self.questionArr = filtered
            DispatchQueue.main.async {
                self.tableQuestion.reloadData()
            }
            }.resume()
    }
    
    func getWebs() {
        
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_WEB_CAMERAS)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//            print("responseString = \(responseString)")
            
            defer {
                DispatchQueue.main.sync {
                    if self.webArr.count == 0 {
                        self.tableWeb.isHidden = true
                        
                    } else {
                        self.tableWeb.isHidden = false
                    }
                    
//                    if (self.webArr != nil) {
//                        for (index, item) in (self.webArr.enumerated()) {
//                            //                        if item.name == self.performName_ {
//                            //                            self.index = index
//                            //                            self.performSegue(withIdentifier: Segues.fromQuestionsTableVC.toQuestion, sender: self)
//                            //                        }
//                        }
//                    }
                    
                }
            }
            guard data != nil else { return }
            let json = try? JSONSerialization.jsonObject(with: data!,
                                                         options: .allowFragments)
            
            let Data = Web_Cameras_json(json: json! as! JSON)?.data
            self.webArr = Data!
            DispatchQueue.main.async {
                self.tableWeb.reloadData()
            }
            }.resume()
        
    }
    
    var mainScreenXml:  XML.Accessor?
    func get_Services(login: String, pass: String){
        serviceArr.removeAll()
        let urlPath = Server.SERVER + Server.GET_ADDITIONAL_SERVICES + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        DispatchQueue.global(qos: .userInteractive).async {
            var request = URLRequest(url: URL(string: urlPath)!)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) {
                data, error, responce in
                
                guard data != nil else { return }
                //                let responseString = String(data: data!, encoding: .utf8) ?? ""
                //                #if DEBUG
                //                print("responseString = \(responseString)")
                //                #endif
                let xml = XML.parse(data!)
                self.mainScreenXml = xml
                let requests = xml["AdditionalServices"]
                let row = requests["Group"]
                row.forEach { row in
                    self.rowComms[row.attributes["name"]!] = []
                    row["AdditionalService"].forEach {
                        self.rowComms[row.attributes["name"]!]?.append( Services(row: $0) )
                    }
                }
                for (key, value) in self.rowComms {
                    self.serviceArr.append(Objects(sectionName: key, sectionObjects: value))
                }
                if self.serviceArr.count > self.rowComms.count{
                    self.serviceArr.removeAll()
                    for (key, value) in self.rowComms {
                        self.serviceArr.append(Objects(sectionName: key, sectionObjects: value))
                    }
                }
                if self.serviceArr.count == 0{
                    DispatchQueue.main.async{
                        self.tableService.isHidden = true
                    }
                }else{
                    DispatchQueue.main.sync {
                        self.tableService.reloadData()
                    }
                }
                
                }.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        self.tableLSHeight.constant = 400
        self.tableNewsHeight.constant = 400
        self.tableCounterHeight.constant = 400
        self.tableAppsHeight.constant = 400
        self.tableQuestionHeight.constant = 400
        self.tableWebHeight.constant = 400
        self.tableServiceHeight.constant = 400
        if tableView == self.tableLS {
            count = lsArr.count
        }
        if tableView == self.tableNews {
            count =  newsArr.count
        }
        if tableView == self.tableCounter {
            count =  nameArr.count
            if count! > 2{
                count = 2
            }
        }
        if tableView == self.tableApps {
            if let sections = fetchedResultsController?.sections {
                count = sections[section].numberOfObjects
                if count! > 2{
                    count = 2
                }
            } else {
                count = 0
            }
//            count =  appsArr.count
        }
        if tableView == self.tableQuestion {
            count =  questionArr.count
        }
        if tableView == self.tableWeb {
            count =  webArr.count
            if count! > 2{
                count = 2
            }
        }
        if tableView == self.tableService {
            if serviceArr.count != 0{
                count =  serviceArr[0].sectionObjects.count
            }else{
                count = 0
            }
            if count! > 2{
                count = 2
            }
        }
        DispatchQueue.main.async {
            var height1: CGFloat = 0
            for cell in self.tableLS.visibleCells {
                height1 += cell.bounds.height
            }
            self.tableLSHeight.constant = height1
            var height2: CGFloat = 0
            for cell in self.tableNews.visibleCells {
                height2 += cell.bounds.height
            }
            if height2 == 0{
                self.menu_1_const.constant = 0
                self.newsHeight.constant = 0
            }else{
                self.menu_1_const.constant = 15
                self.newsHeight.constant = 45
            }
            self.tableNewsHeight.constant = height2
            var height3: CGFloat = 0
            for cell in self.tableCounter.visibleCells {
                height3 += cell.bounds.height
            }
            if height3 == 0{
                self.menu_2_const.constant = 0
                self.counterHeight.constant = 0
                self.canCountHeight.constant = 0
            }else{
                self.menu_2_const.constant = 15
                self.counterHeight.constant = 45
                self.canCountHeight.constant = 30
            }
            self.tableCounterHeight.constant = height3
            var height4: CGFloat = 0
            for cell in self.tableApps.visibleCells {
                height4 += cell.bounds.height
            }
            if height4 == 0{
                self.menu_3_const.constant = 0
                self.appsHeight.constant = 0
            }else{
                self.menu_3_const.constant = 15
                self.appsHeight.constant = 45
            }
            self.tableAppsHeight.constant = height4
            var height5: CGFloat = 0
            for cell in self.tableQuestion.visibleCells {
                height5 += cell.bounds.height
            }
            if height5 == 0{
                self.menu_4_const.constant = 0
                self.questionLSHeight.constant = 0
            }else{
                self.menu_4_const.constant = 15
                self.questionLSHeight.constant = 45
            }
            self.tableQuestionHeight.constant = height5
            var height6: CGFloat = 0
            for cell in self.tableWeb.visibleCells {
                height6 += cell.bounds.height
            }
            if height6 == 0{
                self.menu_5_const.constant = 0
                self.webLSHeight.constant = 0
            }else{
                self.menu_5_const.constant = 15
                self.webLSHeight.constant = 45
            }
            self.tableWebHeight.constant = height6
            var height7: CGFloat = 0
            for cell in self.tableService.visibleCells {
                height7 += cell.bounds.height
            }
            if height7 == 0{
                self.menu_6_const.constant = 0
                self.serviceHeight.constant = 0
            }else{
                self.menu_6_const.constant = 15
                self.serviceHeight.constant = 45
            }
            self.tableServiceHeight.constant = height7
        }
        return count!
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableLS {
            let cell = self.tableLS.dequeueReusableCell(withIdentifier: "HomeLSCell") as! HomeLSCell
//            cell = shadowCell(cell: cell) as! HomeLSCell
            cell.lsText.text = "Лицевой счет:№ " + lsArr[indexPath.row].ident!
            var str_date_arr = lsArr[indexPath.row].date?.components(separatedBy: ".")
            if str_date_arr![1].first == "0"{
                str_date_arr![1].removeFirst()
            }
            let month = get_name_month(number_month: str_date_arr![1])
            cell.dateText.text = month + " " + str_date_arr![2]
            cell.separator.backgroundColor = myColors.btnColor.uiColor()
            cell.payDebt.backgroundColor = myColors.btnColor.uiColor()
            cell.addressText.text = lsArr[indexPath.row].address!
            if Double(lsArr[indexPath.row].sum!)! > 0.00{
                cell.separator.isHidden = true
                cell.noDebtText.isHidden = true
                cell.payDebt.isHidden = false
                cell.payDebt.setTitle("Оплатить " + lsArr[indexPath.row].sum! + " руб", for: .normal)
            }else{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                cell.separator.isHidden = false
                cell.noDebtText.isHidden = false
                cell.noDebtText.text = "Нет задолженности на " + dateFormatter.string(from: Date())
                cell.payDebt.isHidden = true
            }
            cell.delegate = self
            cell.delegate2 = self
            return cell
        }else if tableView == self.tableNews {
            let cell = self.tableNews.dequeueReusableCell(withIdentifier: "HomeNewsCell") as! HomeNewsCell
            cell.textQuestion.text = newsArr[indexPath.row].header
            cell.openNews.tintColor = myColors.btnColor.uiColor()
//            cell = shadowCell(cell: cell) as! HomeNewsCell
//            cell.delegate = self
            return cell
        }else if tableView == self.tableCounter {
            let cell = self.tableCounter.dequeueReusableCell(withIdentifier: "HomeCounterCell") as! HomeCounterCell
            var countName = ""
            cell.ident.text       = identArr[indexPath.row]
            cell.name.text        = nameArr[indexPath.row] + ", " + unitArr[indexPath.row]
            cell.number.text      = ownerArr[indexPath.row]
            countName             = nameArr[indexPath.row]
            cell.pred.text        = String(format:"%.3f", predArr[indexPath.row])
            cell.teck.text        = String(format:"%.3f", teckArr[indexPath.row])
            cell.diff.text        = String(format:"%.3f", diffArr[indexPath.row])
            cell.predLbl.text     = dateOneArr[indexPath.row]
            cell.teckLbl.text     = dateTwoArr[indexPath.row]
            cell.diffLbl.text     = dateThreeArr[indexPath.row]
            cell.sendButton.backgroundColor = myColors.btnColor.uiColor()
            cell.imgCounter.image = UIImage(named: "water")
            if (countName.lowercased().range(of: "гвс") != nil){
                cell.imgCounter.setImageColor(color: .red)
            }
            if (countName.lowercased().range(of: "хвс") != nil) || (countName.lowercased().range(of: "хвc") != nil){
                cell.imgCounter.setImageColor(color: .blue)
            }
            if (countName.lowercased().range(of: "газ") != nil){
                cell.imgCounter.image = UIImage(named: "fire")
                cell.imgCounter.setImageColor(color: .yellow)
            }
            if (countName.lowercased().range(of: "тепло") != nil){
                cell.imgCounter.image = UIImage(named: "fire")
                cell.imgCounter.setImageColor(color: .red)
            }
            if (countName.lowercased().range(of: "элект") != nil){
                cell.imgCounter.image = UIImage(named: "lamp")
                cell.imgCounter.setImageColor(color: .yellow)
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
//            if errorOneArr[indexPath.row]{
//                cell.nonCounterOne.isHidden = false
//                cell.nonCounter.isHidden = false
//                cell.nonCounterHeight.constant = 16
//                cell.nonCounterOne.setImageColor(color: .red)
//                cell.sendButton.setTitle("Передать ещё раз", for: .normal)
//            }else{
//                cell.nonCounterOne.isHidden = true
//                cell.nonCounter.isHidden = true
//                cell.nonCounterHeight.constant = 0
//                cell.sendButton.setTitle("Передать показания", for: .normal)
//            }
//            if errorTwoArr[indexPath.row]{
//                cell.nonCounterTwo.isHidden = false
//                cell.nonCounterTwo.setImageColor(color: .red)
//            }else{
//                cell.nonCounterTwo.isHidden = true
//            }
//            if errorThreeArr[indexPath.row]{
//                cell.nonCounterThree.isHidden = false
//                cell.nonCounterThree.setImageColor(color: .red)
//            }else{
//                cell.nonCounterThree.isHidden = true
//            }
            //        if isEditable(){
//            cell.sendButton.isEnabled = true
//            cell.sendButton.backgroundColor = cell.sendButton.backgroundColor?.withAlphaComponent(1.0)
            //        }else{
            //            cell.sendButton.isEnabled = false
            //            cell.sendButton.backgroundColor = cell.sendButton.backgroundColor?.withAlphaComponent(0.5)
            //        }
            cell.sendButton.backgroundColor = myColors.btnColor.uiColor()
            cell.separator.backgroundColor = myColors.btnColor.uiColor()
//            cell = shadowCell(cell: cell) as! HomeCounterCell
            cell.delegate = self
            return cell
        }else if tableView == self.tableApps {
            let cell = self.tableApps.dequeueReusableCell(withIdentifier: "HomeAppsCell") as! HomeAppsCell
            let app = (fetchedResultsController?.object(at: indexPath))! as Applications
            cell.goApp.tintColor = myColors.btnColor.uiColor()
            cell.img.setImageColor(color: myColors.btnColor.uiColor())
            cell.nameApp.text    = "Заявка №" + app.number!
            cell.comment.text      = app.tema
            //            cell.text_app.text  = app.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            let date = dateFormatter.date(from: app.date!)
            dateFormatter.dateFormat = "dd.MM.yyyy"
            cell.date.text  = dateFormatter.string(from: date!)
//            cell = shadowCell(cell: cell) as! HomeAppsCell
            //            cell.delegate = self
            return cell
        }else if tableView == self.tableQuestion {
            let cell = self.tableQuestion.dequeueReusableCell(withIdentifier: "HomeQuestionsCell") as! HomeQuestionsCell
            cell.nameQuestion.text = questionArr[indexPath.row].name!
            cell.number.text = "Опрос №" + String(questionArr[indexPath.row].id!)
            cell.questionsCount.text = String(questionArr[indexPath.row].questions?.count as! Int) + " вопросов"
            cell.separator.backgroundColor = myColors.btnColor.uiColor()
            cell.goQuestion.tintColor = myColors.btnColor.uiColor()
//            cell = shadowCell(cell: cell) as! HomeQuestionsCell
            cell.delegate = self
            return cell
        }else if tableView == self.tableWeb {
            let cell = self.tableWeb.dequeueReusableCell(withIdentifier: "HomeWebCell") as! HomeWebCell
            cell.goWeb.tintColor = myColors.btnColor.uiColor()
            cell.img.setImageColor(color: myColors.btnColor.uiColor())
//            cell = shadowCell(cell: cell) as! HomeWebCell
            //            cell.delegate = self
            return cell
        }else if tableView == self.tableService {
            let cell = self.tableService.dequeueReusableCell(withIdentifier: "HomeServiceCell") as! HomeServiceCell
            cell.serviceText.text = serviceArr[indexPath.section].sectionObjects[indexPath.row].name
            cell.goService.backgroundColor = myColors.btnColor.uiColor()
//            cell = shadowCell(cell: cell) as! HomeServiceCell
            //            cell.delegate = self
            return cell
        }else{
           return StockCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableQuestion{
            indexQuestion = indexPath.row
            performSegue(withIdentifier: "go_answers", sender: self)
        }else if tableView == self.tableNews{
            performSegue(withIdentifier: "show_news", sender: self)
        }else if tableView == self.tableApps{
            performSegue(withIdentifier: "show_app", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    var indexQuestion = 0
//    func shadowCell(cell: UITableViewCell) -> UITableViewCell{
//        cell.layer.cornerRadius = 7
//        cell.layer.masksToBounds = false
//        cell.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
//        cell.layer.shadowRadius = 7
//        cell.layer.shadowOpacity = 0.5
//        cell.layer.shouldRasterize = true
//        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
//        return cell
//    }
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
        if segue.identifier == "go_answers" {
            let vc = segue.destination as! QuestionAnswerVC
            vc.title = questionArr[indexQuestion].name
            vc.question_ = questionArr[indexQuestion]
            //            vc.delegate = delegate
            vc.questionDelegate = self
        }
        if (segue.identifier == "show_news") {
            let indexPath = tableNews.indexPathForSelectedRow!
            let newsObj = newsArr[indexPath.row]
            let vc = segue.destination as! NewsView
            vc.newsTitle = newsObj.header
            vc.newsData  = newsObj.created
            vc.newsText  = newsObj.text
            vc.newsRead  = newsObj.readed
            vc.newsId    = newsObj.idNews
        }
        if segue.identifier == "show_app" {
            let indexPath = tableApps.indexPathForSelectedRow!
            let app = fetchedResultsController!.object(at: indexPath)
            
            let AppUser             = segue.destination as! AppUser
            AppUser.title           = "Заявка №" + app.number!
            AppUser.txt_tema   = app.tema!
            AppUser.str_type_app = app.type_app!
            AppUser.read = app.is_read_client
            AppUser.adress = app.adress!
            AppUser.flat = app.flat!
            AppUser.phone = app.phone!
            //            AppUser.txt_text   = app.text!
            AppUser.txt_date   = app.date!
            AppUser.id_app     = app.number!
//            AppUser.delegate   = ShowAppDelegate()
            AppUser.App        = app
//            AppUser.updDelegt = AppsUserUpdateDelegate()
        }
        if segue.identifier == "addCounters"{
            let payController             = segue.destination as! AddCountersController
            payController.counterNumber = selectedUniq
            payController.counterName = selectedUniqName
            payController.ident = countIdent
            payController.predValue = predVal
            payController.metrId = metrID
        }
        #if isMupRCMytishi
        if segue.identifier == "paysMytishi" {
            let nav = segue.destination as! UINavigationController
            let payController             = nav.topViewController as! PaysMytishiController
            if choiceIdent == ""{
                payController.saldoIdent = "Все"
            }else{
                payController.saldoIdent = choiceIdent
            }
            payController.debtArr = self.debtArr
        }
        #elseif isKlimovsk12
        if segue.identifier == "paysMytishi" {
            let nav = segue.destination as! UINavigationController
            let payController             = nav.topViewController as! PaysMytishiController
            if choiceIdent == ""{
                payController.saldoIdent = "Все"
            }else{
                payController.saldoIdent = choiceIdent
            }
            payController.debtArr = self.debtArr
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
            payController.debtArr = self.debtArr
        }
        #endif
    }
    var selectedUniq = ""
    var selectedUniqName = ""
    var selectedOwner = ""
    var countIdent = ""
    var predVal = ""
    var metrID = ""
    var can_edit: String = ""
    var date1: String = ""
    var date2: String = ""
    func isEditable() -> Bool {
        return can_edit == "0"
    }
    
    func sendPressed(uniq_num: String, count_name: String, ident: String, predValue: String) {
        print(isEditable())
        if isEditable(){
            var metrId = ""
            for i in 0...self.numberArr.count - 1{
                if uniq_num == self.ownerArr[i]{
                    metrId = self.numberArr[i]
                }
            }
            selectedUniq = uniq_num
            selectedUniqName = count_name
            countIdent = ident
            predVal = predValue
            self.metrID = metrId
            self.performSegue(withIdentifier: "addCounters", sender: self)
        }else{
            let alert = UIAlertController(title: "Ошибка", message: "Возможность передавать показания доступна с " + date1 + " по " + date2 + " числа текущего месяца!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    var choiceIdent = ""
    func goPaysPressed(ident: String) {
        choiceIdent = ident
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "paysMytishi", sender: self)
        #elseif isKlimovsk12
        self.performSegue(withIdentifier: "paysMytishi", sender: self)
        #else
        self.performSegue(withIdentifier: "pays", sender: self)
        #endif
    }
    
    func update() {
        getQuestions()
    }
}

class HomeLSCell: UITableViewCell {
    
    var delegate: DebtCellDelegate?
    var delegate2: DelLSCellDelegate?
    
    @IBOutlet weak var lsText: UILabel!
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var noDebtText: UILabel!
    @IBOutlet weak var separator: UILabel!
    @IBOutlet weak var payDebt: UIButton!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var del_ls_btn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    @IBAction func sendAction(_ sender: UIButton) {
        let str = lsText.text!
        delegate?.goPaysPressed(ident: str.replacingOccurrences(of: "Лицевой счет:№ ", with: ""))
    }
    @IBAction func delAction(_ sender: UIButton) {
        let str = lsText.text!
        delegate2?.try_del_ls_from_acc(ls: str.replacingOccurrences(of: "Лицевой счет:№ ", with: ""))
    }
}

class HomeNewsCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var textQuestion: UILabel!
    @IBOutlet weak var openNews: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class HomeCounterCell: UITableViewCell {
    
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
    
    @IBOutlet weak var nonCounterOne: UIImageView!
    @IBOutlet weak var nonCounterTwo: UIImageView!
    @IBOutlet weak var nonCounterThree: UIImageView!
    
    @IBOutlet weak var separator: UILabel!
    
    @IBOutlet weak var nonCounterHeight: NSLayoutConstraint!
    @IBOutlet weak var lblHeight2: NSLayoutConstraint!
    @IBOutlet weak var lblHeight3: NSLayoutConstraint!
    @IBOutlet weak var lblHeight4: NSLayoutConstraint!
    @IBOutlet weak var lblHeight5: NSLayoutConstraint!
    @IBOutlet weak var lblHeight6: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        delegate?.sendPressed(uniq_num: number.text!, count_name: name.text!, ident: ident.text!, predValue: pred.text!)
    }
}

class HomeAppsCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var nameApp: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var goApp: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class HomeQuestionsCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var nameQuestion: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var questionsCount: UILabel!
    @IBOutlet weak var goQuestion: UIButton!
    @IBOutlet weak var separator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func goQuestions(_ sender: UIButton) {        
        delegate!.performSegue(withIdentifier: "go_answers", sender: self)
    }
}

class HomeWebCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var webText: UILabel!
    @IBOutlet weak var goWeb: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class HomeServiceCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var serviceText: UILabel!
    @IBOutlet weak var goService: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class StockCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

struct lsData {
    
    let ident: String?
    let sum: String?
    let sumFine: String?
    let date: String?
    let address: String?
    
    init(ident: String?, sum: String?, sumFine: String?, date:String?, address: String?) {
        self.ident = ident
        self.sum = sum
        self.sumFine = sumFine
        self.date = date
        self.address = address
    }
}
