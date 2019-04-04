//
//  QuestionVoteController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 03/04/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class QuestionVoteController: UIViewController {

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var orBtn: UIButton!
    
    @IBOutlet weak var backQBtn: UIButton!
    @IBOutlet weak var nextQBtn: UIButton!
    @IBOutlet weak var endVoteBtn: UIButton!
    
    @IBOutlet weak var countQLbl: UILabel!
    @IBOutlet weak var textQLbl: UILabel!
    
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var supportImg: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var yesClk = false
    var noClk = false
    var orClk = false
    var selectQ = 0
    var login = ""
    var pass = ""
    var selAnswer = ""
    public var questions: [QuestionsVote]? = nil
    public var idOSS = ""
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeAction(_ sender: UIButton) {
        var i = 0
        if yesClk && questions![selectQ].answer != "0"{
            selAnswer = "0"
            questions![selectQ].answer = "0"
        }else if noClk && questions![selectQ].answer != "1"{
            selAnswer = "1"
            questions![selectQ].answer = "1"
        }else if orClk && questions![selectQ].answer != "2"{
            selAnswer = "2"
            questions![selectQ].answer = "2"
        }else if !yesClk && !noClk && !orClk{
            let alert = UIAlertController(title: "Ошибка", message: "Выберите вариант ответа", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.StartIndicator()
        self.sendAnswer(complete: true)
        questions?.forEach{
            if $0.answer != nil{
                i += 1
            }
        }
        if i != questions?.count{
            let alert = UIAlertController(title: "Ошибка", message: "Вы не ответили на все вопросы", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            self.completeVote()
        }
    }
    
    @IBAction func yesAction(_ sender: UIButton) {
        if yesClk{
            yesBtn.setTitleColor(.white, for: .normal)
            yesBtn.backgroundColor = myColors.btnColor.uiColor()
            yesClk = false
            if selectQ == (questions!.count - 1){
                endVoteBtn.backgroundColor = .lightGray
                endVoteBtn.isUserInteractionEnabled = false
            }
        }else{
            yesClk = true
            yesBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
            yesBtn.backgroundColor = .white
            noBtn.setTitleColor(.white, for: .normal)
            noBtn.backgroundColor = myColors.btnColor.uiColor()
            noClk = false
            orBtn.setTitleColor(.white, for: .normal)
            orBtn.backgroundColor = myColors.btnColor.uiColor()
            orClk = false
            if selectQ == (questions!.count - 1){
                endVoteBtn.backgroundColor = .green
                endVoteBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func noAction(_ sender: UIButton) {
        if noClk{
            noBtn.setTitleColor(.white, for: .normal)
            noBtn.backgroundColor = myColors.btnColor.uiColor()
            noClk = false
            if selectQ == (questions!.count - 1){
                endVoteBtn.backgroundColor = .lightGray
                endVoteBtn.isUserInteractionEnabled = false
            }
        }else{
            noClk = true
            noBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
            noBtn.backgroundColor = .white
            yesBtn.setTitleColor(.white, for: .normal)
            yesBtn.backgroundColor = myColors.btnColor.uiColor()
            yesClk = false
            orBtn.setTitleColor(.white, for: .normal)
            orBtn.backgroundColor = myColors.btnColor.uiColor()
            orClk = false
            if selectQ == (questions!.count - 1){
                endVoteBtn.backgroundColor = .green
                endVoteBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func orAction(_ sender: UIButton) {
        if orClk{
            orBtn.setTitleColor(.white, for: .normal)
            orBtn.backgroundColor = myColors.btnColor.uiColor()
            orClk = false
            if selectQ == (questions!.count - 1){
                endVoteBtn.backgroundColor = .lightGray
                endVoteBtn.isUserInteractionEnabled = false
            }
        }else{
            orClk = true
            orBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
            orBtn.backgroundColor = .white
            noBtn.setTitleColor(.white, for: .normal)
            noBtn.backgroundColor = myColors.btnColor.uiColor()
            noClk = false
            yesBtn.setTitleColor(.white, for: .normal)
            yesBtn.backgroundColor = myColors.btnColor.uiColor()
            yesClk = false
            if selectQ == (questions!.count - 1){
                endVoteBtn.backgroundColor = .green
                endVoteBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func nextQAction(_ sender: UIButton) {
        if selectQ < questions!.count - 1{
            if yesClk && questions![selectQ].answer != "0"{
                selAnswer = "0"
                questions![selectQ].answer = "0"
                self.StartIndicator()
                self.sendAnswer(complete: false)
            }else if noClk && questions![selectQ].answer != "1"{
                selAnswer = "1"
                questions![selectQ].answer = "1"
                self.StartIndicator()
                self.sendAnswer(complete: false)
            }else if orClk && questions![selectQ].answer != "2"{
                selAnswer = "2"
                questions![selectQ].answer = "2"
                self.StartIndicator()
                self.sendAnswer(complete: false)
            }else if !yesClk && !noClk && !orClk{
                let alert = UIAlertController(title: "Ошибка", message: "Выберите вариант ответа", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.nextQuestion()
            }
        }
    }
    
    func nextQuestion(){
        selectQ += 1
        textQLbl.text = questions![selectQ].text
        countQLbl.text = "Вопрос " + String(selectQ + 1) + " из " + String(questions!.count) + ":"
        backQBtn.backgroundColor = myColors.btnColor.uiColor()
        backQBtn.isUserInteractionEnabled = true
        yesBtn.setTitleColor(.white, for: .normal)
        yesBtn.backgroundColor = myColors.btnColor.uiColor()
        yesClk = false
        orBtn.setTitleColor(.white, for: .normal)
        orBtn.backgroundColor = myColors.btnColor.uiColor()
        orClk = false
        noBtn.setTitleColor(.white, for: .normal)
        noBtn.backgroundColor = myColors.btnColor.uiColor()
        noClk = false
        if questions![selectQ].answer != nil{
            if questions![selectQ].answer == "0"{
                yesBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
                yesBtn.backgroundColor = .white
                yesClk = true
            }else if questions![selectQ].answer == "1"{
                noBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
                noBtn.backgroundColor = .white
                noClk = true
            }else if questions![selectQ].answer == "2"{
                orBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
                orBtn.backgroundColor = .white
                orClk = true
            }
        }
        if selectQ == questions!.count - 1{
            nextQBtn.backgroundColor = .lightGray
            nextQBtn.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func backQAction(_ sender: UIButton) {
        if selectQ > 0{
//            if yesClk{
//                questions![selectQ].answer = "0"
//            }else if noClk{
//                questions![selectQ].answer = "1"
//            }else if orClk{
//                questions![selectQ].answer = "2"
//            }
            selectQ -= 1
            textQLbl.text = questions![selectQ].text
            countQLbl.text = "Вопрос " + String(selectQ + 1) + " из " + String(questions!.count) + ":"
            nextQBtn.backgroundColor = myColors.btnColor.uiColor()
            nextQBtn.isUserInteractionEnabled = true
            yesBtn.setTitleColor(.white, for: .normal)
            yesBtn.backgroundColor = myColors.btnColor.uiColor()
            yesClk = false
            orBtn.setTitleColor(.white, for: .normal)
            orBtn.backgroundColor = myColors.btnColor.uiColor()
            orClk = false
            noBtn.setTitleColor(.white, for: .normal)
            noBtn.backgroundColor = myColors.btnColor.uiColor()
            noClk = false
            if questions![selectQ].answer != nil{
                if questions![selectQ].answer == "0"{
                    yesBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
                    yesBtn.backgroundColor = .white
                    yesClk = true
                }else if questions![selectQ].answer == "1"{
                    noBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
                    noBtn.backgroundColor = .white
                    noClk = true
                }else if questions![selectQ].answer == "2"{
                    orBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
                    orBtn.backgroundColor = .white
                    orClk = true
                }
            }
            endVoteBtn.backgroundColor = .lightGray
            endVoteBtn.isUserInteractionEnabled = false
        }
        if selectQ == 0{
            backQBtn.backgroundColor = .lightGray
            backQBtn.isUserInteractionEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.StopIndicator()
        let defaults = UserDefaults.standard
        login = defaults.string(forKey: "login")!
        pass  = defaults.string(forKey: "pass")!
        yesBtn.layer.borderWidth = 2.0
        yesBtn.layer.borderColor = myColors.btnColor.uiColor().cgColor
        yesBtn.setTitleColor(.white, for: .normal)
        yesBtn.backgroundColor = myColors.btnColor.uiColor()
        noBtn.layer.borderWidth = 2.0
        noBtn.layer.borderColor = myColors.btnColor.uiColor().cgColor
        noBtn.setTitleColor(.white, for: .normal)
        noBtn.backgroundColor = myColors.btnColor.uiColor()
        orBtn.layer.borderWidth = 2.0
        orBtn.layer.borderColor = myColors.btnColor.uiColor().cgColor
        orBtn.setTitleColor(.white, for: .normal)
        orBtn.backgroundColor = myColors.btnColor.uiColor()
        supportImg.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        nextQBtn.backgroundColor = myColors.btnColor.uiColor()
        backQBtn.backgroundColor = .lightGray
        backQBtn.isUserInteractionEnabled = false
        endVoteBtn.backgroundColor = .lightGray
        endVoteBtn.isUserInteractionEnabled = false
        back.tintColor = myColors.btnColor.uiColor()
        loader.color = myColors.indicatorColor.uiColor()
        textQLbl.text = questions![0].text
        countQLbl.text = "Вопрос 1 из " + String(questions!.count) + ":"
        questions?.forEach{
            if $0.answer != nil{
                self.nextQuestion()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    private func sendAnswer(complete: Bool) {
        print(questions![selectQ].id!)
        let id: Int64 = questions![selectQ].id!
        let urlPath = Server.SERVER + Server.SAVE_ANSWER_VOTE + "phone=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&questionId=" + String(id).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&answer=" + selAnswer.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        let alert = UIAlertController(title: "Ошибка сервера", message: "Попробуйте позже", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                    return
                                                }
                                                
                                                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                                                print("responseString = \(responseString)")
                                                if !responseString.contains("error"){
                                                    DispatchQueue.main.async(execute: {
                                                        if !complete{
                                                            self.StopIndicator()
                                                            self.selAnswer = ""
                                                            self.nextQuestion()
                                                        }
                                                    })
                                                }else{
                                                    DispatchQueue.main.async(execute: {
                                                        self.StopIndicator()
                                                        let alert = UIAlertController(title: "Ошибка!", message: responseString.replacingOccurrences(of: "error:", with: ""), preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                    return
                                                }
                                                
                                                
        })
        task.resume()
    }
    
    private func completeVote() {
        let urlPath = Server.SERVER + Server.COMPLETE_VOTE + "phone=" + login.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&pwd=" + pass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&ossId=" + idOSS.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!;
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        let alert = UIAlertController(title: "Ошибка сервера", message: "Попробуйте позже", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                    return
                                                }
                                                
                                                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                                                print("responseString = \(responseString)")
                                                if !responseString.contains("error"){
                                                    DispatchQueue.main.async(execute: {
                                                        self.StopIndicator()
                                                        self.selAnswer = ""
                                                        let alert = UIAlertController(title: "Ваши ответы успешно приняты", message: "", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                                                            self.navigationController?.popViewController(animated: true)
                                                        }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                }else{
                                                    DispatchQueue.main.async(execute: {
                                                        self.StopIndicator()
                                                        let alert = UIAlertController(title: "Ошибка!", message: responseString.replacingOccurrences(of: "error:", with: ""), preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                    return
                                                }
                                                
                                                
        })
        task.resume()
    }
    
    private func StartIndicator() {
        loader.isHidden = false
        loader.startAnimating()
    }
    
    private func StopIndicator() {
        loader.isHidden = true
        loader.stopAnimating()
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
