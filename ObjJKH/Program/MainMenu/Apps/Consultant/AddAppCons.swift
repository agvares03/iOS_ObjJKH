//
//  AddAppCons.swift
//  ObjJKH
//
//  Created by Роман Тузин on 05.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyXMLParser

protocol AddAppConsDelegate : class {
    func addAppDoneCons(addApp: AddAppCons)
}

class AddAppCons: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    var responseString: String = ""
    // id аккаунта текущего
    var id_author: String = ""
    var name_account: String = ""
    var id_account: String = ""
    var id_app: String = ""
    var images: [UIImage?] = [] {
        didSet {
            drawImages()
        }
    }
    weak var delegate: AddAppConsDelegate?
    
    @IBOutlet weak var edLS: UITextField!
    @IBOutlet weak var typeCell: UITableViewCell!
    @IBOutlet weak var text_App: UITextView!
    @IBOutlet weak var imgScroll: UIScrollView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var edPhone: UITextField!
    
    @IBAction func attachFile(_ sender: UIButton) {
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default, handler: { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        action.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        action.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in }))
        present(action, animated: true, completion: nil)
    }
    
    @IBAction func AddApp(_ sender: UIButton) {
        self.StartIndicator()
        
//        let txtLogin: String = edLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
//        let txtPass: String  = edPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let txtText: String  = text_App.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
        var itsOk: Bool = true
        if (txtText == "") {
            itsOk = false
        }
        if ((self.appType + 1) <= 0) {
            itsOk = false
        }
        if (self.edLS.text == "") {
            itsOk = false
        }
        if (!itsOk) {
            self.StopIndicator()
            var textError: String = "Не заполнены параметры: "
            var firstPar: Bool = true
            if (txtText == "") {
                if (firstPar) {
                    textError = textError + "текст"
                    firstPar = false
                }
            }
            if ((self.appType + 1) <= 0) {
                if (firstPar) {
                    textError = textError + "тип"
                    firstPar = false
                } else {
                    textError = textError + ", тип"
                }
            }
            if (self.edLS.text == "") {
                if (firstPar) {
                    textError = textError + "лиц. счет"
                    firstPar = false
                } else {
                    textError = textError + ", лиц. счет"
                }
            }
            let alert = UIAlertController(title: "Ошибка", message: textError, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let ident = self.edLS.text!
            var urlPath = Server.SERVER + Server.ADD_APP +
                "ident=" + ident +
                "&name=" + txtText +
                "&text=" + txtText +
                "&type=" + String(self.appType + 1) +
                "&priority=2"
            let phone = self.edPhone.text!
            if phone != ""{
                urlPath = urlPath + "&phonenum=" + phone
            }
            
            let url: NSURL = NSURL(string: urlPath)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            
            //            print(request.url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: {
                                                    data, response, error in
                                                    
                                                    if error != nil {
                                                        DispatchQueue.main.async(execute: {
                                                            self.StopIndicator()
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
    
    var edLogin: String = ""
    var edPass: String = ""
    
    var appTypes = [String]()
    
    var appType = -1
    var appTypeStr = ""
    var appTheme = ""
    var appText = "Описание..."
    
    private let typesGroup = DispatchGroup()
    
    func choice() {
        if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Не переданы обязательные параметры", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "2") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "-2") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Проверьте правильность лицевого счета", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "xxx") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Не удалось. Попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            self.images.forEach {
                if let img = $0 {
                    self.uploadPhoto(img)
                }
            }
            DispatchQueue.main.async(execute: {
                
                // все ок - запишем заявку в БД (необходимо получить и записать авт. комментарий в БД
                // Запишем заявку в БД
                let db = DB()
                db.add_app(id: 1, number: self.responseString, text: self.text_App.text!, tema: self.text_App.text!, date: self.date_teck()!, adress: "", flat: "", phone: "", owner: self.name_account, is_close: 1, is_read: 1, is_answered: 1, type_app: String(self.appType + 1), serverStatus: "новая заявка")
                db.getComByID(login: self.edLogin, pass: self.edPass, number: self.responseString)
                
                self.StopIndicator()
                
                let alert = UIAlertController(title: "Успешно", message: "Создана заявка №" + self.responseString, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    if self.delegate != nil {
                        self.delegate?.addAppDoneCons(addApp: self)
                    }
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "NewMain"){
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.StopIndicator()
        indicator.stopAnimating()
        indicator.isHidden = true
        let defaults = UserDefaults.standard
        edLogin = defaults.string(forKey: "login_cons")!
        edPass = defaults.string(forKey: "pass_cons")!
        // получим id текущего аккаунта
        id_author    = defaults.string(forKey: "id_account")!
        name_account = defaults.string(forKey: "name")!
        id_account   = defaults.string(forKey: "id_account")!
        
        getTypes()
        
        typeCell.detailTextLabel?.text = appTypeString()
        
        text_App.delegate = self
        text_App.text = appText
        text_App.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if text_App.textColor == UIColor.lightGray {
            text_App.text = nil
            text_App.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text_App.text.isEmpty {
            text_App.text = "Описание..."
            text_App.textColor = UIColor.lightGray
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.text_App.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func appTypeString() -> String {
        if appType == -1 {
            return "не выбран"
        }
        
        if appType >= 0 && appType < appTypes.count {
            return appTypes[appType]
        }
        
        return ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectType" {
            let selectItemController = (segue.destination as! UINavigationController).viewControllers.first as! SelectItemController
            if appTypes.count == 0 {
                StartIndicator()
                typesGroup.wait()
            }
            selectItemController.strings = appTypes
            selectItemController.selectedIndex = appType
            selectItemController.selectHandler = { selectedIndex in
                self.appType = selectedIndex
                self.typeCell.detailTextLabel?.text = self.appTypeString()
            }
        }
    }
    
    func StartIndicator() {
        DispatchQueue.main.async {
            self.btnAdd.isEnabled = false
            self.btnAdd.isHidden  = true
            
            self.indicator.startAnimating()
            self.indicator.isHidden = false
        }
    }
    
    func StopIndicator() {
        DispatchQueue.main.async {
            self.btnAdd.isEnabled = true
            self.btnAdd.isHidden  = false
            
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
        }
    }
    
    func date_teck() -> (String)? {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
        
    }
    
    private func uploadPhoto(_ img: UIImage) {
        
        let group = DispatchGroup()
        let reqID = responseString.stringByAddingPercentEncodingForRFC3986() ?? ""
        let id = UserDefaults.standard.string(forKey: "id_account")?.stringByAddingPercentEncodingForRFC3986() ?? ""
        
        print(reqID)
        
        group.enter()
        let uid = UUID().uuidString
        Alamofire.upload(multipartFormData: { multipartFromdata in
            multipartFromdata.append(UIImageJPEGRepresentation(img, 0.5)!, withName: uid, fileName: "\(uid).jpg", mimeType: "image/jpeg")
        }, to: Server.SERVER + Server.ADD_FILE + "reqID=" + reqID + "&accID=" + id) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value!)
                    group.leave()
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        group.wait()
        return
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        images.append(info[UIImagePickerControllerOriginalImage] as? UIImage)
        dismiss(animated: true, completion: nil)
    }
    
    private func drawImages() {
        
        imgScroll.isHidden = false
        
        imgScroll.subviews.forEach {
            $0.removeFromSuperview()
        }
        var x = 0.0
        var tag = 0
        
        images.forEach {
            let img = UIImageView(frame: CGRect(x: x, y: 0.0, width: 150.0, height: 150.0))
            img.image = $0
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            img.isUserInteractionEnabled = true
            img.addGestureRecognizer(tap)
            imgScroll.addSubview(img)
            
            let deleteButton = UIButton(frame: CGRect(x: x + 130.0, y: 0.0, width: 20.0, height: 20.0))
            deleteButton.backgroundColor = .white
            deleteButton.layer.cornerRadius = 0.5 * deleteButton.bounds.size.width
            deleteButton.clipsToBounds = true
            deleteButton.tag = tag
            deleteButton.alpha = 0.7
            deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
            imgScroll.addSubview(deleteButton)
            
            let image = UIImageView(frame: CGRect(x: x + 135.0, y: 5.0, width: 10.0, height: 10.0))
            image.image = UIImage(named: "close_ic")
            imgScroll.addSubview(image)
            
            x += 160
            tag += 1
        }
        imgScroll.contentSize = CGSize(width: CGFloat(x), height: imgScroll.frame.size.height)
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        images.remove(at: sender.tag)
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview()
    }
    
    private func getTypes() {
        typesGroup.enter()
        
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_REQUEST_TYPES + "table=Support_RequestTypes")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
            defer {
                self.typesGroup.leave()
                DispatchQueue.main.async {
                    self.StopIndicator()
                }
            }
            
            guard data != nil else { return }
            
            let xml = XML.parse(data!)
            xml["Table"]["Row"].forEach {
                self.appTypes.append($0.attributes["name"] ?? "")
            }
            #if DEBUG
            print(String(data: data!, encoding: .utf8) ?? "")
            #endif
            
            }.resume()
    }

}
