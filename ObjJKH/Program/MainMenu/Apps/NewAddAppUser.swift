//
//  NewAddAppUser.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 13/06/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyXMLParser
import Photos
import Crashlytics

protocol NewAddAppDelegate : class {
    func newAddAppDone(addApp: NewAddAppUser)
}
protocol DelFileAppCellDelegate: class {
    func delFileLs(ident: Int, name: String)
}

class NewAddAppUser: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DelFileAppCellDelegate {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBAction func back_btn(_ sender: UIBarButtonItem) {
        if fromMenu{
            navigationController?.popViewController(animated: true)
        }else{
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    public var fromMenu = false
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    
    @IBOutlet weak var lsTextView: UITextField!
    @IBOutlet weak var lsImg: UIImageView!
    @IBOutlet weak var lsTable: UITableView!
    @IBOutlet weak var lsTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var typeTextView: UITextField!
    @IBOutlet weak var typeImg: UIImageView!
    @IBOutlet weak var typeTable: UITableView!
    @IBOutlet weak var typeTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var descHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addFileImg: UIImageView!
    @IBOutlet weak var addFileText: UILabel!
    
    @IBOutlet weak var fileTable: UITableView!
    @IBOutlet weak var fileTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addAppBtn: UIButton!
    @IBAction func addAppAction(_ sender: UIButton) {
        
        self.StartIndicator()
        
        let txtLogin: String = edLogin.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let txtPass: String  = edPass.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let txtText: String  = descText.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
        var itsOk: Bool = true
        if (txtText == "") {
            itsOk = false
        }
        if (descText.text! == "Описание...") || lsTextView.text == "" || typeTextView.text == ""{
            itsOk = false
        }
        if (!itsOk) {
            self.StopIndicator()
            var textError: String = "Не заполнены параметры:"
            var firstPar: Bool = true
            if (txtText == "") {
                if (firstPar) {
                    textError = textError + " текст,"
                    firstPar = false
                }
            }
            if (descText.text! == "Описание...") {
                textError = textError + " текст,"
            }
            if (lsTextView.text == "") {
                textError = textError + " лиц. счет,"
            }
            if (typeTextView.text == "") {
                textError = textError + " тип заявки,"
            }
            if textError.last == ","{
                textError.removeLast()
            }
            let alert = UIAlertController(title: "Ошибка", message: textError, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = false
            }
            let urlPath = Server.SERVER + Server.ADD_APP +
                "ident=" + txtLogin +
                "&pwd=" + txtPass +
                "&name=" + txtText +
                "&text=" + txtText +
                "&type=" + String(self.selectType + 1) +
                "&priority=" + "2" + "&phonenum=" + txtLogin
            
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
    }
    
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
            if self.images.count != 0{
//                self.sendEmailFile()
            }
            DispatchQueue.main.async(execute: {
                
                // все ок - запишем заявку в БД (необходимо получить и записать авт. комментарий в БД
                // Запишем заявку в БД
                let db = DB()
                db.add_app(id: 1, number: self.responseString, text: self.descText.text!, tema: self.descText.text!, date: self.date_teck()!, adress: "", flat: "", phone: "", owner: self.name_account, is_close: 1, is_read: 1, is_answered: 1, type_app: String(self.selectType + 1), serverStatus: "новая заявка")
                db.getComByID(login: self.edLogin, pass: self.edPass, number: self.responseString)
                
                self.StopIndicator()
                
                let alert = UIAlertController(title: "Успешно", message: "Создана заявка №" + self.responseString, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    if self.delegate != nil {
                        self.delegate?.newAddAppDone(addApp: self)
                    }
                    if self.fromMenu{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            })
        }
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
        }
    }
    
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
                                                        self.view.isUserInteractionEnabled = true
                                                    })
                                                    return
                                                }
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                print("responseString = \(responseString)")
                                                
        })
        task.resume()
    }
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        images.append(info[UIImagePickerControllerOriginalImage] as? UIImage)
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset {
                let assetResources = PHAssetResource.assetResources(for: asset)
                fileList.append(assetResources.first!.originalFilename)
                print("FileName: ", assetResources.first!.originalFilename)
            }else{
                if fileList.count == 0{
                    fileList.append("image1.png")
                }else{
                    fileList.append("image" + String(fileList.count + 1) + ".png")
                }
            }
        } else {
            if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                let asset = result.firstObject
                fileList.append(asset?.value(forKey: "filename") as! String)
                print("FileName: ", asset?.value(forKey: "filename") as! String)
            }else{
                if fileList.count == 0{
                    fileList.append("image1.png")
                }else{
                    fileList.append("image" + String(fileList.count + 1) + ".png")
                }
            }
        }
        DispatchQueue.main.async{
            self.fileTable.reloadData()
        }        
        dismiss(animated: true, completion: nil)
    }
    
    var responseString = ""
    weak var delegate: NewAddAppDelegate?
    var images: [UIImage?] = []
    private var appLS:[String] = []
    private var appTypes:[String] = []
    private var fileList:[String] = []
    var edLogin = ""
    var edPass = ""
    var id_author = ""
    var name_account = ""
    var id_account = ""
    var appText = "Описание..."
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("NewAddAppUser", forKey: "last_UI_action")
        self.StopIndicator()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = myColors.btnColor.uiColor()
        let defaults = UserDefaults.standard
        edLogin = defaults.string(forKey: "login")!
        edPass = defaults.string(forKey: "pass")!
        // получим id текущего аккаунта
        id_author    = defaults.string(forKey: "id_account")!
        name_account = defaults.string(forKey: "name")!
        id_account   = defaults.string(forKey: "id_account")!
        
        lsTable.delegate = self
        lsTable.dataSource = self
        typeTable.delegate = self
        typeTable.dataSource = self
        fileTable.delegate = self
        fileTable.dataSource = self
        
        lsTextView.delegate = self
        typeTextView.delegate = self
        getTypes()
        getLSs()
        
        descText.delegate = self
        descText.text = appText
        descText.textColor = UIColor.lightGray
        
        addAppBtn.backgroundColor = myColors.btnColor.uiColor()
        backBtn.tintColor = .white
        indicator.color = myColors.indicatorColor.uiColor()
        lsImg.setImageColor(color: myColors.indicatorColor.uiColor())
        typeImg.setImageColor(color: myColors.indicatorColor.uiColor())
        addFileImg.setImageColor(color: myColors.indicatorColor.uiColor())
        
        lsTextView.addTarget(self, action: #selector(lsTapped), for: .touchDown)
        typeTextView.addTarget(self, action: #selector(typeTapped), for: .touchDown)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        if UserDefaults.standard.bool(forKey: "NewMain"){
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = myColors.btnColor.uiColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func lsTapped(textField: UITextField) {
        showLS = true
        DispatchQueue.main.async{
            self.lsImg.image = UIImage(named: "arrows_up")
            self.lsImg.setImageColor(color: myColors.indicatorColor.uiColor())
            self.lsTable.reloadData()
        }

    }
    @objc func typeTapped(textField: UITextField) {
        showTypes = true
        DispatchQueue.main.async{
            self.typeImg.image = UIImage(named: "arrows_up")
            self.typeImg.setImageColor(color: myColors.indicatorColor.uiColor())
            self.typeTable.reloadData()
        }

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    func date_teck() -> (String)? {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
        
    }
    
    private func getLSs() {
        let defaults = UserDefaults.standard
        let str_ls = defaults.string(forKey: "str_ls")
        let str_ls_arr = str_ls?.components(separatedBy: ",")
        str_ls_arr?.forEach{
            self.appLS.append($0)
        }
        DispatchQueue.main.async{
            if self.appLS.count == 1{
                self.lsTextView.text = self.appLS[0]
                self.showLS = false
                self.lsImg.image = UIImage(named: "arrows_down")
                self.lsImg.setImageColor(color: myColors.indicatorColor.uiColor())
            }
            self.lsTable.reloadData()
        }
    }
    
    private func getTypes() {
        var request = URLRequest(url: URL(string: Server.SERVER + Server.GET_REQUEST_TYPES + "table=Support_RequestTypes")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, error, responce in
            
            guard data != nil else { return }
            
            let xml = XML.parse(data!)
            xml["Table"]["Row"].forEach {
                self.appTypes.append($0.attributes["name"] ?? "")
            }
            #if DEBUG
            print(String(data: data!, encoding: .utf8) ?? "")
            #endif
            DispatchQueue.main.async{
                self.typeTable.reloadData()
            }
            }.resume()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descText.textColor == UIColor.lightGray {
            descText.text = nil
            descText.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descText.text.isEmpty {
            descText.text = "Описание..."
            descText.textColor = UIColor.lightGray
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            viewTop.constant = keyboardHeight + 16
        }
    }
    // И вниз при исчезновении
    @objc func keyboardWillHide(notification: NSNotification?) {
        viewTop.constant = 16
    }
    
    var showLS = false
    var showTypes = false
    var showFiles = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 0.5
        tableView.layer.cornerRadius = 7.0
        self.lsTableHeight.constant = 0
        self.typeTableHeight.constant = 0
        self.fileTableHeight.constant = 0
        if showLS{
            self.lsTableHeight.constant = 400
            if tableView == self.lsTable {
                count = appLS.count
                print("ЛС: ", count)
            }
        }
        if showTypes{
            self.typeTableHeight.constant = 400
            if tableView == self.typeTable {
                count =  appTypes.count
                print("Типы: ", count)
            }
        }
        self.fileTableHeight.constant = 400
        if tableView == self.fileTable {
            count =  fileList.count
            print("Файлы: ", count)
        }
        DispatchQueue.main.async {
            var height1: CGFloat = 0
            for cell in self.lsTable.visibleCells {
                height1 += cell.bounds.height
            }
            self.lsTableHeight.constant = height1
            
            var height2: CGFloat = 0
            for cell in self.typeTable.visibleCells {
                height2 += cell.bounds.height
            }
            self.typeTableHeight.constant = height2
            
            let height3: CGFloat = CGFloat(33 * self.fileList.count)
//            for cell in self.fileTable.visibleCells {
//                height3 += cell.bounds.height
//            }
            self.fileTableHeight.constant = height3
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.lsTable {
            let cell = self.lsTable.dequeueReusableCell(withIdentifier: "lsAddAppCell") as! LsAddAppsCell
            cell.textLS.text = appLS[indexPath.row]
            return cell
        }else if tableView == self.typeTable {
            let cell = self.typeTable.dequeueReusableCell(withIdentifier: "typeAddAppCell") as! TypeAddAppsCell
            cell.textType.text = appTypes[indexPath.row]
            return cell
        }else{
            let cell = self.fileTable.dequeueReusableCell(withIdentifier: "fileAddAppCell") as! FileAddAppsCell
            cell.textFile.text = fileList[indexPath.row]
            cell.iconFile.setImageColor(color: myColors.indicatorColor.uiColor())
            cell.ident = indexPath.row
            cell.delegate2 = self
            return cell
        }
    }
    var selectLS = -1
    var selectType = -1
    var selectFile = -1
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        if tableView == self.lsTable {
            selectLS = indexPath.row
            lsTextView.text = appLS[selectLS]
            showLS = false
            lsImg.image = UIImage(named: "arrows_down")
            lsImg.setImageColor(color: myColors.indicatorColor.uiColor())
            lsTable.reloadData()
            print("1")
        }else if tableView == self.typeTable {
            selectType = indexPath.row
            typeTextView.text = appTypes[selectType]
            showTypes = false
            typeImg.image = UIImage(named: "arrows_down")
            typeImg.setImageColor(color: myColors.indicatorColor.uiColor())
            typeTable.reloadData()
            print("2")
        }else{
            selectFile = indexPath.row
        }
    }
    
    private func uploadPhoto(_ img: UIImage) {
        
        let group = DispatchGroup()
        let reqID = responseString.stringByAddingPercentEncodingForRFC3986() ?? ""
        //let id = UserDefaults.standard.string(forKey: "id_account")?.stringByAddingPercentEncodingForRFC3986() ?? ""
        let id = UserDefaults.standard.string(forKey: "phone")?.stringByAddingPercentEncodingForRFC3986() ?? ""
        
        print(reqID)
        
        group.enter()
        let uid = UUID().uuidString
        Alamofire.upload(multipartFormData: { multipartFromdata in
            multipartFromdata.append(UIImageJPEGRepresentation(img, 0.5)!, withName: uid, fileName: "\(uid).jpg", mimeType: "image/jpeg")
        }, to: Server.SERVER + Server.ADD_FILE + "reqID=" + reqID + "&phone=" + id) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
//                    print("Upload Value: ")
//                    print(response.result.value!)
                    group.leave()
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        group.wait()
        return
    }
    
    func heightForTitle(text:String, width:CGFloat) -> CGFloat{
        let textView:UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        textView.text = text
        textView.sizeToFit()
        
        return textView.frame.height
    }
    
    func StartIndicator() {
        self.addAppBtn.isEnabled = false
        self.addAppBtn.isHidden  = true
        
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator() {
        self.addAppBtn.isEnabled = true
        self.addAppBtn.isHidden  = false
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    func delFileLs(ident: Int, name: String) {
        let alert = UIAlertController(title: "", message: "Вы действительно хотите удалить файл " + name + " ?", preferredStyle: .alert)
        let delAction = UIAlertAction(title: "Да", style: .destructive) { (_) -> Void in
            self.fileList.remove(at: ident)
            self.images.remove(at: ident)
            print(self.images.count)
            self.fileTable.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Нет", style: .default) { (_) -> Void in }
        alert.addAction(cancelAction)
        alert.addAction(delAction)
        self.present(alert, animated: true, completion: nil)
    }

}

class DashedBorderView: UIView {
    
    let _border = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        _border.strokeColor = UIColor.lightGray.cgColor
        _border.fillColor = nil
        _border.lineDashPattern = [4, 4]
        self.layer.addSublayer(_border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:8).cgPath
        _border.frame = self.bounds
    }
}
