//
//  AdditionalServicesController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 04.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Dropper
import SwiftyXMLParser
import CoreData
import Crashlytics
//import YandexMobileMetrica

struct Services {
    let id:             String?
    let name:           String?
    let address:        String?
    let description:    String?
    let logo:           String?
    let phone:          String?
    let canbeordered:   String?
    let id_account:     String?
    let id_requesttype: String?
    let showinadblock:  String?
    let shopName:       String?
    let shopIDphone:    String?

    
    init(row: XML.Accessor) {
        id             = row.attributes["id"]
        name           = row.attributes["name"]
        address        = row.attributes["address"]
        description    = row.attributes["description"]
        logo           = row.attributes["logo"]
        phone          = row.attributes["phone"]
        canbeordered   = row.attributes["canbeordered"]
        id_account     = row.attributes["id_account"]
        id_requesttype = row.attributes["id_requesttype"]
        showinadblock  = row.attributes["showinadblock"]
        shopName       = row.attributes["shopName"]
        shopIDphone    = row.attributes["shopIDphone"]
    }
}

struct Objects {
    var sectionName : String!
    var sectionObjects : [Services]!
}

private var objectArray: [Services] = []
private var rowComms: [String : [Services]]  = [:]

class AdditionalServicesController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBAction func updateConect(_ sender: UIButton) {
        self.viewDidLoad()
    }
    @IBOutlet weak var updateConectBtn: UIButton!
    @IBOutlet weak var nonConectView: UIView!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
//        if UserDefaults.standard.bool(forKey: "NewMain"){
            navigationController?.popViewController(animated: true)
