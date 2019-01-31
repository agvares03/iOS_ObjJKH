//
//  NewsController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class NewsController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBOutlet weak var back: UIBarButtonItem!
    
    private var refreshControl: UIRefreshControl?
    var news_read = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        news_read = UserDefaults.standard.integer(forKey: "request_read")
        self.tableView.estimatedRowHeight = 71
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.indicator.startAnimating()
        NewsManager.instance.completionLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                self?.tableView.reloadData()
            }
            
        }
        
        NewsManager.instance.loadNewsIfNeed()
        
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
        
        let titles = Titles()
        self.title = titles.getTitle(numb: "0")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.integer(forKey: "news_read") < news_read{
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
       navigationController?.dismiss(animated: true, completion: nil)
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
