//
//  AppUser.swift
//  ObjJKH
//
//  Created by Роман Тузин on 31.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import UserNotifications
import Firebase
import FirebaseDatabase

protocol ShowAppDelegate : class {
    func showAppDone(showApp: AppUser)
}

class AppUser: UIViewController, UITableViewDelegate, UITableViewDataSource, CloseAppDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var hidden_Header: UIBarButtonItem!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBAction func back_btn(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var pay_txt: UILabel!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var payView: UIView!
    @IBOutlet weak var heightPayView: NSLayoutConstraint!
    
    @IBAction func payBtnAction(_ sender: UIButton) {
        var payT = false
        #if isKlimovsk12
        payT = true
        #elseif isMupRCMytishi
        payT = true
        #else
        payedA()
        #endif
        if payT{
            if UserDefaults.standard.string(forKey: "mail")! == "" || UserDefaults.standard.string(forKey: "mail")! == "-"{
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
                        self.payedM()
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
            }
        }
    }
    
    @IBOutlet weak var table_Const: NSLayoutConstraint!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var date_txt: UILabel!
    @IBOutlet weak var tema_txt: UILabel!
    @IBOutlet weak var table_comments: UITableView!
    @IBOutlet weak var ed_comment: UITextField!
    @IBOutlet weak var type_app: UILabel!
    @IBOutlet weak var ls_adress: UILabel!
    @IBOutlet weak var ls_phone: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var delegate:ShowAppDelegate?
    var updDelegt: AppsUserUpdateDelegate?
    var App: Applications? = nil
    @IBOutlet weak var fot_img: UIButton!
    
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var refreshControl: UIRefreshControl?
    
    var txt_tema: String = ""
    var txt_date: String = ""
    
    var responseString: String = ""
    var fetchedResultsController: NSFetchedResultsController<Comments>?
    
    // id аккаунта текущего
    var id_author: String = ""
    var adress: String = ""
    var flat: String = ""
    var phone: String = ""
    var name_account: String = ""
    var id_account: String = ""
    var id_app: String = ""
    var teck_id: Int64 = 1
    var str_type_app: String = ""
    var read: Int64 = 0
    var paid_sum: Double = 0.00
    var paid_text: String = ""
    var isPay: Bool = false
    var isPaid: Bool = false
    var acc_ident = ""
    
    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    var postData = [String]()
    
    var timer: Timer? = nil
    var totalSum = Double()
    var items:[Any] = []
    func payedM(){
        let k:String = String(paid_sum)
        self.totalSum = Double(k.replacingOccurrences(of: " руб.", with: ""))!
        if (self.totalSum <= 0) {
            let alert = UIAlertController(title: "Ошибка", message: "Нет суммы к оплате", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            items.removeAll()
            let price = String(format:"%.2f", paid_sum).replacingOccurrences(of: ".", with: "")
            let ItemsData = ["Name" : paid_text, "Price" : Int(price)!, "Quantity" : Double(1.00), "Amount" : Int(price)!, "Tax" : "none"] as [String : Any]
            items.append(ItemsData)
            var Data:[String:String] = [:]
            var DataStr: String = ""
            DataStr = "ls1-\(acc_ident)|"
            DataStr = DataStr + "|"
            Data["name"] = DataStr
            print(Data)
            let defaults = UserDefaults.standard
            self.onePay = 0
            self.oneCheck = 0
            #if isKlimovsk12
            UserDefaults.standard.set("_" + acc_ident, forKey: "payIdent")
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
            PayController.buyItem(withName: name, description: "", amount: amount, recurrent: false, makeCharge: false, additionalPaymentData: Data, receiptData: receiptData, email: defaults.object(forKey: "mail")! as? String, shopsData: shops, shopsReceiptsData: nil, from: self, success: { (paymentInfo) in

            }, cancelled:  {

            }, error: { (error) in
                let alert = UIAlertController(title: "Ошибка", message: "Сервер оплаты не отвечает. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
            #elseif isMupRCMytishi
            let receiptData = ["Items" : items, "Email" : defaults.string(forKey: "mail")!, "Phone" : defaults.object(forKey: "login")! as? String ?? "", "Taxation" : "osn"] as [String : Any]
            let name = "Оплата услуг ЖКХ"
            let amount = NSNumber(floatLiteral: self.totalSum)
            defaults.set(defaults.string(forKey: "login"), forKey: "CustomerKey")
            defaults.synchronize()
            print(receiptData)
            PayController.buyItem(withName: name, description: "", amount: amount, recurrent: false, makeCharge: false, additionalPaymentData: Data, receiptData: receiptData, email: defaults.object(forKey: "mail")! as? String, from: self, success: { (paymentInfo) in

            }, cancelled: {

            }) { (error) in
                let alert = UIAlertController(title: "Ошибка", message: "Сервер оплаты не отвечает. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }

            #endif
        }
    }
    
    func payedA(){
        self.totalSum = self.paid_sum
        let defaults = UserDefaults.standard
        defaults.setValue(String(describing: self.paid_sum), forKey: "sum")
        defaults.synchronize()
        self.performSegue(withIdentifier: "CostPay_New", sender: self)
    }

    @IBAction func add_foto(_ sender: UIButton) {
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default, handler: { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        action.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        action.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in }))
        present(action, animated: true, completion: nil)
    }
    var isHidden = true
    
    @IBAction func hiddHeader(_ sender: UIButton) {
        print(isHidden, headerView.frame.origin.y)
        if !isHidden{
            hidden_Header.title = "▽"
            headerView.isHidden = true
            table_Const.constant = table_Const.constant - headerView.frame.size.height
            isHidden = true
        }else{
            hidden_Header.title = "△"
            headerView.isHidden = false
            table_Const.constant = table_Const.constant + headerView.frame.size.height
            isHidden = false
        }
    }
    
    @IBAction func add_comm(_ sender: UIButton) {
        self.addComm(comm: ed_comment.text)
    }
    
    func addComm(comm: String?){
        if (comm != "") {
            self.StartIndicator()
            self.ed_comment.text = comm!
            let id_app_txt = self.id_app.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            let text_txt: String   = comm!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            
            let urlPath = Server.SERVER + Server.SEND_COMM + "reqID=" + id_app_txt + "&text=" + text_txt;
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            print(request)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        DispatchQueue.main.async(execute: {
                                                            self.StopIndicator()
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
                                                    
                                                    self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                    print("responseString = \(self.responseString)")
                                                    
                                                    self.choice(comm: comm!)
            })
            task.resume()
            
        }
    }
    
    @IBAction func close_app(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Apps", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "close_alert") as! CloseAppAlert
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        myAlert.number = self.id_app
        myAlert.id_author = self.id_author
        myAlert.name_account = self.name_account
        myAlert.id_account = self.id_account
        myAlert.delegate = self
        myAlert.App = self.App
        myAlert.teck_id = self.teck_id
        self.present(myAlert, animated: true, completion: nil)
    }
    
    @IBAction func files_app(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.StopIndicator()
//        if read == 0{
            self.read_request()
//        }
        // получим id текущего аккаунта
        let defaults = UserDefaults.standard
        id_author    = defaults.string(forKey: "id_account")!
        name_account = defaults.string(forKey: "name")!
        id_account   = defaults.string(forKey: "id_account")!
        
        tema_txt.text = txt_tema
        date_txt.text = txt_date
        defaults.set("", forKey: "PaymentID")
        defaults.set("", forKey: "PaysError")
        defaults.set(false, forKey: "PaymentSucces")
        table_comments.delegate = self
        table_comments.rowHeight = UITableViewAutomaticDimension
        table_comments.estimatedRowHeight = 44.0
        
        load_data()
        updateTable()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Обновление списка заявок
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.table_comments.refreshControl = refreshControl
        } else {
            self.table_comments.addSubview(refreshControl!)
        }
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        payBtn.backgroundColor = myColors.btnColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        fot_img.imageView?.setImageColor(color: myColors.btnColor.uiColor())
        hidden_Header.tintColor = myColors.indicatorColor.uiColor()
        
        let titles = Titles()
        self.title = titles.getSimpleTitle(numb: "2") + " №" + id_app
        print(self.adress, self.flat, self.phone)
        self.type_app.text = defaults.string(forKey: self.str_type_app + "_type")
        if self.flat.count > 0{
            var ls_12_end = ""
            if self.flat.count > 2{
                let ls_12 = self.flat.index(self.flat.startIndex, offsetBy: 2)
                ls_12_end = self.flat.substring(to: ls_12)
            }
            if ls_12_end == "00"{
                self.flat.remove(at: self.flat.startIndex)
            }
            var ls_1_end = ""
            let ls_1 = self.flat.index(self.flat.startIndex, offsetBy: 1)
            ls_1_end = self.flat.substring(to: ls_1)
            if ls_1_end == "0"{
                self.flat.remove(at: self.flat.startIndex)
            }
            if ls_12_end == "кв"{
                self.ls_adress.text = self.adress + ", " + self.flat
            }else{
                self.ls_adress.text = self.adress + ", кв. " + self.flat
            }
        }else{
            self.ls_adress.text = self.adress
        }
        self.ls_phone.text = self.phone
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, error in
        })        
        
        timer = Timer(timeInterval: 4, target: self, selector: #selector(reload), userInfo: ["start" : "ok"], repeats: true)
        RunLoop.main.add(timer!, forMode: .defaultRunLoopMode)
        let numberLine: CGFloat = CGFloat(tema_txt!.numberOfVisibleLines)
        let count = tema_txt.frame.size.height * numberLine
        headerHeight.constant = headerHeight.constant + count
        headerView.isHidden = true
        table_Const.constant = table_Const.constant - headerView.frame.size.height
        if isPay && !isPaid{
            pay_txt.text = paid_text
            payBtn.setTitle("Оплатить " + String(format:"%.2f", paid_sum) + " руб", for: .normal)
        }else{
            heightPayView.constant = 0
            payView.isHidden = true
        }
    }
    
    func read_request(){
        let request_id = String(self.id_app)
        
        var request = URLRequest(url: URL(string: Server.SERVER + "SetRequestReadedByClientState.ashx?" + "reqID=" + request_id)!)
        request.httpMethod = "GET"
        print(request)
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            print(String(data: data!, encoding: .utf8) ?? "")
            
            guard data != nil else { return }
            
            var request_read = UserDefaults.standard.integer(forKey: "request_read")
            request_read -= 1
//            DispatchQueue.main.async {
//                let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
//                let updatedBadgeNumber = currentBadgeNumber - 1
//                if (updatedBadgeNumber > -1) {
//                    UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
//                }
////                if request_read >= 0{
////                    UserDefaults.standard.setValue(request_read, forKey: "request_read")
////                    UserDefaults.standard.synchronize()
////                }else{
////                    UserDefaults.standard.setValue(0, forKey: "request_read")
////                    UserDefaults.standard.synchronize()
////                }
//                
//            }
            
            }.resume()
    }
    
    @objc func reload() {
        //        let db = DB()
        //        if (db.isNotification()) {
        DispatchQueue.main.async(execute: {
            self.load_new_data()
        })
        //        }
    }
    
    func load_notification() {
        DispatchQueue.main.async(execute: {
            self.load_new_data()
        })
    }
    
    func load_new_data() {
        // Экземпляр класса DB
        let db = DB()
        let defaults = UserDefaults.standard
        let login = defaults.object(forKey: "login")
        let pass = defaults.object(forKey: "pass")
        
        // КОММЕНТАРИИ ПО УКАЗАННОЙ ЗАЯВКЕ
        db.del_comms_by_app(number_app: self.id_app)
        db.getComByID(login: login as! String, pass: pass as! String, number: self.id_app)
        
        self.load_data()
        self.table_comments.reloadData()
        if #available(iOS 10.0, *) {
            self.table_comments.refreshControl?.endRefreshing()
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        view.frame.origin.y = -265
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        view.frame.origin.y = 0
    }

    func choice(comm: String?) {
        if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                UserDefaults.standard.set(self.responseString, forKey: "errorStringSupport")
                UserDefaults.standard.synchronize()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен. \nОтвет с сервера: <" + self.responseString + ">", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if responseString != "-1" {
            DispatchQueue.main.async(execute: {
                
                // Экземпляр класса DB
                let db = DB()
                db.add_comm(ID: Int64(self.responseString)!, id_request: Int64(self.id_app)!, text: comm!, added: self.date_teck()!, id_Author: self.id_author, name: self.name_account, id_account: self.id_account)
                self.ed_comment.text = ""
                self.StopIndicator()
                self.load_data()
                self.updateTable()
                
                self.view.endEditing(true)
                
            })
        }else{
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                self.ed_comment.text = ""
                self.view.endEditing(true)
                
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver("reloadTheTable")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "NewMain"){
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: NSNotification.Name(rawValue: "reloadTheTable"), object: nil)
//        UserDefaults.standard.addObserver(self, forKeyPath: "PaymentSucces", options:NSKeyValueObservingOptions.new, context: nil)
//        UserDefaults.standard.set(true, forKey: "observeStart")
    }
    
//    deinit {
//        UserDefaults.standard.removeObserver(self, forKeyPath: "PaymentSucces", context: nil)
//        UserDefaults.standard.set(false, forKey: "observeStart")
//    }
    
    var onePay = 0
    var oneCheck = 0
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if UserDefaults.standard.bool(forKey: "PaymentSucces") && onePay == 0{
            
            onePay = 1
            addMobilePay()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func load_data() {
        let predicateFormat = String(format: "id_app = %@", id_app)
        fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Comments", keysForSort: ["dateK"], predicateFormat: predicateFormat, ascending: true) as? NSFetchedResultsController<Comments>
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
    }
    
    func updateTable() {
        table_comments.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comm = (fetchedResultsController?.object(at: indexPath))! as Comments
        if (comm.id_author != comm.id_account) {
            let cell = self.table_comments.dequeueReusableCell(withIdentifier: "CommCellCons") as! CommCellCons
            cell.author.text     = comm.author
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            cell.date.text       = dateFormatter.string(from: comm.dateK!)
            cell.text_comm.text  = comm.text
            self.teck_id = comm.id + 1
            
//            #if isGKRZS
//            let server = Server()
//            cell.author.textColor = server.hexStringToUIColor(hex: "#1f287f")
//            #else
//            #endif
            
            return cell
        } else {
            let cell = self.table_comments.dequeueReusableCell(withIdentifier: "CommCell") as! CommCell
            cell.author.text     = "Вы" //comm.author
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            if comm.dateK != nil{
                cell.date.text       = dateFormatter.string(from: comm.dateK!)
            }
            cell.text_comm.text  = comm.text
            self.teck_id = comm.id + 1
            
//            #if isGKRZS
//            let server = Server()
//            cell.author.textColor = server.hexStringToUIColor(hex: "#1f287f")
//            #else
//            #endif
            
            return cell
        }
    }
    
    func closeAppDone(closeApp: CloseAppAlert) {
        self.load_data()
        self.table_comments.reloadData()
        self.delegate?.showAppDone(showApp: self)
    }
    
    func date_teck() -> (String)? {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func StartIndicator() {
        
        self.btn2.isEnabled = false
        self.btn2.isHidden  = true
        
        self.btn3.isEnabled = false
        self.btn3.isHidden  = true
        
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator() {
        
        self.btn2.isEnabled = true
        self.btn2.isHidden  = false
        
        self.btn3.isEnabled = true
        self.btn3.isHidden  = false
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        StartIndicator()
        DispatchQueue.global(qos: .userInitiated).async {
            if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.uploadPhoto(img)
            }
            DispatchQueue.main.async {
                self.StopIndicator()
                self.updDelegt?.updateList()
                self.load_data()
                self.updateTable()
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadPhoto(_ img: UIImage) {
        
        let group = DispatchGroup()
        let reqID = id_app.stringByAddingPercentEncodingForRFC3986() ?? ""
        let id = UserDefaults.standard.string(forKey: "id_account")?.stringByAddingPercentEncodingForRFC3986() ?? ""
        let phone = UserDefaults.standard.string(forKey: "phone")?.stringByAddingPercentEncodingForRFC3986() ?? ""
        group.enter()
        let uid = UUID().uuidString
        Alamofire.upload(multipartFormData: { multipartFromdata in
            multipartFromdata.append(UIImageJPEGRepresentation(img, 0.5)!, withName: uid, fileName: "\(uid).jpg", mimeType: "image/jpeg")
        }, to: Server.SERVER + Server.ADD_FILE + "reqID=" + reqID + "&phone=" + phone) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
//                    print(response.result.value!)
                    group.leave()
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        group.wait()
        return
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        if (timer != nil) {
            timer?.invalidate()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if segue.identifier == "files" {
            let vc = segue.destination as! FilesController
            vc.data_ = (fetchedResultsController?.fetchedObjects?.filter { $0.text?.contains("файл") ?? false }) ?? []
        }
        if segue.identifier == "CostPay_New" {
            let payController             = segue.destination as! Pay
            payController.ident = acc_ident
        }
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.global(qos: .background).async {
                sleep(2)
                DispatchQueue.main.sync {
                    // Экземпляр класса DB
                    let db = DB()
                    let defaults = UserDefaults.standard
                    let login = defaults.object(forKey: "login")
                    let pass = defaults.object(forKey: "pass")
                    
                    // КОММЕНТАРИИ ПО УКАЗАННОЙ ЗАЯВКЕ
                    db.del_comms_by_app(number_app: self.id_app)
                    db.getComByID(login: login as! String, pass: pass as! String, number: self.id_app)
                    
                    self.load_data()
                    self.table_comments.reloadData()
                    if #available(iOS 10.0, *) {
                        self.table_comments.refreshControl?.endRefreshing()
                    } else {
                        self.refreshControl?.endRefreshing()
                    }
                    
                }
            }
        }
    }
    
    func addMobilePay() {
        let ident: String = acc_ident
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
//        let sum = self.totalSum
        let sum = 1.00
        let desc = "Произведена оплата" + String(sum) + "руб. за " + paid_text
        let urlPath = Server.SERVER + "MobileAPI/AddPay.ashx?"
            + "idpay=" + idPay.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&status=" + status.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&ident=" + ident.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&desc=" + desc.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&sum=" + String(sum).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&idreq=" + id_app.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
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
                                                }else{
                                                    DispatchQueue.main.async {
//                                                        UserDefaults.standard.set(0, forKey: "request_read")
//                                                        UserDefaults.standard.synchronize()
                                                        self.payView.isHidden = true
                                                        self.heightPayView.constant = 0
                                                        self.addComm(comm: "Произведена оплата " + String(sum) + " руб. за " + self.paid_text)
                                                    }
                                                }
                                                
        })
        
        task.resume()
    }
    
}