//        }else{
//            navigationController?.dismiss(animated: true, completion: nil)
//        }
    }
    
    var mainScreenXml:  XML.Accessor?
    private var refreshControl: UIRefreshControl?
    
    var login: String?
    var pass: String?
    var sectionNum = IndexPath()
    var openedSection: [Int: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("AdditionalService", forKey: "last_UI_action")
//        let params : [String : Any] = ["Переход на страницу": "Дополнительные услуги"]
//        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { (error) in
//            //            print("DID FAIL REPORT EVENT: %@", message)
//            print("REPORT ERROR: %@", error.localizedDescription)
//        })
        let defaults     = UserDefaults.standard
        nonConectView.isHidden = true
        tableView.isHidden = false
        login = defaults.string(forKey: "login")
        pass  = defaults.string(forKey: "pass")
        noDataLbl.isHidden = true
        automaticallyAdjustsScrollViewInsets = false
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
//        self.get_Services(login: self.login!, pass: self.pass!)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl!)
        }
        self.get_Services(login: self.login!, pass: self.pass!)
        startAnimation()
        loader.color = myColors.btnColor.uiColor()
        let titles = Titles()
        self.title = titles.getTitle(numb: "8")
        backBtn.tintColor = myColors.btnColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        updateConectBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: Network.reachability)
        updateUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            nonConectView.isHidden = false
            tableView.isHidden = true
        case .wifi: break
            
        case .wwan: break
            
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    private func startAnimation() {
        loader.isHidden     = false
        tableView.isHidden = true
        loader.startAnimating()
    }
    
    private func stopAnimation() {
        tableView.isHidden = false
        loader.stopAnimating()
        loader.isHidden     = true
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.get_Services(login: self.login!, pass: self.pass!)
            sleep(2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func get_Services(login: String, pass: String){
        objectArray.removeAll()
        let urlPath = Server.SERVER + Server.GET_ADDITIONAL_SERVICES + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        DispatchQueue.global(qos: .userInteractive).async {
            var request = URLRequest(url: URL(string: urlPath)!)
            request.httpMethod = "GET"
            print(request)
            URLSession.shared.dataTask(with: request) {
                data, error, responce in
                
                guard data != nil else { return }
                //                let responseString = String(data: data!, encoding: .utf8) ?? ""
                //                #if DEBUG
                //                print("responseString = \(responseString)")
                //                #endif
                var obj: [Services] = []
                let xml = XML.parse(data!)
                self.mainScreenXml = xml
                let requests = xml["AdditionalServices"]
                let row = requests["Group"]
                row.forEach { row in
                    rowComms[row.attributes["name"]!] = []
                    row["AdditionalService"].forEach {
//                        rowComms[row.attributes["name"]!]?.append( Services(row: $0) )
                        obj.append(Services(row: $0))
                    }
                }
                obj.forEach{
                    let url:NSURL = NSURL(string: ($0.logo)!)!
                    let data = try? Data(contentsOf: url as URL)
                    if UIImage(data: data!) == nil{
                        
                    }else{
                        objectArray.append($0)
                    }
                }
//                print(objectArray.count)
//                for (key, value) in rowComms {
//                    objectArray.append(Objects(sectionName: key, sectionObjects: value))
//                }
//                if objectArray.count > rowComms.count{
//                    objectArray.removeAll()
//                    for (key, value) in rowComms {
//                        objectArray.append(Objects(sectionName: key, sectionObjects: value))
//                    }
//                }
//                if objectArray.count == 0{
//                    DispatchQueue.main.async{
//                        if #available(iOS 10.0, *) {
//                            self.tableView.refreshControl?.endRefreshing()
//                        } else {
//                            self.refreshControl?.endRefreshing()
//                        }
//                        self.noDataLbl.isHidden = false
//                        self.tableView.isHidden = true
//                        self.stopAnimation()
//                    }
//                }else{
                    DispatchQueue.main.sync {
                        if #available(iOS 10.0, *) {
                            self.tableView.refreshControl?.endRefreshing()
                        } else {
                            self.refreshControl?.endRefreshing()
                        }
                        self.tableView.reloadData()
                        self.stopAnimation()
                    }
//                }
                
                }.resume()
        }
    }
    var descText:String = ""
    var temaText:String = ""
    var type:String = ""
    var name_account:String = ""
    var id_account:String = ""
    var edLogin:String = ""
    var edPass:String = ""
    
    func addAppAction(checkService: Int) {
        self.startAnimation()
        name_account = UserDefaults.standard.string(forKey: "name")!
        id_account   = UserDefaults.standard.string(forKey: "id_account")!
        edLogin      = UserDefaults.standard.string(forKey: "login")!
        edPass       = UserDefaults.standard.string(forKey: "pass")!
        let ident: String = UserDefaults.standard.string(forKey: "login")!.stringByAddingPercentEncodingForRFC3986() ?? ""
        temaText = objectArray[checkService].name!.stringByAddingPercentEncodingForRFC3986() ?? ""
        descText = "Ваш заказ принят. В ближайшее время сотрудник свяжется с Вами для уточнения деталей " + objectArray[checkService].name!
        type = objectArray[checkService].id_requesttype!.stringByAddingPercentEncodingForRFC3986() ?? ""
        descText = descText.stringByAddingPercentEncodingForRFC3986() ?? ""
        let consId = objectArray[checkService].id_account!.stringByAddingPercentEncodingForRFC3986() ?? ""
        let urlPath = Server.SERVER + Server.ADD_APP +
            "ident=" + ident +
            "&name=" + temaText +
            "&text=" + descText +
            "&type=" + type +
            "&priority=" + "2" +
            "&phonenum=" + ident +
            "&consultantId=" + consId
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        print("RequestURL: ", request.url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        self.stopAnimation()
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
                                                        self.view.isUserInteractionEnabled = true
                                                    })
                                                    return
                                                }
                                                
                                                self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(self.responseString)")
                                                
                                                self.choice()
        })
        task.resume()
        
    }
        
    func choice() {
        if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                self.stopAnimation()
                let alert = UIAlertController(title: "Ошибка", message: "Не переданы обязательные параметры", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "2") {
            DispatchQueue.main.async(execute: {
                self.stopAnimation()
                let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
                self.stopAnimation()
                let alert = UIAlertController(title: "Ошибка", message: "Не удалось. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if Int(responseString) == nil || Int(responseString)! < 1{
            DispatchQueue.main.async(execute: {
               self.stopAnimation()
               let alert = UIAlertController(title: "Ошибка", message: "Сервер не отвечает. Попробуйте позже", preferredStyle: .alert)
               let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
               alert.addAction(cancelAction)
               self.present(alert, animated: true, completion: nil)
            })
        } else {
//            if self.images.count != 0{
                self.sendEmailFile()
//            }
            DispatchQueue.main.async(execute: {
                
                // все ок - запишем заявку в БД (необходимо получить и записать авт. комментарий в БД
                // Запишем заявку в БД
                let db = DB()
                db.add_app(id: 1, number: self.responseString, text: self.descText, tema: self.temaText, date: self.date_teck()!, adress: "", flat: "", phone: "", owner: self.name_account, is_close: 1, is_read: 1, is_answered: 1, type_app: self.type, serverStatus: "новая заявка")
                db.getComByID(login: self.edLogin, pass: self.edPass, number: self.responseString)
                
                self.stopAnimation()
                
                let alert = UIAlertController(title: "Успешно", message: "Создана заявка №" + self.responseString, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            })
        }
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func date_teck() -> (String)? {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
        
    }
    
    var responseString = ""
    func sendEmailFile(){
        let reqID = responseString.stringByAddingPercentEncodingForRFC3986() ?? ""
        let urlPath = Server.SERVER + "MobileAPI/SendRequestToMail.ashx?" + "requestId=" + reqID
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        print(request)
    
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        self.stopAnimation()
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
                                                        self.view.isUserInteractionEnabled = true
                                                    })
                                                    return
                                                }
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(responseString)")
                                                
        })
        task.resume()
    }
    
