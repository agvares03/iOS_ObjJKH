//
//  NewsView.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class NewsView: UIViewController {
    
    var newsTitle: String?
    var newsData: String?
    var newsText: String?
    
    @IBOutlet weak var NewsTitle: UILabel!
    @IBOutlet weak var NewsData: UILabel!
    @IBOutlet weak var NewsText: UILabel!
    
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
//        navigationController?.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NewsTitle.text = newsTitle
        NewsData.text = newsData
        NewsText.text = newsText
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
