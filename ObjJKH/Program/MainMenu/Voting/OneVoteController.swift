//
//  OneVoteController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 03/04/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import Gloss

class OneVoteController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var typeSobrLbl: UILabel!
    @IBOutlet weak var formSobrLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var meetSobrImg: UIImageView!
    @IBOutlet weak var goVoteBtn: UIButton!
    @IBOutlet weak var resVoteHeight: NSLayoutConstraint!
    @IBOutlet weak var resView: UIView!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var form: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var supportImg: UIImageView!
    
    var login: String = ""
    var pass: String = ""
    public var vote: VoteDataJson? = nil
    var fromMenu = true
    var idOSS:Int64 = 0
    
    var clickPov = false
    @IBAction func povVoteClick(_ sender: UIButton) {
        if clickPov{
            clickPov = false
            DispatchQueue.main.async {
                self.tableViewHeight.constant = 0
            }
            meetSobrImg.image = UIImage(named: "arrows_right")
        }else{
            clickPov = true
            DispatchQueue.main.async {
                var height: CGFloat = 0
                for cell in self.tableView.visibleCells {
                    height += cell.bounds.height
                }
                self.tableViewHeight.constant = CGFloat((self.vote?.questions?.count)! * Int(height) + 10)
            }
            meetSobrImg.image = UIImage(named: "arrows_down")
        }
    }
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        login = defaults.string(forKey: "login")!
        pass  = defaults.string(forKey: "pass")!
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if vote?.type == ""{
            typeSobrLbl.text = "-"
        }else{
            typeSobrLbl.text = vote?.type
        }
        if vote?.form == ""{
            formSobrLbl.text = "-"
        }else{
            formSobrLbl.text = vote?.form
        }
        if vote?.dateRealPart == ""{
            dateLbl.text = "-"
        }else{
            var str:String = (vote?.dateRealPart)!
            let i: Int = (vote?.dateRealPart!.count)!
            for _ in 1...i{
                if str.last != " "{
                    str.removeLast()
                }
            }
            dateLbl.text = str
        }
        if vote?.houseAddress == ""{
            addressLbl.text = "-"
        }else{
            addressLbl.text = vote?.houseAddress
        }
        
        tableViewHeight.constant = 0
        supportImg.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        back.tintColor = myColors.btnColor.uiColor()
        goVoteBtn.backgroundColor = myColors.btnColor.uiColor()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let dateEnd: Date = dateFormatter.date(from: (vote?.dateEnd)!)!
        let date = dateFormatter.string(from: Date())
        let dateCurr: Date = dateFormatter.date(from: date)!
        if dateCurr < dateEnd{
            let sepCurr = date.replacingOccurrences(of: " ", with: ".").components(separatedBy: ".")
            let sepEnd: [String] = (vote?.dateEnd!.replacingOccurrences(of: " ", with: ".").components(separatedBy: "."))!
            let dayEnd: Int = Int(sepEnd[0])!
            let dayCurr: Int = Int(sepCurr[0])!
            let monthEnd: Int = Int(sepEnd[1])!
            let monthCurr: Int = Int(sepCurr[1])!
            if monthEnd == monthCurr{
                let s = dayEnd - dayCurr
                if s > 0{
                    self.endDateLbl.text = "До конца голосования " + String(s) + " дней"
                }else if s < 0{
                    self.endDateLbl.text = "Голосование окончено"
                }else{
                    self.endDateLbl.text = "Голосование заканчивается сегодня"
                }
            }else if monthEnd > monthCurr{
                if monthCurr == 1 || monthCurr == 3 || monthCurr == 5 || monthCurr == 7 || monthCurr == 8 || monthCurr == 10 || monthCurr == 12{
                    let s = dayEnd + (31 - dayCurr)
                    self.endDateLbl.text = "До конца голосования " + String(s) + " дней"
                }else if monthCurr == 4 || monthCurr == 6 || monthCurr == 9 || monthCurr == 11{
                    let s = dayEnd + (30 - dayCurr)
                    self.endDateLbl.text = "До конца голосования " + String(s) + " дней"
                }else if monthCurr == 2 && (monthCurr / 4 == 0){
                    let s = dayEnd + (29 - dayCurr)
                    self.endDateLbl.text = "До конца голосования " + String(s) + " дней"
                }else if monthCurr == 2 && (monthCurr / 4 != 0){
                    let s = dayEnd + (28 - dayCurr)
                    self.endDateLbl.text = "До конца голосования " + String(s) + " дней"
                }
            }else if monthEnd < monthCurr{
                self.endDateLbl.text = "Голосование окончено"
            }
        }else{
            self.endDateLbl.text = "Голосование окончено"
        }
        
        if (vote?.isComplete)!{
            resVoteHeight.constant = 40.5
            resView.isHidden = false
            goVoteBtn.isHidden = true
        }else{
            resVoteHeight.constant = 0
            resView.isHidden = true
        }
        idOSS = (vote?.id)!
        // Do any additional setup after loading the view.
    }
    
    func getVote(){
        let phone = UserDefaults.standard.string(forKey: "phone") ?? ""
        //        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_QUESTIONS + "accID=" + id)!)
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_OSS + "phone=" + phone + "&pwd=" + pass)!)
        request.httpMethod = "GET"
        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, error, responce in
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(responseString)")
                                                //            if error != nil {
                                                //                print("ERROR")
                                                //                return
                                                //            }
                                                
                                                guard data != nil else { return }
                                                let json = try? JSONSerialization.jsonObject(with: data!,
                                                                                             options: .allowFragments)
                                                let unfilteredData = VoteJson(json: json! as! JSON)?.data
                                                var filtered: [VoteDataJson] = []
                                                unfilteredData?.forEach { json in
                                                    
                                                    //                                                    var isContains = false
                                                    //                                                    json.questions?.forEach {
                                                    //                                                        if !($0.isCompleteByUser ?? false) {
                                                    //                                                            isContains = false
                                                    //                                                        }
                                                    //                                                    }
                                                    //                                                    if !isContains {
                                                    filtered.append(json)
                                                    //                                                    }
                                                }
                                                filtered.forEach{
                                                    if $0.id == self.idOSS{
                                                        self.vote = $0
                                                    }
                                                }
                                                DispatchQueue.main.async {
                                                    if (self.vote?.isComplete)!{
                                                        self.resVoteHeight.constant = 40.5
                                                        self.resView.isHidden = false
                                                        self.goVoteBtn.isHidden = true
                                                    }else{
                                                        self.resVoteHeight.constant = 0
                                                        self.resView.isHidden = true
                                                    }
                                                    self.tableView.reloadData()
                                                }
        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (vote?.questions!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "OneVoteCell") as! OneVoteCell
        cell.textQuestion.text = vote?.questions![indexPath.row].text
        if vote?.questions![indexPath.row].answer == nil{
            cell.statusImg.image = UIImage(named: "unCheck")
        }else if vote?.questions![indexPath.row].answer == "0"{
            cell.statusImg.image = UIImage(named: "Check")
            cell.statusImg.setImageColor(color: .green)
        }else if vote?.questions![indexPath.row].answer == "1"{
            cell.statusImg.image = UIImage(named: "Check")
            cell.statusImg.setImageColor(color: .red)
        }else if vote?.questions![indexPath.row].answer == "2"{
            cell.statusImg.image = UIImage(named: "Check")
            cell.statusImg.setImageColor(color: .lightGray)
        }
        cell.delegate = self
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "OneVoteCell") as! OneVoteCell
//        DispatchQueue.main.async {
//            self.tableViewHeight.constant = CGFloat((self.vote?.questions?.count)! * cell.textQuestion.frame.size.height)
//        }
//        return cell.textQuestion.frame.size.height
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !fromMenu{
            getVote()
        }else{
            fromMenu = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "questionVote" {
            let payController             = segue.destination as! QuestionVoteController
            payController.questions = (vote?.questions)!
            let k: Int64 = (vote?.id)!
            payController.idOSS = String(k)
        }
        
        if segue.identifier == "resVote"{
            let payController             = segue.destination as! resVoteController
            payController.vote = vote
        }
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

class OneVoteCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var textQuestion: UILabel!
    @IBOutlet weak var statusImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }    
}