//    func isSectionOpened(_ section: Int) -> Bool{
//        if let status = openedSection[section]{
//            return status
//        }
////        openedSection[section] = true
//        return false
//    }
    
//    func changeSectionStatus(_ section: Int){
//        if let status = openedSection[section]{
//            openedSection[section] = !status
//        }else{
//            openedSection[section] = true
//        }
//        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
//    }
}

extension AdditionalServicesController: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    // MARK: UITableViewDataSource
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if objectArray.count != 0{
//            return objectArray.count
//        }else{
//            return 0
//        }
//    }
    
    
    // Получим количество строк для конкретной секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isSectionOpened(section){
        if objectArray.count > 0{
            return objectArray.count
        }else{
            return 0
        }
    }
    
    // Получим данные для использования в ячейке
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableHeader", for: indexPath) as! ServiceTableHeader
//            cell.title.text = objectArray[indexPath.section].sectionName
//            cell.substring.textColor = myColors.btnColor.uiColor()
//            if isSectionOpened(indexPath.section){
//                cell.substring.text = "▼"
//            }else{
//                cell.substring.text = "▶︎"
//            }
//            return cell
//        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableCell", for: indexPath) as! ServiceTableCell
            let service = objectArray[indexPath.row]
            cell.configure(item: service)
            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0{
//            changeSectionStatus(indexPath.section)
//        }else{
        sectionNum = indexPath
        if objectArray[indexPath.row].canbeordered == "1" && objectArray[indexPath.row].id_requesttype != "" && objectArray[indexPath.row].id_account != ""{
            self.addAppAction(checkService: indexPath.row)
        }
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "goService", sender: self)
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goService") {
            let AddApp = segue.destination as! AdditionalVC
            AddApp.item = objectArray[sectionNum.row]
        }
    }
    // MARK: UITableViewDelegate
}

class ServiceTableCell: UITableViewCell {
    
    // MARK: Outlets
//    @IBOutlet weak var urlHeight: NSLayoutConstraint!
//    @IBOutlet weak var phoneHeight: NSLayoutConstraint!
//    @IBOutlet weak var imgWidth: NSLayoutConstraint!
//    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var substring: UILabel!
//    @IBOutlet weak var urlBtn: UIButton!
//    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var imgService: UIImageView!
    
//    @IBAction func urlBtnPressed(_ sender: UIButton) {
//        let url = URL(string: (urlBtn.titleLabel?.text)!)
//        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//    }
//    @IBAction func phoneBtnPressed(_ sender: UIButton) {
//        let newPhone = phoneBtn.titleLabel?.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
//        if let url = URL(string: "tel://" + newPhone!) {
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
//    }
    
    func configure(item: Services?) {
        guard let item = item else { return }
        let url:NSURL = NSURL(string: (item.logo)!)!
        let data = try? Data(contentsOf: url as URL)
//        name.text = item.name
//        substring.text = item.description
//        var str:String = item.address!
//        if str == ""{
//            urlBtn.isHidden = true
//            urlHeight.constant = 0
//        }else{
//            if !str.contains("http"){
//                str = "http://" + str
//            }
//            urlBtn.setTitle(str, for: .normal)
//        }
//        if item.phone == ""{
//            phoneBtn.isHidden = true
//            phoneHeight.constant = 0
//        }else{
//            phoneBtn.setTitle(item.phone, for: .normal)
//        }
        
        if UIImage(data: data!) == nil{
//            imgWidth.constant = 0
        }else{
            imgService.image = UIImage(data: data!)
        }
    }
    
}

class ServiceTableHeader: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var substring: UILabel!
}
