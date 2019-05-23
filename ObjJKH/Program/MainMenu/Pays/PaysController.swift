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
import YandexMobileAds
import GoogleMobileAds
import YandexMobileMetrica

private protocol MainDataProtocol:  class {}

class PaysController: UIViewController, DropperDelegate, UITableViewDelegate, UITableViewDataSource, YMANativeAdDelegate, YMANativeAdLoaderDelegate {
    
    var adLoader: YMANativeAdLoader!
    var bannerView: YMANativeBannerView?
    var gadBannerView: GADBannerView!
    var request = GADRequest()
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        if UserDefaults.standard.bool(forKey: "NewMain"){
            navigationController?.popViewController(animated: true)
        }else{
            navigationController?.dismiss(animated: true, completion: nil)
        }
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
    var sumOSV  :[Double] = []
    var osvc    :[String] = []
    var idOSV   :[Int]    = []
    
    var login: String?
    var pass: String?
    var currPoint = CGFloat()
    let dropper = Dropper(width: 150, height: 400)
    
    public var saldoIdent = "Все"
    public var debtArr:[AnyObject] = []
    
    @IBOutlet weak var ls_button: UIButton!
    @IBOutlet weak var txt_sum_obj: UITextField!
    
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
        #if isKlimovsk12
        if defaults.string(forKey: "mail")! == "" || defaults.string(forKey: "mail")! == "-"{
            let alert = UIAlertController(title: "Ошибка", message: "Укажите e-mail", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "e-mail..."
                textField.keyboardType = .emailAddress
            }
            let cancelAction = UIAlertAction(title: "Сохранить", style: .default) { (_) -> Void in
                let textField = alert.textFields![0]
                let str = textField.text
                var kD = 0
                var kS = 0
                str!.forEach{
                    if $0 == "."{
                        kD += 1
                    }
                    if $0 == "@"{
                        kS += 1
                    }
                }
                if ((str?.contains("@"))!) && ((str?.contains("."))!) && kD == 1 && kS == 1{
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
        #else
        payed()
        #endif
    }
    
    private func payed() {
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
        let k:String = txt_sum_obj.text!
        self.totalSum = Double(k.replacingOccurrences(of: " .руб", with: ""))!
        if (self.totalSum <= 0) {
            let alert = UIAlertController(title: "Ошибка", message: "Нет суммы к оплате", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            #if isKlimovsk12
            items.removeAll()
            var i = 0
            checkBox.forEach{
                if $0 == true && sumOSV[i] > 0.00{
                    let price = String(format:"%.2f", sumOSV[i]).replacingOccurrences(of: ".", with: "")
                    let ItemsData = ["ShopCode" : "66950", "Name" : osvc[i], "Price" : Int(price)!, "Quantity" : Double(1.00), "Amount" : Int(price)!, "Tax" : "none", "QUANTITY_SCALE_FACTOR" : 3] as [String : Any]
                    items.append(ItemsData)
                }
                i += 1
            }
            var Data:[String:Any] = [:]
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
            checkBox.forEach{
                if $0 == true && sumOSV[i] > 0.00{
                    DataStr = DataStr + "\(String(idOSV[i]))-\(String(format:"%.2f", sumOSV[i]))|"
                }
                i += 1
            }
            Data["name"] = DataStr
            
            let defaults = UserDefaults.standard
            let shopCode = "66950"
            var shops:[Any] = []
            let ItemsData = ["ShopCode" : shopCode, "Amount" : String(format:"%.2f", self.totalSum).replacingOccurrences(of: ".", with: ""), "Name" : "ТСЖ Климовск 12"] as [String : Any]
            shops.append(ItemsData)
            print(shops)
            print(items)
            let receiptData = ["ShopCode" : shopCode, "Items" : items, "Email" : defaults.string(forKey: "mail")!, "Phone" : defaults.object(forKey: "login")! as? String ?? "", "Taxation" : "osn"] as [String : Any]
            let name = "Оплата услуг ЖКХ"
            let amount = NSNumber(floatLiteral: self.totalSum)
            defaults.set(defaults.string(forKey: "login"), forKey: "CustomerKey")
            defaults.synchronize()
            print(receiptData)
            PayController.buyItem(withName: name, description: "", amount: amount, recurrent: false, makeCharge: false, additionalPaymentData: Data, receiptData: receiptData, email: defaults.object(forKey: "mail")! as? String, shopsData: shops, shopsReceiptsData: nil, from: self, success: { (paymentInfo) in
                
            }, cancelled:  {
                
            }, error: { (error) in
                let alert = UIAlertController(title: "Ошибка", message: "Сервер оплаты не отвечает. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
            #else
            defaults.setValue(String(describing: self.sum), forKey: "sum")
            defaults.synchronize()
            self.performSegue(withIdentifier: "CostPay_New", sender: self)
            #endif
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults     = UserDefaults.standard
        let params : [String : Any] = ["Переход на страницу": "Оплата"]
        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { (error) in
            //            print("DID FAIL REPORT EVENT: %@", message)
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        currPoint = 537
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
            getData(ident: "Все")
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
        viewTop.constant = getPoint()
        updateConectBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        sendView.isUserInteractionEnabled = true
        sendView.addGestureRecognizer(tap)
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
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: Network.reachability)
        updateUserInterface()
        if defaults.bool(forKey: "show_Ad"){
            if defaults.integer(forKey: "ad_Type") == 2{
                let configuration = YMANativeAdLoaderConfiguration(blockID: "R-M-393573-1",
                                                                   imageSizes: [kYMANativeImageSizeMedium],
                                                                   loadImagesAutomatically: true)
                self.adLoader = YMANativeAdLoader(configuration: configuration)
                self.adLoader.delegate = self
                loadAd()
            }else if defaults.integer(forKey: "ad_Type") == 3{
                gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
                gadBannerView.adUnitID = "ca-app-pub-5483542352686414/5099103340"
                gadBannerView.rootViewController = self
                addBannerViewToView(gadBannerView)
                #if DEBUG
                request.testDevices = ["2019ef9a63d2b397740261c8441a0c9b"];
                #else
                request.testDevices = nil;
                #endif
                gadBannerView.load(request)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView){
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        DispatchQueue.main.async {
            self.adHeight = bannerView.frame.size.height
            self.viewTop.constant = self.getPoint() - bannerView.frame.size.height + 40
        }
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
        DispatchQueue.main.async {
            self.adHeight = bannerView.frame.size.height
            self.viewTop.constant = self.getPoint() - bannerView.frame.size.height + 40
        }
        if #available(iOS 11.0, *) {
            displayAdAtBottomOfSafeArea();
        } else {
            displayAdAtBottom();
        }
    }
    
    func displayAdAtBottom() {
        let views = ["bannerView" : self.bannerView!]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[bannerView]-(10)-|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[bannerView]-(0)-|",
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
        ls_button.setTitle(contents, for: UIControlState.normal)
        update = false
        if (contents == "Все"){
            choiceIdent = "Все"
            getData(ident: "Все")
        } else {
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Saldo")
        fetchRequest.predicate = NSPredicate.init(format: "num_month = %@ AND year = %@", String(self.iterMonth), String(self.iterYear))
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results {
                let object = result as! NSManagedObject
//                if ident != "Все"{
                    if (object.value(forKey: "ident") as! String) == ident{
                        if (object.value(forKey: "usluga") as! String) != "Я"{
                            sumOSV.append(Double(String(format:"%.2f", Double(object.value(forKey: "end") as! String)!)) as! Double)
                            checkBox.append(true)
                            osvc.append(object.value(forKey: "usluga") as! String)
                            idOSV.append(Int(object.value(forKey: "id") as! Int64))
                            
                            uslugaArr.append(object.value(forKey: "usluga") as! String)
                            endArr.append(String(format:"%.2f", Double(object.value(forKey: "end") as! String)!))
                            idArr.append(Int(object.value(forKey: "id") as! Int64))
                            if (object.value(forKey: "usluga") as! String) != "Я"{
                                self.sum = self.sum + Double(object.value(forKey: "end") as! String)!
                            }
                        }
                    }
                    DispatchQueue.main.async(execute: {
                        if (self.sum != 0) {
                            //                    self.txt_sum_jkh.text = String(format:"%.2f", self.sum) + " р."
                            let serviceP = self.sum / 0.992 - self.sum
                            self.totalSum = self.sum + serviceP
                            self.txt_sum_obj.text = String(format:"%.2f", self.sum)
                            if self.debtArr.count != 0{
                                var s = 0.00
                                self.debtArr.forEach{
                                    if self.choiceIdent == "Все"{
                                        print($0["Sum"])
                                        s = s + Double($0["Sum"] as! String)!
                                        if s <= 0.00{
                                            self.txt_sum_obj.text = "0.00"
                                        }
                                    }else if self.choiceIdent == ($0["Ident"] as! String){
                                        if ($0["Sum"] as! String) == "0.00"{
                                            self.txt_sum_obj.text = "0.00"
                                        }
                                    }
                                }
                            }
                        } else {
                            //                    self.txt_sum_jkh.text = "0.00 р."
                            self.txt_sum_obj.text = "0.00"
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
    
    func end_osv() {
        self.sum = 0
        select = false
        checkBox.removeAll()
        sumOSV.removeAll()
        osvc.removeAll()
        uslugaArr.removeAll()
        endArr.removeAll()
        idArr.removeAll()
        var endSum = 0.00
        // Выборка из БД последней ведомости - посчитаем сумму к оплате
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Saldo")
        fetchRequest.predicate = NSPredicate.init(format: "num_month = %@ AND year = %@", String(self.iterMonth), String(self.iterYear))
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results {
                let object = result as! NSManagedObject
                sumOSV.append(Double(object.value(forKey: "end") as! String)!)
                checkBox.append(true)
                osvc.append(object.value(forKey: "usluga") as! String)
                idOSV.append(Int(object.value(forKey: "id") as! Int64))
                self.sum = self.sum + Double(object.value(forKey: "end") as! String)!
                endSum = Double(object.value(forKey: "end") as! String)!
            }
            sumOSV.removeLast()
            checkBox.removeLast()
            osvc.removeLast()
            idOSV.removeLast()
            self.sum = self.sum - endSum
            DispatchQueue.main.async(execute: {
                if (self.sum != 0) {
                    //                    self.txt_sum_jkh.text = String(format:"%.2f", self.sum) + " р."
                    let serviceP = self.sum / 0.992 - self.sum
                    self.totalSum = self.sum + serviceP
                    self.txt_sum_obj.text = String(format:"%.2f", self.sum)
                    if self.debtArr.count != 0{
                        var s = 0.00
                        self.debtArr.forEach{
                            if self.choiceIdent == "Все"{
                                s = s + Double($0["Sum"] as! String)!
                                if s <= 0.00{
                                    self.txt_sum_obj.text = "0.00"
                                }
                            }else if self.choiceIdent == ($0["Ident"] as! String){
                                if ($0["Sum"] as! String) == "0.00"{
                                    self.txt_sum_obj.text = "0.00"
                                }
                            }
                        }
                    }
                } else {
                    //                    self.txt_sum_jkh.text = "0.00 р."
                    self.txt_sum_obj.text = "0.00"
                }
                if self.saldoIdent == "Все"{
                    self.updateFetchedResultsController()
                }
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
        self.updateTable()
    }
    
    func updateTable() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if choiceIdent == ""{
//            if let sections = fetchedResultsController?.sections {
//                kol = sections[section].numberOfObjects - 1
//                return sections[section].numberOfObjects - 1
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
    var kol = 0
    var select = false
    var update = false
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayCell") as! PaySaldoCell
        if select == false && update == false{
            cell.check.setImage(UIImage(named: "Check.png"), for: .normal)
        }else{
            if selectedRow >= 0 && select{
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
//            }else{
//                let sum:String = endArr[indexPath.row]
//                osvc.append(uslugaArr[indexPath.row])
//                checkBox.append(true)
//                sumOSV.append(Double(sum)!)
//                idOSV.append(Int(idArr[indexPath.row]))
//            }
//
//        }
        if checkBox[indexPath.row]{
            cell.check.setImage(UIImage(named: "Check.png"), for: .normal)
        }else{
            cell.check.setImage(UIImage(named: "unCheck.png"), for: .normal)
        }
        
        if choiceIdent == ""{
            let osv = fetchedResultsController!.object(at: indexPath)
            if (osv.usluga == "Я") {
                cell.usluga.text = "ИТОГО"
            } else {
                cell.usluga.text = osv.usluga
            }
            cell.end.text    = osv.end
        }else{
            if (uslugaArr[indexPath.row] == "Я") {
                cell.usluga.text = "ИТОГО"
            } else {
                cell.usluga.text = uslugaArr[indexPath.row]
            }
            cell.end.text    = endArr[indexPath.row]
        }
        
        
        cell.delegate = self
        select = false
        selectedRow = -1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(checkBox)
        update = true
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
        self.txt_sum_obj.text = String(format:"%.2f", self.sum)
        if self.debtArr.count != 0{
            var s = 0.00
            self.debtArr.forEach{
                if choiceIdent == "Все"{
                    s = s + Double($0["Sum"] as! String)!
                    if s <= 0.00{
                        self.txt_sum_obj.text = "0.00"
                    }
                }else if self.choiceIdent == ($0["Ident"] as! String){
                    if ($0["Sum"] as! String) == "0.00"{
                        self.txt_sum_obj.text = "0.00"
                    }
                }
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var str: String = textField.text!
        str = str.replacingOccurrences(of: ",", with: ".")
        if str != ""{
            self.sum = Double(str)!
        }else{
            self.sum = 0.00
        }
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
    }
    
    @objc func keyboardWillShow(sender: NSNotification?) {
        let viewHeight = view.frame.size.height
        if viewHeight == 667{
            viewTop.constant = getPoint() - 210 + 40
            return
            
        }else if viewHeight == 736{
            viewTop.constant = getPoint() - 220 + 40
            return
        }else if viewHeight == 568{
            viewTop.constant = getPoint() - 210 + 40
        }else{
            viewTop.constant = getPoint() - 240 + 40
        }
    }
    
    // И вниз при исчезновении
    @objc func keyboardWillHide(sender: NSNotification?) {
        viewTop.constant = getPoint()
        if UserDefaults.standard.bool(forKey: "show_Ad"){
            viewTop.constant = getPoint() - adHeight + 40
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
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
