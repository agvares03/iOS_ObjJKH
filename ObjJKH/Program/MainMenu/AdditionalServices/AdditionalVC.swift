//
//  AdditionalVC.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 05/09/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class AdditionalVC: UIViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var urlHeight: NSLayoutConstraint!
    @IBOutlet weak var addAppHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneHeight: NSLayoutConstraint!
    @IBOutlet weak var urlLblHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneLblHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var urlLbl: UILabel!
    @IBOutlet weak var substring: UILabel!
    @IBOutlet weak var urlBtn: UIButton!
    @IBOutlet weak var addAppBtn: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var imgService: UIImageView!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        //        if UserDefaults.standard.bool(forKey: "NewMain"){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func urlBtnPressed(_ sender: UIButton) {
        let url = URL(string: (urlBtn.titleLabel?.text)!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBAction func phoneBtnPressed(_ sender: UIButton) {
        let newPhone = phoneBtn.titleLabel?.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        if let url = URL(string: "tel://" + newPhone!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func addAppPressed(_ sender: UIButton) {
        addAppAction()
    }
    
    public var item: Services?
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let item = item else { return }
        let url:NSURL = NSURL(string: (item.logo)!)!
        let data = try? Data(contentsOf: url as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        stopAnimation()
        name.text = item.name
        substring.text = item.description
        var str:String = item.address!
        if str == ""{
            urlBtn.isHidden = true
            urlHeight.constant = 0
            urlLbl.isHidden = true
            urlLblHeight.constant = 0
        }else{
            if !str.contains("http"){
                str = "http://" + str
            }
            urlBtn.setTitle(str, for: .normal)
        }
        if item.phone == ""{
            phoneBtn.isHidden = true
            phoneHeight.constant = 0
            phoneLbl.isHidden = true
            phoneLblHeight.constant = 0
        }else{
            phoneBtn.setTitle(item.phone, for: .normal)
        }
        imgService.image = UIImage(data: data!)
        if imgService.image == nil{
            imgWidth.constant = 0
        }else{
            imgWidth.constant = view.frame.size.width / 2
        }
        if item.canbeordered == "1" && item.id_requesttype != "" && item.id_account != ""{
            addAppBtn.isHidden = false
            addAppHeight.constant = 40
            addAppBtn.backgroundColor = myColors.btnColor.uiColor()
            loader.color = myColors.btnColor.uiColor()
        }else{
            addAppBtn.isHidden = true
            addAppHeight.constant = 0
        }
        backBtn.tintColor = myColors.btnColor.uiColor()
        // Do any additional setup after loading the view.
    }
    
    var descText:String = ""
    var temaText:String = ""
    var type:String = ""
    var name_account:String = ""
    var id_account:String = ""
    var edLogin:String = ""
    var edPass:String = ""
    
    func addAppAction() {
        self.startAnimation()
        name_account = UserDefaults.standard.string(forKey: "name")!
        id_account   = UserDefaults.standard.string(forKey: "id_account")!
        edLogin      = UserDefaults.standard.string(forKey: "login")!
        edPass       = UserDefaults.standard.string(forKey: "pass")!
        let ident: String = UserDefaults.standard.string(forKey: "login")!.stringByAddingPercentEncodingForRFC3986() ?? ""
        temaText = self.item?.name!.stringByAddingPercentEncodingForRFC3986() ?? ""
        descText = "Ваш заказ принят. В ближайшее время сотрудник свяжется с Вами для уточнения деталей " + (self.item?.name)!
        type = self.item?.id_requesttype!.stringByAddingPercentEncodingForRFC3986() ?? ""
        descText = descText.stringByAddingPercentEncodingForRFC3986() ?? ""
        let consId = self.item?.id_account!.stringByAddingPercentEncodingForRFC3986() ?? ""
        let urlPath = Server.SERVER + Server.ADD_APP +
            "ident=" + ident +
            "&name=" + temaText +
            "&text=" + descText +
            "&type=" + type +
            "&priority=" + "2" +
            "&phonenum=" + ident +
            "&consultantId=" + consId
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        print("RequestURL: ", request.url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        self.stopAnimation()
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
                                                        self.view.isUserInteractionEnabled = true
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
        if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                self.stopAnimation()
                let alert = UIAlertController(title: "Ошибка", message: "Не переданы обязательные параметры", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "2") {
            DispatchQueue.main.async(execute: {
                self.stopAnimation()
                let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
                self.stopAnimation()
                let alert = UIAlertController(title: "Ошибка", message: "Не удалось. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if Int(responseString) == nil || Int(responseString)! < 1{
            DispatchQueue.main.async(execute: {
               self.stopAnimation()
               let alert = UIAlertController(title: "Ошибка", message: "Сервер не отвечает. Попробуйте позже", preferredStyle: .alert)
               let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
               alert.addAction(cancelAction)
               self.present(alert, animated: true, completion: nil)
            })
        } else {
//            if self.images.count != 0{
                self.sendEmailFile()
//            }
            DispatchQueue.main.async(execute: {
                
                // все ок - запишем заявку в БД (необходимо получить и записать авт. комментарий в БД
                // Запишем заявку в БД
                let db = DB()
                db.add_app(id: 1, number: self.responseString, text: self.descText, tema: self.temaText, date: self.date_teck()!, adress: "", flat: "", phone: "", owner: self.name_account, is_close: 1, is_read: 1, is_answered: 1, type_app: self.type, serverStatus: "новая заявка")
                db.getComByID(login: self.edLogin, pass: self.edPass, number: self.responseString)
                
                self.stopAnimation()
                
                let alert = UIAlertController(title: "Успешно", message: "Создана заявка №" + self.responseString, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            })
        }
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func date_teck() -> (String)? {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
        
    }
    
    var responseString = ""
    func sendEmailFile(){
        let reqID = responseString.stringByAddingPercentEncodingForRFC3986() ?? ""
        let urlPath = Server.SERVER + "MobileAPI/SendRequestToMail.ashx?" + "requestId=" + reqID
        
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        print(request)
    
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        self.stopAnimation()
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
                                                        self.view.isUserInteractionEnabled = true
                                                    })
                                                    return
                                                }
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(responseString)")
                                                
        })
        task.resume()
    }
    
    private func startAnimation() {
        loader.isHidden     = false
        addAppBtn.isHidden = true
        loader.startAnimating()
    }
    
    private func stopAnimation() {
        addAppBtn.isHidden = false
        loader.stopAnimating()
        loader.isHidden     = true
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
