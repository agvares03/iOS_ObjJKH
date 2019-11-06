//
//  addCountersController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 25/03/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import YandexMobileAds
import GoogleMobileAds

class AddCountersController: UIViewController, YMANativeAdDelegate, YMANativeAdLoaderDelegate, UITextFieldDelegate {
    
    var adLoader: YMANativeAdLoader!
    var bannerView: YMANativeBannerView?
    var gadBannerView: GADBannerView!
    var request = GADRequest()
    
    @IBOutlet weak var dateLbl:         UILabel!
    @IBOutlet weak var nameLbl:         UILabel!
    @IBOutlet weak var numberLbl:       UILabel!
    @IBOutlet weak var newCounters1:    UITextField!
    @IBOutlet weak var newCounters2:    UITextField!
    @IBOutlet weak var newCounters3:    UITextField!
    @IBOutlet weak var newCountersDrob1:UITextField!
    @IBOutlet weak var newCountersDrob2:UITextField!
    @IBOutlet weak var newCountersDrob3:UITextField!
    @IBOutlet weak var sendCount:       UIButton!
    @IBOutlet weak var cancelCount:     UIButton!
    @IBOutlet weak var autoSendLbl:     UILabel!
    @IBOutlet weak var backBtn:         UIBarButtonItem!
    @IBOutlet weak var imgCounter:      UIImageView!
    @IBOutlet weak var viewImgCounter:  UIView!
    @IBOutlet weak var indicator:       UIActivityIndicatorView!
    @IBOutlet weak var viewTop:         NSLayoutConstraint!
    @IBOutlet weak var tarif2Height:    NSLayoutConstraint!
    @IBOutlet weak var tarif3Height:    NSLayoutConstraint!
    @IBOutlet weak var tarif2View:      UIView!
    @IBOutlet weak var tarif3View:      UIView!
    @IBOutlet weak var tariffOne:       UILabel!
    @IBOutlet weak var tariffTwo:       UILabel!
    @IBOutlet weak var tariffThree:     UILabel!
    @IBOutlet weak var interLbl:        UILabel!
    
    @IBOutlet weak var count11:         UITextField!
    @IBOutlet weak var count12:         UITextField!
    @IBOutlet weak var count13:         UITextField!
    @IBOutlet weak var count14:         UITextField!
    @IBOutlet weak var count15:         UITextField!
    @IBOutlet weak var count16:         UITextField!
    @IBOutlet weak var count17:         UITextField!
    @IBOutlet weak var count18:         UITextField!
    @IBOutlet weak var count19:         UITextField!
    @IBOutlet weak var count16Width:    NSLayoutConstraint!
    @IBOutlet weak var count17Width:    NSLayoutConstraint!
    @IBOutlet weak var count18Width:    NSLayoutConstraint!
    @IBOutlet weak var count19Width:    NSLayoutConstraint!
    @IBOutlet weak var teckLbl1:        UILabel!
    @IBOutlet weak var countDec1:       UILabel!
    
    @IBOutlet weak var count21:         UITextField!
    @IBOutlet weak var count22:         UITextField!
    @IBOutlet weak var count23:         UITextField!
    @IBOutlet weak var count24:         UITextField!
    @IBOutlet weak var count25:         UITextField!
    @IBOutlet weak var count26:         UITextField!
    @IBOutlet weak var count27:         UITextField!
    @IBOutlet weak var count28:         UITextField!
    @IBOutlet weak var count29:         UITextField!
    @IBOutlet weak var count26Width:    NSLayoutConstraint!
    @IBOutlet weak var count27Width:    NSLayoutConstraint!
    @IBOutlet weak var count28Width:    NSLayoutConstraint!
    @IBOutlet weak var count29Width:    NSLayoutConstraint!
    @IBOutlet weak var teckLbl2:        UILabel!
    @IBOutlet weak var countDec2:       UILabel!
    
    @IBOutlet weak var count31:         UITextField!
    @IBOutlet weak var count32:         UITextField!
    @IBOutlet weak var count33:         UITextField!
    @IBOutlet weak var count34:         UITextField!
    @IBOutlet weak var count35:         UITextField!
    @IBOutlet weak var count36:         UITextField!
    @IBOutlet weak var count37:         UITextField!
    @IBOutlet weak var count38:         UITextField!
    @IBOutlet weak var count39:         UITextField!
    @IBOutlet weak var count36Width:    NSLayoutConstraint!
    @IBOutlet weak var count37Width:    NSLayoutConstraint!
    @IBOutlet weak var count38Width:    NSLayoutConstraint!
    @IBOutlet weak var count39Width:    NSLayoutConstraint!
    @IBOutlet weak var teckLbl3:        UILabel!
    @IBOutlet weak var countDec3:       UILabel!
    
