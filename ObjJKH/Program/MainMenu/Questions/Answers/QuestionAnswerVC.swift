//
//  QuestionAnswerVC.swift
//  ObjJKH
//
//  Created by Роман Тузин on 01.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Crashlytics

var i = Int()
var kek: [Int] = []

var isAccepted      = false
var selectedAnswers: [Int] = []

class QuestionAnswerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var titleQuestion: UILabel!
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        // Добавляем опрос в список начатых опросов
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "PollsStarted") as? [Int] ?? [Int]()
        if !array.contains(question_!.id!) {
            array.append(question_!.id!)
            defaults.set(array, forKey: "PollsStarted")
        }
        
        var answerArr: [Int] = []
        
        selectedAnswers.forEach {
            answerArr.append((question_?.questions![currQuestion].answers![$0].id)!)
        }
        guard answerArr.count != 0 else { return }
        answers[(question_?.questions![currQuestion].id!)!] = answerArr
        print(answers)
        isAccepted = false
        if (currQuestion + 1) < question_?.questions?.count ?? 0 {
            if answers.count > currQuestion + 1{
                kek = answers[(question_?.questions![currQuestion + 1].id!)!]!
            }
            i = 0
            collection.reloadData()
            currQuestion += 1
            NotificationCenter.default.post(name: NSNotification.Name("Uncheck"), object: nil)
            
        } else {
            
            startAnimation()
            DispatchQueue.global(qos: .userInteractive).async {
                self.sendAnswer()
            }
        }
    }
    
    private func sendAnswer() {
        
//        let id = UserDefaults.standard.string(forKey: "id_account") ?? ""
        let phone = UserDefaults.standard.string(forKey: "phone")!
        let groupId = question_?.id ?? 0
        
        var request = URLRequest(url: URL(string: "\(Server.SERVER)\(Server.SAVE_ANSWER)phone=\(phone)&groupID=\(groupId)")!)
        request.httpMethod = "POST"
        
        var json: [[String:Any]] = []
        
//        print(answers)
        
//        var isManyValue = false
        var index = 0
        
        answers.forEach { (arg) in
            let (key, value) = arg
//            isManyValue = false
            
            value.forEach {
                //                if isManyValue {
                json.append( ["QuestionID":key, "AnswerID":$0, "Comment": ""] )
                //                } else {
                //                    json.append( ["QuestionID":key, "AnswerID":$0, "Comment": recomendationArray[index] ] )
                //                }
                
//                isManyValue = true
            }
            
            index += 1
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        
//        print(request.url)
//        print(String(data: request.httpBody!, encoding: .utf8))
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
            guard data != nil else { return }
            if String(data: data!, encoding: .utf8)?.contains("error") ?? false {
                UserDefaults.standard.set(String(data: data!, encoding: .utf8), forKey: "errorStringSupport")
                UserDefaults.standard.synchronize()
                let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен. \nОтвет с сервера: <" + String(data: data!, encoding: .utf8)! + ">", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                    self.performSegue(withIdentifier: "support", sender: self)
                }
                alert.addAction(cancelAction)
                alert.addAction(supportAction)
                DispatchQueue.main.sync {
                    self.present(alert, animated: true, completion: nil)
                    self.stopAnimation()
                }
                return
            }
            
            #if DEBUG
            print(String(data: data!, encoding: .utf8) ?? "")
            #endif
            
            UserDefaults.standard.removeObject(forKey: String(self.question_?.id ?? 0))
            UserDefaults.standard.synchronize()
            
            // Удаляем из списка начатых опросов
            var array = UserDefaults.standard.array(forKey: "PollsStarted") as? [Int] ?? [Int]()
            if array.contains(self.question_!.id!) {
                if let index = array.index(where: { (id) -> Bool in
                    id == self.question_!.id!
                }) {
                    array.remove(at: index)
                }
                UserDefaults.standard.set(array, forKey: "PollsStarted")
            }
            
            DispatchQueue.main.async {
                
                self.stopAnimation()
                self.performSegue(withIdentifier: "final", sender: self)
            }
            
            }.resume()
        return
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            let userDefaults = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.answers)
            userDefaults.set(encodedData, forKey: String(self.question_?.id ?? 0))
            userDefaults.synchronize()
            i = 0
        }
        
        
        navigationController?.popViewController(animated: true)
    }
    
    open var question_: QuestionDataJson?
    open var questionDelegate: QuestionTableDelegate?
    
    private var currQuestion = 0
    private var answers: [Int:[Int]] = [:]
    private var tap: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("QuestionAnswer", forKey: "last_UI_action")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        stopAnimation()
        navigationItem.title    = question_?.name
        if !(question_?.readed)!{
            self.read_question()
        }
        let decoded = UserDefaults.standard.object(forKey: String(question_?.id ?? 0))
        if decoded != nil {
            answers = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as! [Int:[Int]]
        }
        currQuestion = 0
        print("=")
        print(answers)
        kek = answers[(question_?.questions![currQuestion].id!)!] ?? [0]
        print(kek)
        
        automaticallyAdjustsScrollViewInsets = false
        collection.delegate     = self
        collection.dataSource   = self
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped(_:)))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        loader.color = myColors.indicatorColor.uiColor()
        goButton.backgroundColor = myColors.btnColor.uiColor()
        
        let titles = Titles()
        self.title = titles.getSimpleTitle(numb: "3")
        
    }
    
    func read_question(){
        let phone = UserDefaults.standard.string(forKey: "id_account") ?? ""
        let question_id = String(self.question_!.id!)
        
        var request = URLRequest(url: URL(string: Server.SERVER + "SetQuestionGroupReadedState.ashx?" + "phone=" + phone + "&groupID=" + question_id)!)
        request.httpMethod = "GET"
        print(request)
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
//            print(String(data: data!, encoding: .utf8) ?? "")
            guard data != nil else { return }
//            var question_read = UserDefaults.standard.integer(forKey: "question_read")
//            question_read -= 1
//            DispatchQueue.main.async {
//                let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
//                let updatedBadgeNumber = currentBadgeNumber - 1
//                if (updatedBadgeNumber > -1) {
//                    UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
//                }
//            }
//            UserDefaults.standard.setValue(question_read, forKey: "question_read")
//            UserDefaults.standard.synchronize()
            
            }.resume()
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        guard currQuestion != 0 else { return }
        
        if #available(iOS 10.0, *) {
            UIViewPropertyAnimator(duration: 0, curve: .linear) {
                self.collection.frame.origin.x = recognizer.location(in: self.view).x
                }.startAnimation()
        } else {
            self.collection.frame.origin.x = recognizer.location(in: self.view).x
        }
        
        if recognizer.state == .ended {
            if recognizer.location(in: view).x > 100 {
                currQuestion -= 1
                collection.alpha = 0
                collection.frame.origin.x = 0
                if #available(iOS 10.0, *) {
                    UIViewPropertyAnimator(duration: 0, curve: .linear) {
                        self.collection.alpha = 1
                        }.startAnimation()
                } else {
                    collection.alpha = 1
                }
                collection.reloadData()
                
            } else {
                if #available(iOS 10.0, *) {
                    UIViewPropertyAnimator(duration: 0, curve: .linear) {
                        self.collection.frame.origin.x = 0
                        }.startAnimation()
                    
                } else {
                    collection.frame.origin.x = 0
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return question_?.questions![currQuestion].answers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionAnswerCell", for: indexPath) as! QuestionAnswerCell
        question.text = question_?.questions![currQuestion].question
        titleQuestion.text = "\(currQuestion + 1) из \(question_?.questions?.count ?? 0)"
        cell.display((question_?.questions![currQuestion].answers![indexPath.row])!, index: indexPath.row)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        
//        switch kind {
//            
//        case UICollectionElementKindSectionHeader:
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "QuestionAnswerHeader", for: indexPath) as! QuestionAnswerHeader
//            header.display((question_?.questions![currQuestion])!, currentQuestion: currQuestion, questionCount: question_?.questions?.count ?? 0)
//            return header
//            
//        default:
//            
//            assert(false, "Unexpected element kind")
//            return UICollectionReusableView()
//        }
//    }
    
    private func startAnimation() {
        loader.isHidden = false
        loader.startAnimating()
        goButton.isHidden = true
    }
    
    private func stopAnimation() {
        loader.isHidden = true
        loader.stopAnimating()
        goButton.isHidden = false
    }
    
}

