//
//  NewsController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Crashlytics
//import YandexMobileMetrica

class NewsController: UIViewController, UITableViewDelegate {

    
    @IBOutlet weak var updateConectBtn: UIButton!
    @IBOutlet weak var nonConectView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var noDataLbl: UILabel!
    
    @IBAction func updateConect(_ sender: UIButton) {
        self.viewDidLoad()
    }
    @IBOutlet weak var back: UIBarButtonItem!
    
    private var refreshControl: UIRefreshControl?
    var news_read = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("News", forKey: "last_UI_action")
//        let params : [String : Any] = ["Переход на страницу": "Уведомления"]
//        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { (error) in
//            //            print("DID FAIL REPORT EVENT: %@", message)
//            print("REPORT ERROR: %@", error.localizedDescription)
//        })
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: Network.reachability)
        let error = updateUserInterface()
        noDataLbl.isHidden = true
        news_read = UserDefaults.standard.integer(forKey: "newsKol")
        self.tableView.estimatedRowHeight = 71
        self.tableView.rowHeight = UITableViewAutomaticDimension
        nonConectView.isHidden = true
        self.indicator.startAnimating()
        if !error{
            NewsManager.instance.completionLoaded = { [weak self] in
                DispatchQueue.main.async {
                    self?.indicator.stopAnimating()
                    let newsList = NewsManager.instance.getNewsList()
                    print(newsList)
                    if newsList.count == 0{
                        DispatchQueue.main.async {
                            self?.noDataLbl.isHidden = false
                            self?.tableView.isHidden = true
                        }
                    }else{
                        self?.noDataLbl.isHidden = true
                        self?.tableView.isHidden = false
                        self?.tableView.reloadData()
                    }
                }                
            }
//            self.indicator.stopAnimating()
            NewsManager.instance.loadNewsIfNeed()
        }else{
            let _ = updateUserInterface()
        }
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl!)
        }
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        updateConectBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        let titles = Titles()
        self.title = titles.getTitle(numb: "0")
    }
    
    func updateUserInterface() -> Bool {
        switch Network.reachability.status {
        case .unreachable:
            nonConectView.isHidden = false
            tableView.isHidden = true
            return true
        case .wifi: break
            
        case .wwan: break
            
        }
        return false
    }
    @objc func statusManager(_ notification: Notification) {
        let _ = updateUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        if UserDefaults.standard.integer(forKey: "newsKol") < news_read{
            NewsManager.instance.loadNews()
            self.tableView.reloadData()
            if #available(iOS 10.0, *) {
                self.tableView.refreshControl?.endRefreshing()
            } else {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc private func refresh(_ sender: UIRefreshControl?) {
        NewsManager.instance.loadNews()
        self.tableView.reloadData()
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl?.endRefreshing()
        } else {
            self.refreshControl?.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
//        if UserDefaults.standard.bool(forKey: "NewMain"){
            navigationController?.popViewController(animated: true)
//        }else{
//            navigationController?.dismiss(animated: true, completion: nil)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "show_news") {
            let indexPath = tableView.indexPathForSelectedRow!
            let newsObj = NewsManager.instance.getNewsList()[indexPath.row]
            let vc = segue.destination as! NewsView
            vc.newsTitle = newsObj.header
            vc.newsData  = newsObj.created
            vc.newsText  = newsObj.text
            vc.newsRead  = newsObj.readed
            vc.newsId    = newsObj.idNews
        }
    }
    
}
