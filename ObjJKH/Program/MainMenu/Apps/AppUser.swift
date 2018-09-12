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

protocol ShowAppDelegate : class {
    func showAppDone(showApp: AppUser)
}

class AppUser: UIViewController, UITableViewDelegate, UITableViewDataSource, CloseAppDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBAction func back_btn(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var date_txt: UILabel!
    @IBOutlet weak var tema_txt: UILabel!
    @IBOutlet weak var table_comments: UITableView!
    @IBOutlet weak var ed_comment: UITextField!
    
    var delegate:ShowAppDelegate?
    var updDelegt: AppsUserUpdateDelegate?
    var App: Applications? = nil
    
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
    var name_account: String = ""
    var id_account: String = ""
    var id_app: String = ""
    var teck_id: Int64 = 1

    @IBAction func add_foto(_ sender: UIButton) {
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
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
            
            let urlPath = Server.SERVER + Server.SEND_COMM + "reqID=" + id_app_txt + "&text=" + text_txt;
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        DispatchQueue.main.async(execute: {
                                                            self.StopIndicator()
                                                            let alert = UIAlertController(title: "Ошибка сервера", message: "Попробуйте позже", preferredStyle: .alert)
                                                            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                            alert.addAction(cancelAction)
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
        indicator.color = myColors.indicatorColor.uiColor()
        
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        view.frame.origin.y = -265
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        view.frame.origin.y = 0
    }

    func choice() {
        if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Ошибка сервера. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                
                // Экземпляр класса DB
                let db = DB()
                db.add_comm(ID: Int64(self.responseString)!, id_request: Int64(self.id_app)!, text: self.ed_comment.text!, added: self.date_teck()!, id_Author: self.id_author, name: self.name_account, id_account: self.id_account)
                self.ed_comment.text = ""
                self.StopIndicator()
                self.load_data()
                self.updateTable()
                
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
        } else {
            let cell = self.table_comments.dequeueReusableCell(withIdentifier: "CommCell") as! CommCell
            cell.author.text     = "Вы" //comm.author
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
    
}
