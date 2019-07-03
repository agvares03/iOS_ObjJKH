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
    var request = GADRequest()

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var newCounters1: UITextField!
    @IBOutlet weak var newCounters2: UITextField!
    @IBOutlet weak var newCounters3: UITextField!
    @IBOutlet weak var sendCount: UIButton!
    @IBOutlet weak var cancelCount: UIButton!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var imgCounter: UIImageView!
    @IBOutlet weak var viewImgCounter: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var tarif2Height: NSLayoutConstraint!
    @IBOutlet weak var tarif3Height: NSLayoutConstraint!
    @IBOutlet weak var tarif2View: UIView!
    @IBOutlet weak var tarif3View: UIView!
    @IBOutlet weak var tariffOne: UILabel!
    
    @IBOutlet weak var count11: UITextField!
    @IBOutlet weak var count12: UITextField!
    @IBOutlet weak var count13: UITextField!
    @IBOutlet weak var count14: UITextField!
    @IBOutlet weak var count15: UITextField!
    @IBOutlet weak var count16: UITextField!
    @IBOutlet weak var count17: UITextField!
    @IBOutlet weak var count18: UITextField!
    
    @IBOutlet weak var count21: UITextField!
    @IBOutlet weak var count22: UITextField!
    @IBOutlet weak var count23: UITextField!
    @IBOutlet weak var count24: UITextField!
    @IBOutlet weak var count25: UITextField!
    @IBOutlet weak var count26: UITextField!
    @IBOutlet weak var count27: UITextField!
    @IBOutlet weak var count28: UITextField!
    
    @IBOutlet weak var count31: UITextField!
    @IBOutlet weak var count32: UITextField!
    @IBOutlet weak var count33: UITextField!
    @IBOutlet weak var count34: UITextField!
    @IBOutlet weak var count35: UITextField!
    @IBOutlet weak var count36: UITextField!
    @IBOutlet weak var count37: UITextField!
    @IBOutlet weak var count38: UITextField!
    
    @IBOutlet weak var pred11: UILabel!
    @IBOutlet weak var pred12: UILabel!
    @IBOutlet weak var pred13: UILabel!
    @IBOutlet weak var pred14: UILabel!
    @IBOutlet weak var pred15: UILabel!
    @IBOutlet weak var pred16: UILabel!
    @IBOutlet weak var pred17: UILabel!
    @IBOutlet weak var pred18: UILabel!
    
    @IBOutlet weak var pred21: UILabel!
    @IBOutlet weak var pred22: UILabel!
    @IBOutlet weak var pred23: UILabel!
    @IBOutlet weak var pred24: UILabel!
    @IBOutlet weak var pred25: UILabel!
    @IBOutlet weak var pred26: UILabel!
    @IBOutlet weak var pred27: UILabel!
    @IBOutlet weak var pred28: UILabel!
    
    @IBOutlet weak var pred31: UILabel!
    @IBOutlet weak var pred32: UILabel!
    @IBOutlet weak var pred33: UILabel!
    @IBOutlet weak var pred34: UILabel!
    @IBOutlet weak var pred35: UILabel!
    @IBOutlet weak var pred36: UILabel!
    @IBOutlet weak var pred37: UILabel!
    @IBOutlet weak var pred38: UILabel!
    
    
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
        var count1: String = newCounters1.text!
        var count2: String = newCounters2.text!
        var count3: String = newCounters3.text!
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
    
    public var metrId = ""
    public var counterName = ""
    public var counterNumber = ""
    public var ident = ""
    public var predValue1 = ""
    public var predValue2 = ""
    public var predValue3 = ""
    public var tariffNumber = 3
    
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
        count1.append(count16)
        count1.append(count17)
        count1.append(count18)
        
        pred1.append(pred11)
        pred1.append(pred12)
        pred1.append(pred13)
        pred1.append(pred14)
        pred1.append(pred15)
        pred1.append(pred16)
        pred1.append(pred17)
        pred1.append(pred18)
        
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
        
        count2.append(count25)
        count2.append(count24)
        count2.append(count23)
        count2.append(count22)
        count2.append(count21)
        count2.append(count26)
        count2.append(count27)
        count2.append(count28)
        
        count3.append(count35)
        count3.append(count34)
        count3.append(count33)
        count3.append(count32)
        count3.append(count31)
        count3.append(count36)
        count3.append(count37)
        count3.append(count38)
        
        pred2.append(pred21)
        pred2.append(pred22)
        pred2.append(pred23)
        pred2.append(pred24)
        pred2.append(pred25)
        pred2.append(pred26)
        pred2.append(pred27)
        pred2.append(pred28)
        
        pred3.append(pred31)
        pred3.append(pred32)
        pred3.append(pred33)
        pred3.append(pred34)
        pred3.append(pred35)
        pred3.append(pred36)
        pred3.append(pred37)
        pred3.append(pred38)
        let date = Date()
        let calendar = NSCalendar.current
        let resultDay = calendar.component(.day, from: date as Date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = resultDay < 10 ? "d MMMM yyyy" : "dd MMMM yyyy"
        let currentDate = dateFormatter.string(from: date)
        dateLbl.text = "Показания на \(currentDate) г."
        nameLbl.text = counterName
        numberLbl.text = counterNumber + ", л/сч " + ident
        var predV1 = predValue1.replacingOccurrences(of: ".", with: ",")
        if predV1.count < 9{
            for _ in predV1.count ... 8{
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
        if predV2.count < 9{
            for _ in predV2.count ... 8{
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
        if predV3.count < 9{
            for _ in predV3.count ... 8{
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        newCounters1.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        newCounters2.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        newCounters3.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
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
                urlPath = urlPath + "&val2=" + count2.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            }else if tariffNumber == 3{
                urlPath = urlPath + "&val2=" + count2.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&val3=" + count3.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
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
                        if textField == newCounters1{
                            count1[i].text = "0"
                        }else if textField == newCounters2{
                            count2[i].text = "0"
                        }else if textField == newCounters3{
                            count3[i].text = "0"
                        }
                    }
                    for i in 5...str.count + 4{
                        if textField == newCounters1{
                            count1[i].text = String(str.first!)
                        }else if textField == newCounters2{
                            count2[i].text = String(str.first!)
                        }else if textField == newCounters3{
                            count3[i].text = String(str.first!)
                        }
                        str.removeFirst()
                    }
                }else if str.count == 0{
                    for i in 5...7{
                        if textField == newCounters1{
                            count1[i].text = "0"
                        }else if textField == newCounters2{
                            count2[i].text = "0"
                        }else if textField == newCounters3{
                            count3[i].text = "0"
                        }
                    }
                }else if str.count > 3{
                    cnt.removeLast()
                    textField.text = cnt
                }
            }else{
                for i in 5...7{
                    if textField == newCounters1{
                        count1[i].text = "0"
                    }else if textField == newCounters2{
                        count2[i].text = "0"
                    }else if textField == newCounters3{
                        count3[i].text = "0"
                    }
                }
            }
        }else{
            if str.count > 0 && str.count < 6{
                if textField == newCounters1{
                    count1.forEach{
                        $0.text = "0"
                    }
                }else if textField == newCounters2{
                    count2.forEach{
                        $0.text = "0"
                    }
                }else if textField == newCounters3{
                    count3.forEach{
                        $0.text = "0"
                    }
                }
                for i in 0...str.count - 1{
                    if textField == newCounters1{
                        count1[i].text = String(str.last!)
                    }else if textField == newCounters2{
                        count2[i].text = String(str.last!)
                    }else if textField == newCounters3{
                        count3[i].text = String(str.last!)
                    }
                    str.removeLast()
                }
            }else if str.count > 5{
                str.removeLast()
                textField.text = str
            }else if str.count == 0{
                if textField == newCounters1{
                    count1.forEach{
                        $0.text = "0"
                    }
                }else if textField == newCounters2{
                    count2.forEach{
                        $0.text = "0"
                    }
                }else if textField == newCounters3{
                    count3.forEach{
                        $0.text = "0"
                    }
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
