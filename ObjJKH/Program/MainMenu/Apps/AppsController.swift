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

protocol AppsUserUpdateDelegate {
    func updateList()
}

protocol AppsConsUpdateDelegate {
    func updateList()
}

class AppsController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddAppDelegate, AddAppConsDelegate, ShowAppDelegate, AppsUserUpdateDelegate, AppsConsUpdateDelegate {
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var back: UIBarButtonItem!
    
    var timer: Timer? = nil
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableApps: UITableView!
    @IBOutlet weak var switchCloseApps: UISwitch!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    @IBAction func switch_Go(_ sender: UISwitch) {
        updateCloseApps()
    }
    
    @IBAction func btnAddApp(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let isCons = defaults.string(forKey: "isCons")
        if (isCons == "0") {
            self.performSegue(withIdentifier: "add_app", sender: self)
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
        question_read = UserDefaults.standard.integer(forKey: "request_read")
        question_read_cons = UserDefaults.standard.integer(forKey: "request_read_cons")
        
        tableApps.delegate = self
        load_data()
        updateTable()
        
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
        back.tintColor = myColors.btnColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        
        let titles = Titles()
        self.title = titles.getTitle(numb: "2")
        
        timer = Timer(timeInterval: 4, target: self, selector: #selector(reload), userInfo: ["start" : "ok"], repeats: true)
        RunLoop.main.add(timer!, forMode: .defaultRunLoopMode)
        
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
        db.parse_Apps(login: UserDefaults.standard.string(forKey: "login") ?? "", pass: UserDefaults.standard.string(forKey: "pass") ?? "", isCons: UserDefaults.standard.string(forKey: "isCons")!)
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
        } else if (segue.identifier == "add_app_cons") {
            let AddApp = (segue.destination as! UINavigationController).viewControllers.first as! AddAppCons
            AddApp.delegate = self
        }
    }
    
    func addAppDone(addApp: AddAppUser) {
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
                    db.parse_Apps(login: login as! String, pass: pass as! String, isCons: isCons!)
                    
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
                    db.parse_Apps(login: login as! String, pass: pass as! String, isCons: isCons!)
                    
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
        if (UserDefaults.standard.integer(forKey: "request_read") < question_read){
            self.load_new_data()
        }
        if (UserDefaults.standard.integer(forKey: "request_read_cons") < question_read_cons){
            self.load_new_data()
        }
        self.load_data()
        self.tableApps.reloadData()
    }
    
}