    @IBOutlet weak var pred11:          UILabel!
    @IBOutlet weak var pred12:          UILabel!
    @IBOutlet weak var pred13:          UILabel!
    @IBOutlet weak var pred14:          UILabel!
    @IBOutlet weak var pred15:          UILabel!
    @IBOutlet weak var pred16:          UILabel!
    @IBOutlet weak var pred17:          UILabel!
    @IBOutlet weak var pred18:          UILabel!
    @IBOutlet weak var pred19:          UILabel!
    @IBOutlet weak var pred16Width:     NSLayoutConstraint!
    @IBOutlet weak var pred17Width:     NSLayoutConstraint!
    @IBOutlet weak var pred18Width:     NSLayoutConstraint!
    @IBOutlet weak var pred19Width:     NSLayoutConstraint!
    @IBOutlet weak var predView1:       UIView!
    @IBOutlet weak var pred1Height:     NSLayoutConstraint!
    @IBOutlet weak var predLbl1:        UILabel!
    @IBOutlet weak var predDec1:        UILabel!
    
    @IBOutlet weak var pred21:          UILabel!
    @IBOutlet weak var pred22:          UILabel!
    @IBOutlet weak var pred23:          UILabel!
    @IBOutlet weak var pred24:          UILabel!
    @IBOutlet weak var pred25:          UILabel!
    @IBOutlet weak var pred26:          UILabel!
    @IBOutlet weak var pred27:          UILabel!
    @IBOutlet weak var pred28:          UILabel!
    @IBOutlet weak var pred29:          UILabel!
    @IBOutlet weak var pred26Width:     NSLayoutConstraint!
    @IBOutlet weak var pred27Width:     NSLayoutConstraint!
    @IBOutlet weak var pred28Width:     NSLayoutConstraint!
    @IBOutlet weak var pred29Width:     NSLayoutConstraint!
    @IBOutlet weak var predView2:       UIView!
    @IBOutlet weak var pred2Height:     NSLayoutConstraint!
    @IBOutlet weak var predLbl2:        UILabel!
    @IBOutlet weak var predDec2:        UILabel!
    
