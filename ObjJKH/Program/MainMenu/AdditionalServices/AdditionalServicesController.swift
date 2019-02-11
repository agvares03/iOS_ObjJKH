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
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    var mainScreenXml:  XML.Accessor?
    private var refreshControl: UIRefreshControl?
    
    var login: String?
    var pass: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults     = UserDefaults.standard
        login = defaults.string(forKey: "login")
        pass  = defaults.string(forKey: "pass")
        
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
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
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
            
//            var request = URLRequest(url: URL(string: "http://uk-gkh.org/komfortnew/GetAdditionalServices.ashx?login=+79261937745&pwd=123")!)
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
                DispatchQueue.main.sync {
                    if #available(iOS 10.0, *) {
                        self.tableView.refreshControl?.endRefreshing()
                    } else {
                        self.refreshControl?.endRefreshing()
                    }
                    self.tableView.reloadData()
                    self.stopAnimation()
                }
                }.resume()
        }
    }
}

extension AdditionalServicesController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    
    // Получим количество строк для конкретной секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    
    // Получим заголовок для секции
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName
    }
    
    
    // Получим данные для использования в ячейке
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableCell", for: indexPath) as! ServiceTableCell
        let service = objectArray[indexPath.section].sectionObjects[indexPath.row]
        cell.configure(item: service)
        return cell
    }
    
    // MARK: UITableViewDelegate
}

class ServiceTableCell: UITableViewCell {
    
    // MARK: Outlets
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
        if !str.contains("http"){
            str = "http://" + str
        }
        if item.phone == ""{
            phoneHeight.constant = 0
        }
        phoneBtn.setTitle(item.phone, for: .normal)
        urlBtn.setTitle(str, for: .normal)
        imgService.image = UIImage(data: data!)
        if imgService.image == nil{
            imgWidth.constant = 0
        }
    }
    
}
