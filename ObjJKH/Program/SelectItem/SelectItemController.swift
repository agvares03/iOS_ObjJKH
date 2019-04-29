//
//  SelectItemController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class SelectItemController: UITableViewController {

    @IBAction func cancelItem(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var back: UIBarButtonItem!
    
    var selectedIndex: Int = -1
    var strings = [String]()
    var selectHandler:((Int)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if tableView.numberOfSections > 0 && tableView.numberOfRows(inSection: 0) < selectedIndex {
            let path = NSIndexPath(row: selectedIndex, section: 0)
            tableView.selectRow(at: path as IndexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        }
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath as IndexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "item")
        cell?.textLabel?.text = strings[indexPath.row]
        cell?.textLabel?.lineBreakMode = .byWordWrapping
        cell?.textLabel?.numberOfLines = 0
        cell?.accessoryType = selectedIndex == indexPath.row ? .checkmark : .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if selectHandler != nil {
            selectHandler!(selectedIndex)
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
