//
//  PaysMytishiController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 14/01/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import Dropper
import CoreData
import StoreKit
import PassKit

private protocol MainDataProtocol:  class {}

class PaysMytishiController: UIViewController, DropperDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func backClick(_ sender: UIBarButtonItem){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var lsView: UIView!
    @IBOutlet weak var addLS: UILabel!
    
    @IBAction func updateConect(_ sender: UIButton) {
        self.viewDidLoad()
    }
    @IBOutlet weak var updateConectBtn: UIButton!
    @IBOutlet weak var nonConectView: UIView!
    
    @IBOutlet weak var lsLbl: UILabel!
    @IBOutlet weak var spinImg: UIImageView!
    @IBOutlet weak var servicePay: UILabel!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var historyPay: UIButton!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController<Saldo>?
    var iterYear: String = "0"
    var iterMonth: String = "0"
    
    var sum: Double = 0
    var totalSum: Double = 0
    var selectedRow = -1
    var checkBox:[Bool]   = []
    var idOSV   :[Int]    = []
    var sumOSV  :[Double] = []
    var osvc    :[String] = []
    var identOSV:[String] = []
    
    var login: String?
    var pass: String?
    var currPoint = CGFloat()
    let dropper = Dropper(width: 150, height: 400)
    
    public var saldoIdent = "Все"
    public var debtArr:[AnyObject] = []
    
    @IBOutlet weak var ls_button: UIButton!
    @IBOutlet weak var txt_sum_jkh: UILabel!
    @IBOutlet weak var txt_sum_obj: UILabel!
    
