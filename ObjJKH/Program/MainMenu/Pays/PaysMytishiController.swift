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
import YandexMobileAds
import GoogleMobileAds
//import YandexMobileMetrica

private protocol MainDataProtocol:  class {}

class PaysMytishiController: UIViewController, DropperDelegate, UITableViewDelegate, UITableViewDataSource, YMANativeAdDelegate, YMANativeAdLoaderDelegate, GADBannerViewDelegate {
    
    var adLoader: YMANativeAdLoader!
    var bannerView: YMANativeBannerView?
    var gadBannerView: GADBannerView!
    var request = GADRequest()
    
    @IBAction func backClick(_ sender: UIBarButtonItem){
        //        if UserDefaults.standard.bool(forKey: "NewMain"){
        navigationController?.popViewController(animated: true)
        //        }else{
        //            navigationController?.dismiss(animated: true, completion: nil)
        //        }
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
//    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var viewBot: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var historyPay: UIButton!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var paysPeriodLbl: UILabel!
    
    @IBOutlet weak var applePayBtn: UIButton!
    @IBOutlet weak var applePayView: UIView!
    @IBOutlet weak var applePayIcon: UIImageView!
    @IBOutlet weak var applePayWidth: NSLayoutConstraint!
    @IBOutlet weak var applePayLeft: NSLayoutConstraint!
    
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
    
    public var isHomePage:Bool = false
    
    var login: String?
    var pass: String?
    var currPoint = CGFloat()
    let dropper = Dropper(width: 150, height: 400)
    
    public var saldoIdent = "Все"
    public var debtArr:[AnyObject] = []
    public var endSum = ""
    
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    @IBOutlet weak var ls_button: UIButton!
    @IBOutlet weak var txt_sum_jkh: UILabel!
    @IBOutlet weak var txt_sum_obj: UILabel!
    @IBOutlet weak var textSum: UILabel!
    @IBOutlet weak var textService: UILabel!
    @IBOutlet weak var paysViewHeight: NSLayoutConstraint!
    
    @objc private func lblTapped(_ sender: UITapGestureRecognizer) {
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "addLSMup", sender: self)
        #elseif isPocket
        self.performSegue(withIdentifier: "addLSPocket", sender: self)
        //        #elseif isRodnikMUP
        //        self.performSegue(withIdentifier: "addLSSimple", sender: self)
        #else
        //        self.performSegue(withIdentifier: "addLS", sender: self)
        self.performSegue(withIdentifier: "addLSSimple", sender: self)
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
    @IBAction func applePayAction(_ sender: UIButton) {
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
            let alert = UIAlertController(title: "Электронный чек", message: "Укажите e-mail", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "e-mail..."
                textField.keyboardType = .emailAddress
            }
            let cancelAction = UIAlertAction(title: "Сохранить", style: .default) { (_) -> Void in
                let textField = alert.textFields![0]
                let str = textField.text
                let validEmail = DB().isValidEmail(testStr: str!)
                if validEmail{
                    UserDefaults.standard.set(str, forKey: "mail")
                    self.payType = 1
                    self.payedT()
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
            self.payType = 1
            self.payedT()
        }
    }
    @IBAction func Payed(_ sender: UIButton) {
        var l = false
        //        #if isUKKomfort
        //        self.payedS()
        //        #elseif isStolitsa
        //        #if isKlimovsk12 || isMupRCMytishi || isUpravdomChe || isReutKomfort || isServiceKomfort || isServicekom || isUKGarant || isParus || isTeplovodoresources || isStroimBud || isRodnikMUP || isUKParitetKhab
        #if isKlimovsk12 || isMupRCMytishi || isUpravdomChe || isReutKomfort || isServicekom || isUKGarant || isParus || isTeplovodoresources || isStroimBud || isRodnikMUP || isUKParitetKhab || isAFregat || isRodnikMUP || isElectroSbitSaratov || isJKH_Pavlovskoe || isNewOpaliha || isPritomskoe || isDJVladimir || isSibAliance || isTSJ_Rachangel || isMUP_IRKC || isNarianMarEl || isParitet || isTSN_Ruble40 || isEnergoProgress
        l = true
        #else
        self.payedS()
        #endif
        if l{
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
                let alert = UIAlertController(title: "Электронный чек", message: "Укажите e-mail", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "e-mail..."
                    textField.keyboardType = .emailAddress
                }
                let cancelAction = UIAlertAction(title: "Сохранить", style: .default) { (_) -> Void in
                    let textField = alert.textFields![0]
                    let str = textField.text
                    let validEmail = DB().isValidEmail(testStr: str!)
                    if validEmail{
                        UserDefaults.standard.set(str, forKey: "mail")
                        self.payType = 0
                        self.payedT()
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
            } else {
                self.payType = 0
                self.payedT()
            }
        }
    }
    
    private func payedS() {
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
        let k:String = txt_sum_jkh.text!.replacingOccurrences(of: ",", with: ".")
        self.totalSum = Double(k.replacingOccurrences(of: " руб.", with: ""))!
        if (self.totalSum <= 0) {
            let alert = UIAlertController(title: "Ошибка", message: "Нет суммы к оплате", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            defaults.setValue(String(describing: self.totalSum), forKey: "sum")
            defaults.synchronize()
            self.performSegue(withIdentifier: "CostPay_New", sender: self)
        }
    }
    
    var payType = 0
    private func payedT(){
        let k:String = txt_sum_jkh.text!
        let l:String = txt_sum_obj.text!
        var shopCode = ""
        var targetName = ""
        #if isKlimovsk12
        shopCode = "215944"
        targetName = "ТСЖ Климовск 12"
        #elseif isUpravdomChe
        shopCode = "245322"
        targetName = "УК Упрадом Чебоксары"
        #elseif isReutKomfort
        shopCode = "234821"
        targetName = "УК РеутКомфорт"
        //        #elseif isServiceKomfort
        //        shopCode = "252187"
        //        targetName = "УК Сервис и Комфорт"
        #elseif isServicekom
        shopCode = "254158"
        targetName = "Сервиском"
        #elseif isUKGarant
        shopCode = "256133"
        targetName = "УК Гарант"
        #elseif isParus
        shopCode = "256138"
        targetName = "РКЦ Парус"
        #elseif isTeplovodoresources
        shopCode = "256310"
        targetName = "Тепловодоресурс"
        #elseif isStroimBud
        shopCode = "254788"
        targetName = "Строим будущее"
        #elseif isUKParitetKhab
        shopCode = "255262"
        targetName = "УК Паритет Хабаровск"
        #elseif isAFregat
        shopCode = "260713"
        targetName = "ТСЖ Фрегат"
        #elseif isRodnikMUP
        shopCode = "252087"
        targetName = "МУП Родник"
        #elseif isElectroSbitSaratov
        shopCode = "252095"
        targetName = "Электросбыт Саратов"
        #elseif isJKH_Pavlovskoe
        shopCode = "261606"
        targetName = "Павловское ЖКХ"
        #elseif isNewOpaliha
        targetName = "ТСЖ Новая Опалиха"
        debtArr.forEach{
            if debtArr.count > 1{
                if String($0["Ident"] as! String) == selectLS{
                    if String($0["HouseId"] as! String) == "1"{
                        shopCode = "275451"
                    }else if String($0["HouseId"] as! String) == "2"{
                        shopCode = "275443"
                    }else if String($0["HouseId"] as! String) == "3"{
                        shopCode = "275438"
                    }else if String($0["HouseId"] as! String) == "4"{
                        shopCode = "275399"
                    }else if String($0["HouseId"] as! String) == "5"{
                        shopCode = "275395"
                    }else if String($0["HouseId"] as! String) == "6"{
                        shopCode = "275374"
                    }
                }
            }else{
                if String($0["HouseId"] as! String) == "1"{
                    shopCode = "275451"
                }else if String($0["HouseId"] as! String) == "2"{
                    shopCode = "275443"
                }else if String($0["HouseId"] as! String) == "3"{
                    shopCode = "275438"
                }else if String($0["HouseId"] as! String) == "4"{
                    shopCode = "275399"
                }else if String($0["HouseId"] as! String) == "5"{
                    shopCode = "275395"
                }else if String($0["HouseId"] as! String) == "6"{
                    shopCode = "275374"
                }
            }
        }
        #elseif isPritomskoe
        shopCode = "263200"
        targetName = "Притомское РКЦ"
        #elseif isDJVladimir
        shopCode = "258724"
        targetName = "ДОМЖИЛСЕРВИС Владимир"
        #elseif isSibAliance
        shopCode = "259876"
        targetName = "УК Сибирский Альянс"
        #elseif isTSJ_Rachangel
        shopCode = "265024"
        targetName = "ТСЖ Архангельское"
        #elseif isMUP_IRKC
        shopCode = "266061"
        targetName = "МУП ИРКЦ"
        #elseif isNarianMarEl
        shopCode = "259873"
        targetName = "Нарьян-Марская электростанция"
        #elseif isParitet
        shopCode = "266564"
        targetName = "УК Паритет"
        #elseif isTSN_Ruble40
        targetName = "ТСН Рублевский 40"
        debtArr.forEach{
            if debtArr.count > 1{
                if String($0["Ident"] as! String) == selectLS{
                    if String($0["HouseId"] as! String) == "3"{
                        shopCode = "272890"
                        if (selectLS.containsIgnoringCase(find: "k") || selectLS.containsIgnoringCase(find: "к")){
                            shopCode = "281492"
                        }
                    }else if String($0["HouseId"] as! String) == "5"{
                        shopCode = "272878"
                        if (selectLS.containsIgnoringCase(find: "k") || selectLS.containsIgnoringCase(find: "к")){
                            shopCode = "281496"
                        }
                    }else if String($0["HouseId"] as! String) == "10"{
                        shopCode = "272890"
                    }
                }
            }else{
                if String($0["HouseId"] as! String) == "3"{
                    shopCode = "272890"
                    if (selectLS.containsIgnoringCase(find: "k") || selectLS.containsIgnoringCase(find: "к")){
                        shopCode = "281492"
                    }
                }else if String($0["HouseId"] as! String) == "5"{
                    shopCode = "272878"
                    if (selectLS.containsIgnoringCase(find: "k") || selectLS.containsIgnoringCase(find: "к")){
                        shopCode = "281496"
                    }
                }else if String($0["HouseId"] as! String) == "10"{
                    shopCode = "272890"
                }
            }
        }
        #elseif isEnergoProgress
        shopCode = "280632"
        targetName = "Энергопрогресс"
        #endif
        self.totalSum = Double(k.replacingOccurrences(of: " руб.", with: ""))!
        self.sum = Double(l.replacingOccurrences(of: " руб.", with: ""))!
        if (self.totalSum <= 0) {
            let alert = UIAlertController(title: "Ошибка", message: "Нет суммы к оплате", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            items.removeAll()
            let servicePay = totalSum - self.sum
            var i = 0
            var k = false
            checkBox.forEach{
                if $0 == true && sumOSV[i] < 0{
                    k = true
                }
                i += 1
            }
            i = 0
            if k{
                let price = String(format:"%.2f", self.totalSum).replacingOccurrences(of: ".", with: "")
                #if isKlimovsk12
                var ItemsData: [String : Any] = [:]
                if i == 0{
                    ItemsData = ["ShopCode" : shopCode, "Name" : "Услуга ЖКУ", "Price" : Int(String(format:"%.2f", self.sum).replacingOccurrences(of: ".", with: ""))!, "Quantity" : Double(1.00), "Amount" : Int(String(format:"%.2f", self.sum).replacingOccurrences(of: ".", with: ""))!, "Tax" : "none", "QUANTITY_SCALE_FACTOR" : 3] as [String : Any]
                    items.append(ItemsData)
                }
                #elseif isMupRCMytishi
                let ItemsData = ["Name" : "Услуга ЖКУ", "Price" : Int(price)!, "Quantity" : Double(1.00), "Amount" : Int(price)!, "Tax" : "none"] as [String : Any]
                items.append(ItemsData)
                #else
                let ItemsData = ["ShopCode" : shopCode, "Name" : "Услуга ЖКУ", "Price" : Int(price)!, "Quantity" : Double(1.00), "Amount" : Int(price)!, "Tax" : "none", "QUANTITY_SCALE_FACTOR" : 3] as [String : Any]
                items.append(ItemsData)
                #endif
            }else{
                checkBox.forEach{
                    if $0 == true && sumOSV[i] > 0.00{
                        let price = String(format:"%.2f", sumOSV[i]).replacingOccurrences(of: ".", with: "")
                        #if isKlimovsk12
                        var ItemsData: [String : Any] = [:]
                        if i == 0{
                            ItemsData = ["ShopCode" : shopCode, "Name" : "Услуга ЖКУ", "Price" : Int(String(format:"%.2f", self.sum).replacingOccurrences(of: ".", with: ""))!, "Quantity" : Double(1.00), "Amount" : Int(String(format:"%.2f", self.sum).replacingOccurrences(of: ".", with: ""))!, "Tax" : "none", "QUANTITY_SCALE_FACTOR" : 3] as [String : Any]
                            items.append(ItemsData)
                        }
                        #elseif isMupRCMytishi
                        let ItemsData = ["Name" : osvc[i], "Price" : Int(price)!, "Quantity" : Double(1.00), "Amount" : Int(price)!, "Tax" : "none"] as [String : Any]
                        items.append(ItemsData)
                        #else
                        let ItemsData = ["ShopCode" : shopCode, "Name" : osvc[i], "Price" : Int(price)!, "Quantity" : Double(1.00), "Amount" : Int(price)!, "Tax" : "none", "QUANTITY_SCALE_FACTOR" : 3] as [String : Any]
                        items.append(ItemsData)
                        #endif
                    }
                    i += 1
                }
                if servicePay != 0{
                    let servicePrice = String(format:"%.2f", servicePay).replacingOccurrences(of: ".", with: "")
                    #if isMupRCMytishi
                    let ItemsData = ["Name" : "Сервисный сбор", "Price" : Int(servicePrice)!, "Quantity" : Double(1.00), "Amount" : Int(servicePrice)!, "Tax" : "none"] as [String : Any]
                    items.append(ItemsData)
                    #else
                    let ItemsData = ["ShopCode" : shopCode, "Name" : "Сервисный сбор", "Price" : Int(servicePrice)!, "Quantity" : Double(1.00), "Amount" : Int(servicePrice)!, "Tax" : "none"] as [String : Any]
                    items.append(ItemsData)
                    #endif
                }
            }
            
            var Data:[String:String] = [:]
            var DataStr: String = ""
            if selectLS == "Все"{
                let str_ls = UserDefaults.standard.string(forKey: "str_ls")!
                let str_ls_arr = str_ls.components(separatedBy: ",")
                for i in 0...str_ls_arr.count - 1{
                    DataStr = DataStr + "ls\(i + 1)-\(str_ls_arr[0])|"
                }
            }else{
                DataStr = "ls1-\(selectLS.stringByAddingPercentEncodingForRFC3986() ?? "")|"
            }
            DataStr = DataStr + "|"
            i = 0
            if items.count > 8{
                DataStr = DataStr + "Кол - Превышено|"
            }else{
                #if isKlimovsk12
                DataStr = DataStr + "1-\(String(format:"%.2f", self.sum))|"
                #elseif isMupRCMytishi
                if k{
                    DataStr = DataStr + "usluga-\(String(format:"%.2f", self.totalSum))|"
                }else{
                    checkBox.forEach{
                        if $0 == true && sumOSV[i] > 0.00{
                            DataStr = DataStr + "\(String(idOSV[i]))-\(String(format:"%.2f", sumOSV[i]))|"
                        }
                        i += 1
                    }
                }
                #else
                if k{
                    DataStr = DataStr + "0-\(String(format:"%.2f", self.totalSum))|"
                }else{
                    checkBox.forEach{
                        if $0 == true && sumOSV[i] > 0.00{
                            DataStr = DataStr + "\(String(idOSV[i]))-\(String(format:"%.2f", sumOSV[i]))|"
                        }
                        i += 1
                    }
                }
                #endif
            }
            if k == false{
                DataStr = DataStr + "serv-\(String(format:"%.2f", servicePay))"
            }
            Data["name"] = DataStr
            let defaults = UserDefaults.standard
            self.onePay = 0
            self.oneCheck = 0
            #if isMupRCMytishi
            let receiptData = ["Items" : items, "Email" : defaults.string(forKey: "mail")!, "Phone" : defaults.object(forKey: "login")! as? String ?? "", "Taxation" : "osn"] as [String : Any]
            let name = "МУП РЦ Мытищи"
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
            //            #elseif isKlimovsk12 || isUpravdomChe || isReutKomfort || isServiceKomfort || isServicekom || isUKGarant || isParus || isTeplovodoresources || isStroimBud || isRodnikMUP || isUKParitetKhab
            #elseif isKlimovsk12 || isUpravdomChe || isReutKomfort || isServicekom || isUKGarant || isParus || isTeplovodoresources || isStroimBud || isRodnikMUP || isUKParitetKhab || isAFregat || isRodnikMUP || isElectroSbitSaratov || isJKH_Pavlovskoe || isNewOpaliha || isPritomskoe || isDJVladimir || isSibAliance || isTSJ_Rachangel || isMUP_IRKC || isNarianMarEl || isParitet || isTSN_Ruble40
            if selectLS == "Все"{
                let str_ls = UserDefaults.standard.string(forKey: "str_ls")!
                let str_ls_arr = str_ls.components(separatedBy: ",")
                UserDefaults.standard.set("_" + str_ls_arr[0], forKey: "payIdent")
                
            }else{
                UserDefaults.standard.set("_" + selectLS.stringByAddingPercentEncodingForRFC3986()!, forKey: "payIdent")
            }
            UserDefaults.standard.synchronize()
            Data["chargeFlag"] = "false"
            var shops:[Any] = []
            let shopItem = ["ShopCode" : shopCode, "Amount" : String(format:"%.2f", self.totalSum).replacingOccurrences(of: ".", with: ""), "Name" : targetName] as [String : Any]
            shops.append(shopItem)
            print(shops)
            let receiptData = ["Items" : items, "Email" : defaults.string(forKey: "mail")!, "Phone" : defaults.object(forKey: "login")! as? String ?? "", "Taxation" : "osn"] as [String : Any]
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
                PayController.buyItem(withName: targetName, description: "", amount: amount, recurrent: false, makeCharge: false, additionalPaymentData: Data, receiptData: receiptData, email: defaults.object(forKey: "mail")! as? String, shopsData: shops, shopsReceiptsData: nil, from: self, success: { (paymentInfo) in
                    
                }, cancelled:  {
                    
                }, error: { (error) in
                    let alert = UIAlertController(title: "Ошибка", message: "Сервер оплаты не отвечает. Попробуйте позже", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                })
            }
            #endif
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults     = UserDefaults.standard
//        let params : [String : Any] = ["Переход на страницу": "Оплата"]
//        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { (error) in
//            //            print("DID FAIL REPORT EVENT: %@", message)
//            print("REPORT ERROR: %@", error.localizedDescription)
//        })
        UserDefaults.standard.set("", forKey: "payIdent")
        if UserDefaults.standard.double(forKey: "servPercent") == 0.00{
            currPoint = 492
            paysViewHeight.constant = 135
            txt_sum_jkh.isHidden = true
            servicePay.text = "Комиссия не взимается"
            servicePay.textColor = .lightGray
            textSum.isHidden = true
            textService.isHidden = true
        }else{
            currPoint = 462
            paysViewHeight.constant = 165
            txt_sum_jkh.isHidden = false
            servicePay.isHidden = false
            textSum.isHidden = false
            textService.isHidden = false
        }
        #if isDJ
        currPoint = 522
        paysViewHeight.constant = 110
        txt_sum_jkh.isHidden = true
        servicePay.text = "Комиссия не взимается"
        servicePay.textColor = .lightGray
        servicePay.isHidden = true
        textSum.isHidden = true
        textService.isHidden = true
        #endif
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
//        viewTop.constant = self.getPoint()
        viewBot.constant = 0
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
        if defaults.bool(forKey: "show_Ad"){
            self.supportView.isHidden = true
            if defaults.integer(forKey: "ad_Type") == 2{
                let configuration = YMANativeAdLoaderConfiguration(blockID: defaults.string(forKey: "adsCode")!,
                                                                   imageSizes: [kYMANativeImageSizeMedium],
                                                                   loadImagesAutomatically: true)
                self.adLoader = YMANativeAdLoader(configuration: configuration)
                self.adLoader.delegate = self
                loadAd()
            }else if defaults.integer(forKey: "ad_Type") == 3{
                gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
                //                gadBannerView.adUnitID = "ca-app-pub-5483542352686414/5099103340"
                gadBannerView.adUnitID = defaults.string(forKey: "adsCode")
                gadBannerView.rootViewController = self
                addBannerViewToView(gadBannerView)
                gadBannerView.delegate = self
                gadBannerView.load(request)
            }
        }
        #if isMupRCMytishi
        applePayIcon.setImageColor(color: .white)
        applePayView.isHidden = false
        applePayWidth.constant = 160
        applePayLeft.constant = 10
        #else
        applePayView.isHidden = true
        applePayWidth.constant = 0
        applePayLeft.constant = 0
        #endif
        if UserDefaults.standard.string(forKey: "periodPays") != ""{
            paysPeriodLbl.text = "Оплата производится по квитанции за \(UserDefaults.standard.string(forKey: "periodPays") ?? "")"
        }else{
            paysPeriodLbl.text = ""
            tableViewTop.constant = 110
        }
        paysPeriodLbl.textColor = myColors.btnColor.uiColor()
        if isHomePage{
            tableViewTop.constant = 70
            lsLbl.isHidden = true
            ls_button.isHidden = true
            spinImg.isHidden = true
        }
        #if isDJ
        DispatchQueue.main.async(execute: {
            let sumDebt = UserDefaults.standard.double(forKey: "sumDebt")
            if sumDebt > 0 && sumDebt < 10000{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnePageController") as! OnePageController
                vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                self.addChildViewController(vc)
                self.view.addSubview(vc.view)
            }else if sumDebt > 10000{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnePageController") as! OnePageController
                vc.view.backgroundColor = UIColor.black.withAlphaComponent(0)
                self.addChildViewController(vc)
                let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "TwoPageController") as! TwoPageController
                vc1.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                self.addChildViewController(vc1)
                self.view.addSubview(vc1.view)
                self.view.addSubview(vc.view)
            }
        })
        #endif
        // Do any additional setup after loading the view.
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView){
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            let bannerView = bannerView
            let layoutGuide = self.view.safeAreaLayoutGuide
            let constraints = [
                bannerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
                bannerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
                bannerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 2)
            ]
            NSLayoutConstraint.activate(constraints)
        } else {
            let views = ["bannerView" : bannerView]
            let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[bannerView]-(10)-|",
                                                            options: [],
                                                            metrics: nil,
                                                            views: views)
            let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[bannerView]-(10)-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: views)
            self.view.addConstraints(horizontal)
            self.view.addConstraints(vertical)
        }
        DispatchQueue.main.async {
            self.adHeight = bannerView.frame.size.height - 35
//            self.viewTop.constant = self.getPoint() - bannerView.frame.size.height + 10
            self.viewBot.constant = bannerView.frame.size.height - 35
        }
    }
    
    func loadAd() {
        self.adLoader.loadAd(with: nil)
    }
    var adHeight = CGFloat()
    func didLoadAd(_ ad: YMANativeGenericAd) {
        ad.delegate = self
        self.bannerView?.removeFromSuperview()
        let bannerView = YMANativeBannerView(frame: CGRect.zero)
        bannerView.ad = ad
        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.bannerView = bannerView
        if #available(iOS 11.0, *) {
            displayAdAtBottomOfSafeArea();
        } else {
            displayAdAtBottom();
        }
        DispatchQueue.main.async {
            self.adHeight = bannerView.frame.size.height - 35
//            self.viewTop.constant = self.getPoint() - bannerView.frame.size.height + 10
            self.viewBot.constant = bannerView.frame.size.height - 35
            //            print("ViewTOP: ", self.viewTop.constant)
        }
    }
    
