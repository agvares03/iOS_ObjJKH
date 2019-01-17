//
//  EditAccountController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 16/01/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class EditAccountController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var separator: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addLSBtn: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
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
    
    var data = [String]()
    var isModified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        let str_ls = UserDefaults.standard.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        if ((str_ls_arr?.count)! > 0) {
            for i in 0..<(str_ls_arr?.count ?? 1 - 1) {
                data.append((str_ls_arr?[i])!)
            }
        }
        if UserDefaults.standard.string(forKey: "mail") != ""{
            emailText.text = UserDefaults.standard.string(forKey: "mail")
        }
        if UserDefaults.standard.string(forKey: "mail") != "-"{
            emailText.text = ""
        }
        if data.count < 5{
            tableHeight.constant = CGFloat(44 * data.count)
        }else{
            tableHeight.constant = CGFloat(44 * 4)
        }
        
        backBtn.tintColor = myColors.btnColor.uiColor()
        saveBtn.backgroundColor = myColors.btnColor.uiColor()
        addLSBtn.backgroundColor = myColors.btnColor.uiColor()
        separator.backgroundColor = myColors.btnColor.uiColor()
        tableView.setEditing(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
            // Delete the row from the data source
            
            // Удалим лицевой счет на сервере
//            try_del_ls_from_acc(ls: data[indexPath.row], row: indexPath)
            
            //            data.remove(at: indexPath.row)
            //            isModified = true
            //            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
}
