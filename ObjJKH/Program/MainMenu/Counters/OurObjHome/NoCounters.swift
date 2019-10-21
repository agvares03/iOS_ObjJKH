//
//  NoCounters.swift
//  ObjJKH
//
//  Created by Роман Тузин on 11.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class NoCounters: UIViewController, WKUIDelegate{

    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
//    @IBOutlet weak var webView: UIWebView!
    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        automaticallyAdjustsScrollViewInsets = false
        let localfilePath = Bundle.main.url(forResource: "no_counters", withExtension: "html");
//        let myRequest = URLRequest(url: localfilePath!);
        webView.load(NSURLRequest(url: localfilePath!) as URLRequest)
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
