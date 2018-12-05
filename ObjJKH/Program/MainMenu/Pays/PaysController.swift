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
//import ASDKUI

class PaysController: UIViewController, DropperDelegate {
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var historyPay: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController<Saldo>?
    var iterYear: String = "0"
    var iterMonth: String = "0"
    
    var sum: Double = 0
    
    var login: String?
    var pass: String?
    
    let dropper = Dropper(width: 150, height: 400)

    @IBOutlet weak var ls_button: UIButton!
    @IBOutlet weak var txt_sum_jkh: UILabel!
    @IBOutlet weak var txt_sum_obj: UILabel!
    
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
    
    // Нажатие в оплату
    @IBAction func Payed(_ sender: UIButton) {
        if (self.sum <= 0) {
            let alert = UIAlertController(title: "Ошибка", message: "Нет суммы к оплате", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            #if isMupRCMytishi
        
//                let vc = ASDKPaymentFormViewController.init(amount: 123, orderId: "123", title: "Название", description: "Текст", cardId: "123", email: "tra-ss@mail.ru", customerKey: "123", recurrent: false, makeCharge: true, additionalPaymentData: nil, receiptData: nil, success: nil, cancelled: nil, error: nil)
//                navigationController?.present(vc!, animated: true, completion: nil)
        
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
        
        dropper.delegate = self
        dropper.items.append("Все")
        if ((str_ls_arr?.count)! > 3) {
            dropper.items.append((str_ls_arr?[0])!)
            dropper.items.append((str_ls_arr?[1])!)
            dropper.items.append((str_ls_arr?[2])!)
        } else if ((str_ls_arr?.count)! == 2) {
            dropper.items.append((str_ls_arr?[0])!)
            dropper.items.append((str_ls_arr?[1])!)
        } else if ((str_ls_arr?.count)! == 1) {
            dropper.items.append((str_ls_arr?[0])!)
        }
        dropper.showWithAnimation(0.001, options: Dropper.Alignment.center, button: ls_button)
        dropper.hideWithAnimation(0.001)
        
        getSum(login: login!, pass: pass!)
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        btnPay.backgroundColor = myColors.btnColor.uiColor()
        historyPay.backgroundColor = myColors.btnColor.uiColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        ls_button.setTitle(contents, for: UIControlState.normal)
        self.sum = 0
        if (contents == "Все") {
            getSum(login: login!, pass: pass!)
        } else {
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
    
    
    // Дубль - получение ведомостей по лиц. счетам
    // Ведомость
    func parse_OSV(login: String, pass: String) {
        
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
                                                        var bill_month    = ""
                                                        var bill_year     = ""
                                                        var bill_service  = ""
                                                        var bill_acc      = ""
                                                        var bill_debt     = ""
                                                        var bill_pay      = ""
                                                        var bill_total    = ""
                                                        var json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                        print(json)
                                                        if let json_bills = json["data"] {
                                                            let int_end = (json_bills.count)!-1
                                                            if (int_end < 0) {
                                                                
                                                            } else {
                                                                
                                                                for index in 0...int_end {
                                                                    let json_bill = json_bills.object(at: index) as! [String:AnyObject]
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
                                                                            bill_acc = String(describing: obj.value as! NSNumber)
                                                                        }
                                                                        if obj.key == "Debt" {
                                                                            bill_debt = String(describing: obj.value as! NSNumber)
                                                                        }
                                                                        if obj.key == "Payed" {
                                                                            bill_pay = String(describing: obj.value as! NSNumber)
                                                                        }
                                                                        if obj.key == "Total" {
                                                                            bill_total = String(describing: obj.value as! NSNumber)
                                                                        }
                                                                    }
                                                                    
                                                                    self.add_data_saldo(usluga: bill_service, num_month: bill_month, year: bill_year, start: bill_acc, plus: bill_debt, minus: bill_pay, end: bill_total)
                                                                    
                                                                    if (Int(bill_month)! > i_month) {
                                                                        i_month = Int(bill_month)!
                                                                    }
                                                                    if (Int(bill_year)! > i_year) {
                                                                        i_year = Int(bill_year)!
                                                                    }
                                                                    
                                                                }
                                                            }
                                                        }
                                                        
                                                        self.end_osv()
                                                        
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                    
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
        // Выборка из БД последней ведомости - посчитаем сумму к оплате
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Saldo")
        fetchRequest.predicate = NSPredicate.init(format: "num_month = %@ AND year = %@", String(self.iterMonth), String(self.iterYear))
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results {
                let object = result as! NSManagedObject
                self.sum = self.sum + Double(object.value(forKey: "end") as! String)!
            }
            
            DispatchQueue.main.async(execute: {
                if (self.sum != 0) {
                    self.txt_sum_jkh.text = String(format:"%.2f", self.sum) + " р."
                    self.txt_sum_obj.text = String(format:"%.2f", self.sum) + " р."
                } else {
                    self.txt_sum_jkh.text = "0,00 р."
                    self.txt_sum_obj.text = "0,00 р."
                }
                
            })
            
        } catch {
            print(error)
        }
    }    
}
