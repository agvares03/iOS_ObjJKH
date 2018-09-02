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

class AppsController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddAppDelegate, ShowAppDelegate, AppsUserUpdateDelegate {
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableApps: UITableView!
    @IBOutlet weak var switchCloseApps: UISwitch!
    @IBAction func switch_Go(_ sender: UISwitch) {
        updateCloseApps()
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
        db.parse_Apps(login: UserDefaults.standard.string(forKey: "login") ?? "", pass: UserDefaults.standard.string(forKey: "pass") ?? "", isCons: "0")
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
        } else if (segue.identifier == "add_app") {
            let AddApp = (segue.destination as! UINavigationController).viewControllers.first as! AddAppUser
            AddApp.delegate = self
        }
    }
    
    func addAppDone(addApp: AddAppUser) {
        load_data()
        self.tableApps.reloadData()
    }
    
    func showAppDone(showApp: AppUser) {
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
                    // ЗАЯВКИ С КОММЕНТАРИЯМИ
                    db.del_db(table_name: "Comments")
                    db.del_db(table_name: "Applications")
                    db.parse_Apps(login: login as! String, pass: pass as! String, isCons: "0")
                    
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
