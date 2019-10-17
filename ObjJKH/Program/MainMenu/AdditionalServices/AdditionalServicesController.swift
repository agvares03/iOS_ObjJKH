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
//import YandexMobileMetrica

struct Services {
    let id:            String?
    let name:          String?
    let address:       String?
    let description:   String?
    let logo:          String?
    let phone:         String?
    
    init(row: XML.Accessor) {
        id          = row.attributes["id"]
        name        = row.attributes["name"]
        address     = row.attributes["address"]
        description = row.attributes["description"]
        logo        = row.attributes["logo"]
        phone       = row.attributes["phone"]
    }
}

struct Objects {
    var sectionName : String!
    var sectionObjects : [Services]!
}

private var objectArray = [Objects]()
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
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.get_Services(login: self.login!, pass: self.pass!)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl!)
        }
        self.get_Services(login: self.login!, pass: self.pass!)
        startAnimation()
        
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
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
            DispatchQueue.main.async {
                if #available(iOS 10.0, *) {
                    self.tableView.refreshControl?.endRefreshing()
                } else {
                    self.refreshControl?.endRefreshing()
                }
            }
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
            
            URLSession.shared.dataTask(with: request) {
                data, error, responce in
                
                guard data != nil else { return }
                //                let responseString = String(data: data!, encoding: .utf8) ?? ""
                //                #if DEBUG
                //                print("responseString = \(responseString)")
                //                #endif
                let xml = XML.parse(data!)
                self.mainScreenXml = xml
                let requests = xml["AdditionalServices"]
                let row = requests["Group"]
                row.forEach { row in
                    rowComms[row.attributes["name"]!] = []
                    row["AdditionalService"].forEach {
                        rowComms[row.attributes["name"]!]?.append( Services(row: $0) )
                    }
                }
                for (key, value) in rowComms {
                    objectArray.append(Objects(sectionName: key, sectionObjects: value))
                }
                if objectArray.count > rowComms.count{
                    objectArray.removeAll()
                    for (key, value) in rowComms {
                        objectArray.append(Objects(sectionName: key, sectionObjects: value))
                    }
                }
                if objectArray.count == 0{
                    DispatchQueue.main.async{
                        self.noDataLbl.isHidden = false
                        self.tableView.isHidden = true
                    }
                }else{
                    DispatchQueue.main.sync {
                        if #available(iOS 10.0, *) {
                            self.tableView.refreshControl?.endRefreshing()
                        } else {
                            self.refreshControl?.endRefreshing()
                        }
                        self.tableView.reloadData()
                        self.stopAnimation()
                    }
                }
                
                }.resume()
        }
    }
    
    func isSectionOpened(_ section: Int) -> Bool{
        if let status = openedSection[section]{
            return status
        }
//        openedSection[section] = true
        return false
    }
    
    func changeSectionStatus(_ section: Int){
        if let status = openedSection[section]{
            openedSection[section] = !status
        }else{
            openedSection[section] = true
        }
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

extension AdditionalServicesController: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    
    // Получим количество строк для конкретной секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSectionOpened(section){
            return objectArray[section].sectionObjects.count + 1
        }
        return 1
    }
    
    // Получим данные для использования в ячейке
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableHeader", for: indexPath) as! ServiceTableHeader
            cell.title.text = objectArray[indexPath.section].sectionName
            cell.substring.textColor = myColors.btnColor.uiColor()
            if isSectionOpened(indexPath.section){
                cell.substring.text = "▼"
            }else{
                cell.substring.text = "▶︎"
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableCell", for: indexPath) as! ServiceTableCell
        let service = objectArray[indexPath.section].sectionObjects[indexPath.row - 1]
        cell.configure(item: service)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            changeSectionStatus(indexPath.section)
        }else{
            sectionNum = indexPath
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goService", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goService") {
            let AddApp = segue.destination as! AdditionalVC
            AddApp.item = objectArray[sectionNum.section].sectionObjects[sectionNum.row - 1]
        }
    }
    // MARK: UITableViewDelegate
}

class ServiceTableCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var urlHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var substring: UILabel!
    @IBOutlet weak var urlBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var imgService: UIImageView!
    @IBAction func urlBtnPressed(_ sender: UIButton) {
        let url = URL(string: (urlBtn.titleLabel?.text)!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @IBAction func phoneBtnPressed(_ sender: UIButton) {
        let newPhone = phoneBtn.titleLabel?.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        if let url = URL(string: "tel://" + newPhone!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func configure(item: Services?) {
        guard let item = item else { return }
        let url:NSURL = NSURL(string: (item.logo)!)!
        let data = try? Data(contentsOf: url as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
        name.text = item.name
        substring.text = item.description
        var str:String = item.address!
        if str == ""{
            urlBtn.isHidden = true
            urlHeight.constant = 0
        }else{
            if !str.contains("http"){
                str = "http://" + str
            }
            urlBtn.setTitle(str, for: .normal)
        }
        if item.phone == ""{
            phoneBtn.isHidden = true
            phoneHeight.constant = 0
        }else{
            phoneBtn.setTitle(item.phone, for: .normal)
        }        
        imgService.image = UIImage(data: data!)
        if imgService.image == nil{
            imgWidth.constant = 0
        }
    }
    
}

class ServiceTableHeader: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var substring: UILabel!
}
