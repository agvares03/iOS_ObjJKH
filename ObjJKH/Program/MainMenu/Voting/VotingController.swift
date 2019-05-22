//
//  VotingController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 02/04/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import Foundation
import Gloss
import YandexMobileMetrica

protocol VotingCellDelegate: class {
    func sendPressed(name: String, id: Int64)
}

class VotingController: UIViewController, UITableViewDelegate, UITableViewDataSource, VotingCellDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var supportImg: UIImageView!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var login: String = ""
    var pass: String = ""
    var fromMenu = true
    private var voting: [VoteDataJson]? = []
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
//        navigationController?.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let params : [String : Any] = ["Переход на страницу": "Голосования"]
        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { (error) in
            //            print("DID FAIL REPORT EVENT: %@", message)
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        self.StartIndicator()
        noDataLbl.isHidden = true
        let defaults = UserDefaults.standard
        login = defaults.string(forKey: "login")!
        pass  = defaults.string(forKey: "pass")!
        
        tableView.delegate = self
        tableView.dataSource = self
        
        supportImg.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        back.tintColor = myColors.btnColor.uiColor()
        loader.color = myColors.indicatorColor.uiColor()
        getVote()
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
                                                self.voting = filtered
                                                DispatchQueue.main.async {
                                                    self.StopIndicator()
                                                    if self.voting?.count == 0{
                                                        self.tableView.isHidden = true
                                                        self.noDataLbl.isHidden = false
                                                    }else{
                                                        self.tableView.isHidden = false
                                                        self.noDataLbl.isHidden = true
                                                        self.tableView.reloadData()
                                                    }
                                                }
        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voting!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "VotingCell") as! VotingCell
        cell.nameVote.text = voting![indexPath.row].comment
        if voting![indexPath.row].dateEnd == ""{
            cell.dateVote.text = "-"
        }else{
            var str:String = (voting![indexPath.row].dateEnd)!
            let i: Int = voting![indexPath.row].dateEnd!.count
            for _ in 1...i{
                if str.last != " "{
                    str.removeLast()
                }
            }
            cell.dateVote.text = str
        }
        cell.infoVote.isHidden = true
        var answer = 0
        voting![indexPath.row].questions?.forEach{
            if $0.answer != nil{
                answer += 1
            }
        }
        if voting![indexPath.row].isComplete!{
            cell.infoVote.isHidden = false
            cell.statusVote.text = "Ваш голос учтен"
            cell.statusVote.textColor = .lightGray
        }else if answer != 0{
            cell.statusVote.text = "Ваш голос учтен"
            cell.statusVote.textColor = .green
        }else{
            cell.statusVote.text = "Вы не голосовали"
            cell.statusVote.textColor = .red
        }
        cell.id = voting![indexPath.row].id!
        cell.delegate1 = self
        cell.delegate = self
        return cell
    }
    
    var selectedVote: VoteDataJson? = nil
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        selectedVote = voting![indexPath.row]
        self.performSegue(withIdentifier: "oneVote", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        if !fromMenu{
            getVote()
        }else{
            fromMenu = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "oneVote" {
            let payController             = segue.destination as! OneVoteController
            payController.vote = selectedVote
        }
        if segue.identifier == "resVote"{
            let payController             = segue.destination as! resVoteController
            payController.vote = selectedVote
        }
    }
    
    func sendPressed(name: String, id: Int64) {
        voting?.forEach{
            if $0.comment == name && $0.id == id{
                self.selectedVote = $0
            }
        }
        self.performSegue(withIdentifier: "resVote", sender: self)
    }
    
    private func StartIndicator() {
        loader.isHidden = false
        loader.startAnimating()
    }
    
    private func StopIndicator() {
        loader.isHidden = true
        loader.stopAnimating()
    }
}

class VotingCell: UITableViewCell {
    
    var delegate: UIViewController?
    var delegate1: VotingCellDelegate?
    
    @IBOutlet weak var nameVote: UILabel!
    @IBOutlet weak var dateVote: UILabel!
    @IBOutlet weak var statusVote: UILabel!
    @IBOutlet weak var infoVote: UIButton!
    @IBOutlet weak var img: UIImageView!
    var id: Int64 = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func resAction(_ sender: UIButton) {
        delegate1?.sendPressed(name: nameVote.text!, id: id)
    }
    
}

struct VoteJson: JSONDecodable {
    
    let data: [VoteDataJson]?
    
    init?(json: JSON) {
        data = "data" <~~ json
    }
    
}

struct VoteDataJson: JSONDecodable {
    
    let id:Int64?
    let dateStart:String?
    let dateEnd:String?
    let dateRealPart:String?
    let houseAddress:String?
    let type: String?
    let author: String?
    let form: String?
    let comment: String?
    let areaResidential: Double?
    let areaNonresidential: Double?
    let isComplete: Bool?
    let questions:[QuestionsVote]?
    let accounts:[AccountsVote]?
    
    init?(json: JSON) {
        id                  = "ID"                  <~~ json
        dateStart           = "DateStart"           <~~ json
        dateEnd             = "DateEnd"             <~~ json
        dateRealPart        = "DateRealPart"        <~~ json
        houseAddress        = "HouseAddress"        <~~ json
        author              = "Author"              <~~ json
        form                = "Form"                <~~ json
        comment             = "Comment"             <~~ json
        areaResidential     = "AreaResidential"     <~~ json
        areaNonresidential  = "AreaNonresidential"  <~~ json
        isComplete          = "IsComplete"          <~~ json
        questions           = "Questions"           <~~ json
        accounts            = "Acciunts"            <~~ json
        type                = "Type"                <~~ json
    }
}

struct QuestionsVote: JSONDecodable {
    
    let id:Int64?
    let number:String?
    let text:String?
    var answer:String?
    let answerStats:[AnswerStats]?
    
    init?(json: JSON) {
        id           = "ID"             <~~ json
        number       = "Number"         <~~ json
        text         = "Text"           <~~ json
        answer       = "Answer"         <~~ json
        answerStats  = "AnswersStats"   <~~ json
    }
}

struct AccountsVote: JSONDecodable {
    
    let ident:String?
    let area:String?
    let property:String?
    
    init?(json: JSON) {
        ident       = "Ident"              <~~ json
        area        = "Area"               <~~ json
        property    = "PropertyPercent"    <~~ json
    }
}

struct AnswerStats: JSONDecodable {
    
    let name:String?
    let count:Int?
    let percentage:Int?
    
    init?(json: JSON) {
        name        = "Name"          <~~ json
        count       = "Count"         <~~ json
        percentage  = "Percentage"    <~~ json
    }
}