    @IBOutlet weak var pred31:          UILabel!
    @IBOutlet weak var pred32:          UILabel!
    @IBOutlet weak var pred33:          UILabel!
    @IBOutlet weak var pred34:          UILabel!
    @IBOutlet weak var pred35:          UILabel!
    @IBOutlet weak var pred36:          UILabel!
    @IBOutlet weak var pred37:          UILabel!
    @IBOutlet weak var pred38:          UILabel!
    @IBOutlet weak var pred39:          UILabel!
    @IBOutlet weak var pred36Width:     NSLayoutConstraint!
    @IBOutlet weak var pred37Width:     NSLayoutConstraint!
    @IBOutlet weak var pred38Width:     NSLayoutConstraint!
    @IBOutlet weak var pred39Width:     NSLayoutConstraint!
    @IBOutlet weak var predView3:       UIView!
    @IBOutlet weak var pred3Height:     NSLayoutConstraint!
    @IBOutlet weak var predLbl3:        UILabel!
    @IBOutlet weak var predDec3:        UILabel!
    
    
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        StartIndicator()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func back(_ sender: UIButton) {
        StartIndicator()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func sendAction1(_ sender: UIButton) {
        var count1 = ""
        var count2 = ""
        var count3 = ""
        if newCounters1.text! != ""{
            count1 = newCounters1.text!
        }else if newCountersDrob1.text! != ""{
            count1 = newCountersDrob1.text!
        }
        if newCounters2.text! != ""{
            count2 = newCounters2.text!
        }else if newCountersDrob2.text! != ""{
            count2 = newCountersDrob2.text!
        }
        if newCounters3.text! != ""{
            count3 = newCounters3.text!
        }else if newCountersDrob3.text! != ""{
            count3 = newCountersDrob3.text!
        }
        if ((count1 == "" || count1 == "0") && (tariffNumber == 0 || tariffNumber == 1)){
            let alert = UIAlertController(title: "", message: "Вы хотите передать нулевые показания?", preferredStyle: .alert)
            let noAction = UIAlertAction(title: "Нет", style: .default) { (_) -> Void in
                
            }
            let yesAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
                self.send_count(edLogin: self.edLogin, edPass: self.edPass, uniq_num: self.metrId, count1: "0,00", count2: "", count3: "")
            }
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }else if ((count1 == "" || count1 == "0" || count2 == "" || count2 == "0") && tariffNumber == 2) || ((count1 == "" || count1 == "0" || count2 == "" || count2 == "0" || count3 == "" || count3 == "0") && tariffNumber == 3){
            let alert = UIAlertController(title: "Ошибка", message: "Введите показания", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }else{
            if tariffNumber == 0 || tariffNumber == 1{
                for _ in 1...count1.count{
                    if count1.first == "0"{
                        count1.removeFirst()
                    }
                }
                if count1.replacingOccurrences(of: ".", with: ",").first == ","{
                    count1 = "0" + count1
                }
                if count1.replacingOccurrences(of: ".", with: ",").last == ","{
                    count1.removeLast()
                }
                if count1 == "0"{
                    let alert = UIAlertController(title: "Ошибка", message: "Введите показания", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                //            print(count.replacingOccurrences(of: ".", with: ","))
                self.send_count(edLogin: edLogin, edPass: edPass, uniq_num: metrId, count1: count1.replacingOccurrences(of: ".", with: ","), count2: "", count3: "")
            }else if tariffNumber == 2{
                for _ in 1...count1.count{
                    if count1.first == "0"{
                        count1.removeFirst()
                    }
                }
                for _ in 1...count2.count{
                    if count2.first == "0"{
                        count2.removeFirst()
                    }
                }
                if count1.replacingOccurrences(of: ".", with: ",").first == ","{
                    count1 = "0" + count1
                }
                if count1.replacingOccurrences(of: ".", with: ",").last == ","{
                    count1.removeLast()
                }
                if count2.replacingOccurrences(of: ".", with: ",").first == ","{
                    count2 = "0" + count2
                }
                if count2.replacingOccurrences(of: ".", with: ",").last == ","{
                    count2.removeLast()
                }
                if count1 == "0" || count2 == "0"{
                    let alert = UIAlertController(title: "Ошибка", message: "Введите показания", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                //            print(count.replacingOccurrences(of: ".", with: ","))
                self.send_count(edLogin: edLogin, edPass: edPass, uniq_num: metrId, count1: count1.replacingOccurrences(of: ".", with: ","), count2: count2.replacingOccurrences(of: ".", with: ","), count3: "")
            }else if tariffNumber == 3{
                for _ in 1...count1.count{
                    if count1.first == "0"{
                        count1.removeFirst()
                    }
                }
                for _ in 1...count2.count{
                    if count2.first == "0"{
                        count2.removeFirst()
                    }
                }
                for _ in 1...count3.count{
                    if count3.first == "0"{
                        count3.removeFirst()
                    }
                }
                if count1.replacingOccurrences(of: ".", with: ",").first == ","{
                    count1 = "0" + count1
                }
                if count1.replacingOccurrences(of: ".", with: ",").last == ","{
                    count1.removeLast()
                }
                if count2.replacingOccurrences(of: ".", with: ",").first == ","{
                    count2 = "0" + count2
                }
                if count2.replacingOccurrences(of: ".", with: ",").last == ","{
                    count2.removeLast()
                }
                if count3.replacingOccurrences(of: ".", with: ",").first == ","{
                    count3 = "0" + count3
                }
                if count3.replacingOccurrences(of: ".", with: ",").last == ","{
                    count3.removeLast()
                }
                if count1 == "0" || count2 == "0" || count3 == "0"{
                    let alert = UIAlertController(title: "Ошибка", message: "Введите показания", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                //            print(count.replacingOccurrences(of: ".", with: ","))
                self.send_count(edLogin: edLogin, edPass: edPass, uniq_num: metrId, count1: count1.replacingOccurrences(of: ".", with: ","), count2: count2.replacingOccurrences(of: ".", with: ","), count3: count3.replacingOccurrences(of: ".", with: ","))
            }
        }
        //        else{
        //            let alert = UIAlertController(title: "Ошибка", message: "Введите показания", preferredStyle: .alert)
        //            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
        //            }
        //            alert.addAction(cancelAction)
        //            self.present(alert, animated: true, completion: nil)
        //        }
    }
    
    var edLogin = ""
    var edPass = ""
    var responseString = ""
    private var count1:[UITextField] = []
    private var pred1:[UILabel] = []
    private var count2:[UITextField] = []
    private var pred2:[UILabel] = []
    private var count3:[UITextField] = []
    private var pred3:[UILabel] = []
    
    public var lastCheckDate = ""
    public var autoSend = false
    public var recheckInter = ""
    public var metrId = ""
    public var counterName = ""
    public var counterNumber = ""
    public var ident = ""
    public var predValue1 = ""
    public var predValue2 = ""
    public var predValue3 = ""
    public var tariffNumber = 3
    public var numberDecimal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.StopIndicator()
        let defaults     = UserDefaults.standard
        edLogin          = defaults.string(forKey: "login")!
        edPass           = defaults.string(forKey: "pass")!
        count1.append(count15)
        count1.append(count14)
        count1.append(count13)
        count1.append(count12)
        count1.append(count11)
        
        pred1.append(pred11)
        pred1.append(pred12)
        pred1.append(pred13)
        pred1.append(pred14)
        pred1.append(pred15)
        
        count2.append(count25)
        count2.append(count24)
        count2.append(count23)
        count2.append(count22)
        count2.append(count21)
        
        count3.append(count35)
        count3.append(count34)
        count3.append(count33)
        count3.append(count32)
        count3.append(count31)
        
        pred2.append(pred21)
        pred2.append(pred22)
        pred2.append(pred23)
        pred2.append(pred24)
        pred2.append(pred25)
        
        pred3.append(pred31)
        pred3.append(pred32)
        pred3.append(pred33)
        pred3.append(pred34)
        pred3.append(pred35)
        
        if numberDecimal == 4{
            count1.append(count16)
            count1.append(count17)
            count1.append(count18)
            count1.append(count19)
            
            pred1.append(pred16)
            pred1.append(pred17)
            pred1.append(pred18)
            pred1.append(pred19)
            
            count2.append(count26)
            count2.append(count27)
            count2.append(count28)
            count2.append(count29)
            
            count3.append(count36)
            count3.append(count37)
            count3.append(count38)
            count3.append(count39)
            
            pred2.append(pred26)
            pred2.append(pred27)
            pred2.append(pred28)
            pred2.append(pred29)
            
            pred3.append(pred36)
            pred3.append(pred37)
            pred3.append(pred38)
            pred3.append(pred39)
            
        }else if numberDecimal == 3{
            count1.append(count16)
            count1.append(count17)
            count1.append(count18)
            count19.isHidden = true
            count19Width.constant = 0
            
            pred1.append(pred16)
            pred1.append(pred17)
            pred1.append(pred18)
            pred19.isHidden = true
            pred19Width.constant = 0
            
            count2.append(count26)
            count2.append(count27)
            count2.append(count28)
            count29.isHidden = true
            count29Width.constant = 0
            
            count3.append(count36)
            count3.append(count37)
            count3.append(count38)
            count39.isHidden = true
            count39Width.constant = 0
            
            pred2.append(pred26)
            pred2.append(pred27)
            pred2.append(pred28)
            pred29.isHidden = true
            pred29Width.constant = 0
            
            pred3.append(pred36)
            pred3.append(pred37)
            pred3.append(pred38)
            pred39.isHidden = true
            pred39Width.constant = 0
            
        }else if numberDecimal == 2{
            count1.append(count16)
            count1.append(count17)
            count18.isHidden = true
            count19.isHidden = true
            count18Width.constant = 0
            count19Width.constant = 0
            
            pred1.append(pred16)
            pred1.append(pred17)
            pred18.isHidden = true
            pred19.isHidden = true
            pred18Width.constant = 0
            pred19Width.constant = 0
            
            count2.append(count26)
            count2.append(count27)
            count28.isHidden = true
            count29.isHidden = true
            count28Width.constant = 0
            count29Width.constant = 0
            
            count3.append(count36)
            count3.append(count37)
            count38.isHidden = true
            count39.isHidden = true
            count38Width.constant = 0
            count39Width.constant = 0
            
            pred2.append(pred26)
            pred2.append(pred27)
            pred28.isHidden = true
            pred29.isHidden = true
            pred28Width.constant = 0
            pred29Width.constant = 0
            
            pred3.append(pred36)
            pred3.append(pred37)
            pred38.isHidden = true
            pred39.isHidden = true
            pred38Width.constant = 0
            pred39Width.constant = 0
            
        }else if numberDecimal == 1{
            count1.append(count16)
            count17.isHidden = true
            count18.isHidden = true
            count19.isHidden = true
            count17Width.constant = 0
            count18Width.constant = 0
            count19Width.constant = 0
            
            pred1.append(pred16)
            pred17.isHidden = true
            pred18.isHidden = true
            pred19.isHidden = true
            pred17Width.constant = 0
            pred18Width.constant = 0
            pred19Width.constant = 0
            
            count2.append(count26)
            count27.isHidden = true
            count28.isHidden = true
            count29.isHidden = true
            count27Width.constant = 0
            count28Width.constant = 0
            count29Width.constant = 0
            
            count3.append(count36)
            count37.isHidden = true
            count38.isHidden = true
            count39.isHidden = true
            count37Width.constant = 0
            count38Width.constant = 0
            count39Width.constant = 0
            
            pred2.append(pred26)
            pred27.isHidden = true
            pred28.isHidden = true
            pred29.isHidden = true
            pred27Width.constant = 0
            pred28Width.constant = 0
            pred29Width.constant = 0
            
            pred3.append(pred36)
            pred37.isHidden = true
            pred38.isHidden = true
            pred39.isHidden = true
            pred37Width.constant = 0
            pred38Width.constant = 0
            pred39Width.constant = 0
        }else{
            count16.isHidden = true
            count17.isHidden = true
            count18.isHidden = true
            count19.isHidden = true
            count16Width.constant = 0
            count17Width.constant = 0
            count18Width.constant = 0
            count19Width.constant = 0
            
            pred16.isHidden = true
            pred17.isHidden = true
            pred18.isHidden = true
            pred19.isHidden = true
            pred16Width.constant = 0
            pred17Width.constant = 0
            pred18Width.constant = 0
            pred19Width.constant = 0
            
            count26.isHidden = true
            count27.isHidden = true
            count28.isHidden = true
            count29.isHidden = true
            count26Width.constant = 0
            count27Width.constant = 0
            count28Width.constant = 0
            count29Width.constant = 0
            
            count36.isHidden = true
            count37.isHidden = true
            count38.isHidden = true
            count39.isHidden = true
            count36Width.constant = 0
            count37Width.constant = 0
            count38Width.constant = 0
            count39Width.constant = 0
            
            pred26.isHidden = true
            pred27.isHidden = true
            pred28.isHidden = true
            pred29.isHidden = true
            pred26Width.constant = 0
            pred27Width.constant = 0
            pred28Width.constant = 0
            pred29Width.constant = 0
            
            pred36.isHidden = true
            pred37.isHidden = true
            pred38.isHidden = true
            pred39.isHidden = true
            pred36Width.constant = 0
            pred37Width.constant = 0
            pred38Width.constant = 0
            pred39Width.constant = 0
            
            countDec1.isHidden = true
            countDec2.isHidden = true
            countDec3.isHidden = true
            predDec1.isHidden = true
            predDec2.isHidden = true
            predDec3.isHidden = true
            newCountersDrob1.isHidden = true
            newCountersDrob2.isHidden = true
            newCountersDrob3.isHidden = true
        }
        if tariffNumber == 0 || tariffNumber == 1{
            tariffOne.isHidden = true
            tarif2View.isHidden = true
            tarif3View.isHidden = true
            tarif2Height.constant = 0
            tarif3Height.constant = 0
        }else if tariffNumber == 2{
            tarif3View.isHidden = true
            tarif3Height.constant = 0
        }
        
        let date = Date()
        let calendar = NSCalendar.current
        let resultDay = calendar.component(.day, from: date as Date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = resultDay < 10 ? "d MMMM yyyy" : "dd MMMM yyyy"
        let currentDate = dateFormatter.string(from: date)
        dateLbl.text = "Показания на \(currentDate) г."
        if lastCheckDate != "" && lastCheckDate != "0"{
            dateLbl.text = "Последняя поверка \(lastCheckDate) г."
        }
        nameLbl.text = counterName
        numberLbl.text = counterNumber + ", л/сч " + ident
        
        if autoSend{
            var predV1 = predValue1.replacingOccurrences(of: ".", with: ",")
            if numberDecimal == 0{
                predV1.forEach{_ in
                    if predV1.contains(","){
                        predV1.removeLast()
                    }
                }
            }
            if predV1.count < 5 && numberDecimal == 0{
                for _ in predV1.count ... 4{
                    predV1 = "0" + predV1
                }
            }else if predV1.count < (6 + numberDecimal) && numberDecimal > 0{
                for _ in predV1.count ... (5 + numberDecimal){
                    predV1 = "0" + predV1
                }
            }
            count1.forEach{
                if predV1.first == ","{
                    predV1.removeFirst()
                }
                $0.text = String(predV1.first!)
                predV1.removeFirst()
            }
            var k = count1[0].text
            count1[0].text = count1[4].text
            count1[4].text = k
            k = count1[1].text
            count1[1].text = count1[3].text
            count1[3].text = k
            var predV2 = predValue2.replacingOccurrences(of: ".", with: ",")
            if numberDecimal == 0{
                predV2.forEach{_ in
                    if predV2.contains(","){
                        predV2.removeLast()
                    }
                }
            }
            if predV2.count < 5 && numberDecimal == 0{
                for _ in predV2.count ... 4{
                    predV2 = "0" + predV2
                }
            }else if predV2.count < (6 + numberDecimal) && numberDecimal > 0{
                for _ in predV2.count ... (5 + numberDecimal){
                    predV2 = "0" + predV2
                }
            }
            count2.forEach{
                if predV2.first == ","{
                    predV2.removeFirst()
                }
                $0.text = String(predV2.first!)
                predV2.removeFirst()
            }
            k = count2[0].text
            count2[0].text = count2[4].text
            count2[4].text = k
            k = count2[1].text
            count2[1].text = count2[3].text
            count2[3].text = k
            var predV3 = predValue3.replacingOccurrences(of: ".", with: ",")
            if numberDecimal == 0{
                predV3.forEach{_ in
                    if predV3.contains(","){
                        predV3.removeLast()
                    }
                }
            }
            if predV3.count < 5 && numberDecimal == 0{
                for _ in predV3.count ... 4{
                    predV3 = "0" + predV3
                }
            }else if predV3.count < (6 + numberDecimal) && numberDecimal > 0{
                for _ in predV3.count ... (5 + numberDecimal){
                    predV3 = "0" + predV3
                }
            }
            count3.forEach{
                if predV3.first == ","{
                    predV3.removeFirst()
                }
                $0.text = String(predV3.first!)
                predV3.removeFirst()
            }
            k = count3[0].text
            count3[0].text = count3[4].text
            count3[4].text = k
            k = count3[1].text
            count3[1].text = count3[3].text
            count3[3].text = k
            teckLbl1.text = "Текущие показания"
            teckLbl2.text = "Текущие показания"
            teckLbl3.text = "Текущие показания"
            autoSendLbl.isHidden = false
            sendCount.isHidden = true
            cancelCount.isHidden = true
            predView1.isHidden = true
            predView2.isHidden = true
            predView3.isHidden = true
            pred1Height.constant = 0
            pred2Height.constant = 0
            pred3Height.constant = 0
            predLbl1.isHidden = true
            predLbl2.isHidden = true
            predLbl3.isHidden = true
            newCounters1.isUserInteractionEnabled = false
            newCounters2.isUserInteractionEnabled = false
            newCounters3.isUserInteractionEnabled = false
        }else{
            var predV1 = predValue1.replacingOccurrences(of: ".", with: ",")
            if numberDecimal == 0{
                predV1.forEach{_ in
                    if predV1.contains(","){
                        predV1.removeLast()
                    }
                }
            }
            if predV1.count < 5 && numberDecimal == 0{
                for _ in predV1.count ... 4{
                    predV1 = "0" + predV1
                }
            }else if predV1.count < (6 + numberDecimal) && numberDecimal > 0{
                for _ in predV1.count ... (5 + numberDecimal){
                    predV1 = "0" + predV1
                }
            }
            pred1.forEach{
                if predV1.first == ","{
                    predV1.removeFirst()
                }
                $0.text = String(predV1.first!)
                predV1.removeFirst()
            }
            
            var predV2 = predValue2.replacingOccurrences(of: ".", with: ",")
            if numberDecimal == 0{
                predV2.forEach{_ in
                    if predV2.contains(","){
                        predV2.removeLast()
                    }
                }
            }
            if predV2.count < 5 && numberDecimal == 0{
                for _ in predV2.count ... 4{
                    predV2 = "0" + predV2
                }
            }else if predV2.count < (6 + numberDecimal) && numberDecimal > 0{
                for _ in predV2.count ... (5 + numberDecimal){
                    predV2 = "0" + predV2
                }
            }
            pred2.forEach{
                if predV2.first == ","{
                    predV2.removeFirst()
                }
                $0.text = String(predV2.first!)
                predV2.removeFirst()
            }
            
            var predV3 = predValue3.replacingOccurrences(of: ".", with: ",")
            if numberDecimal == 0{
                predV3.forEach{_ in
                    if predV3.contains(","){
                        predV3.removeLast()
                    }
                }
            }
            if predV3.count < 5 && numberDecimal == 0{
                for _ in predV3.count ... 4{
                    predV3 = "0" + predV3
                }
            }else if predV3.count < (6 + numberDecimal) && numberDecimal > 0{
                for _ in predV3.count ... (5 + numberDecimal){
                    predV3 = "0" + predV3
                }
            }
            pred3.forEach{
                if predV3.first == ","{
                    predV3.removeFirst()
                }
                $0.text = String(predV3.first!)
                predV3.removeFirst()
            }
            autoSendLbl.isHidden = true
            sendCount.isHidden = false
            cancelCount.isHidden = false
            predView1.isHidden = false
            predView2.isHidden = false
            predView3.isHidden = false
            pred1Height.constant = 24
            pred2Height.constant = 24
            pred3Height.constant = 24
        }
        if recheckInter != "" && recheckInter != "0"{
            interLbl.isHidden = false
            interLbl.text = "Межповерочный интервал \(recheckInter) \(getInterYear(str: recheckInter))"
        }else{
            interLbl.isHidden = true
            interLbl.text = ""
        }
        imgCounter.image = UIImage(named: "water")
        if (nameLbl.text!.lowercased().range(of: "гвс") != nil) || (nameLbl.text!.lowercased().range(of: "ф/в") != nil){
            viewImgCounter.backgroundColor = .red
        }
        if (nameLbl.text!.lowercased().range(of: "хвс") != nil) || (nameLbl.text!.lowercased().range(of: "хвc") != nil){
            viewImgCounter.backgroundColor = .blue
        }
        if (nameLbl.text!.lowercased().range(of: "газ") != nil){
            imgCounter.image = UIImage(named: "fire")
            viewImgCounter.backgroundColor = .yellow
        }
        if (nameLbl.text!.lowercased().range(of: "тепло") != nil){
            imgCounter.image = UIImage(named: "fire")
            viewImgCounter.backgroundColor = .red
        }
        if (nameLbl.text!.lowercased().range(of: "элект") != nil) || (nameLbl.text!.contains("кВт")){
            imgCounter.image = UIImage(named: "lamp")
            viewImgCounter.backgroundColor = .yellow
        }
        cancelCount.tintColor = myColors.btnColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        sendCount.tintColor = myColors.btnColor.uiColor()
        backBtn.tintColor = myColors.btnColor.uiColor()
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        
        // Покрасим название тарифов
        tariffOne.textColor = myColors.btnColor.uiColor()
        tariffTwo.textColor = myColors.btnColor.uiColor()
        tariffThree.textColor = myColors.btnColor.uiColor()
        autoSendLbl.textColor = myColors.btnColor.uiColor()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        newCounters1.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        newCounters2.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        newCounters3.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
//
//        newCountersDrob1.addTarget(self, action: #selector(self.textFieldTouch(_:)), for: .editingDidBegin)
        newCountersDrob1.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        newCountersDrob2.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        newCountersDrob3.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        if defaults.bool(forKey: "show_Ad"){
            if defaults.integer(forKey: "ad_Type") == 2{
                let configuration = YMANativeAdLoaderConfiguration(blockID: defaults.string(forKey: "adsCode")!,
                                                                   imageSizes: [kYMANativeImageSizeMedium],
                                                                   loadImagesAutomatically: true)
                self.adLoader = YMANativeAdLoader(configuration: configuration)
                self.adLoader.delegate = self
                loadAd()
            }else if defaults.integer(forKey: "ad_Type") == 3{
                gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
                //                gadBannerView.adUnitID = "ca-app-pub-5483542352686414/5099103340"
                gadBannerView.adUnitID = defaults.string(forKey: "adsCode")
                gadBannerView.rootViewController = self
                addBannerViewToView(gadBannerView)
                //                gadBannerView.delegate = self
                gadBannerView.load(request)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func getInterYear(str: String) -> String{
        if str == "11" || str == "12" || str == "13" || str == "14"{
            return "лет"
        }else if str.last == "1"{
            return "год"
        }else if str.last == "2" || str.last == "3" || str.last == "4"{
            return "года"
        }else{
            return "лет"
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView){
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            let bannerView = bannerView
            let layoutGuide = self.view.safeAreaLayoutGuide
            let constraints = [
                bannerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
                bannerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
                bannerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 2)
            ]
            NSLayoutConstraint.activate(constraints)
        } else {
            let views = ["bannerView" : bannerView]
            let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[bannerView]-(10)-|",
                                                            options: [],
                                                            metrics: nil,
                                                            views: views)
            let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[bannerView]-(10)-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: views)
            self.view.addConstraints(horizontal)
            self.view.addConstraints(vertical)
        }
    }
    
    func loadAd() {
        self.adLoader.loadAd(with: nil)
    }
    
    func didLoadAd(_ ad: YMANativeGenericAd) {
        ad.delegate = self
        self.bannerView?.removeFromSuperview()
        let bannerView = YMANativeBannerView(frame: CGRect.zero)
        bannerView.ad = ad
        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.bannerView = bannerView
        
        if #available(iOS 11.0, *) {
            displayAdAtBottomOfSafeArea();
        } else {
            displayAdAtBottom();
        }
    }
    
    func displayAdAtBottom() {
        let views = ["bannerView" : self.bannerView!]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[bannerView]-(10)-|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[bannerView]-(10)-|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views)
        self.view.addConstraints(horizontal)
        self.view.addConstraints(vertical)
    }
    
    @available(iOS 11.0, *)
    func displayAdAtBottomOfSafeArea() {
        let bannerView = self.bannerView!
        let layoutGuide = self.view.safeAreaLayoutGuide
        let constraints = [
            bannerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            bannerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            bannerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 2)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - YMANativeAdDelegate
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeAppInstallAd) {
        print("Loaded App Install ad")
        didLoadAd(ad)
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeContentAd) {
        print("Loaded Content ad")
        didLoadAd(ad)
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didFailLoadingWithError error: Error) {
        print("Native ad loading error: \(error)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        // Подхватываем показ клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (responseString == "5"){
            UserDefaults.standard.set(true, forKey: "PaymentSucces")
            UserDefaults.standard.synchronize()
        }
        StopIndicator()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            viewTop.constant = keyboardHeight
            if self.view.frame.size.height <= 568{
                viewTop.constant = 0
            }
        }
        //        if self.view.frame.size.height <= 568{
        //            sendBtnTop.constant = 7
        //            cancelBtnTop.constant = 7
        //        }
    }
    // И вниз при исчезновении
    @objc func keyboardWillHide(notification: NSNotification?) {
        viewTop.constant = 0
        //        if self.view.frame.size.height <= 568{
        //            sendBtnTop.constant = 40
        //            cancelBtnTop.constant = 40
        //        }
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func send_count(edLogin: String, edPass: String, uniq_num: String, count1: String, count2: String, count3: String) {
        StartIndicator()
        
        let strNumber: String = uniq_num
        #if isPocket
        var urlPath = Server.SERVER + "AddMeterValueEverydayMode.ashx?"
            + "login=" + edLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&pwd=" + edPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&meterID=" + strNumber.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&val=" + count1.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        #else
        var urlPath = Server.SERVER + "AddMeterValueEverydayMode.ashx?"
            + "login=" + edLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&pwd=" + edPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&meterID=" + strNumber.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&val=" + count1.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            + "&ident=" + self.ident.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        #endif
        if tariffNumber == 2{
            urlPath = urlPath + "&valT2=" + count2.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        }else if tariffNumber == 3{
            urlPath = urlPath + "&valT2=" + count2.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&valT3=" + count3.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        }
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        UserDefaults.standard.set("Ошибка соединения с сервером", forKey: "errorStringSupport")
                                                        UserDefaults.standard.synchronize()
                                                        let alert = UIAlertController(title: "Сервер временно не отвечает", message: "Возможно на устройстве отсутствует интернет или сервер временно не доступен", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { (_) -> Void in }
                                                        let supportAction = UIAlertAction(title: "Написать в техподдержку", style: .default) { (_) -> Void in
                                                            self.performSegue(withIdentifier: "support", sender: self)
                                                        }
                                                        alert.addAction(cancelAction)
                                                        alert.addAction(supportAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                    return
                                                }
                                                
                                                self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(self.responseString)")
                                                
                                                self.choice()
                                                
        })
        
        task.resume()
    }
    
    func choice() {
        if (responseString == "0") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Переданы не все параметры. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Не пройдена авторизация. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "2") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Не найден прибор у пользователя. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "3") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Передача показаний невозможна.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "5") {
            DispatchQueue.main.async(execute: {
                // Успешно - обновим значения в БД
                
                self.StopIndicator()
                let alert = UIAlertController(title: "Успешно", message: "Показания переданы", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: self.responseString as String, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "support" {
            UserDefaults.standard.set(true, forKey: "fromMenu")
            UserDefaults.standard.synchronize()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var cnt: String = textField.text!.replacingOccurrences(of: ".", with: ",")
        var str: String = textField.text!.replacingOccurrences(of: ".", with: ",")
        if numberDecimal == 0{
            cnt = cnt.replacingOccurrences(of: ",", with: "")
            str = str.replacingOccurrences(of: ",", with: "")
        }
        if (newCounters1.text!.count < newCountersDrob1.text!.count || newCounters2.text!.count < newCountersDrob2.text!.count || newCounters3.text!.count < newCountersDrob3.text!.count) && str.count > 0 && !str.contains(",") && (textField == newCountersDrob1 || textField == newCountersDrob2 || textField == newCountersDrob3){
            let l = str.last
            str.removeLast()
            str = str + "," + String(l!)
            textField.text = str
        }
        print(str)
        if str.contains(","){
            var k = 0
            str.forEach{
                if $0 == ","{
                    k += 1
                }
            }
            if str.last == "," && k > 1{
                str.removeLast()
                textField.text = str
            }else if str.last != ","{
                for _ in 0...str.count - 1{
                    if str.first != ","{
                        str.removeFirst()
                    }
                }
                str.removeFirst()
                if str.count < (numberDecimal + 1){
                    for i in 5...(4 + numberDecimal){
                        if textField == newCounters1 || textField == newCountersDrob1{
                            count1[i].text = "0"
                        }else if textField == newCounters2 || textField == newCountersDrob2{
                            count2[i].text = "0"
                        }else if textField == newCounters3 || textField == newCountersDrob3{
                            count3[i].text = "0"
                        }
                    }
                    for i in 5...str.count + 4{
                        if textField == newCounters1 || textField == newCountersDrob1{
                            count1[i].text = String(str.first!)
                        }else if textField == newCounters2 || textField == newCountersDrob2{
                            count2[i].text = String(str.first!)
                        }else if textField == newCounters3 || textField == newCountersDrob3{
                            count3[i].text = String(str.first!)
                        }
                        str.removeFirst()
                    }
                }else if str.count == 0{
                    for i in 5...(5 + numberDecimal){
                        if textField == newCounters1 || textField == newCountersDrob1{
                            count1[i].text = "0"
                        }else if textField == newCounters2 || textField == newCountersDrob2{
                            count2[i].text = "0"
                        }else if textField == newCounters3 || textField == newCountersDrob3{
                            count3[i].text = "0"
                        }
                    }
                }else if str.count > numberDecimal{
                    cnt.removeLast()
                    textField.text = cnt
                }
            }else{
                for i in 5...(4 + numberDecimal){
                    if textField == newCounters1 || textField == newCountersDrob2{
                        count1[i].text = "0"
                    }else if textField == newCounters2 || textField == newCountersDrob2{
                        count2[i].text = "0"
                    }else if textField == newCounters3 || textField == newCountersDrob3{
                        count3[i].text = "0"
                    }
                }
            }
        }else{
            if str.count > 0 && str.count < 6{
                if textField == newCounters1 || textField == newCountersDrob1{
                    count1.forEach{
                        $0.text = "0"
                    }
                }else if textField == newCounters2 || textField == newCountersDrob2{
                    count2.forEach{
                        $0.text = "0"
                    }
                }else if textField == newCounters3 || textField == newCountersDrob3{
                    count3.forEach{
                        $0.text = "0"
                    }
                }
                for i in 0...str.count - 1{
                    if textField == newCounters1 || textField == newCountersDrob1{
                        count1[i].text = String(str.last!)
                        str.removeLast()
                    }else if textField == newCounters2 || textField == newCountersDrob2{
                        count2[i].text = String(str.last!)
                        str.removeLast()
                    }else if textField == newCounters3 || textField == newCountersDrob3{
                        count3[i].text = String(str.last!)
                        str.removeLast()
                    }
                }
            }else if str.count > 5{
                str.removeLast()
                textField.text = str
            }else if str.count == 0{
                if textField == newCounters1 || textField == newCountersDrob1{
                    count1.forEach{
                        $0.text = "0"
                    }
                }else if textField == newCounters2 || textField == newCountersDrob2{
                    count2.forEach{
                        $0.text = "0"
                    }
                }else if textField == newCounters3 || textField == newCountersDrob3{
                    count3.forEach{
                        $0.text = "0"
                    }
                }
            }
        }
        if textField == newCounters1{
            newCountersDrob1.text = newCounters1.text
        }else if textField == newCountersDrob1{
            newCounters1.text = newCountersDrob1.text
        }
        
        if textField == newCounters2{
            newCountersDrob2.text = newCounters2.text
        }else if textField == newCountersDrob2{
            newCounters2.text = newCountersDrob2.text
        }
        
        if textField == newCounters3{
            newCountersDrob3.text = newCounters3.text
        }else if textField == newCountersDrob3{
            newCounters3.text = newCountersDrob3.text
        }
    }
    
    func StartIndicator(){
        self.sendCount.isHidden = true
        self.cancelCount.isHidden = true
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.sendCount.isHidden = false
        self.cancelCount.isHidden = false
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
}
