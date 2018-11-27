//
//  HistoryPayController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 27/11/2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class HistoryPayController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet private weak var tableView:       UITableView!
    @IBOutlet private weak var headerView:      UIView!
    @IBOutlet private weak var dateLabel:       UILabel!
    @IBOutlet private weak var periodLabel:     UILabel!
    @IBOutlet private weak var sumLabel:        UILabel!
    
    private var values: [HistoryPayCellData] = []

    var login = ""
    var pass  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login = UserDefaults.standard.string(forKey: "login")!
        pass  = UserDefaults.standard.string(forKey: "pass")!
        parse_OSV(login: login, pass: pass)
        
        tableView.delegate = self
        tableView.dataSource = self
        back.tintColor = myColors.btnColor.uiColor()
        headerView.backgroundColor = myColors.btnColor.uiColor()
    }
    
    func parse_OSV(login: String, pass: String) {
        
        let urlPath = Server.SERVER + Server.GET_PAYMENTS + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        
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
                                                        var bill_date    = ""
                                                        var bill_id      = ""
                                                        var bill_ident     = ""
                                                        var bill_period      = ""
                                                        var bill_sum    = ""
                                                        var json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                        print(json)
                                                        if let json_bills = json["data"] {
                                                            let int_end = (json_bills.count)!-1
                                                            if (int_end < 0) {
                                                                
                                                            } else {
                                                                
                                                                for index in 0...int_end {
                                                                    let json_bill = json_bills.object(at: index) as! [String:AnyObject]
                                                                    for obj in json_bill {
                                                                        if obj.key == "Date" {
                                                                            bill_date = obj.value as! String
                                                                        }
                                                                        if obj.key == "ID" {
                                                                            bill_id = String(describing: obj.value as! NSNumber)
                                                                        }
                                                                        if obj.key == "Ident" {
                                                                            bill_ident = obj.value as! String
                                                                        }
                                                                        if obj.key == "Period" {
                                                                            bill_period = obj.value as! String
                                                                        }
                                                                        if obj.key == "Sum" {
                                                                            bill_sum = String(describing: obj.value as! NSNumber)
                                                                        }
                                                                    }
                                                                    self.values.append(HistoryPayCellData(date: bill_date, id: bill_id, ident: bill_ident, period: bill_period, sum: bill_sum))
                                                                }
                                                            }
                                                            
                                                        }
                                                        DispatchQueue.main.async(execute: {
                                                            self.tableView.reloadData()
                                                        })
                                                        
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                    
                                                }
                                                
        })
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryPayCell", for: indexPath) as! HistoryPayCell
        cell.display(values[indexPath.row])
        return cell
    }
}

class HistoryPayCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var datePay: UILabel!
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var summ: UILabel!
    
    fileprivate func display(_ item: HistoryPayCellData) {
        let date1: String = item.date.substring(to: item.date.index(item.date.endIndex, offsetBy: -9))
        if !item.sum.contains("."){
            self.summ.text = item.sum + ".00"
        }else{
            self.summ.text = item.sum
        }
        self.period.text = item.period
        
        self.datePay.text = date1
    }
    
    
    
}

private final class HistoryPayCellData {
    
    let date:           String
    let id:             String
    let ident:          String
    let period:         String
    let sum:            String
    
    init(date: String?, id: String?, ident: String?, period: String?, sum: String?) {
        
        self.date   = date   ?? ""
        self.id     = id     ?? ""
        self.ident  = ident  ?? ""
        self.period = period ?? ""
        self.sum    = sum    ?? ""
    }
}
