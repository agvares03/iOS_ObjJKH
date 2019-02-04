//
//  AppCons.swift
//  ObjJKH
//
//  Created by Роман Тузин on 06.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import UserNotifications
import Firebase


protocol ShowAppConsDelegate : class {
    func showAppDoneCons(showApp: AppCons)
}

class AppCons: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var hidden_Header: UIBarButtonItem!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBAction func back_btn(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var table_Const: NSLayoutConstraint!
    @IBOutlet weak var view1: NSLayoutConstraint!
    @IBOutlet weak var view2: NSLayoutConstraint!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var date_txt: UILabel!
    @IBOutlet weak var tema_txt: UILabel!
    @IBOutlet weak var ed_comment: UITextField!
    @IBOutlet weak var table_comments: UITableView!
    
    var delegate:ShowAppConsDelegate?
    var updDelegt: AppsConsUpdateDelegate?
    var App: Applications? = nil
    
    private var refreshControl: UIRefreshControl?
    @IBOutlet weak var type_app: UILabel!
    @IBOutlet weak var ls_adress: UILabel!
    @IBOutlet weak var ls_phone: UILabel!
    @IBOutlet weak var ls_call: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    // массивы для перевода на консультантов (один массив - имена, другой - коды)
    var names_cons: [String] = []
    var ids_cons: [String] = []
    var teck_cons = -1
    
    var txt_tema: String = ""
    var txt_date: String = ""
    
    var responseString: String = ""
    var teckID: Int64 = 0
    var fetchedResultsController: NSFetchedResultsController<Comments>?
    
    // id аккаунта текущего
    var id_author: String = ""
    var name_account: String = ""
    var id_account: String = ""
    var id_app: String = ""
    var teck_id: Int64 = 1
    var adress: String = ""
    var flat: String = ""
    var phone: String = ""
    var read: Int64 = 0
    
    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    var postData = [String]()
    
    var str_type_app: String = ""
    
    var timer: Timer? = nil
    
    var isHidden = true
    
    @IBAction func hiddHeader(_ sender: UIButton) {
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
    
    @IBAction func call(_ sender: UIButton) {
        let newPhone = phone.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        if let url = URL(string: "tel://" + newPhone) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
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
    
    @IBAction func add_comm(_ sender: UIButton) {
        if (ed_comment.text != "") {
            self.StartIndicator()
            
            let id_app_txt = self.id_app.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            let text_txt: String   = ed_comment.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            
            let urlPath = Server.SERVER + Server.SEND_COMM_CONS + "reqID=" + id_app_txt + "&accID=" + id_account + "&text=" + text_txt;
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        DispatchQueue.main.async(execute: {
                                                            self.StopIndicator()
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
                                                    
                                                    self.choice()
            })
            task.resume()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if view.frame.width == 320{
            view1.constant = 60.75
            view2.constant = 60.75
        }
        self.StopIndicator()
        if read == 0{
            self.read_request()
        }
        // получим id текущего аккаунта
        let defaults = UserDefaults.standard
        id_author    = defaults.string(forKey: "id_account")!
        name_account = defaults.string(forKey: "name")!
        id_account   = defaults.string(forKey: "id_account")!
        
        tema_txt.text = txt_tema
        date_txt.text = txt_date
        
        table_comments.delegate = self
        table_comments.rowHeight = UITableViewAutomaticDimension
        table_comments.estimatedRowHeight = 44.0
        
        load_data()
        updateTable()
        
        get_cons(id_acc: id_account)
        
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
        
        let titles = Titles()
        self.title = titles.getSimpleTitle(numb: "2")
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
        back.tintColor = myColors.btnColor.uiColor()
        ls_call.tintColor = myColors.btnColor.uiColor()
        hidden_Header.tintColor = myColors.indicatorColor.uiColor()
        let numberLine: CGFloat = CGFloat(tema_txt!.numberOfVisibleLines)
        let count = tema_txt.frame.size.height * numberLine
        headerHeight.constant = headerHeight.constant + count
        headerView.isHidden = true
        table_Const.constant = table_Const.constant - headerView.frame.size.height
    }
    
    func read_request(){
        let request_id = String(self.id_app)
        
        var request = URLRequest(url: URL(string: Server.SERVER + "SetRequestReadedState.ashx?" + "reqID=" + request_id)!)
        request.httpMethod = "GET"
        print(request)
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            print(String(data: data!, encoding: .utf8) ?? "")
            
            guard data != nil else { return }
            
            var request_read = UserDefaults.standard.integer(forKey: "request_read_cons")
            request_read -= 1
            DispatchQueue.main.async {
                let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
                let updatedBadgeNumber = currentBadgeNumber - 1
                if (updatedBadgeNumber > -1) {
                    UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
                }
            }
            UserDefaults.standard.setValue(request_read, forKey: "request_read_cons")
            UserDefaults.standard.synchronize()
            
            }.resume()
    }
    
    @objc func reload() {
        DispatchQueue.global(qos: .userInteractive).async {
            let db = DB()
            if (db.isNotification()) {
                self.load_notification()                
            }
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        view.frame.origin.y = -265
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        view.frame.origin.y = 0
    }
    
    func load_notification() {
        DispatchQueue.main.async(execute: {
            self.load_new_data()
        })
    }
    
    func choice() {
        if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                
                self.ed_comment.text = ""
                self.load_new_data()
//                // Экземпляр класса DB
//                let db = DB()
//                db.add_comm(ID: Int64(self.responseString)!, id_request: Int64(self.id_app)!, text: self.ed_comment.text!, added: self.date_teck()!, id_Author: self.id_author, name: self.name_account, id_account: self.id_account)
//                self.ed_comment.text = ""
//                self.StopIndicator()
//                self.load_data()
//                self.updateTable()
                
                self.view.endEditing(true)
                
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func load_data() {
        let predicateFormat = String(format: "id_app = %@", id_app)
        fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Comments", keysForSort: ["date"], predicateFormat: predicateFormat) as? NSFetchedResultsController<Comments>
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
            let cell = self.table_comments.dequeueReusableCell(withIdentifier: "CommCell") as! CommCell
            cell.author.text     = comm.author
            cell.date.text       = comm.date
            cell.text_comm.text  = comm.text
            self.teck_id = comm.id + 1
            
            //            #if isGKRZS
            //            let server = Server()
            //            cell.author.textColor = server.hexStringToUIColor(hex: "#1f287f")
            //            #else
            //            #endif
            
            return cell
        } else {
            let cell = self.table_comments.dequeueReusableCell(withIdentifier: "CommCellCons") as! CommCellCons
            cell.author.text     = comm.author
            cell.date.text       = comm.date
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        if (timer != nil) {
            timer?.invalidate()
        }
    }
    
    func get_cons(id_acc: String) {
        let urlPath = Server.SERVER + Server.GET_CONS + "id_account=" + id_acc
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    return
                                                } else {
                                                    do {
                                                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                        
                                                        // Получим список консультантов
                                                        if let houses = json["data"] {
                                                            for index in 0...(houses.count)!-1 {
                                                                let obj_cons = houses.object(at: index) as! [String:AnyObject]
                                                                for obj in obj_cons {
                                                                    if obj.key == "name" {
                                                                        self.names_cons.append(obj.value as! String)
                                                                    }
                                                                    if obj.key == "id" {
                                                                        self.ids_cons.append(String(describing: obj.value))
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
    
    func StartIndicator() {
        
//        self.indicator.startAnimating()
//        self.indicator.isHidden = false
    }
    
    func StopIndicator() {
        
//        self.indicator.stopAnimating()
//        self.indicator.isHidden = true
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
        
        print(reqID)
        
        group.enter()
        let uid = UUID().uuidString
        Alamofire.upload(multipartFormData: { multipartFromdata in
            multipartFromdata.append(UIImageJPEGRepresentation(img, 0.5)!, withName: uid, fileName: "\(uid).jpg", mimeType: "image/jpeg")
        }, to: Server.SERVER + Server.ADD_FILE + "reqID=" + reqID + "&accID=" + id) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value!)
                    group.leave()
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        group.wait()
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "files" {
            let vc = segue.destination as! FilesController
            vc.data_ = (fetchedResultsController?.fetchedObjects?.filter { $0.text?.contains("файл") ?? false }) ?? []
        } else if segue.identifier == "select_cons" {
            let selectItemController = (segue.destination as! UINavigationController).viewControllers.first as! SelectItemController
            selectItemController.strings = names_cons
            selectItemController.selectedIndex = teck_cons
            selectItemController.selectHandler = { selectedIndex in
                self.teck_cons = selectedIndex
                let choice_cons = self.appConsString()
                let choice_id   = self.ids_cons[selectedIndex]
                print("User - " + choice_cons + " id - " + choice_id)
                // Переведем заявку другому консультанту
                self.ch_app(id_account: self.id_account, id_app: self.id_app, new_cons_id: choice_id, new_cons_name: choice_cons)
            }
        }
    }
    
    func appConsString() -> String {
        if teck_cons == -1 {
            return "не выбран"
        }
        
        if teck_cons >= 0 && teck_cons < names_cons.count {
            return names_cons[teck_cons]
        }
        
        return ""
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.global(qos: .background).async {
                sleep(2)
                DispatchQueue.main.sync {
                    self.load_new_data()
                }
            }
        }
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

    // Действия консультанта
    // Принять заявку
    @IBAction func get_app(_ sender: UIButton) {
        let alert = UIAlertController(title: "Принятие заявки", message: "Принять заявку к выполнению?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
            
            self.StartIndicator()
            
            let id_app_txt = self.id_app.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            
            let urlPath = Server.SERVER + Server.GET_APP + "accID=" + self.id_account + "&reqID=" + id_app_txt
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        DispatchQueue.main.async(execute: {
                                                            self.StopIndicator()
                                                            
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
                                                    
                                                    self.choice_get_app()
            })
            task.resume()
            
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    // Перевести заявку
    func ch_app(id_account: String, id_app: String, new_cons_id: String, new_cons_name: String) {
        self.StartIndicator()
        let urlPath = Server.SERVER + Server.CH_CONS + "accID=" + id_account + "&reqID=" + id_app + "&chgID=" + new_cons_id
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        self.StopIndicator()
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
                                                
                                                self.choice_cons_app(name_cons: new_cons_name)
        })
        task.resume()
    }
    // Выполнить заявку
    @IBAction func ok_app(_ sender: UIButton) {
        let alert = UIAlertController(title: "Выполнение заявки", message: "Выполнить заявку?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
            
            self.StartIndicator()
            
            let id_app_txt = self.id_app.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            
            let urlPath = Server.SERVER + Server.OK_APP + "accID=" + self.id_account + "&reqID=" + id_app_txt
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        DispatchQueue.main.async(execute: {
                                                            self.StopIndicator()
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
                                                    
                                                    self.choice_ok_app()
            })
            task.resume()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    // Закрытие заявки
    @IBAction func close_app(_ sender: UIButton) {
        let alert = UIAlertController(title: "Закрытие заявки", message: "Действительно закрыть заявку?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
            
            self.StartIndicator()
            
            let id_app_txt = self.id_app.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            
            let urlPath = Server.SERVER + Server.CLOSE_APP_CONS + "accID=" + self.id_account + "&reqID=" + id_app_txt
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        DispatchQueue.main.async(execute: {
                                                            self.StopIndicator()
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
                                                    
                                                    self.choice_close_app()
            })
            task.resume()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // ПРОЦЕДУРЫ ОТВЕТЫ ОТ СЕРВЕРА
    // Ответ - принятие заявки
    func choice_get_app() {
        if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "3"){
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Предупреждение", message: "Заявка принята специалистом", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                self.load_new_data()
//                let db = DB()
//                db.add_comm(ID: self.teckID, id_request: Int64(self.id_app)!, text: "Заявка принята специалистом " + self.name_account, added: self.date_teck()!, id_Author: self.id_author, name: self.name_account, id_account: self.id_account)
//                self.StopIndicator()
//                self.load_data()
//                self.updateTable()
            })
        }
    }
    
    // Ответ - комментарий
    func choice_send_comm(text: String) {
        if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.load_new_data()
//                // Экземпляр класса DB
//                let db = DB()
//                db.add_comm(ID: Int64(self.responseString)!, id_request: Int64(self.id_app)!, text: text, added: self.date_teck()!, id_Author: self.id_author, name: self.name_account, id_account: self.id_account)
//                self.StopIndicator()
//                self.load_data()
//                self.updateTable()
                
            })
        }
    }
    
    // Ответ - перевести заявку другому консультанту
    func choice_cons_app(name_cons: String) {
        if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                // Экземпляр класса DB
                let db = DB()
                db.add_comm(ID: self.teckID, id_request: Int64(self.id_app)!, text: "Заявка №" + self.id_app + " переведена специалисту - " + name_cons, added: self.date_teck()!, id_Author: self.id_account, name: self.name_account, id_account: self.id_account)
                // Подумать, как можно удалить потом
                //db.del_app(number: self.id_app)
                self.StopIndicator()
                self.load_data()
                self.updateTable()
                
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    // Ответ - выполнить заявку
    func choice_ok_app() {
        if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else{
            DispatchQueue.main.async(execute: {
                self.load_new_data()
//                // Экземпляр класса DB
//                let db = DB()
//                db.add_comm(ID: self.teckID, id_request: Int64(self.id_app)!, text: "Заявка №" + self.id_app + " выполнена специалистом - " + self.name_account, added: self.date_teck()!, id_Author: self.id_author, name: self.name_account, id_account: self.id_account)
//                // Подумать, как можно удалить потом
//                //                db.del_app(number: self.id_app)
//                self.StopIndicator()
//                self.load_data()
//                self.updateTable()
                
            })
        }
    }
    
    // Ответ - закрыть заявку
    func choice_close_app() {
        if (responseString == "xxx") {
            self.StopIndicator()
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
        } else{
            DispatchQueue.main.async(execute: {
                // Успешно - обновим значение в БД
                self.App?.is_close = 0
                CoreDataManager.instance.saveContext()
                
                self.load_new_data()
//                // Экземпляр класса DB
//                let db = DB()
//                db.add_comm(ID: self.teckID, id_request: Int64(self.id_app)!, text: "Заявка №" + self.id_app + " закрыта специалистом - " + self.name_account, added: self.date_teck()!, id_Author: self.id_author, name: self.name_account, id_account: self.id_account)
//                // Подумать, как можно удалить потом
//                //                db.del_app(number: self.id_app)
//                self.StopIndicator()
//                self.load_data()
//                self.updateTable()
            })
        }
    }
    
    
}

extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}
