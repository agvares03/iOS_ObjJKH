//
//  EditAccountController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 16/01/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class EditAccountController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var noPrivLS: UILabel!
    @IBOutlet weak var privLS1: UILabel!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var separator: UILabel!
    @IBOutlet weak var separator1: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var fioText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addLSBtn: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        if (isModified) {
            let defaults = UserDefaults.standard
            var str_rezult: String = ""
            if (data.count > 0) {
                for i in 0..<data.count {
                    if (i == 0) {
                        str_rezult = data[i]
                    } else {
                        str_rezult = str_rezult + "," + data[i]
                    }
                }
            }
            
            // Запишем в память новый список лицевых счетов
            defaults.set(emailText.text, forKey: "mail")
            defaults.set(str_rezult, forKey: "str_ls")
            defaults.synchronize()
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddLS(_ sender: UIButton) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        #if isMupRCMytishi
        self.performSegue(withIdentifier: "addLSMup", sender: self)
        #elseif isPocket
        self.performSegue(withIdentifier: "addLSPocket", sender: self)
        #else
        self.performSegue(withIdentifier: "addLS", sender: self)
        #endif
    }
    
    @IBAction func SaveInfo(_ sender: UIButton) {
        let email:String = emailText.text!
        var kD = 0
        var kS = 0
        email.forEach{
            if $0 == "."{
                kD += 1
            }
            if $0 == "@"{
                kS += 1
            }
        }
        if (email.contains("@")) && (email.contains(".")) && kD == 1 && kS == 1{
            UserDefaults.standard.set(email, forKey: "mail")
            
            let defaults = UserDefaults.standard
            let phone:String = defaults.string(forKey: "phone")!
            let fio:String = fioText.text!
            var urlPath = Server.SERVER + Server.MOBILE_API_PATH + Server.SET_EMAIL_ACC
            urlPath = urlPath + "phone=" + phone + "&email=" + email + "&fio" + fio.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            print(request)
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        DispatchQueue.main.async(execute: {
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
                                                        })
                                                        return
                                                    }
                                                    
                                                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                    print("responseString = \(responseString)")
                                                    if responseString == "ok"{
                                                        DispatchQueue.main.async(execute: {
                                                            let alert = UIAlertController(title: "", message: "Данные успешно сохранены", preferredStyle: .alert)
                                                            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                            alert.addAction(cancelAction)
                                                            self.present(alert, animated: true, completion: nil)
                                                        })
                                                    }else{
                                                        DispatchQueue.main.async(execute: {
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
                                                        })
                                                    }
                                                    
            })
            task.resume()
        }else{
            let alert = UIAlertController(title: "Ошибка", message: "Укажите корректный e-mail!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    var data = [String]()
    var isModified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let str_ls = UserDefaults.standard.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        if ((str_ls_arr?.count)! > 0) {
            if str_ls_arr?[0] != ""{
                for i in 0..<(str_ls_arr?.count ?? 1 - 1) {
                    data.append((str_ls_arr?[i])!)
                }
            }
        }
        if UserDefaults.standard.string(forKey: "mail") != ""{
            emailText.text = UserDefaults.standard.string(forKey: "mail")
        }
        if UserDefaults.standard.string(forKey: "mail") == "-"{
            emailText.text = ""
        }
        if UserDefaults.standard.string(forKey: "name") != ""{
            fioText.text = UserDefaults.standard.string(forKey: "name")
        }
        if data.count < 5{
            tableHeight.constant = CGFloat(44 * data.count)
        }else{
            tableHeight.constant = CGFloat(44 * 4)
        }
        noPrivLS.isHidden = true
        backBtn.tintColor = myColors.btnColor.uiColor()
        saveBtn.backgroundColor = myColors.btnColor.uiColor()
        addLSBtn.backgroundColor = myColors.btnColor.uiColor()
        separator.backgroundColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.btnColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        tableView.setEditing(true, animated: true)
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if data.count == 0{
            self.tableView.isHidden = true
            privLS1.isHidden = true
            noPrivLS.isHidden = false
            tableHeight.constant = 44
        }else{
            self.tableView.isHidden = false
            privLS1.isHidden = false
            noPrivLS.isHidden = true
            if data.count < 5{
                tableHeight.constant = CGFloat(44 * data.count)
            }else{
                tableHeight.constant = CGFloat(44 * 4)
            }
        }

        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccLSCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try_del_ls_from_acc(ls: data[indexPath.row], row: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func try_del_ls_from_acc(ls: String, row: IndexPath) {
        
        let defaults = UserDefaults.standard
        let phone = defaults.string(forKey: "phone")
        let ident =  ls
        
        if (phone == ident) {
            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Невозможно отвязать лицевой счет " + ls + ". Вы зашли, используя этот лицевой счет.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Удаление лицевого счета", message: "Отвязать лицевой счет " + ls + " от аккаунта?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
                
                var urlPath = Server.SERVER + Server.MOBILE_API_PATH + Server.DEL_IDENT_ACC
                urlPath = urlPath + "phone=" + phone! + "&ident=" + ident
                let url: NSURL = NSURL(string: urlPath)!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "GET"
                
                let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                      completionHandler: {
                                                        data, response, error in
                                                        
                                                        if error != nil {
                                                            UserDefaults.standard.set("Ошибка соединения с сервером", forKey: "errorStringSupport")
                                                            UserDefaults.standard.synchronize()
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
                                                            return
                                                        }
                                                        
                                                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                        print("responseString = \(responseString)")
                                                        
                                                        self.del_ls_from_acc(indexPath: row)
                })
                task.resume()
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func del_ls_from_acc(indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
            self.data.remove(at: indexPath.row)
            self.isModified = true
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.bool(forKey: "NewMain"){
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        data.removeAll()
        let str_ls = UserDefaults.standard.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        if ((str_ls_arr?.count)! > 0) {
            if str_ls_arr?[0] != ""{
                for i in 0..<(str_ls_arr?.count ?? 1 - 1) {
                    data.append((str_ls_arr?[i])!)
                }
            }
        }
        self.tableView.reloadData()
    }
}
