//
//  NewSaldoController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 28/05/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import CoreData
import Dropper
import Gloss
import Crashlytics
//import YandexMobileMetrica

class NewSaldoController: UIViewController, UITableViewDelegate, UITableViewDataSource, GoUrlReceiptDelegate {    

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var can_btn_pay: NSLayoutConstraint!
    @IBOutlet weak var LsLbl: UILabel!
    @IBOutlet weak var spinImg: UIImageView!
    @IBOutlet weak var tableReceipts: UITableView!
    
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBOutlet weak var addLs: UILabel!
    @IBOutlet weak var lsView: UIView!
    
    var fileList: [File] = []
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("NewSaldo", forKey: "last_UI_action")
        tableReceipts.delegate = self
        tableReceipts.dataSource = self
        back.tintColor = myColors.btnColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
//        updateConectBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        let titles = Titles()
        self.title = titles.getTitle(numb: "5")
        getPaysFile()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        //        getData(login: login!, pass: pass!)
    }
    
    func getPaysFile(){
        let login = UserDefaults.standard.string(forKey: "login") ?? ""
        let pass = UserDefaults.standard.string(forKey: "pass") ?? ""
        let urlPath = Server.SERVER + Server.GET_BILLS_FILE + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, error, responce in
                                                
                                                guard data != nil else { return }
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(responseString)")
                                                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                                                    if json != nil{
                                                        let unfilteredData = PaysFileJson(json: json as! JSON)?.data
                                                        unfilteredData?.forEach { json in
                                                            let ident = json.ident
                                                            let year = json.year
                                                            let month = json.month
                                                            let link = json.link
                                                            let sum = json.sum
                                                            let fileObj = File(month: month!, year: year!, ident: ident!, link: link!, sum: sum!)
                                                            self.fileList.append(fileObj)
                                                        }
                                                        DispatchQueue.main.async {
                                                            self.fileList.reverse()
                                                            self.tableReceipts.reloadData()
                                                        }
                                                    }
                                                }
                                                
        })
        task.resume()
    }
    
    func get_name_month(number_month: String) -> String {
        var rezult: String = ""
        
        if (number_month == "1") {
            rezult = "Январь"
        } else if (number_month == "2") {
            rezult = "Февраль"
        } else if (number_month == "3") {
            rezult = "Март"
        } else if (number_month == "4") {
            rezult = "Апрель"
        } else if (number_month == "5") {
            rezult = "Май"
        } else if (number_month == "6") {
            rezult = "Июнь"
        } else if (number_month == "7") {
            rezult = "Июль"
        } else if (number_month == "8") {
            rezult = "Август"
        } else if (number_month == "9") {
            rezult = "Сентябрь"
        } else if (number_month == "10") {
            rezult = "Октябрь"
        } else if (number_month == "11") {
            rezult = "Ноябрь"
        } else if (number_month == "12") {
            rezult = "Декабрь"
        }
        
        return rezult
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fileList.count != 0 {
            return fileList.count
        } else {
            return 0
        }
    }
    var endSum = ""
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableReceipts.dequeueReusableCell(withIdentifier: "HomeReceiptsCell1") as! HomeReceiptsCell
        if (fileList[indexPath.row].link.contains(".png")) || (fileList[indexPath.row].link.contains(".jpg")) || (fileList[indexPath.row].link.contains(".pdf")){
            cell.goReceipt.isHidden = false
        }else{
            cell.goReceipt.isHidden = true
        }
        cell.ident.text = "Л/сч.:  " + fileList[indexPath.row].ident
        cell.goReceipt.tintColor = myColors.btnColor.uiColor()
        cell.separator.backgroundColor = myColors.btnColor.uiColor()
        cell.receiptText.text = self.get_name_month(number_month: String(fileList[indexPath.row].month)) + " " + String(fileList[indexPath.row].year)
        cell.receiptSum.text = String(format:"%.2f", fileList[indexPath.row].sum) + " руб"
        cell.separator.text = fileList[indexPath.row].link
        cell.delegate2 = self
        cell.delegate = self
        return cell
    }
    var link = ""
    func goUrlReceipt(url: String) {
        self.link = url
        self.performSegue(withIdentifier: "openURL", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openURL" {
            let payController             = segue.destination as! openSaldoController
            payController.urlLink = self.link
        }
    }
}
