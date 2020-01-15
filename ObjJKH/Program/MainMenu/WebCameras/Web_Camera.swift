//
//  Web_Camera.swift
//  ObjJKH
//
//  Created by Роман Тузин on 01.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Foundation
import WebKit
import Crashlytics

class Web_Camera: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    open var web_camera: Web_Camera_json?
    var webView: WKWebView!
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
//        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("Web_Camera", forKey: "last_UI_action")
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
//        let web_link: String = web_camera?.link ?? ""
//        if (web_link.contains("rtsp")) {
//
//            guard let url = URL(string: "https://ya.ru") else { //URL(string: web_link) else {
//                return //be safe
//            }
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.openURL(url)
////                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//
////            webView.isHidden = true
////
////            let mediaPlayer = VLCMediaPlayer()
////            func playURI(uri: String) {
////                mediaPlayer.drawable = self.movieView
////                let url = URL(string: uri)
////                let media = VLCMedia(url: url)
////                mediaPlayer.media = media
////
////                mediaPlayer.play()
////            }
//
//        } else {
        let url : NSURL! = NSURL(string: (web_camera?.link!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!)
        print(url)
        webView.load(NSURLRequest(url: url as URL) as URLRequest)
//        }
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
//        indicator.color = myColors.indicatorColor.uiColor()
        
        let titles = Titles()
        self.title = titles.getSimpleTitle(numb: "7")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        StartIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        StopIndicator()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        StopIndicator()
    }
    
    func StartIndicator() {
        self.indicator.isHidden = false
        self.indicator.startAnimating()
    }
    
    func StopIndicator() {
        self.indicator.isHidden = true
    }

}
