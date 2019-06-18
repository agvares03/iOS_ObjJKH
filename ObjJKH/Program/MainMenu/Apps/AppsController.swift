//
//  AppsController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 31.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase
import YandexMobileMetrica

protocol AppsUserUpdateDelegate {
    func updateList()
}

protocol AppsConsUpdateDelegate {
    func updateList()
}

class AppsController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddAppDelegate, NewAddAppDelegate, AddAppConsDelegate, ShowAppDelegate, ShowNewAppDelegate, AppsUserUpdateDelegate, AppsConsUpdateDelegate {
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var back: UIBarButtonItem!
    
    var timer: Timer? = nil
    var isCons: String = "0"
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
//        if UserDefaults.standard.bool(forKey: "NewMain"){
            navigationController?.popViewController(animated: true)
//        }else{
//            navigationController?.dismiss(animated: true, completion: nil)
//        }
    }
    
    @IBAction func updateConect(_ sender: UIButton) {
        self.viewDidLoad()
    }
    @IBOutlet weak var updateConectBtn: UIButton!
    @IBOutlet weak var nonConectView: UIView!
    @IBOutlet weak var addLS: UILabel!
    @IBOutlet weak var lsView: UIView!
    @IBOutlet weak var hiddenAppsView: UIView!
    @IBOutlet weak var tableApps: UITableView!
    @IBOutlet weak var switchCloseApps: UISwitch!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBAction func switch_Go(_ sender: UISwitch) {
        updateCloseApps()
    }
    
    @objc private func lblTapped(_ sender: UITapGestureRecognizer) {
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "addLSMup", sender: self)
        #elseif isPocket
        self.performSegue(withIdentifier: "addLSPocket", sender: self)
        #else
        self.performSegue(withIdentifier: "addLS", sender: self)
        #endif
    }
    
    @IBAction func btnAddApp(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let isCons = defaults.string(forKey: "isCons")
        if (isCons == "0") {
            self.performSegue(withIdentifier: "add_app", sender: self)
//            self.performSegue(withIdentifier: "new_add_app", sender: self)
        } else {
            self.performSegue(withIdentifier: "add_app_cons", sender: self)
        }
    }
    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    var postData = [String]()
    var question_read = 0
    var question_read_cons = 0
    private var refreshControl: UIRefreshControl?
    var fetchedResultsController: NSFetchedResultsController<Applications>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "fromMenu")
