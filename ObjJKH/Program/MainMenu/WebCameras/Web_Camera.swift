//
//  Web_Camera.swift
//  ObjJKH
//
//  Created by Роман Тузин on 01.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class Web_Camera: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    open var web_camera: Web_Camera_json?
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: (web_camera?.link)!)
        let requestObj = NSURLRequest(url: url! as URL)
        webView.loadRequest(requestObj as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        StartIndicator()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        StopIndicator()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        StopIndicator()
    }
    
    func StartIndicator() {
        self.indicator.isHidden = false
        self.indicator.startAnimating()
    }
    
    func StopIndicator() {
        self.indicator.isHidden = true
    }

}