    func displayAdAtBottom() {
        let views = ["bannerView" : self.bannerView!]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[bannerView]-(10)-|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[bannerView]-(10)-|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views)
        self.view.addConstraints(horizontal)
        self.view.addConstraints(vertical)
    }
    
    @available(iOS 11.0, *)
    func displayAdAtBottomOfSafeArea() {
        let bannerView = self.bannerView!
        let layoutGuide = self.view.safeAreaLayoutGuide
        let constraints = [
            bannerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            bannerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            bannerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 2)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - YMANativeAdDelegate
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeAppInstallAd) {
        print("Loaded App Install ad")
        didLoadAd(ad)
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeContentAd) {
        print("Loaded Content ad")
        didLoadAd(ad)
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didFailLoadingWithError error: Error) {
        print("Native ad loading error: \(error)")
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
        if isHomePage == false{
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
                                sumOSV.append(Double(String(format:"%.2f", Double(object.value(forKey: "end") as! String)!)) as! Double)
                                checkBox.append(true)
                                osvc.append(object.value(forKey: "usluga") as! String)
                                idOSV.append(Int(object.value(forKey: "id") as! Int64))
                                
                                uslugaArr.append(object.value(forKey: "usluga") as! String)
                                endArr.append(String(format:"%.2f", Double(object.value(forKey: "end") as! String)!))
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
                                    print(self.sum, String(format:"%.2f", self.sum))
                                    sumOSV.append(Double(String(format:"%.2f", self.sum)) as! Double)
                                    checkBox.append(true)
                                    osvc.append("Услуги ЖКУ")
                                    idOSV.append(Int(object.value(forKey: "id") as! Int64))
                                    
                                    uslugaArr.append("Услуги ЖКУ")
                                    endArr.append(String(format:"%.2f", self.sum))
                                    idArr.append(Int(object.value(forKey: "id") as! Int64))
                                    identOSV.append(object.value(forKey: "ident") as! String)
                                }else{
                                    sumOSV[0] = Double(String(format:"%.2f", self.sum)) as! Double
                                    endArr[0] = String(format:"%.2f", self.sum)
                                }
                            }else if results.count == 1{
                                self.sum = self.sum + Double(object.value(forKey: "end") as! String)!
                                if sumOSV.count == 0{
                                    print(self.sum, String(format:"%.2f", self.sum))
                                    sumOSV.append(Double(String(format:"%.2f", self.sum)) as! Double)
                                    checkBox.append(true)
                                    osvc.append("Услуги ЖКУ")
                                    idOSV.append(Int(object.value(forKey: "id") as! Int64))
                                    
                                    uslugaArr.append("Услуги ЖКУ")
                                    endArr.append(String(format:"%.2f", self.sum))
                                    idArr.append(Int(object.value(forKey: "id") as! Int64))
                                    identOSV.append(object.value(forKey: "ident") as! String)
                                }else{
                                    sumOSV[0] = Double(String(format:"%.2f", self.sum)) as! Double
                                    endArr[0] = String(format:"%.2f", self.sum)
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async(execute: {
                        if (self.sum > 0) {
                            let serviceP = (self.sum / (1 - (UserDefaults.standard.double(forKey: "servPercent") / 100))) - self.sum
                            self.servicePay.text  = String(format:"%.2f", serviceP) + " руб."
                            self.totalSum = self.sum + serviceP
                            self.txt_sum_obj.text = String(format:"%.2f", self.sum) + " руб."
                            self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
                        } else {
                            //                    self.txt_sum_jkh.text = "0,00 р."
                            self.txt_sum_obj.text = "0.00 руб."
                            self.txt_sum_jkh.text = "0.00 руб."
                            self.servicePay.text  = "0.00 руб."
                        }
                    })
                    //                }
                }
                if (uslugaArr.count == 0) {
                    sumOSV.append(Double(String(format:"%.2f", self.sum)) as! Double)
                    checkBox.append(true)
                    osvc.append("Услуги ЖКУ")
                    idOSV.append(0)
                    
                    uslugaArr.append("Услуги ЖКУ")
                    endArr.append(String(format:"%.2f", self.sum))
                    idArr.append(0)
                    identOSV.append(ident)
                }
                #if isDJ
                self.debtArr.forEach{
                    if String($0["Ident"] as! String) == ident{
                        if String($0["InsuranceSum"] as! String) != "" && String($0["InsuranceSum"] as! String) != "0.00" && String($0["InsuranceSum"] as! String) != "0"{
                            let suInsur: Double = Double($0["InsuranceSum"] as! String)!
                            sumOSV.append(Double(String(format:"%.2f", suInsur)) as! Double)
                            checkBox.append(true)
                            osvc.append("Страховой сбор")
                            idOSV.append(1)
                            
                            uslugaArr.append("Страховой сбор")
                            endArr.append(String(format:"%.2f", suInsur))
                            idArr.append(1)
                            identOSV.append(ident)
                            DispatchQueue.main.async(execute: {
                                self.totalSum = self.sum + suInsur
                                self.txt_sum_obj.text = String(format:"%.2f", self.totalSum) + " руб."
                                self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
                            })
                        }
                    }else if ident == "Все"{
                        if String(self.debtArr[0]["InsuranceSum"] as! String) != "" && String(self.debtArr[0]["InsuranceSum"] as! String) != "0.00" && String(self.debtArr[0]["InsuranceSum"] as! String) != "0"{
                            let suInsur: Double = Double(self.debtArr[0]["InsuranceSum"] as! String)!
                            sumOSV.append(Double(String(format:"%.2f", suInsur)) as! Double)
                            checkBox.append(true)
                            osvc.append("Страховой сбор")
                            idOSV.append(1)
                            
                            uslugaArr.append("Страховой сбор")
                            endArr.append(String(format:"%.2f", suInsur))
                            idArr.append(1)
                            identOSV.append(ident)
                            DispatchQueue.main.async(execute: {
                                self.totalSum = self.sum + suInsur
                                self.txt_sum_obj.text = String(format:"%.2f", self.totalSum) + " руб."
                                self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
                            })
                        }
                    }
                }
                #endif
                DispatchQueue.main.async(execute: {
                    if UserDefaults.standard.double(forKey: "servPercent") == 0.00{
                        self.servicePay.text = "Комиссия не взимается"
                        self.servicePay.textColor = .lightGray
                    }
                    self.updateTable()
                })
                
            } catch {
                print(error)
            }
        }else{
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
                    s = s + Double($0["Sum"] as! String)!
                    if ($0["Sum"] as! String) == "0.00"{
                        for i in 0...self.checkBox.count - 1{
                            self.checkBox[i] = false
                        }
                        self.txt_sum_obj.text = "0.00 руб."
                        self.txt_sum_jkh.text = "0.00 руб."
                        self.servicePay.text  = "0.00 руб."
                    }
                }
                //                                print(s)
            }
            if s > 0{
                self.sum = s
                let serviceP = (self.sum / (1 - (UserDefaults.standard.double(forKey: "servPercent") / 100))) - self.sum
                self.servicePay.text  = String(format:"%.2f", serviceP) + " руб."
                self.totalSum = s + serviceP
                self.txt_sum_obj.text = String(format:"%.2f", s) + " руб."
                self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
            }
            sumOSV.append(Double(String(format:"%.2f", self.sum)) as! Double)
            checkBox.append(true)
            osvc.append("Услуги ЖКУ")
            idOSV.append(0)
            
            uslugaArr.append("Услуги ЖКУ")
            endArr.append(String(format:"%.2f", self.sum))
            idArr.append(0)
            identOSV.append(ident)
            #if isDJ
            self.debtArr.forEach{
                if String($0["Ident"] as! String) == ident{
                    if String($0["InsuranceSum"] as! String) != "" && String($0["InsuranceSum"] as! String) != "0.00" && String($0["InsuranceSum"] as! String) != "0"{
                        let suInsur: Double = Double($0["InsuranceSum"] as! String)!
                        sumOSV.append(Double(String(format:"%.2f", suInsur)) as! Double)
                        checkBox.append(true)
                        osvc.append("Страховой сбор")
                        idOSV.append(1)
                        
                        uslugaArr.append("Страховой сбор")
                        endArr.append(String(format:"%.2f", suInsur))
                        idArr.append(1)
                        identOSV.append(ident)
                        DispatchQueue.main.async(execute: {
                            self.totalSum = self.sum + suInsur
                            self.txt_sum_obj.text = String(format:"%.2f", self.totalSum) + " руб."
                            self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
                        })
                    }
                }else if ident == "Все"{
                    if String(self.debtArr[0]["InsuranceSum"] as! String) != "" && String(self.debtArr[0]["InsuranceSum"] as! String) != "0.00" && String(self.debtArr[0]["InsuranceSum"] as! String) != "0"{
                        let suInsur: Double = Double(self.debtArr[0]["InsuranceSum"] as! String)!
                        sumOSV.append(Double(String(format:"%.2f", suInsur)) as! Double)
                        checkBox.append(true)
                        osvc.append("Страховой сбор")
                        idOSV.append(1)
                        
                        uslugaArr.append("Страховой сбор")
                        endArr.append(String(format:"%.2f", suInsur))
                        idArr.append(1)
                        identOSV.append(ident)
                        DispatchQueue.main.async(execute: {
                            self.totalSum = self.sum + suInsur
                            self.txt_sum_obj.text = String(format:"%.2f", self.totalSum) + " руб."
                            self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
                        })
                    }
                }
            }
            #endif
            
            DispatchQueue.main.async(execute: {
                if UserDefaults.standard.double(forKey: "servPercent") == 0.00{
                    self.servicePay.text = "Комиссия не взимается"
                    self.servicePay.textColor = .lightGray
                }
                self.updateTable()
            })
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
        self.updateTable()
    }
    
    func updateTable() {
        self.tableView.reloadData()
    }
    
    var kol = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if uslugaArr.count != 0 {
            kol = uslugaArr.count
            return uslugaArr.count
        } else {
            return 0
        }
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
            //            if (osv.usluga?.contains("газ"))! || osv.usluga == "Страховка"{
            //                cell.end.isUserInteractionEnabled = false
            //                cell.end.isHidden = true
            //                cell.endL.isHidden = false
            //                cell.endL.text = osv.end
            //            }else{
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
            //            }
        }else{
            if uslugaArr[indexPath.row] == "Страховой сбор"{
                #if isDJ
                cell.end.isUserInteractionEnabled = false
                cell.end.isHidden = true
                cell.endL.isHidden = false
                cell.endL.text = endArr[indexPath.row]
                #endif
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
        if kol == 2{
            if uslugaArr[indexPath.row] == "Услуги ЖКУ"{
                cell.check.isHidden = true
            }
        }else if kol == 1{
            cell.check.isHidden = true
        }
        select = false
        selectedRow = -1
        //        #endif
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CostPay_New" {
            var ident = ""
            if choiceIdent == "Все"{
                let str_ls = UserDefaults.standard.string(forKey: "str_ls")!
                let str_ls_arr = str_ls.components(separatedBy: ",")
                for i in 0...str_ls_arr.count - 1{
                    ident = str_ls_arr[0]
                }
            }else{
                ident = choiceIdent
            }
            let payController             = segue.destination as! Pay
            payController.ident = ident
        }
    }
    
    var editRow = IndexPath()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if kol > 1{
            selectedRow = indexPath.row
            editRow = indexPath
            update = true
            select = true
            tableView.reloadRows(at: [indexPath], with: .automatic)
            setSumm()
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func setSumm(){
        var sum = 0.00
        for i in 0 ... sumOSV.count - 1 {
            if checkBox[i] == true{
                sum = sum + sumOSV[i]
            }
        }
        self.sum = sum
        if self.sum > 0{
            let serviceP = (self.sum / (1 - (UserDefaults.standard.double(forKey: "servPercent") / 100))) - self.sum
            self.servicePay.text  = String(format:"%.2f", serviceP) + " руб."
            self.totalSum = self.sum + serviceP
            self.txt_sum_obj.text = String(format:"%.2f", self.sum) + " руб."
            self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
            if UserDefaults.standard.double(forKey: "servPercent") == 0.00{
                self.servicePay.text = "Комиссия не взимается"
                self.servicePay.textColor = .lightGray
            }
        }else{
            self.txt_sum_obj.text = "0.00 руб."
            self.txt_sum_jkh.text = "0.00 руб."
            self.servicePay.text  = "0.00 руб."
            if UserDefaults.standard.double(forKey: "servPercent") == 0.00{
                self.servicePay.text = "Комиссия не взимается"
                self.servicePay.textColor = .lightGray
            }
        }
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
        let s: Double = Double(str) as! Double
        textField.text = String(format:"%.2f", s)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var str: String = textField.text!
        str = str.replacingOccurrences(of: ",", with: ".")
        if str.contains("."){
            if let index = str.index(of: ".") {
                let distance = str.distance(from: str.startIndex, to: index)
                let k = str.count - distance - 1
                if k > 2{
                    str.removeLast()
                    textField.text = str
                }
            }
        }
        if str != "" && str != "-"{
            for i in 0...osvc.count - 1{
                var code:String = osvc[i]
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
            if self.sum > 0{
                let serviceP = (self.sum / (1 - (UserDefaults.standard.double(forKey: "servPercent") / 100))) - self.sum
                self.servicePay.text  = String(format:"%.2f", serviceP) + " руб."
                self.totalSum = self.sum + serviceP
                self.txt_sum_obj.text = String(format:"%.2f", self.sum) + " руб."
                self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
            }else{
                self.txt_sum_obj.text = "0.00 руб."
                self.txt_sum_jkh.text = "0.00 руб."
                self.servicePay.text  = "0.00 руб."
            }
        }else{
            for i in 0...osvc.count - 1{
                var code:String = osvc[i]
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
            if self.sum > 0{
                let serviceP = (self.sum / (1 - (UserDefaults.standard.double(forKey: "servPercent") / 100))) - self.sum
                self.servicePay.text  = String(format:"%.2f", serviceP) + " руб."
                self.totalSum = self.sum + serviceP
                self.txt_sum_obj.text = String(format:"%.2f", self.sum) + " руб."
                self.txt_sum_jkh.text = String(format:"%.2f", self.totalSum) + " руб."
            }else{
                self.txt_sum_obj.text = "0.00 руб."
                self.txt_sum_jkh.text = "0.00 руб."
                self.servicePay.text  = "0.00 руб."
            }
        }
        if UserDefaults.standard.double(forKey: "servPercent") == 0.00{
            self.servicePay.text = "Комиссия не взимается"
            self.servicePay.textColor = .lightGray
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification?) {
        var keyboardH = CGFloat()
        if let keyboardSize = (sender?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardH = keyboardSize.height
//            viewTop.constant = getPoint() - keyboardH + 50
            viewBot.constant = keyboardH - 40
        }
    }
    
    // И вниз при исчезновении
    @objc func keyboardWillHide(sender: NSNotification?) {
//        viewTop.constant = getPoint()
        viewBot.constant = 0
        if UserDefaults.standard.bool(forKey: "show_Ad"){
//            viewTop.constant = getPoint() - adHeight + 10
            viewBot.constant = adHeight
        }
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
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        if (UserDefaults.standard.string(forKey: "PaysError") != "" || (UserDefaults.standard.string(forKey: "PaymentID") != "" && UserDefaults.standard.bool(forKey: "PaymentSucces"))) && onePay == 0{
            onePay = 1
            addMobilePay()
        }
        if UserDefaults.standard.bool(forKey: "PaymentSucces") && oneCheck == 0{
            oneCheck = 1
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        }
        // Подхватываем показ клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    var onePay = 0
    var oneCheck = 0
    
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
                                                print("responseStringMobile = \(responseString)")
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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