class QuestionAnswerHeader: UICollectionViewCell {
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var title: UILabel!
    
    func display(_ item: QuestionJson, currentQuestion: Int, questionCount: Int) {
        question.text = item.question
        title.text = "\(currentQuestion + 1) из \(questionCount)"
    }
    
    class func fromNib() -> QuestionAnswerHeader? {
        var cell: QuestionAnswerHeader?
        let views = Bundle.main.loadNibNamed("DynamicCellsNib", owner: nil, options: nil)
        views?.forEach {
            if let view = $0 as? QuestionAnswerHeader {
                cell = view
            }
        }
        cell?.question.preferredMaxLayoutWidth = cell?.question.bounds.size.width ?? 0.0
        
        return cell
    }
    
}

class QuestionAnswerCell: UICollectionViewCell {
    
    @IBOutlet weak var toggle: OnOffButton!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var toggleView: UIView!
    
    var isAccepted      = false
    
    @objc fileprivate func didTapOnOffButton(_ sender: UITapGestureRecognizer? = nil) {
        if sender != nil {
            isAccepted = false
            NotificationCenter.default.post(name: NSNotification.Name("Uncheck"), object: nil)
        }
        
        if isAccepted && checked { return }
        if !isAccepted { isAccepted = true }
        
        if checked || ((currIndex == index + 1) && (i < kek.count)){
            if (currIndex == index + 1) && (selectedAnswers.count < kek.count){
                i += 1
                selectedAnswers.append(index)
            }
            if checked{
                selectedAnswers.append(index)
            }
            toggle.strokeColor  = blueColor
            toggleView.isHidden = false
            toggle.lineWidth    = 2
            toggle.setBackgroundImage(nil, for: .normal)
            
            checked                 = false
            isAccepted              = true
            currIndex = 0
            
        } else {
            
            for (ind, item) in selectedAnswers.enumerated() {
                if item == index {
                    selectedAnswers.remove(at: ind)
                }
            }
            toggle.strokeColor  = .lightGray
            toggleView.isHidden = true
            toggle.lineWidth    = 0
            toggle.setBackgroundImage(UIImage(named: "ic_choice"), for: .normal)
            
            isAccepted              = false
            checked                 = true
        }
        if i == kek.count{
            i = 0
        }
    }
    
    private let blueColor = UIColor(red: 0/255, green: 100/255, blue: 255/255, alpha: 1)
    fileprivate var checked  = false
    private var index = 0
    private var currIndex = 0
    
    func display(_ item: QuestionsTextJson, index: Int) {
        self.index = index
        kek.forEach {
            if item.id == $0{
                currIndex = index + 1
            }
        }
        toggle.checked = false
        
        toggle.strokeColor  = .lightGray
        toggle.lineWidth    = 2
        
        question.text = item.text
        
        checked = false
        didTapOnOffButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnOffButton(_:)))
        toggle.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Uncheck"), object: nil, queue: nil) { _ in
            self.checked = false
            self.didTapOnOffButton()
        }
    }
}
