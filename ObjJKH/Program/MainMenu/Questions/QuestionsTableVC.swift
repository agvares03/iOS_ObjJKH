//
//  QuestionsTableVC.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Gloss

protocol QuestionTableDelegate {
    func update()
}

class QuestionsTableVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QuestionTableDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    open var performName_ = ""
    
    @IBAction func updateConect(_ sender: UIButton) {
        self.viewDidLoad()
    }
    @IBOutlet weak var updateConectBtn: UIButton!
    @IBOutlet weak var nonConectView: UIView!
    
    private var refreshControl: UIRefreshControl?
    private var questions: [QuestionDataJson]? = []
    private var index = 0
    
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
//        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        collection.delegate     = self
        collection.dataSource   = self
        nonConectView.isHidden = true
        collection.isHidden = false
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            collection.refreshControl = refreshControl
        } else {
            collection.addSubview(refreshControl!)
        }
        
        loader.isHidden = false
        loader.startAnimating()
//        getQuestions()
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        loader.color = myColors.indicatorColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        updateConectBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        let titles = Titles()
        self.title = titles.getTitle(numb: "3")
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: Network.reachability)
        updateUserInterface()
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
    
    @objc private func refresh(_ sender: UIRefreshControl?) {
        emptyLabel.isHidden = true
        getQuestions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.refresh(nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(questions?.count ?? 0)
        
        return questions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionsTableCell", for: indexPath) as! QuestionsTableCell
        cell.display(questions![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 85.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "go_answers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "go_answers" {
            let vc = segue.destination as! QuestionAnswerVC
            vc.title = questions?[index].name
            vc.question_ = questions?[index]
            //            vc.delegate = delegate
            vc.questionDelegate = self
            performName_ = ""
        }
    }
    
    func getQuestions() {
        
        let id = UserDefaults.standard.string(forKey: "id_account") ?? ""
        let phone = UserDefaults.standard.string(forKey: "phone") ?? ""
//        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "accID=" + id)!)
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "phone=" + phone)!)
        request.httpMethod = "GET"
        print(request)
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
            defer {
                DispatchQueue.main.sync {
                    self.collection.reloadData()
                    self.loader.stopAnimating()
                    self.loader.isHidden = true
                    
                    if #available(iOS 10.0, *) {
                        self.collection.refreshControl?.endRefreshing()
                    } else {
                        self.refreshControl?.endRefreshing()
                    }
                    
                    if self.questions?.count == 0 {
                        self.emptyLabel.isHidden = false
                        
                    } else {
                        self.emptyLabel.isHidden = true
                    }
                    
                    for (index, item) in (self.questions?.enumerated())! {
                        if item.name == self.performName_ {
//                            self.index = index
//                            self.performSegue(withIdentifier: Segues.fromQuestionsTableVC.toQuestion, sender: self)
                        }
                    }
                    
                }
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            print("responseString = \(responseString)")
            
            guard data != nil else { return }
            let json = try? JSONSerialization.jsonObject(with: data!,
                                                         options: .allowFragments)
            let unfilteredData = QuestionsJson(json: json! as! JSON)?.data
            var filtered: [QuestionDataJson] = []
            unfilteredData?.forEach { json in

                var isContains = false
                json.questions?.forEach {
                    if !($0.isCompleteByUser ?? false) {
                        isContains = false
                    }
                }
                if !isContains {
                    filtered.append(json)
                }
            }
            self.questions = filtered
            }.resume()
    }
    
    func update() {
        getQuestions()
    }

}
