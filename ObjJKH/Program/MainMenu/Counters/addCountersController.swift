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

class AddCountersController: UIViewController, YMANativeAdDelegate, YMANativeAdLoaderDelegate {
    
    var adLoader: YMANativeAdLoader!
    var bannerView: YMANativeBannerView?
    var gadBannerView: GADBannerView!

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var newCounters: UITextField!
    @IBOutlet weak var sendCount: UIButton!
    @IBOutlet weak var cancelCount: UIButton!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var imgCounter: UIImageView!
    @IBOutlet weak var viewImgCounter: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var sendBtnTop: NSLayoutConstraint!
    @IBOutlet weak var cancelBtnTop: NSLayoutConstraint!
    
    @IBOutlet weak var count1: UITextField!
    @IBOutlet weak var count2: UITextField!
    @IBOutlet weak var count3: UITextField!
    @IBOutlet weak var count4: UITextField!
    @IBOutlet weak var count5: UITextField!
    @IBOutlet weak var count6: UITextField!
    @IBOutlet weak var count7: UITextField!
    @IBOutlet weak var count8: UITextField!
    
    @IBOutlet weak var pred1: UILabel!
    @IBOutlet weak var pred2: UILabel!
    @IBOutlet weak var pred3: UILabel!
    @IBOutlet weak var pred4: UILabel!
    @IBOutlet weak var pred5: UILabel!
    @IBOutlet weak var pred6: UILabel!
    @IBOutlet weak var pred7: UILabel!
    @IBOutlet weak var pred8: UILabel!
    
    
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func sendAction(_ sender: UIButton) {
        var count: String = newCounters.text!
        if count == "" || count == "0"{
            let alert = UIAlertController(title: "", message: "Вы хотите передать нулевые показания?", preferredStyle: .alert)
            let noAction = UIAlertAction(title: "Нет", style: .default) { (_) -> Void in
                
            }
            let yesAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
                self.send_count(edLogin: self.edLogin, edPass: self.edPass, uniq_num: self.metrId, count: "0,00")
            }
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }else
//            if count != "" && count != "0"
            {
            for _ in 1...count.count{
                if count.first == "0"{
                    count.removeFirst()
                }
            }
            if count.replacingOccurrences(of: ".", with: ",").first == ","{
                count = "0" + count
            }
            if count.replacingOccurrences(of: ".", with: ",").last == ","{
                count.removeLast()
            }
            if count == "0"{
                let alert = UIAlertController(title: "Ошибка", message: "Введите показания", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
//            print(count.replacingOccurrences(of: ".", with: ","))
            self.send_count(edLogin: edLogin, edPass: edPass, uniq_num: metrId, count: count.replacingOccurrences(of: ".", with: ","))
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
    private var count:[UITextField] = []
    private var pred:[UILabel] = []
    
    public var metrId = ""
    public var counterName = ""
    public var counterNumber = ""
    public var ident = ""
    public var predValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.StopIndicator()
        let defaults     = UserDefaults.standard
        edLogin          = defaults.string(forKey: "login")!
        edPass           = defaults.string(forKey: "pass")!
        count.append(count5)
        count.append(count4)
        count.append(count3)
        count.append(count2)
        count.append(count1)
        count.append(count6)
        count.append(count7)
        count.append(count8)
        
        pred.append(pred1)
        pred.append(pred2)
        pred.append(pred3)
        pred.append(pred4)
        pred.append(pred5)
        pred.append(pred6)
        pred.append(pred7)
        pred.append(pred8)
        let date = Date()
        let calendar = NSCalendar.current
        let resultDay = calendar.component(.day, from: date as Date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = resultDay < 10 ? "d MMMM yyyy" : "dd MMMM yyyy"
        let currentDate = dateFormatter.string(from: date)
        dateLbl.text = "Показания на \(currentDate) г."
        nameLbl.text = counterName
        numberLbl.text = counterNumber + ", л/сч " + ident
        var predV = predValue.replacingOccurrences(of: ".", with: ",")
        if predV.count < 9{
            for _ in predV.count ... 8{
                predV = "0" + predV
            }
        }
        pred.forEach{
            if predV.first == ","{
                predV.removeFirst()
            }
            $0.text = String(predV.first!)
            predV.removeFirst()
        }
        imgCounter.image = UIImage(named: "water")
        if (nameLbl.text!.lowercased().range(of: "гвс") != nil){
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
        if (nameLbl.text!.lowercased().range(of: "элект") != nil){
            imgCounter.image = UIImage(named: "lamp")
            viewImgCounter.backgroundColor = .yellow
        }
        cancelCount.tintColor = myColors.btnColor.uiColor()
        indicator.color = myColors.indicatorColor.uiColor()
        support.setImageColor(color: myColors.btnColor.uiColor())
        sendCount.tintColor = myColors.btnColor.uiColor()
        backBtn.tintColor = myColors.btnColor.uiColor()
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        newCounters.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        if defaults.bool(forKey: "show_Ad"){
            if defaults.integer(forKey: "ad_Type") == 2{
                let configuration = YMANativeAdLoaderConfiguration(blockID: "R-M-393573-1",
                                                                   imageSizes: [kYMANativeImageSizeMedium],
                                                                   loadImagesAutomatically: true)
                self.adLoader = YMANativeAdLoader(configuration: configuration)
                self.adLoader.delegate = self
                loadAd()
            }else if defaults.integer(forKey: "ad_Type") == 3{
                gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
                gadBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
                gadBannerView.rootViewController = self
                addBannerViewToView(gadBannerView)
                gadBannerView.load(GADRequest())
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView){
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
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
        // Подхватываем показ клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            viewTop.constant = keyboardHeight
            if self.view.frame.size.height <= 568{
                viewTop.constant = 0
            }
        }
        if self.view.frame.size.height <= 568{
            sendBtnTop.constant = 7
            cancelBtnTop.constant = 7
        }
    }
    // И вниз при исчезновении
    @objc func keyboardWillHide(notification: NSNotification?) {
        viewTop.constant = 0
        if self.view.frame.size.height <= 568{
            sendBtnTop.constant = 40
            cancelBtnTop.constant = 40
        }
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func send_count(edLogin: String, edPass: String, uniq_num: String, count: String) {
        if (count != "") {
            StartIndicator()
            
            let strNumber: String = uniq_num
            #if isPocket
            let urlPath = Server.SERVER + "AddMeterValueEverydayMode.ashx?"
                + "login=" + edLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&pwd=" + edPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&meterID=" + strNumber.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&val=" + count.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            #else
            let urlPath = Server.SERVER + "AddMeterValueEverydayMode.ashx?"
                + "login=" + edLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&pwd=" + edPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&meterID=" + strNumber.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&val=" + count.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
                + "&ident=" + self.ident.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            #endif
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var cnt: String = textField.text!.replacingOccurrences(of: ".", with: ",")
        var str: String = textField.text!.replacingOccurrences(of: ".", with: ",")
        if str.contains(","){
            if str.last != ","{
                for _ in 0...str.count - 1{
                    if str.first != ","{
                        str.removeFirst()
                    }
                }
                str.removeFirst()
                if str.count < 4{
                    for i in 5...7{
                        count[i].text = "0"
                    }
                    for i in 5...str.count + 4{
                        count[i].text = String(str.first!)
                        str.removeFirst()
                    }
                }else if str.count == 0{
                    for i in 5...7{
                        count[i].text = "0"
                    }
                }else if str.count > 3{
                    cnt.removeLast()
                    textField.text = cnt
                }
            }else{
                for i in 5...7{
                    count[i].text = "0"
                }
            }
        }else{
            if str.count > 0 && str.count < 6{
                count.forEach{
                    $0.text = "0"
                }
                for i in 0...str.count - 1{
                    count[i].text = String(str.last!)
                    str.removeLast()
                }
            }else if str.count > 5{
                str.removeLast()
                textField.text = str
            }else if str.count == 0{
                count.forEach{
                    $0.text = "0"
                }
            }
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