//        let defaults     = UserDefaults.standard
        let params : [String : Any] = ["Переход на страницу": "Заявки"]
        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { (error) in
//            print("DID FAIL REPORT EVENT: %@", message)
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        question_read = UserDefaults.standard.integer(forKey: "request_read")
        question_read_cons = UserDefaults.standard.integer(forKey: "request_read_cons")
        
        // Проверим является ли пользователем консультантом, потому что консультант должен видеть заявки
        isCons = UserDefaults.standard.string(forKey: "isCons") ?? "0"
        
        tableApps.delegate = self
        load_data()
        updateTable()
        
        nonConectView.isHidden = true
        lsView.isHidden = true
        btnAdd.isHidden = false
        tableApps.isHidden = false
        hiddenAppsView.isHidden = false
        
        let str_ls = UserDefaults.standard.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        
        if (isCons == "1") {
            lsView.isHidden = true
        } else {
            
            if ((str_ls_arr?.count)! > 0) && str_ls_arr![0] != ""{
                lsView.isHidden = true
            } else {
                addLS.textColor = myColors.btnColor.uiColor()
                let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
                let underlineAttributedString = NSAttributedString(string: "Подключить лицевой счет", attributes: underlineAttribute)
                addLS.attributedText = underlineAttributedString
                let tap = UITapGestureRecognizer(target: self, action: #selector(lblTapped(_:)))
                addLS.isUserInteractionEnabled = true
                addLS.addGestureRecognizer(tap)
                lsView.isHidden = false
                btnAdd.isHidden = true
                tableApps.isHidden = true
                hiddenAppsView.isHidden = true
            }
            
        }
        
        // Обновление списка заявок
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tableApps.refreshControl = refreshControl
        } else {
            self.tableApps.addSubview(refreshControl!)
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, error in
        })
        // Установим цвета для элементов в зависимости от Таргета
        
        btnAdd.backgroundColor = myColors.btnColor.uiColor()
        switchCloseApps.tintColor = myColors.btnColor.uiColor()
        switchCloseApps.onTintColor = myColors.btnColor.uiColor()
        back.tintColor = myColors.btnColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        updateConectBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        
        let titles = Titles()
        self.title = titles.getTitle(numb: "2")
        
        timer = Timer(timeInterval: 4, target: self, selector: #selector(reload), userInfo: ["start" : "ok"], repeats: true)
        RunLoop.main.add(timer!, forMode: .defaultRunLoopMode)
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
            btnAdd.isHidden = true
            tableApps.isHidden = true
            hiddenAppsView.isHidden = true
        case .wifi: break
            
        case .wwan: break
            
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    @objc func reload() {
        DispatchQueue.global(qos: .userInteractive).async {
            let db = DB()
            if (db.isNotification()) {
                self.load_notification()
            }
        }
    }
    
    func load_notification() {
        DispatchQueue.main.async(execute: {
            self.load_new_data()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateList() {
        let db = DB()
        fetchedResultsController?.fetchedObjects?.forEach {
            db.del_app(number: $0.number ?? "")
        }
        db.del_db(table_name: "Comments")
        db.del_db(table_name: "Fotos")
        db.parse_Apps(login: UserDefaults.standard.string(forKey: "login") ?? "", pass: UserDefaults.standard.string(forKey: "pass") ?? "", isCons: UserDefaults.standard.string(forKey: "isCons")!, isLoad: false)
        load_data()
        updateTable()
    }
    
    func load_data() {
        if (switchCloseApps.isOn) {
            self.fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Applications", keysForSort: ["number"]) as? NSFetchedResultsController<Applications>
        } else {
            let close: NSNumber = 1
            let predicateFormat = String(format: " is_close =%@ ", close)
            self.fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Applications", keysForSort: ["number"], predicateFormat: predicateFormat) as? NSFetchedResultsController<Applications>
        }
        
        do {
            try fetchedResultsController!.performFetch()
        } catch {
            print(error)
        }
    }
    
    func updateTable() {
        tableApps.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let app = (fetchedResultsController?.object(at: indexPath))! as Applications
        let isCons = UserDefaults.standard.string(forKey: "isCons")
        // Определим интерфейс для разных ук
//        #if isGKRZS
//        let img = UIImage(named: "ic_comm_list_white")
//        #else
        let img = UIImage(named: "app_close")
//        #endif
        if (app.is_close == 1){
            let cell = self.tableApps.dequeueReusableCell(withIdentifier: "AppCell") as! AppsCell
            if (app.is_read_client == 0 && isCons == "0") || (app.is_read == 0 && isCons == "1"){
                cell.Number.font = UIFont.boldSystemFont(ofSize: 16.0)
                cell.Number.textColor = .black
                cell.tema.font = UIFont.boldSystemFont(ofSize: 16.0)
                cell.tema.textColor = .black
                cell.date_app.font = UIFont.boldSystemFont(ofSize: 13.0)
                cell.date_app.textColor = .black
            }else{
                cell.Number.font = UIFont.systemFont(ofSize: 16.0)
                cell.Number.textColor = .lightGray
                cell.tema.font = UIFont.systemFont(ofSize: 16.0)
                cell.tema.textColor = .lightGray
                cell.date_app.font = UIFont.systemFont(ofSize: 13.0)
                cell.date_app.textColor = .black
            }
            
            cell.Number.text    = app.number
            cell.tema.text      = app.tema
            //            cell.text_app.text  = app.text
            cell.date_app.text  = app.date
            cell.image_app.image = img
            cell.image_app.tintColor = myColors.btnColor.uiColor()
//            #if isGKRZS
//            let server = Server()
//            cell.Number.textColor = server.hexStringToUIColor(hex: "#1f287f")
//            #else
//            #endif
            
            cell.delegate = self
            return cell
        } else {
            let cell = self.tableApps.dequeueReusableCell(withIdentifier: "AppCellClose") as! AppsCellClose
            if (app.is_read_client == 0 && isCons == "0") || (app.is_read == 0 && isCons == "1"){
                cell.Number.font = UIFont.boldSystemFont(ofSize: 16.0)
                cell.Number.textColor = .black
                cell.tema.font = UIFont.boldSystemFont(ofSize: 16.0)
                cell.tema.textColor = .black
                cell.date_app.font = UIFont.boldSystemFont(ofSize: 13.0)
                cell.date_app.textColor = .black
            }else{
                cell.Number.font = UIFont.systemFont(ofSize: 16.0)
                cell.Number.textColor = .lightGray
                cell.tema.font = UIFont.systemFont(ofSize: 16.0)
                cell.tema.textColor = .lightGray
                cell.date_app.font = UIFont.systemFont(ofSize: 13.0)
                cell.date_app.textColor = .black
            }
            cell.Number.text    = app.number
            cell.tema.text      = app.tema
            //            cell.text_app.text  = app.text
            cell.date_app.text  = app.date
            
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let app = (fetchedResultsController?.object(at: indexPath))! as Applications
        let defaults = UserDefaults.standard
        let isCons = defaults.string(forKey: "isCons")
        
        if (app.is_close == 1) {
            if (isCons == "0") {
                self.performSegue(withIdentifier: "show_app", sender: self)
//                self.performSegue(withIdentifier: "new_show_app", sender: self)
            } else {
                self.performSegue(withIdentifier: "show_app_cons", sender: self)
            }
        } else {
            if (isCons == "0") {
                self.performSegue(withIdentifier: "show_app_close", sender: self)
            } else {
                self.performSegue(withIdentifier: "show_app_close_cons", sender: self)
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
            if app.paid_text != nil{
                AppUser.paid_text = app.paid_text!
            }
            if app.paid_sum != nil{
                AppUser.paid_sum = Double(app.paid_sum!) as! Double
                AppUser.isPay = app.is_pay
                AppUser.isPaid = app.is_paid
            }
            if app.acc_ident != nil{
                AppUser.acc_ident = app.acc_ident!
            }
            
            //            AppUser.txt_text   = app.text!
            AppUser.txt_date   = app.date!
            AppUser.id_app     = app.number!
            AppUser.delegate   = self
            AppUser.App        = app
            AppUser.updDelegt = self
        }else if segue.identifier == "new_show_app" {
            let indexPath = tableApps.indexPathForSelectedRow!
            let app = fetchedResultsController!.object(at: indexPath)
            
            let AppUser             = segue.destination as! NewAppUser
            AppUser.title           = "Заявка №" + app.number!
            AppUser.txt_tema   = app.tema!
            AppUser.str_type_app = app.type_app!
            AppUser.read = app.is_read_client
            AppUser.adress = app.adress!
            AppUser.flat = app.flat!
            AppUser.phone = app.phone!
            if app.paid_text != nil{
                AppUser.paid_text = app.paid_text!
            }
            if app.paid_sum != nil{
                AppUser.paid_sum = Double(app.paid_sum!) as! Double
                AppUser.isPay = app.is_pay
                AppUser.isPaid = app.is_paid
            }
            if app.acc_ident != nil{
                AppUser.acc_ident = app.acc_ident!
            }
            
            //            AppUser.txt_text   = app.text!
            AppUser.txt_date   = app.date!
            AppUser.id_app     = app.number!
            AppUser.delegate   = self
            AppUser.App        = app
            AppUser.updDelegt = self
        } else if (segue.identifier == "show_app_close") {
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
            AppUser.delegate   = self
            AppUser.App        = app
            AppUser.updDelegt  = self
        } else if segue.identifier == "show_app_cons" {
            let indexPath = tableApps.indexPathForSelectedRow!
            let app = fetchedResultsController!.object(at: indexPath)
            
            let AppUser             = segue.destination as! AppCons
            AppUser.title           = "Заявка №" + app.number!
            AppUser.txt_tema   = app.tema!
            AppUser.str_type_app = app.type_app!
            AppUser.read = app.is_read
            AppUser.adress = app.adress!
            AppUser.flat = app.flat!
            AppUser.phone = app.phone!
            //            AppUser.txt_text   = app.text!
            AppUser.txt_date   = app.date!
            AppUser.id_app     = app.number!
            AppUser.delegate   = self as? ShowAppConsDelegate
            AppUser.App        = app
            AppUser.updDelegt = self
        } else if (segue.identifier == "show_app_close_cons") {
            let indexPath = tableApps.indexPathForSelectedRow!
            let app = fetchedResultsController!.object(at: indexPath)
            
            let AppUser             = segue.destination as! AppCons
            AppUser.title           = "Заявка №" + app.number!
            AppUser.txt_tema   = app.tema!
            AppUser.str_type_app = app.type_app!
            AppUser.read = app.is_read
            AppUser.adress = app.adress!
            AppUser.flat = app.flat!
            AppUser.phone = app.phone!
            //            AppUser.txt_text   = app.text!
            AppUser.txt_date   = app.date!
            AppUser.id_app     = app.number!
            AppUser.delegate   = self as? ShowAppConsDelegate
            AppUser.App        = app
            AppUser.updDelegt  = self
        }else if (segue.identifier == "add_app") {
                let AddApp = (segue.destination as! UINavigationController).viewControllers.first as! AddAppUser
                AddApp.delegate = self
        }else if (segue.identifier == "new_add_app") {
            let AddApp = (segue.destination as! UINavigationController).viewControllers.first as! NewAddAppUser
            AddApp.delegate = self
        } else if (segue.identifier == "add_app_cons") {
                let AddApp = (segue.destination as! UINavigationController).viewControllers.first as! AddAppCons
                AddApp.delegate = self
        }
    }
    
    func addAppDone(addApp: AddAppUser) {
        load_data()
        self.tableApps.reloadData()
    }
    
    func newAddAppDone(addApp: NewAddAppUser) {
        load_data()
        self.tableApps.reloadData()
    }

    func addAppDoneCons(addApp: AddAppCons) {
        load_data()
        self.tableApps.reloadData()
    }
    
    func showAppDone(showApp: AppUser) {
        load_data()
        updateTable()
    }
    
    func showAppDone(showApp: NewAppUser) {
        load_data()
        updateTable()
    }
    
    func showAppDoneCons(showApp: AppCons) {
        load_data()
        updateTable()
    }
    
    func updateCloseApps() {
        load_data()
        updateTable()
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
                    let isCons = defaults.string(forKey: "isCons")
                    // ЗАЯВКИ С КОММЕНТАРИЯМИ
                    db.del_db(table_name: "Comments")
                    db.del_db(table_name: "Fotos")
                    db.del_db(table_name: "Applications")
                    db.parse_Apps(login: login as! String, pass: pass as! String, isCons: isCons!, isLoad: false)
                    
                    self.load_data()
                    self.tableApps.reloadData()
                    if #available(iOS 10.0, *) {
                        self.tableApps.refreshControl?.endRefreshing()
                    } else {
                        self.refreshControl?.endRefreshing()
                    }
                    
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        if (timer != nil) {
            timer?.invalidate()
        }
    }
    
    func load_new_data() {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.global(qos: .background).async {
                sleep(2)
                DispatchQueue.main.sync {
                    // Экземпляр класса DB
                    let db = DB()
                    let defaults = UserDefaults.standard
                    let login = defaults.object(forKey: "login")
                    let pass = defaults.object(forKey: "pass")
                    let isCons = defaults.string(forKey: "isCons")
                    // ЗАЯВКИ С КОММЕНТАРИЯМИ
                    db.del_db(table_name: "Comments")
                    db.del_db(table_name: "Fotos")
                    db.del_db(table_name: "Applications")
                    db.parse_Apps(login: login as! String, pass: pass as! String, isCons: isCons!, isLoad: false)
                    
                    self.load_data()
                    self.tableApps.reloadData()
                    if #available(iOS 10.0, *) {
                        self.tableApps.refreshControl?.endRefreshing()
                    } else {
                        self.refreshControl?.endRefreshing()
                    }
                    
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.load_new_data()
//        if UserDefaults.standard.bool(forKey: "back"){
//            UserDefaults.standard.set(false, forKey: "back")
//            self.load_new_data()
//        }
//        self.load_data()
//        self.tableApps.reloadData()
    }
    
}
