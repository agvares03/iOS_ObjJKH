//
//  AllObjectPlace.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 31/10/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class AllObjectPlace: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    public var choiceHome = ""
    public var choiceEntrance = ""
    public var choicePremise = ""
    
    public var object_names: [String] = []
    public var object_ids: [String] = []
    public var object_check: [Bool] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        StopIndicator()
        back.tintColor = myColors.btnColor.uiColor()
        indicator.color = myColors.btnColor.uiColor()
        // Do any additional setup after loading the view.
    }
    
    var firstLoad = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstLoad{
            StartIndicator()
            getObject()
        }else{
            firstLoad = true
        }
    }
    
    func getObject() {
        object_check.removeAll()
        object_ids.removeAll()
        object_names.removeAll()
        var urlPath = Server.SERVER + "MobileAPI/ControlObjects/GetControlObjects.ashx?"
        
        if choicePremise != ""{
            urlPath = urlPath + "premiseId=" + choicePremise.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        }else if choiceEntrance != ""{
            urlPath = urlPath + "entranceId=" + choiceEntrance.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        }else if choiceHome != ""{
            urlPath = urlPath + "houseId=" + choiceHome.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        }
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    return
                                                }
                                                let objectString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("street = \(String(describing: objectString))")
                                                if (objectString.containsIgnoringCase(find: "Name")){
                                                    do {
                                                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                        if let json_bills = json["data"] {
                                                            print(json_bills.count!)
                                                        
                                                            if ((json_bills as? NSNull) == nil) && json_bills.count != 0{
                                                                let int_end = (json_bills.count)!-1
                                                                if (int_end < 0) {
                                                                    
                                                                } else {
                                                                    for index in 0...int_end {
                                                                        let json_bill = json_bills.object(at: index) as! [String:AnyObject]
                                                                        for obj in json_bill {
                                                                            if obj.key == "Name" {
                                                                                if ((obj.value as? NSNull) == nil){
                                                                                    let sum = String(describing: obj.value as! String)
                                                                                    self.object_names.append(sum)
                                                                                }
                                                                            }
                                                                            if obj.key == "ID" {
                                                                                if ((obj.value as? NSNull) == nil){
                                                                                    let sum = String(describing: obj.value as! Int)
                                                                                    self.object_ids.append(sum)
                                                                                }
                                                                            }
                                                                            if obj.key == "IsInspected" {
                                                                                if ((obj.value as? NSNull) == nil){
                                                                                    let sum = obj.value as! Bool
                                                                                    self.object_check.append(sum)
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        DispatchQueue.main.async{
                                                            self.tableView.reloadData()
                                                            self.StopIndicator()
                                                        }
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                }
                                                
        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if object_ids.count != 0 {
                return object_ids.count
            } else {
                return 0
            }
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: "ObjectCell") as! ObjectCell
        cell.name.text = object_names[indexPath.row]
        if !object_check[indexPath.row]{
            cell.icon.image = UIImage(named: "plusIcon")
            cell.icon.tintColor = myColors.labelColor.uiColor()
        }else{
            cell.icon.image = UIImage(named: "Check")
            cell.icon.tintColor = myColors.labelColor.uiColor()
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        if object_check[indexPath.row] {
//            self.performSegue(withIdentifier: "new_show_app_close", sender: self)
        } else {
            choiceObjectId      = object_ids[indexPath.row]
            choiceObjectName    = object_names[indexPath.row]
            self.performSegue(withIdentifier: "showObject", sender: self)
        }
    }
    var choiceObjectId      = ""
    var choiceObjectName    = ""
    func StartIndicator() {
        self.tableView.isHidden = true
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator() {
        self.tableView.isHidden = false
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showObject") {
            let controller = segue.destination as! ChoiceObjectVC
            controller.objectId     = choiceObjectId
            controller.objectName    = choiceObjectName
        }
    }
}

class ObjectCell: UITableViewCell {
    
    var delegate: UIViewController?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
