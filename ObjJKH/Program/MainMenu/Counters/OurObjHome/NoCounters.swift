//
//  NoCounters.swift
//  ObjJKH
//
//  Created by Роман Тузин on 11.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Foundation

class NoCounters: UIViewController {

    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        let localfilePath = Bundle.main.url(forResource: "no_counters", withExtension: "html");
        let myRequest = URLRequest(url: localfilePath!);
        webView.loadRequest(myRequest);
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
