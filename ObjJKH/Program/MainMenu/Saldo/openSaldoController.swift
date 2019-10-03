//
//  openSaldoController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 04/03/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class openSaldoController: UIViewController, WKUIDelegate {
    
//    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    public var urlLink = ""
    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        back.tintColor = myColors.btnColor.uiColor()
        print(urlLink)
//        urlLink = urlLink.replacingOccurrences(of: "О", with: "O")
//        if urlLink.contains(".pdf"){
//            guard let url = URL(string: urlLink) else {
//                return
//            }
//            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
//            let downloadTask = urlSession.downloadTask(with: url)
//            downloadTask.resume()
//        }else{
        if urlLink.contains(".pdf"){
            if let url : NSURL = NSURL(string: urlLink.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!){
                if let data = try? Data(contentsOf: url as URL){
                    webView.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: url as URL)
                }
            }
        }else{
            let url : NSURL! = NSURL(string: urlLink.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
            webView.load(NSURLRequest(url: url as URL) as URLRequest)
        }
//        }
        // Do any additional setup after loading the view.
    }
    
    func loadFromLocal(local: URL){
//        let pdfPath = NSURL(fileURLWithPath: Bundle.main.path(forResource: local, ofType: "pdf")!)
        DispatchQueue.main.async {
            self.webView?.load(NSURLRequest(url: local as URL) as URLRequest)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension openSaldoController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            loadFromLocal(local: destinationURL)
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
