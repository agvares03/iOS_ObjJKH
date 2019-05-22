//
//  WebsController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 01.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Gloss
import YandexMobileMetrica

class WebsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBAction func backClick(_ sender: UIBarButtonItem) {
//        navigationController?.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateConect(_ sender: UIButton) {
        self.viewDidLoad()
    }
    @IBOutlet weak var updateConectBtn: UIButton!
    @IBOutlet weak var nonConectView: UIView!
    
    @IBOutlet weak var back: UIBarButtonItem!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return web_cameras?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebsCell", for: indexPath) as! WebsCell
        cell.display(web_cameras![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 94.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        if ((web_cameras?[index].link?.contains("rtsp"))!) {
            guard let url = URL(string: (web_cameras?[index].link)!) else {
                return //be safe
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    print("success!") // do what you want
                })
            }
        } else {
            performSegue(withIdentifier: "go_web_camera", sender: self)
        }
    }
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    private var web_cameras: [Web_Camera_json]? = []
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let params : [String : Any] = ["Переход на страницу": "Web-камеры"]
        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { (error) in
            //            print("DID FAIL REPORT EVENT: %@", message)
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        nonConectView.isHidden = true
        collection.isHidden = false
        automaticallyAdjustsScrollViewInsets = false
        collection.delegate     = self
        collection.dataSource   = self
        
        indicator.isHidden = false
        indicator.startAnimating()
        getWebs()
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        
        let titles = Titles()
        self.title = titles.getTitle(numb: "7")
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        updateConectBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: Network.reachability)
        updateUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            nonConectView.isHidden = false
            collection.isHidden = true
        case .wifi: break
            
        case .wwan: break
            
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWebs() {
        
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_WEB_CAMERAS)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
            defer {
                DispatchQueue.main.sync {
                    self.collection.reloadData()
                    self.indicator.stopAnimating()
                    self.indicator.isHidden = true
                    
                    //                    if #available(iOS 10.0, *) {
                    //                        self.collection.refreshControl?.endRefreshing()
                    //                    } else {
                    //                        self.refreshControl?.endRefreshing()
                    //                    }
                    
                    if self.web_cameras?.count == 0 {
                        self.collection.isHidden = true
                        self.emptyLabel.isHidden = false
                        
                    } else {
                        self.collection.isHidden = false
                        self.emptyLabel.isHidden = true
                    }
                    
                    if (self.web_cameras != nil) {
                        for (index, item) in (self.web_cameras?.enumerated())! {
                            //                        if item.name == self.performName_ {
                            //                            self.index = index
                            //                            self.performSegue(withIdentifier: Segues.fromQuestionsTableVC.toQuestion, sender: self)
                            //                        }
                        }
                    }
                    
                }
            }
            guard data != nil else { return }
            let json = try? JSONSerialization.jsonObject(with: data!,
                                                         options: .allowFragments)
            
            let Data = Web_Cameras_json(json: json! as! JSON)?.data
            self.web_cameras = Data
            
            }.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "go_web_camera" {
            
            let vc = segue.destination as! Web_Camera
            vc.title = web_cameras?[index].name
            vc.web_camera = web_cameras?[index]
            //            //            vc.delegate = delegate
            //            vc.questionDelegate = self
            //            performName_ = ""
    
        }
    }

}
