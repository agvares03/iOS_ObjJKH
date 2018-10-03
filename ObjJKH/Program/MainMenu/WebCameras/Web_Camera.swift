//
//  Web_Camera.swift
//  ObjJKH
//
//  Created by Роман Тузин on 01.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Foundation

class Web_Camera: UIViewController {

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    open var web_camera: Web_Camera_json?
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            let url = NSURL(string: (web_camera?.link)!)
            let requestObj = NSURLRequest(url: url! as URL)
            webView.loadRequest(requestObj as URLRequest)
//        }
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
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
