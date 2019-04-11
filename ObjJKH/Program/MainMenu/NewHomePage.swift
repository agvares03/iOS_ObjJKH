//
//  NewMainMenu.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 14/03/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class NewHomePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
    
    @IBAction func AddLS(_ sender: UIButton) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "addLS_Mup", sender: self)
        #else
        self.performSegue(withIdentifier: "addLS", sender: self)
        #endif
    }
    
    func try_del_ls_from_acc(ls: UILabel) {
        
        let defaults = UserDefaults.standard
        let phone = defaults.string(forKey: "phone")
        let ident =  ls.text
        
        if (phone == ident) {
            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Невозможно отвязать лицевой счет " + ls.text! + ". Вы зашли, используя этот лицевой счет.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Отвязать лицевой счет " + ls.text! + " от аккаунта?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
                
                var urlPath = Server.SERVER + Server.MOBILE_API_PATH + Server.DEL_IDENT_ACC
                urlPath = urlPath + "phone=" + phone! + "&ident=" + ident!
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
                                                        
                                                        self.del_ls_from_acc(ls: ls)
                })
                task.resume()
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func del_ls_from_acc(ls: UILabel) {
        DispatchQueue.main.async(execute: {
            // Выведем подключенные лицевые счета
            let defaults = UserDefaults.standard
            let str_ls = defaults.string(forKey: "str_ls")
            var newStr_ls = str_ls?.replacingOccurrences(of: ls.text! + ",", with: "")
            newStr_ls = newStr_ls?.replacingOccurrences(of: "," + ls.text!, with: "")
            newStr_ls = newStr_ls?.replacingOccurrences(of: ls.text!, with: "")
            
//            self.btn_ls1.isHidden = true
//            self.btn_ls1.isEnabled = false
//
//            self.btn_ls2.isHidden = true
//            self.btn_ls2.isEnabled = false
            
            let str_ls_arr = newStr_ls?.components(separatedBy: ",")
            defaults.set(newStr_ls, forKey: "str_ls")
            defaults.synchronize()
//            if ((str_ls_arr?.count)! >= 3) {
//                
//                self.btn_ls1.isHidden = false
//                self.btn_ls1.isEnabled = true
//                
//                self.btn_ls2.isHidden = false
//                self.btn_ls2.isEnabled = true
//            } else if ((str_ls_arr?.count)! == 2) {
//                self.btn_ls1.isHidden = false
//                self.btn_ls1.isEnabled = true
//                
//                self.btn_ls2.isHidden = false
//                self.btn_ls2.isEnabled = true
//            } else if ((str_ls_arr?.count)! == 1) {
//                self.btn_ls2.isHidden = true
//                self.btn_ls2.isEnabled = false
//            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        targetName.text = "Мобильное ЖКХ"
        #if isOur_Obj_Home
        targetName.text = "Наш Общий Дом"
        fon_top.image = UIImage(named: "logo_Our_Obj_Home")
        #elseif isChist_Dom
        fon_top.image = UIImage(named: "Logo_Chist_Dom")
        #elseif isMupRCMytishi
        targetName.text = "МУП РЦ Мытищи"
        fon_top.image = UIImage(named: "logo_MupRCMytishi")
        #elseif isDJ
        fon_top.image = UIImage(named: "logo_DJ")
        #elseif isStolitsa
        targetName.text = "УК Жилищник Столица"
        fon_top.image = UIImage(named: "logo_Stolitsa")
        #elseif isKomeks
        fon_top.image = UIImage(named: "Logo_Komeks")
        #elseif isUKKomfort
        targetName.text = "УК Комфорт"
        fon_top.image = UIImage(named: "logo_UK_Komfort")
        #elseif isKlimovsk12
        targetName.text = "ТСЖ Климовск 12"
        fon_top.image = UIImage(named: "logo_Klimovsk12")
        #elseif isPocket
        fon_top.image = UIImage(named: "Logo_Pocket")
        #elseif isReutKomfort
        targetName.text = "УК Реут Комфорт"
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
        
        allAppsBtn.tintColor = myColors.btnColor.uiColor()
        allQuestionsBtn.tintColor = myColors.btnColor.uiColor()
        allNewsBtn.tintColor = myColors.btnColor.uiColor()
        allWebsBtn.tintColor = myColors.btnColor.uiColor()
        allCountersBtn.tintColor = myColors.btnColor.uiColor()
        allServicesBtn.tintColor = myColors.btnColor.uiColor()
        btn_Add_LS.tintColor = myColors.btnColor.uiColor()
        elipseBackground.backgroundColor = myColors.btnColor.uiColor()
        
        let str_menu_2 = UserDefaults.standard.string(forKey: "menu_2") ?? ""
        if (str_menu_2 != "") {
            var answer = str_menu_2.components(separatedBy: ";")
            if (answer[2] == "0") {
                if let tabBarController = self.tabBarController {
                    let indexToRemove = 1
                    if indexToRemove < tabBarController.viewControllers!.count {
                        var viewControllers = tabBarController.viewControllers
                        viewControllers?.remove(at: indexToRemove)
                        tabBarController.viewControllers = viewControllers
                    }
                }
            }
        }
        getDebt()
        // Do any additional setup after loading the view.
    }
    
    var lsArr = ["123","12"]
    var newsArr = ["123"]
    var counterArr = ["123"]
    var appsArr = ["123"]
    var questionArr = ["123"]
    var webArr = ["123"]
    var serviceArr = ["123"]
    
    var dateOld = "01.01"
    func getDebt() {
        var debtIdent:[String] = []
        var debtSum:[String] = []
        var debtSumFine:[String] = []
        let defaults = UserDefaults.standard
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        var sumObj = 0.00
        var u = 0
//        let viewHeight = self.heigth_view.constant
//        let backHeight = self.backgroundHeight.constant
        if (str_ls_arr?.count)! > 0 && str_ls_arr?[0] != ""{
            str_ls_arr?.forEach{
                let ls = $0
                let urlPath = Server.SERVER + Server.GET_DEBT_ACCOUNT + "ident=" + ls.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
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
                                                                    //                                                                var sumOver     = ""
                                                                    //                                                                var sumFineOver = ""
                                                                    var sumAll      = ""
                                                                    var json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                                    //                                                                                                                                        print(json)
                                                                    
                                                                    if let json_bills = json["data"] {
                                                                        let int_end = (json_bills.count)!-1
                                                                        if (int_end < 0) {
                                                                            
                                                                        } else {
                                                                            sum = String(format:"%.2f", json_bills["Sum"] as! Double)
                                                                            //                                                                            let s = json_bills["Sum"] as! Double
                                                                            sumFine = String(format:"%.2f", json_bills["SumFine"] as! Double)
                                                                            //                                                                            sum = "0.00"
                                                                            //                                                                            let s = 0
                                                                            //                                                                            sumFine = "0.00"
                                                                            debtIdent.append(ls)
                                                                            debtSum.append(sum)
                                                                            debtSumFine.append(sumFine)
                                                                            sumAll = String(format:"%.2f", json_bills["SumAll"] as! Double)
                                                                            date = json_bills["Date"] as! String
                                                                            
                                                                            defaults.set(date, forKey: "dateDebt")
                                                                            if Double(sumAll) != 0.00{
                                                                                let d = date.components(separatedBy: ".")
                                                                                let d1 = self.dateOld.components(separatedBy: ".")
                                                                                if (Int(d[0])! >= Int(d1[0])!) && (Int(d[1])! >= Int(d1[1])!){
                                                                                    DispatchQueue.main.async {
                                                                                        self.dateOld = date
                                                                                    }
                                                                                }
                                                                                sumObj = sumObj + Double(sumAll)!
                                                                            }
                                                                        }
                                                                    }
                                                                    defaults.set(sumObj, forKey: "sumDebt")
                                                                    defaults.synchronize()
                                                                    
                                                                    let str_menu_6 = UserDefaults.standard.string(forKey: "menu_6") ?? ""
                                                                    if (str_menu_6 != "") {
                                                                        var answer = str_menu_6.components(separatedBy: ";")
                                                                        if (answer[2] == "0") {
                                                                        }else{
                                                                            DispatchQueue.main.async {
                                                                                var o = 0
                                                                                debtSum.forEach{
                                                                                    if Double($0) != 0.00{
                                                                                        o += 1
                                                                                    }
                                                                                }
                                                                                if o != 0{
                                                                                    
                                                                                }
                                                                                self.tableLS.reloadData()
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                
                                                            } catch let error as NSError {
                                                                print(error)
                                                            }
                                                            
                                                        }
                })
                task.resume()
            }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        if tableView == self.tableLS {
            count = lsArr.count
        }
        if tableView == self.tableNews {
            count =  newsArr.count
        }
        if tableView == self.tableCounter {
            count =  counterArr.count
        }
        if tableView == self.tableApps {
            count =  appsArr.count
        }
        if tableView == self.tableQuestion {
            count =  questionArr.count
        }
        if tableView == self.tableWeb {
            count =  webArr.count
        }
        if tableView == self.tableService {
            count =  serviceArr.count
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
            self.tableNewsHeight.constant = height2
            var height3: CGFloat = 0
            for cell in self.tableCounter.visibleCells {
                height3 += cell.bounds.height
            }
            self.tableCounterHeight.constant = height3
            var height4: CGFloat = 0
            for cell in self.tableApps.visibleCells {
                height4 += cell.bounds.height
            }
            self.tableAppsHeight.constant = height4
            var height5: CGFloat = 0
            for cell in self.tableQuestion.visibleCells {
                height5 += cell.bounds.height
            }
            self.tableQuestionHeight.constant = height5
            var height6: CGFloat = 0
            for cell in self.tableWeb.visibleCells {
                height6 += cell.bounds.height
            }
            self.tableWebHeight.constant = height6
            var height7: CGFloat = 0
            for cell in self.tableService.visibleCells {
                height7 += cell.bounds.height
            }
            self.tableServiceHeight.constant = height7
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableLS {
            var cell = self.tableLS.dequeueReusableCell(withIdentifier: "HomeLSCell") as! HomeLSCell
            cell = shadowCell(cell: cell) as! HomeLSCell
            cell.lsText.text = lsArr[indexPath.row]
            cell.separator.backgroundColor = myColors.btnColor.uiColor()
            cell.payDebt.backgroundColor = myColors.btnColor.uiColor()
//            cell.delegate = self
            return cell
        }else if tableView == self.tableNews {
            var cell = self.tableNews.dequeueReusableCell(withIdentifier: "HomeNewsCell") as! HomeNewsCell
            cell.openNews.tintColor = myColors.btnColor.uiColor()
            cell = shadowCell(cell: cell) as! HomeNewsCell
//            cell.delegate = self
            return cell
        }else if tableView == self.tableCounter {
            var cell = self.tableCounter.dequeueReusableCell(withIdentifier: "HomeCounterCell") as! HomeCounterCell
            cell.sendButton.backgroundColor = myColors.btnColor.uiColor()
            cell.separator.backgroundColor = myColors.btnColor.uiColor()
            cell = shadowCell(cell: cell) as! HomeCounterCell
            //            cell.delegate = self
            return cell
        }else if tableView == self.tableApps {
            var cell = self.tableApps.dequeueReusableCell(withIdentifier: "HomeAppsCell") as! HomeAppsCell
            cell.goApp.tintColor = myColors.btnColor.uiColor()
            cell.img.setImageColor(color: myColors.btnColor.uiColor())
            cell = shadowCell(cell: cell) as! HomeAppsCell
            //            cell.delegate = self
            return cell
        }else if tableView == self.tableQuestion {
            var cell = self.tableQuestion.dequeueReusableCell(withIdentifier: "HomeQuestionsCell") as! HomeQuestionsCell
            cell.separator.backgroundColor = myColors.btnColor.uiColor()
            cell.goQuestion.tintColor = myColors.btnColor.uiColor()
            cell = shadowCell(cell: cell) as! HomeQuestionsCell
            //            cell.delegate = self
            return cell
        }else if tableView == self.tableWeb {
            var cell = self.tableWeb.dequeueReusableCell(withIdentifier: "HomeWebCell") as! HomeWebCell
            cell.goWeb.tintColor = myColors.btnColor.uiColor()
            cell.img.setImageColor(color: myColors.btnColor.uiColor())
            cell = shadowCell(cell: cell) as! HomeWebCell
            //            cell.delegate = self
            return cell
        }else if tableView == self.tableService {
            var cell = self.tableService.dequeueReusableCell(withIdentifier: "HomeServiceCell") as! HomeServiceCell
            cell.goService.backgroundColor = myColors.btnColor.uiColor()
            cell = shadowCell(cell: cell) as! HomeServiceCell
            //            cell.delegate = self
            return cell
        }else{
           return StockCell()
        }
    }
    
    func shadowCell(cell: UITableViewCell) -> UITableViewCell{
        cell.layer.cornerRadius = 7
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.layer.shadowRadius = 7
        cell.layer.shadowOpacity = 0.5
        cell.layer.shouldRasterize = true
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        return cell
    }
}

class HomeLSCell: UITableViewCell {
    
    var delegate: UIViewController?
    
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
    
    var delegate: UIViewController?
    
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
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var questionsCount: UILabel!
    @IBOutlet weak var goQuestion: UIButton!
    @IBOutlet weak var separator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
