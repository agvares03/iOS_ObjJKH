//
//  openSaldoController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 04/03/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class openSaldoController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    public var urlLink: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        back.tintColor = myColors.btnColor.uiColor()
        print(urlLink)
        let url : NSURL! = NSURL(string: urlLink)
        webView.loadRequest(NSURLRequest(url: url as URL) as URLRequest)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
