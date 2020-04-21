//
//  NewsView.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Gloss
import SwiftyXMLParser

class NewsView: UIViewController, QuestionTableDelegate {
    func update() {
        print("")
    }
    
    
    var newsTitle: String?
    var newsData: String?
    var newsText: String?
    var newsRead: Bool?
    var newsId: String?
    var questionID: String?
    var serviceID: String?
    private var questions: [QuestionDataJson]? = []
    
    @IBOutlet weak var NewsTitle: UILabel!
    @IBOutlet weak var NewsData: UILabel!
    @IBOutlet weak var NewsText: UILabel!
    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceBtn: UIButton!
    @IBOutlet weak var serviceHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceIMG: UIImageView!
    @IBOutlet weak var newsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nav_bottom: UINavigationItem!
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBAction func goAnswers(_ sender: UIButton) {
        startAnimation()
        DispatchQueue.main.async{
            self.questionBtn.isHidden = false
        }
        getQuestions()
    }
    
    @IBAction func goService(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goService", sender: self)
        }
    }
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
//        navigationController?.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if !newsRead!{
            self.read_news()
        }
        NewsTitle.text = newsTitle
        NewsData.text = newsData
        NewsText.text = newsText
        loader.color = myColors.btnColor.uiColor()
        questionBtn.backgroundColor = myColors.btnColor.uiColor()
        if Int(questionID!)! > 0{
            questionBtn.isHidden = false
            btnHeight.constant = 40
            loader.isHidden = true
        }else{
            questionBtn.isHidden = true
            btnHeight.constant = 0
            loader.isHidden = true
        }
        if Int(serviceID!)! > 0{
            let login = UserDefaults.standard.string(forKey: "login")
            let pass  = UserDefaults.standard.string(forKey: "pass")
            get_Services(login: login ?? "", pass: pass ?? "")
            loader.isHidden = false
            loader.startAnimating()
        }else{
            self.serviceHeight.constant = 0
            self.serviceIMG.isHidden = true
            self.serviceBtn.isHidden = true
        }
        // Установим цвета для элементов в зависимости от Таргета
        back.tintColor = myColors.btnColor.uiColor()
        newsHeight.constant = heightForView(text: newsText ?? "", font: NewsText.font, width: view.frame.size.width - 20)
        let titles = Titles()
        self.title = titles.getSimpleTitle(numb: "0")
        
    }
    
    func startAnimation(){
        DispatchQueue.main.async{
            self.loader.startAnimating()
            self.loader.isHidden = false
        }
    }
    
    func stopAnimation(){
        DispatchQueue.main.async{
            self.loader.stopAnimating()
            self.loader.isHidden = true
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        print(label.frame.height, width)
        return label.frame.height
    }
    
    func read_news(){
        let phone = UserDefaults.standard.string(forKey: "login")!
        let url: String = "SetAnnouncementIsReaded.ashx?"
        var request = URLRequest(url: URL(string: Server.SERVER + url + "id=" + newsId! + "&phone=" + phone)!)
        request.httpMethod = "GET"
        print(request)
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            print(String(data: data!, encoding: .utf8) ?? "")
            guard data != nil else { return }
            var read_news = UserDefaults.standard.integer(forKey: "newsKol")
            read_news -= 1
            if read_news >= 0{
                 UserDefaults.standard.set(read_news, forKey: "newsKol")
            }else{
                 UserDefaults.standard.set(0, forKey: "newsKol")
            }
            DispatchQueue.main.async {
                let updatedBadgeNumber = UserDefaults.standard.integer(forKey: "appsKol") + UserDefaults.standard.integer(forKey: "newsKol")
                if (updatedBadgeNumber > -1) {
                    UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
                }
                //                if request_read >= 0{
                //                    UserDefaults.standard.setValue(request_read, forKey: "request_read")
                //                    UserDefaults.standard.synchronize()
                //                }else{
                //                    UserDefaults.standard.setValue(0, forKey: "request_read")
                //                    UserDefaults.standard.synchronize()
                //                }
                
            }
            
            }.resume()
    }
    
    func getQuestions() {
//        let id = UserDefaults.standard.string(forKey: "id_account") ?? ""
        let phone = UserDefaults.standard.string(forKey: "phone") ?? ""
    //        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "accID=" + id)!)
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "phone=" + phone)!)
        request.httpMethod = "GET"
        print(request)
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
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
            var questTrue = false
            self.questions!.forEach{
                if String($0.id!) == self.questionID{
                    questTrue = true
                    self.stopAnimation()
                    DispatchQueue.main.async{
                        self.questionBtn.isHidden = false
                        self.performSegue(withIdentifier: "go_answers", sender: self)
                    }
                }
            }
            if !questTrue{
                self.stopAnimation()
                DispatchQueue.main.async{
                    self.questionBtn.isHidden = false
                    let alert = UIAlertController(title: "Ошибка", message: "Опрос не найден", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            }.resume()
    }
    
    var serviceArr: [Services] = []
    var currService = -1
    var mainScreenXml:  XML.Accessor?
    func get_Services(login: String, pass: String){
        serviceArr.removeAll()
//            let urlPath = "http://uk-gkh.org/gbu_lefortovo/GetAdditionalServices.ashx?login=qw&pwd=qw"
        let urlPath = Server.SERVER + Server.GET_ADDITIONAL_SERVICES + "login=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        DispatchQueue.global(qos: .userInteractive).async {
            var request = URLRequest(url: URL(string: urlPath)!)
            request.httpMethod = "GET"
            print(request)
            
            URLSession.shared.dataTask(with: request) {
                data, error, responce in
                
                guard data != nil else { return }
                //                let responseString = String(data: data!, encoding: .utf8) ?? ""
                //                #if DEBUG
                //                print("responseString = \(responseString)")
                //                #endif
                let xml = XML.parse(data!)
                self.mainScreenXml = xml
                let requests = xml["AdditionalServices"]
                let row = requests["Group"]
                row.forEach { row in
                    row["AdditionalService"].forEach {
                        self.serviceArr.append(Services(row: $0))
                    }
                }
                for i in 0...self.serviceArr.count - 1{
                    if self.serviceArr[i].id == self.serviceID{
                        let url:NSURL = NSURL(string: (self.serviceArr[i].logo)!)!
                        let data = try? Data(contentsOf: url as URL)
                        if UIImage(data: data!) == nil{
                            DispatchQueue.main.async{
                                self.serviceHeight.constant = 0
                                self.serviceIMG.isHidden = true
                                self.serviceBtn.isHidden = true
                            }
                        }else{
                            DispatchQueue.main.async{
                                self.currService = i
                                self.serviceIMG.isHidden = false
                                if self.serviceArr[i].canbeordered == "1" && self.serviceArr[i].id_requesttype != "" && self.serviceArr[i].id_account != ""{
                                    self.serviceBtn.isHidden = false
                                }else{
                                    self.serviceBtn.isHidden = true
                                }                                
                                self.serviceHeight.constant = (self.view.frame.size.width - 30) / 2
                                self.serviceIMG.image = UIImage(data: data!)
                            }
                        }
                    }
                }
                DispatchQueue.main.async{
                    self.loader.stopAnimating()
                    self.loader.isHidden = true                    
                }
            }.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go_answers" {
            //            let vc = segue.destination as! QuestionAnswerVC
            //            vc.title = questionArr[indexQuestion].name
            //            vc.question_ = questionArr[indexQuestion]
            //            //            vc.delegate = delegate
            //            vc.questionDelegate = self
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! QuestionsTableVC
            var question: QuestionDataJson?
            questions!.forEach{
                if String($0.id!) == questionID{
                    question = $0
                }
            }
            vc.questionTitle = question?.name ?? ""
            vc.question_ = question
            //            vc.delegate = delegate
            vc.questionDelegate = self
        }
        if (segue.identifier == "goService") {
            let AddApp = segue.destination as! AdditionalVC
            AddApp.item = serviceArr[currService]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
