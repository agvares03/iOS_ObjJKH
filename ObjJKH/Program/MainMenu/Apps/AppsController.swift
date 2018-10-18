//
//  AppsController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 31.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import CoreData

protocol AppsUserUpdateDelegate {
    func updateList()
}

protocol AppsConsUpdateDelegate {
    func updateList()
}

class AppsController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddAppDelegate, AddAppConsDelegate, ShowAppDelegate, AppsUserUpdateDelegate, AppsConsUpdateDelegate {
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableApps: UITableView!
    @IBOutlet weak var switchCloseApps: UISwitch!
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
    
    private var refreshControl: UIRefreshControl?
    var fetchedResultsController: NSFetchedResultsController<Applications>?

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        // Установим цвета для элементов в зависимости от Таргета
        btnAdd.backgroundColor = myColors.btnColor.uiColor()
        back.tintColor = myColors.btnColor.uiColor()
        
        let titles = Titles()
        self.title = titles.getTitle(numb: "2")
        
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
        
        // Определим интерфейс для разных ук
//        #if isGKRZS
//        let img = UIImage(named: "ic_comm_list_white")
//        #else
        let img = UIImage(named: "app_close")
//        #endif
        print(app.tema!, app.is_close)
        if (app.is_close == 1) {
            let cell = self.tableApps.dequeueReusableCell(withIdentifier: "AppCell") as! AppsCell
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
    
}
