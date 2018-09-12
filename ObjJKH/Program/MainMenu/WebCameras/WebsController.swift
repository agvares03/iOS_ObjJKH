//
//  WebsController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 01.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Gloss

class WebsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
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
        performSegue(withIdentifier: "go_web_camera", sender: self)
    }
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var web_cameras: [Web_Camera_json]? = []
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        collection.delegate     = self
        collection.dataSource   = self
        
        indicator.isHidden = false
        indicator.startAnimating()
        getWebs()
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        
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