    @objc private func lblTapped(_ sender: UITapGestureRecognizer) {
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "addLSMup", sender: self)
        #elseif isPocket
        self.performSegue(withIdentifier: "addLSPocket", sender: self)
        #else
        self.performSegue(withIdentifier: "addLS", sender: self)
        #endif
    }
    
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
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        if (ls_button.titleLabel?.text == "Все") && ((str_ls_arr?.count)! > 1){
            let alert = UIAlertController(title: "", message: "Для совершения оплаты укажите лицевой счет", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if defaults.string(forKey: "mail")! == "" || defaults.string(forKey: "mail")! == "-"{
            let alert = UIAlertController(title: "Ошибка", message: "Укажите e-mail", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "e-mail..."
                textField.keyboardType = .emailAddress
            }
            let cancelAction = UIAlertAction(title: "Сохранить", style: .default) { (_) -> Void in
                let textField = alert.textFields![0]
                let str = textField.text
                if ((str?.contains("@"))! && (str?.contains(".ru"))!) || ((str?.contains("@"))! && (str?.contains(".com"))!){
                    UserDefaults.standard.set(str, forKey: "mail")
                    self.payedM()
                    //                    let alert = UIAlertController(title: nil, message: "Выберите способ оплаты", preferredStyle: .actionSheet)
                    //                    let cardImage = UIImage(named: "cardIcon")
                    //                    let actionCard = UIAlertAction(title: "Оплата по карте", style: .default, handler: { (_) in
                    //                        self.payType = 0
                    //                        self.payedM()
                    //                    })
                    //                    actionCard.setValue(cardImage, forKey: "image")
                    //                    let appleImage = UIImage(named: "applePayIcon")
                    //                    let actionApple = UIAlertAction(title: "Оплата Apple Pay", style: .default, handler: { (_) in
                    //                        self.payType = 1
                    //                        self.payedM()
                    //                    })
                    //                    actionApple.setValue(appleImage, forKey: "image")
                    //                    alert.addAction(actionCard)
                    //                    alert.addAction(actionApple)
                    //                    alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in }))
                    //                    self.present(alert, animated: true, completion: nil)
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
            //
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.payedM()
            //            let alert = UIAlertController(title: nil, message: "Выберите привязанный лицевой счет", preferredStyle: .actionSheet)
            //            let cardImage = UIImage(named: "cardIcon")
            //            let actionCard = UIAlertAction(title: "Оплата по карте", style: .default, handler: { (_) in
            //                self.payType = 0
            //                self.payedM()
            //            })
            //            actionCard.setValue(cardImage, forKey: "image")
            //            let appleImage = UIImage(named: "applePayIcon")
            //            let actionApple = UIAlertAction(title: "Оплата Apple Pay", style: .default, handler: { (_) in
            //                self.payType = 1
            //                self.payedM()
            //            })
            //            actionApple.setValue(appleImage, forKey: "image")
            //            alert.addAction(actionCard)
            //            alert.addAction(actionApple)
            //            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in }))
            //            present(alert, animated: true, completion: nil)
        }
    }
    var payType = 0
    private func payedM(){
        let k:String = txt_sum_jkh.text!
        self.totalSum = Double(k.replacingOccurrences(of: " руб.", with: ""))!
        if (self.totalSum <= 0) {
            let alert = UIAlertController(title: "Ошибка", message: "Нет суммы к оплате", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            items.removeAll()
            let servicePay = totalSum - self.sum
            var i = 0
            checkBox.forEach{
                if $0 == true && sumOSV[i] > 0.00{
                    let price = String(format:"%.2f", sumOSV[i]).replacingOccurrences(of: ".", with: "")
                    #if isKlimovsk12
                    var ItemsData: [String : Any] = [:]
                    if i == 0{
                        ItemsData = ["ShopCode" : "215944", "Name" : "Услуга ЖКУ", "Price" : Int(String(format:"%.2f", self.sum).replacingOccurrences(of: ".", with: ""))!, "Quantity" : Double(1.00), "Amount" : Int(String(format:"%.2f", self.sum).replacingOccurrences(of: ".", with: ""))!, "Tax" : "none", "QUANTITY_SCALE_FACTOR" : 3] as [String : Any]
                        items.append(ItemsData)
                    }
                    #else
                    let ItemsData = ["Name" : osvc[i], "Price" : Int(price)!, "Quantity" : Double(1.00), "Amount" : Int(price)!, "Tax" : "none"] as [String : Any]
                    items.append(ItemsData)
                    #endif
                }
                i += 1
            }
            let servicePrice = String(format:"%.2f", servicePay).replacingOccurrences(of: ".", with: "")
            #if isKlimovsk12
            let ItemsData = ["ShopCode" : "215944", "Name" : "Сервисный сбор", "Price" : Int(servicePrice)!, "Quantity" : Double(1.00), "Amount" : Int(servicePrice)!, "Tax" : "none"] as [String : Any]
            #else
            let ItemsData = ["Name" : "Сервисный сбор", "Price" : Int(servicePrice)!, "Quantity" : Double(1.00), "Amount" : Int(servicePrice)!, "Tax" : "none"] as [String : Any]
            #endif
            items.append(ItemsData)
            var Data:[String:String] = [:]
            var DataStr: String = ""
            if selectLS == "Все"{
                let str_ls = UserDefaults.standard.string(forKey: "str_ls")!
                let str_ls_arr = str_ls.components(separatedBy: ",")
                for i in 0...str_ls_arr.count - 1{
                    DataStr = DataStr + "ls\(i + 1)-\(str_ls_arr[0])|"
                }
            }else{
                DataStr = "ls1-\(selectLS)|"
            }
            DataStr = DataStr + "|"
            i = 0
            if items.count > 8{
                DataStr = DataStr + "Кол - Превышено|"
            }else{
                #if isKlimovsk12
                DataStr = DataStr + "1-\(String(format:"%.2f", self.sum))|"
                #else
                checkBox.forEach{
                    if $0 == true && sumOSV[i] > 0.00{
                        DataStr = DataStr + "\(String(idOSV[i]))-\(String(format:"%.2f", sumOSV[i]))|"
                    }
                    i += 1
                }
                #endif
            }
            DataStr = DataStr + "serv-\(String(format:"%.2f", servicePay))"
            Data["name"] = DataStr
            print(Data)
            let defaults = UserDefaults.standard
            self.onePay = 0
            self.oneCheck = 0
            #if isKlimovsk12
            if selectLS == "Все"{
                let str_ls = UserDefaults.standard.string(forKey: "str_ls")!
                let str_ls_arr = str_ls.components(separatedBy: ",")
                UserDefaults.standard.set("_" + str_ls_arr[0], forKey: "payIdent")
                
            }else{
                UserDefaults.standard.set("_" + selectLS, forKey: "payIdent")
            }
            UserDefaults.standard.synchronize()
            Data["chargeFlag"] = "false"
            let shopCode = "215944"
            var shops:[Any] = []
            let shopItem = ["ShopCode" : shopCode, "Amount" : String(format:"%.2f", self.totalSum).replacingOccurrences(of: ".", with: ""), "Name" : "ТСЖ Климовск 12"] as [String : Any]
            shops.append(shopItem)
            let receiptData = ["Items" : items, "Email" : defaults.string(forKey: "mail")!, "Phone" : defaults.object(forKey: "login")! as? String ?? "", "Taxation" : "osn"] as [String : Any]
            let name = "Оплата услуг ЖКХ"
            let amount = NSNumber(floatLiteral: self.totalSum)
            defaults.set(defaults.string(forKey: "login"), forKey: "CustomerKey")
            defaults.synchronize()
            print(receiptData)
            if payType == 1{
                let address = PKContact()
                address.emailAddress = defaults.object(forKey: "mail")! as? String
                address.phoneNumber = CNPhoneNumber.init(stringValue: (defaults.object(forKey: "login")! as? String)!)
                PayController.buy(withApplePayAmount: amount, description: "", email: defaults.object(forKey: "mail")! as? String, appleMerchantId: "merchant.ru.sm-center.ru", shippingMethods: nil, shippingContact: address, shippingEditableFields: [PKAddressField.email, PKAddressField.phone], recurrent: false, additionalPaymentData: Data, receiptData: receiptData, shopsData: shops, shopsReceiptsData: nil, from: self, success: { (paymentInfo) in
                    
                }, cancelled:  {
                    
                }, error: { (error) in
                    let alert = UIAlertController(title: "Ошибка", message: "Сервер оплаты не отвечает. Попробуйте позже", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                })
            }else{
                PayController.buyItem(withName: name, description: "", amount: amount, recurrent: false, makeCharge: false, additionalPaymentData: Data, receiptData: receiptData, email: defaults.object(forKey: "mail")! as? String, shopsData: shops, shopsReceiptsData: nil, from: self, success: { (paymentInfo) in
                    
                }, cancelled:  {
                    
                }, error: { (error) in
                    let alert = UIAlertController(title: "Ошибка", message: "Сервер оплаты не отвечает. Попробуйте позже", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                })
            }
            #else
            let receiptData = ["Items" : items, "Email" : defaults.string(forKey: "mail")!, "Phone" : defaults.object(forKey: "login")! as? String ?? "", "Taxation" : "osn"] as [String : Any]
            let name = "Оплата услуг ЖКХ"
            let amount = NSNumber(floatLiteral: self.totalSum)
            defaults.set(defaults.string(forKey: "login"), forKey: "CustomerKey")
            defaults.synchronize()
            print(receiptData)
            if payType == 1{
                let address = PKContact()
                address.emailAddress = defaults.object(forKey: "mail")! as? String
                address.phoneNumber = CNPhoneNumber.init(stringValue: (defaults.object(forKey: "login")! as? String)!)
                PayController.buy(withApplePayAmount: amount, description: "", email: defaults.object(forKey: "mail")! as? String, appleMerchantId: "merchant.ru.Mytischi", shippingMethods: nil, shippingContact: address, shippingEditableFields: [PKAddressField.email, PKAddressField.phone], recurrent: false, additionalPaymentData: Data, receiptData: receiptData, from: self, success: { (paymentInfo) in
                    
                }, cancelled:  {
                    
                }, error: { (error) in
                    let alert = UIAlertController(title: "Ошибка", message: "Сервер оплаты не отвечает. Попробуйте позже", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                })
            }else{
                PayController.buyItem(withName: name, description: "", amount: amount, recurrent: false, makeCharge: false, additionalPaymentData: Data, receiptData: receiptData, email: defaults.object(forKey: "mail")! as? String, from: self, success: { (paymentInfo) in
                    
                }, cancelled: {
                    
                }) { (error) in
                    let alert = UIAlertController(title: "Ошибка", message: "Сервер оплаты не отвечает. Попробуйте позже", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            #endif
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("", forKey: "payIdent")
        currPoint = 502
        let defaults     = UserDefaults.standard
        // Логин и пароль
        login = defaults.string(forKey: "login")
        pass  = defaults.string(forKey: "pass")
        nonConectView.isHidden = true
        lsLbl.isHidden = false
        ls_button.isHidden = false
        tableView.isHidden = false
        spinImg.isHidden = false
        sendView.isHidden = false
        // Заполним тек. год и тек. месяц
        iterYear         = defaults.string(forKey: "year_osv")!
        iterMonth        = defaults.string(forKey: "month_osv")!
        defaults.set("", forKey: "PaymentID")
        defaults.set("", forKey: "PaysError")
        defaults.set(false, forKey: "PaymentSucces")
        // Заполним лиц. счетами отбор
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
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
            lsLbl.isHidden = true
            ls_button.isHidden = true
            tableView.isHidden = true
            spinImg.isHidden = true
            sendView.isHidden = true
        }
        selectLS = "Все"
        dropper.showWithAnimation(0.001, options: Dropper.Alignment.center, button: ls_button)
        dropper.hideWithAnimation(0.001)
        
        if saldoIdent == "Все"{
            getData(ident: saldoIdent)
            //            end_osv()
        }else{
            ls_button.setTitle(saldoIdent, for: UIControlState.normal)
            selectLS = saldoIdent
            choiceIdent = saldoIdent
            getData(ident: saldoIdent)
        }
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        btnPay.backgroundColor = myColors.btnColor.uiColor()
        historyPay.backgroundColor = myColors.btnColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        viewTop.constant = self.getPoint()
        updateConectBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        sendView.isUserInteractionEnabled = true
        sendView.addGestureRecognizer(tap)
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
            lsLbl.isHidden = true
            ls_button.isHidden = true
            tableView.isHidden = true
            spinImg.isHidden = true
            sendView.isHidden = true
        case .wifi: break
            
        case .wwan: break
            
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectLS = ""
    
    var choiceIdent = "Все"
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        update = false
        ls_button.setTitle(contents, for: UIControlState.normal)
        if (contents == "Все"){
            selectLS = "Все"
            choiceIdent = "Все"
            getData(ident: contents)
        } else {
            selectLS = contents
            choiceIdent = contents
            getData(ident: contents)
        }
    }
    
    var uslugaArr  :[String] = []
    var endArr     :[String] = []
    var idArr      :[Int] = []
    
    func getData(ident: String){
        self.sum = 0
        select = false
        checkBox.removeAll()
        sumOSV.removeAll()
        osvc.removeAll()
        uslugaArr.removeAll()
        endArr.removeAll()
        idArr.removeAll()
        identOSV.removeAll()
        idOSV.removeAll()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Saldo")
        fetchRequest.predicate = NSPredicate.init(format: "num_month = %@ AND year = %@", String(self.iterMonth), String(self.iterYear))
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results {
                let object = result as! NSManagedObject
                //                if ident != "Все"{
                if UserDefaults.standard.string(forKey: "encoding_Pays") == "1"{
                    if (object.value(forKey: "ident") as! String) == ident{
                        if (object.value(forKey: "usluga") as! String) != "Я"{
                            sumOSV.append(Double(object.value(forKey: "end") as! String)!)
                            checkBox.append(true)
                            osvc.append(object.value(forKey: "usluga") as! String)
                            idOSV.append(Int(object.value(forKey: "id") as! Int64))
                            
                            uslugaArr.append(object.value(forKey: "usluga") as! String)
                            endArr.append(object.value(forKey: "end") as! String)
                            idArr.append(Int(object.value(forKey: "id") as! Int64))
                            identOSV.append(object.value(forKey: "ident") as! String)
                            if (object.value(forKey: "usluga") as! String) != "Я"{
                                self.sum = self.sum + Double(object.value(forKey: "end") as! String)!
                            }
                        }
                    }
                }else{
                    if (object.value(forKey: "ident") as! String) == ident{
                        if (object.value(forKey: "usluga") as! String) != "Я"{
                            if (object.value(forKey: "usluga") as! String) != "Я"{
                                self.sum = self.sum + Double(object.value(forKey: "end") as! String)!
                            }
                            if sumOSV.count == 0{
                                sumOSV.append(self.sum)
                                checkBox.append(true)
                                osvc.append("Услуги ЖКУ")
                                idOSV.append(Int(object.value(forKey: "id") as! Int64))
                                
                                uslugaArr.append("Услуги ЖКУ")
                                endArr.append(String(self.sum))
                                idArr.append(Int(object.value(forKey: "id") as! Int64))
                                identOSV.append(object.value(forKey: "ident") as! String)
                            }else{
                                sumOSV[0] = self.sum
                                endArr[0] = String(self.sum)
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    if (self.sum != 0) {
                        //                    self.txt_sum_jkh.text = String(format:"%.2f", self.sum) + " р."
                        #if isKlimovsk12
                        let serviceP = self.sum / 100 * 1.5
                        #else
                        let serviceP = self.sum / 0.992 - self.sum
                        #endif
                        self.servicePay.text  = String(format:"%.2f", serviceP) + " руб."
                        self.totalSum = self.sum + serviceP
                        self.txt_sum_obj.text = String(format:"%.2f", self.sum) + " руб."
                        self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
                        if self.debtArr.count != 0{
                            var s = 0.00
                            self.debtArr.forEach{
                                if self.choiceIdent == "Все"{
                                    s = s + Double($0["Sum"] as! String)!
                                    if s <= 0.00{
                                        for i in 0...self.checkBox.count - 1{
                                            self.checkBox[i] = false
                                        }
                                        self.txt_sum_obj.text = "0.00 руб."
                                        self.txt_sum_jkh.text = "0.00 руб."
                                        self.servicePay.text  = "0.00 руб."
                                    }
                                }else if self.choiceIdent == ($0["Ident"] as! String){
                                    if ($0["Sum"] as! String) == "0.00"{
                                        for i in 0...self.checkBox.count - 1{
                                            self.checkBox[i] = false
                                        }
                                        self.txt_sum_obj.text = "0.00 руб."
                                        self.txt_sum_jkh.text = "0.00 руб."
                                        self.servicePay.text  = "0.00 руб."
                                    }
                                }
                            }
                        }
                    } else {
                        //                    self.txt_sum_jkh.text = "0,00 р."
                        self.self.txt_sum_obj.text = "0.00 руб."
                        self.txt_sum_jkh.text = "0.00 руб."
                        self.servicePay.text  = "0.00 руб."
                    }
                })
                //                }
            }
            DispatchQueue.main.async(execute: {
                self.updateTable()
            })
            
        } catch {
            print(error)
        }
    }
    
//    func end_osv() {
//        self.sum = 0
//        select = false
//        checkBox.removeAll()
//        sumOSV.removeAll()
//        osvc.removeAll()
//        uslugaArr.removeAll()
//        endArr.removeAll()
//        idArr.removeAll()
//        identOSV.removeAll()
//        idOSV.removeAll()
//        // Выборка из БД последней ведомости - посчитаем сумму к оплате
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Saldo")
//        fetchRequest.predicate = NSPredicate.init(format: "num_month = %@ AND year = %@", String(self.iterMonth), String(self.iterYear))
//        do {
//            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
//            for result in results {
//                let object = result as! NSManagedObject
//                if (object.value(forKey: "usluga") as! String) != "Я"{
//                    sumOSV.append(Double(object.value(forKey: "end") as! String)!)
//                    checkBox.append(true)
//                    osvc.append(object.value(forKey: "usluga") as! String)
//                    idOSV.append(Int(object.value(forKey: "id") as! Int64))
//                    identOSV.append(object.value(forKey: "ident") as! String)
//                    self.sum = self.sum + Double(object.value(forKey: "end") as! String)!
//                }
//            }
//            DispatchQueue.main.async(execute: {
//                if (self.sum != 0) {
//                    //                    self.txt_sum_jkh.text = String(format:"%.2f", self.sum) + " р."
//                    #if isKlimovsk12
//                    let serviceP = self.sum / 100 * 1.5
//                    #else
//                    let serviceP = self.sum / 0.992 - self.sum
//                    #endif
//                    self.servicePay.text  = String(format:"%.2f", serviceP) + " руб."
//                    self.totalSum = self.sum + serviceP
//                    self.txt_sum_obj.text = String(format:"%.2f", self.sum) + " руб."
//                    self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
//                    if self.debtArr.count != 0{
//                        var s = 0.00
//                        self.debtArr.forEach{
//                            if self.choiceIdent == "Все"{
//                                s = s + Double($0["Sum"] as! String)!
//                                if s <= 0.00{
//                                    self.txt_sum_obj.text = "0.00 руб."
//                                    self.txt_sum_jkh.text = "0.00 руб."
//                                    self.servicePay.text  = "0.00 руб."
//                                }
//                            }else if self.choiceIdent == ($0["Ident"] as! String){
//                                if ($0["Sum"] as! String) == "0.00"{
//                                    self.txt_sum_obj.text = "0.00 руб."
//                                    self.txt_sum_jkh.text = "0.00 руб."
//                                    self.servicePay.text  = "0.00 руб."
//                                }
//                            }
//                        }
//                    }
//                } else {
//                    //                    self.txt_sum_jkh.text = "0,00 р."
//                    self.self.txt_sum_obj.text = "0.00 руб."
//                    self.txt_sum_jkh.text = "0.00 руб."
//                    self.servicePay.text  = "0.00 руб."
//                }
//                self.updateFetchedResultsController()
//            })
//
//        } catch {
//            print(error)
//        }
//    }
    
    func updateFetchedResultsController() {
        let predicateFormat = String(format: "num_month = %@ AND year = %@", iterMonth, iterYear)
        fetchedResultsController = CoreDataManager.instance.fetchedResultsControllerSaldo(entityName: "Saldo", keysForSort: ["usluga"], predicateFormat: predicateFormat) as NSFetchedResultsController<Saldo>
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        self.updateTable()
    }
    
    func updateTable() {
        self.tableView.reloadData()
    }
    
    var kol = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if choiceIdent == ""{
        //            if let sections = fetchedResultsController?.sections {
        //                let str_ls = UserDefaults.standard.string(forKey: "str_ls")
        //                let str_ls_arr = str_ls?.components(separatedBy: ",")
        //                kol = sections[section].numberOfObjects - 1 - (str_ls_arr?.count)!
        //                return sections[section].numberOfObjects - 1 - (str_ls_arr?.count)!
        //            } else {
        //                return 0
        //            }
        //        }else{
        if uslugaArr.count != 0 {
            kol = uslugaArr.count
            return uslugaArr.count
        } else {
            return 0
        }
        //        }
    }
    var update = false
    var select = false
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayMupCell") as! PayMupSaldoCell
        if select == false && update == false{
            cell.check.setImage(UIImage(named: "Check.png"), for: .normal)
        }else{
            if selectedRow >= 0{
                if checkBox[selectedRow]{
                    cell.check.setImage(UIImage(named: "unCheck.png"), for: .normal)
                    checkBox[selectedRow] = false
                }else{
                    cell.check.setImage(UIImage(named: "Check.png"), for: .normal)
                    checkBox[selectedRow] = true
                }
            }
        }
        cell.check.tintColor = myColors.btnColor.uiColor()
        cell.check.backgroundColor = .white
        //        if sumOSV.count != kol && selectedRow == -1{
        //            if choiceIdent == ""{
        //                let osv = fetchedResultsController!.object(at: indexPath)
        //                let sum:String = osv.end!
        //                osvc.append(osv.usluga!)
        //                checkBox.append(true)
        //                sumOSV.append(Double(sum)!)
        //                idOSV.append(Int(osv.id))
        //                identOSV.append(osv.ident!)
        //            }else{
        //                let sum:String = endArr[indexPath.row]
        //                osvc.append(uslugaArr[indexPath.row])
        //                checkBox.append(true)
        //                sumOSV.append(Double(sum)!)
        //                idOSV.append(Int(idArr[indexPath.row]))
        //            }
        //
        //        }
        var sub: String = ""
        if choiceIdent == ""{
            let osv = fetchedResultsController!.object(at: indexPath)
            if (osv.usluga == "Я") {
                cell.usluga.text = "ИТОГО"
            } else {
                cell.usluga.text = osv.usluga
            }
            cell.end.text    = osv.end
            sub = osv.usluga!
            cell.end.accessibilityIdentifier = sub + osv.ident!
        }else{
            if (uslugaArr[indexPath.row] == "Я") {
                cell.usluga.text = "ИТОГО"
            } else {
                cell.usluga.text = uslugaArr[indexPath.row]
            }
            cell.end.text    = endArr[indexPath.row]
            sub = uslugaArr[indexPath.row]
            cell.end.accessibilityIdentifier = sub
        }
        if checkBox[indexPath.row]{
            cell.check.setImage(UIImage(named: "Check.png"), for: .normal)
        }else{
            cell.check.setImage(UIImage(named: "unCheck.png"), for: .normal)
        }
        if choiceIdent == ""{
            let osv = fetchedResultsController!.object(at: indexPath)
            if (osv.usluga?.contains("газ"))! || osv.usluga == "Страховка"{
                cell.end.isUserInteractionEnabled = false
                cell.end.isHidden = true
                cell.endL.isHidden = false
                cell.endL.text = osv.end
            }else{
                cell.end.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                cell.end.addTarget(self, action: #selector(self.textFieldEditingDidEnd(_:)), for: .editingDidEnd)
                cell.end.isUserInteractionEnabled = true
                cell.endL.isHidden = true
                cell.end.isHidden = false
                //                print(osv.end)
                cell.end.text = osv.end
                if osvc.count != 0{
                    for i in 0...osvc.count - 1{
                        let code:String = osvc[i] + identOSV[i]
                        if cell.end.accessibilityIdentifier == code && sumOSV[i] != 0.00{
                            //                            print(code, sumOSV[i])
                            cell.end.text = String(sumOSV[i])
                        }
                    }
                }
            }
        }else{
            if (uslugaArr[indexPath.row].contains("газ")) || uslugaArr[indexPath.row] == "Страховка"{
                cell.end.isUserInteractionEnabled = false
                cell.end.isHidden = true
                cell.endL.isHidden = false
                cell.endL.text = endArr[indexPath.row]
            }else{
                cell.end.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                cell.end.addTarget(self, action: #selector(self.textFieldEditingDidEnd(_:)), for: .editingDidEnd)
                cell.end.isUserInteractionEnabled = true
                cell.endL.isHidden = true
                cell.end.isHidden = false
                cell.end.text = endArr[indexPath.row]
                if osvc.count != 0{
                    for i in 0...osvc.count - 1{
                        let code:String = osvc[i]
                        if cell.end.accessibilityIdentifier == code && sumOSV[i] != 0.00{
                            cell.end.text = String(sumOSV[i])
                        }
                    }
                }
            }
        }
        cell.delegate = self
        select = false
        selectedRow = -1
        //        #endif
        return cell
    }
    
    var editRow = IndexPath()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        editRow = indexPath
        update = true
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
        #if isKlimovsk12
        let serviceP = self.sum / 100 * 1.5
        #else
        let serviceP = self.sum / 0.992 - self.sum
        #endif
        self.servicePay.text  = String(format:"%.2f", serviceP) + " руб."
        self.totalSum = self.sum + serviceP
        self.txt_sum_obj.text = String(format:"%.2f", self.sum) + " руб."
        self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
//        if self.debtArr.count != 0{
//            var s = 0.00
//            self.debtArr.forEach{
//                if choiceIdent == "Все"{
//                    s = s + Double($0["Sum"] as! String)!
//                    if s <= 0.00{
//                        self.txt_sum_obj.text = "0.00 руб."
//                        self.txt_sum_jkh.text = "0.00 руб."
//                        self.servicePay.text  = "0.00 руб."
//                    }
//                }else if self.choiceIdent == ($0["Ident"] as! String){
//                    if ($0["Sum"] as! String) == "0.00"{
//                        self.txt_sum_obj.text = "0.00 руб."
//                        self.txt_sum_jkh.text = "0.00 руб."
//                        self.servicePay.text  = "0.00 руб."
//                    }
//                }
//            }
//        }
    }
    
    @objc func textFieldEditingDidEnd(_ textField: UITextField) {
        var str:String = textField.text!
        str = str.replacingOccurrences(of: ",", with: ".")
        if str == ""{
            str = "0.00"
        }
        if !str.contains("."){
            str = str + ".00"
        }
        if str.suffix(1) == "."{
            str = str + "00"
        }
        textField.text = str
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var str: String = textField.text!
        str = str.replacingOccurrences(of: ",", with: ".")
        if str != "" && str != "-"{
            for i in 0...osvc.count - 1{
                var code:String = osvc[i]
                //                if choiceIdent == "Все"{
                //                    code = code + identOSV[i]
                //                }
                if (textField.accessibilityIdentifier == code){
                    sumOSV[i] = Double(str)!
                }
            }
            self.sum = 0.00
            var i = 0
            sumOSV.forEach{
                if checkBox[i] == true{
                    self.sum = self.sum + $0
                }
                i += 1
            }
            #if isKlimovsk12
            let serviceP = self.sum / 100 * 1.5
            #else
            let serviceP = self.sum / 0.992 - self.sum
            #endif
            self.servicePay.text  = String(format:"%.2f", serviceP) + " руб."
            self.totalSum = self.sum + serviceP
            self.txt_sum_obj.text = String(format:"%.2f", self.sum) + " руб."
            self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
//            if self.debtArr.count != 0{
//                var s = 0.00
//                self.debtArr.forEach{
//                    if choiceIdent == "Все"{
//                        s = s + Double($0["Sum"] as! String)!
//                        if s <= 0.00{
//                            self.txt_sum_obj.text = "0.00 руб."
//                            self.txt_sum_jkh.text = "0.00 руб."
//                            self.servicePay.text  = "0.00 руб."
//                        }
//                    }else if self.choiceIdent == ($0["Ident"] as! String){
//                        if ($0["Sum"] as! String) == "0.00"{
//                            self.txt_sum_obj.text = "0.00 руб."
//                            self.txt_sum_jkh.text = "0.00 руб."
//                            self.servicePay.text  = "0.00 руб."
//                        }
//                    }
//                }
//            }
        }else{
            for i in 0...osvc.count - 1{
                var code:String = osvc[i]
                //                if choiceIdent == "Все"{
                //                    code = code + identOSV[i]
                //                }
                if textField.accessibilityIdentifier == code{
                    sumOSV[i] = 0.00
                }
            }
            self.sum = 0.00
            var i = 0
            sumOSV.forEach{
                if checkBox[i] == true{
                    self.sum = self.sum + $0
                }
                i += 1
            }
            #if isKlimovsk12
            let serviceP = self.sum / 100 * 1.5
            #else
            let serviceP = self.sum / 0.992 - self.sum
            #endif
            self.servicePay.text  = String(format:"%.2f", serviceP) + " руб."
            self.totalSum = self.sum + serviceP
            self.txt_sum_obj.text = String(format:"%.2f", self.sum) + " руб."
            self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
//            if self.debtArr.count != 0{
//                var s = 0.00
//                self.debtArr.forEach{
//                    if choiceIdent == "Все"{
//                        s = s + Double($0["Sum"] as! String)!
//                        if s <= 0.00{
//                            self.txt_sum_obj.text = "0.00 руб."
//                            self.txt_sum_jkh.text = "0.00 руб."
//                            self.servicePay.text  = "0.00 руб."
//                        }
//                    }else if self.choiceIdent == ($0["Ident"] as! String){
//                        if ($0["Sum"] as! String) == "0.00"{
//                            self.txt_sum_obj.text = "0.00 руб."
//                            self.txt_sum_jkh.text = "0.00 руб."
//                            self.servicePay.text  = "0.00 руб."
//                        }
//                    }
//                }
//            }
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification?) {
        let viewHeight = view.frame.size.height
        if viewHeight == 667{
            viewTop.constant = getPoint() - 210 + 40
        }else if viewHeight == 736{
            viewTop.constant = getPoint() - 220 + 40
        }else if viewHeight == 568{
            viewTop.constant = getPoint() + 40
        }else{
            viewTop.constant = getPoint() - 240 + 40
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
        //        k = 0
        UserDefaults.standard.addObserver(self, forKeyPath: "PaysError", options:NSKeyValueObservingOptions.new, context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: "PaymentID", options:NSKeyValueObservingOptions.new, context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: "PaymentSucces", options:NSKeyValueObservingOptions.new, context: nil)
        // Подхватываем показ клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    var onePay = 0
    var oneCheck = 0
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if UserDefaults.standard.bool(forKey: "PaymentSucces") && oneCheck == 0{
            oneCheck = 1
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        }
        if (UserDefaults.standard.string(forKey: "PaysError") != "" || (UserDefaults.standard.string(forKey: "PaymentID") != "" && UserDefaults.standard.bool(forKey: "PaymentSucces"))) && onePay == 0{
            onePay = 1
            addMobilePay()
        }
    }
    
    func addMobilePay() {
        var ident: String = ""
        var idPay: String = UserDefaults.standard.string(forKey: "PaymentID")!
        if UserDefaults.standard.string(forKey: "PaymentID") == ""{
            idPay = "12345"
        }
        var status = ""
        if UserDefaults.standard.string(forKey: "PaysError") == ""{
            status = "Оплачен"
        }else{
            status = UserDefaults.standard.string(forKey: "PaysError")!
        }
        let sum = self.totalSum
        if selectLS == "Все"{
            let str_ls = UserDefaults.standard.string(forKey: "str_ls")!
            let str_ls_arr = str_ls.components(separatedBy: ",")
            for i in 0...str_ls_arr.count - 1{
                ident = str_ls_arr[0]
            }
        }else{
            ident = selectLS
        }
        let urlPath = Server.SERVER + "MobileAPI/AddPay.ashx?"
            + "idpay=" + idPay.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&status=" + status.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&ident=" + ident.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&desc=&sum=" + String(sum).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    UserDefaults.standard.set("Ошибка соединения с сервером", forKey: "errorStringSupport")
                                                    UserDefaults.standard.synchronize()
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
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                                                print("responseString = \(responseString)")
                                                UserDefaults.standard.setValue("", forKey: "PaysError")
                                                UserDefaults.standard.setValue("", forKey: "PaymentID")
                                                UserDefaults.standard.set(false, forKey: "PaymentSucces")
                                                if responseString != "ok"{
                                                    DispatchQueue.main.async(execute: {
                                                        let alert = UIAlertController(title: "Ошибка", message: responseString as String, preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ok", style: .default) { (_) -> Void in }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                }
                                                
        })
        
        task.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.removeObserver(self, forKeyPath: "PaymentID")
        UserDefaults.standard.removeObserver(self, forKeyPath: "PaysError")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
