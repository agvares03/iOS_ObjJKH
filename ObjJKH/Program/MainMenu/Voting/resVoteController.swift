//
//  resVoteController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 04/04/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class resVoteController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var supportImg: UIImageView!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    var login: String = ""
    var pass: String = ""
    public var vote: VoteDataJson? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        login = defaults.string(forKey: "login")!
        pass  = defaults.string(forKey: "pass")!
        
        tableView.delegate = self
        tableView.dataSource = self
        
        supportImg.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        back.tintColor = myColors.btnColor.uiColor()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (vote?.questions!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "resVoteCell") as! resVoteCell
        cell.textQuestion.text = vote?.questions![indexPath.row].text
        var yesP = 0
        var noP = 0
        var orP = 0
        vote?.questions![indexPath.row].answerStats?.forEach{
            if $0.name == "Всего"{
                let s:Int = $0.count!
                if String(s).last == "1"{
                    cell.allNumber.text = String(s) + " голос"
                }else if String(s).last == "2" || String(s).last == "3" || String(s).last == "4"{
                    cell.allNumber.text = String(s) + " голоса"
                }else{
                    cell.allNumber.text = String(s) + " голосов"
                }
                
            }else if $0.name == "За"{
                let s:Int = $0.count!
                yesP = $0.percentage!
                if yesP != 0{
                    cell.yesNumber.text = String(s) + " (\(String(yesP))%)"
                }else{
                    cell.yesNumber.text = String(s)
                }
            }else if $0.name == "Против"{
                let s:Int = $0.count!
                noP = $0.percentage!
                if noP != 0{
                    cell.noNumber.text = String(s) + " (\(String(noP))%)"
                }else{
                    cell.noNumber.text = String(s)
                }
            }else if $0.name == "Воздержался"{
                let s:Int = $0.count!
                orP = $0.percentage!
                if orP != 0{
                    cell.orNumber.text = String(s) + " (\(String(orP))%)"
                }else{
                    cell.orNumber.text = String(s)
                }
            }
        }
        if yesP > noP && yesP > orP{
            cell.resLbl.text = "За"
            cell.resLbl.textColor = .green
        }else if noP > yesP && noP > orP{
            cell.resLbl.text = "Против"
            cell.resLbl.textColor = .red
        }else if orP > yesP && orP > noP{
            cell.resLbl.text = "Воздержался"
            cell.resLbl.textColor = .lightGray
        }else{
            cell.resLbl.isHidden = true
        }
        if vote?.questions![indexPath.row].answer == nil{
            cell.lResLbl.text = "Ваш ответ не засчитан"
        }else if vote?.questions![indexPath.row].answer == "0"{
            cell.lResLbl.text = "Вы проголосовали: За"
        }else if vote?.questions![indexPath.row].answer == "1"{
            cell.lResLbl.text = "Вы проголосовали: Против"
        }else if vote?.questions![indexPath.row].answer == "2"{
            cell.lResLbl.text = "Вы Воздержались"
        }
        cell.delegate = self
        return cell
    }
}

class resVoteCell: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var textQuestion: UILabel!
    @IBOutlet weak var resLbl: UILabel!
    @IBOutlet weak var lResLbl: UILabel!
    @IBOutlet weak var allNumber: UILabel!
    @IBOutlet weak var yesNumber: UILabel!
    @IBOutlet weak var noNumber: UILabel!
    @IBOutlet weak var orNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
