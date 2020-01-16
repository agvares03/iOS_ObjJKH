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
import Crashlytics

class openSaldoController: UIViewController, WKUIDelegate {
    
//    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareAction(_ sender: UIView) {
        if urlLink.contains(".pdf"){
            DispatchQueue.main.async {
                let url = URL(string: self.urlLink.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
                let pdfData = try? Data.init(contentsOf: url!)
                let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                let pdfNameFromUrl = "documento.pdf"
                let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
                    print("pdf successfully saved!")
                    let fileManager = FileManager.default
                    let documentoPath = (self.getDirectoryPath() as NSString).appendingPathComponent("documento.pdf")

                    if fileManager.fileExists(atPath: documentoPath){
                        let documento = NSData(contentsOfFile: documentoPath)
                        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [documento!], applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView=self.view
                        self.present(activityViewController, animated: true, completion: nil)
                     }
                     else {
                         print("document was not found")
                     }
                } catch {
                    print("Pdf could not be saved")
                }
            }
        }else{
            DispatchQueue.main.async {
                let url : URL = URL(string: self.urlLink.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView=self.view
                        self.present(activityViewController, animated: true, completion: nil)
                    }else{
                        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView=self.view
                        self.present(activityViewController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    public var urlLink = ""
    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("OpenSaldo", forKey: "last_UI_action")
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        back.tintColor = myColors.btnColor.uiColor()
        share.tintColor = myColors.btnColor.uiColor()
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

extension UIApplication {
    class var topViewController: UIViewController? { return getTopViewController() }
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController { return getTopViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController { return getTopViewController(base: selected) }
        }
        if let presented = base?.presentedViewController { return getTopViewController(base: presented) }
        return base
    }
}

extension Hashable {
    func share() {
        let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        UIApplication.topViewController?.present(activity, animated: true, completion: nil)
    }
}
