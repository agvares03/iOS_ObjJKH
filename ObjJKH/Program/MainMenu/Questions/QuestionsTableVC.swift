//
//  QuestionsTableVC.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Gloss
import Crashlytics
//import YandexMobileMetrica

protocol QuestionTableDelegate {
    func update()
}

class QuestionsTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, QuestionTableDelegate {
       

    @IBOutlet weak var table: UITableView!
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
    public var question_: QuestionDataJson?
    public var questionDelegate: QuestionTableDelegate?
    public var questionTitle = ""
    
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
//        if UserDefaults.standard.bool(forKey: "NewMain"){
//            navigationController?.popViewController(animated: true)
//        }else{
            navigationController?.dismiss(animated: true, completion: nil)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("QuestionTable", forKey: "last_UI_action")
//        let params : [String : Any] = ["Переход на страницу": "Опросы"]
//        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { (error) in
//            //            print("DID FAIL REPORT EVENT: %@", message)
//            print("REPORT ERROR: %@", error.localizedDescription)
//        })
        automaticallyAdjustsScrollViewInsets = false
        table.delegate     = self
        table.dataSource   = self
        nonConectView.isHidden = true
        table.isHidden = false
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl!)
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
        if questionTitle != ""{
            performSegue(withIdentifier: "go_answers", sender: self)
        }
    }
    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            nonConectView.isHidden = false
            table.isHidden = true
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
        if questionTitle != "" && prep{
            navigationController?.dismiss(animated: true, completion: nil)
        }
        DispatchQueue.main.async{
            self.refresh(nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if questionTitle != ""{
            prep = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questions?.count != 0{
            return questions!.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionsTableCell") as! QuestionsTableCell
        cell.display(questions![indexPath.row], width: view.frame.size.width)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "go_answers", sender: self)
    }
    
    var prep = false
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "go_answers" {
            if questionTitle != ""{
                let vc = segue.destination as! QuestionAnswerVC
                vc.title = questionTitle
                vc.question_ = question_
                //            vc.delegate = delegate
                vc.questionDelegate = self
                performName_ = ""
            }else{
                let vc = segue.destination as! QuestionAnswerVC
                vc.title = questions?[index].name
                vc.question_ = questions?[index]
                //            vc.delegate = delegate
                vc.questionDelegate = self
                performName_ = ""
            }
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
                    self.table.reloadData()
                    self.loader.stopAnimating()
                    self.loader.isHidden = true
                    
                    if #available(iOS 10.0, *) {
                        self.table.refreshControl?.endRefreshing()
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
            guard data != nil else { return }
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//            print("responseString = \(responseString)")

            if let json = try? JSONSerialization.jsonObject(with: data!,
                                                            options: .allowFragments){
                let unfilteredData = QuestionsJson(json: json as! JSON)?.data
                var filtered: [QuestionDataJson] = []
                unfilteredData?.forEach { json in

                    var isContains = true
                    json.questions?.forEach {
                        if !$0.isCompleteByUser! {
                            isContains = false
                        }
                    }
                    if !isContains {
                        filtered.append(json)
                    }
                }
                self.questions = filtered
            }
            }.resume()
    }
    
    func update() {
        getQuestions()
    }

}
