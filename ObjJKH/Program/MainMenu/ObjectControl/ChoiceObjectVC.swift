//
//  ChoiceObjectVC.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 31/10/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit
import Photos
import Alamofire

class ChoiceObjectVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public var objectId     = ""
    public var objectName   = ""
    
    @IBOutlet weak var image:       UIImageView!
    @IBOutlet weak var textComm:    UITextView!
    @IBOutlet weak var addFileView: UIView!
    @IBOutlet weak var addFileIcon: UIImageView!
    @IBOutlet weak var back:        UIBarButtonItem!
    @IBOutlet weak var btnNext:     UIButton!
    @IBOutlet weak var indicator:   UIActivityIndicatorView!
    @IBOutlet weak var viewTop:     NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth:  NSLayoutConstraint!
    @IBOutlet weak var delBtn:      UIButton!
    @IBOutlet weak var delIcon:     UIImageView!
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func delImage(_ sender: UIButton) {
        image.image             = nil
        delBtn.isHidden         = true
        delIcon.isHidden        = true
        addFileView.isHidden    = false
    }
    
    @IBAction func goAction(_ sender: UIButton) {
        if self.image.image == nil{
            DispatchQueue.main.async{
                let alert = UIAlertController(title: "Ошибка", message: "Прикрепите фото", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in}
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }else if textComm.textColor == .lightGray{
            DispatchQueue.main.async{
                let alert = UIAlertController(title: "Ошибка", message: "Добавте комментарий", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in}
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            self.view.endEditing(true)
            DispatchQueue.main.async {
                self.indicator.isHidden = false
                self.indicator.startAnimating()
                self.btnNext.isHidden = true
                self.sendResult()
            }
        }
    }
    
    private func sendResult(){
        // the image in UIImage type
        guard let image = self.image.image else { return  }

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        let filename = "image" + boundary + ".png"

        let fieldName = "reqtype"
        let fieldValue = "fileupload"

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // Set the URLRequest to POST and to the specified URL
        let urlPath = Server.SERVER + "MobileAPI/ControlObjects/SendControlResult.ashx?objectId=" + objectId.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&text=" + textComm.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let url: NSURL = NSURL(string: urlPath)!
        var urlRequest = URLRequest(url: url as URL)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the reqtype field and its value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue)".data(using: .utf8)!)

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(UIImagePNGRepresentation(image)!)

        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("uploaded to: \(responseString)")
                if responseString == "ok"{
                    DispatchQueue.main.async{
                        let alert = UIAlertController(title: "Успешно!", message: "Результаты осмотра приняты", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                            self.indicator.isHidden = true
                            self.indicator.stopAnimating()
                            self.btnNext.isHidden = false
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }).resume()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title              = objectName
        back.tintColor          = myColors.btnColor.uiColor()
        indicator.color         = myColors.btnColor.uiColor()
        btnNext.backgroundColor = myColors.btnColor.uiColor()
        addFileIcon.setImageColor(color: myColors.indicatorColor.uiColor())
        delBtn.isHidden         = true
        delIcon.isHidden        = true
        addFileView.isHidden    = false
        indicator.stopAnimating()
        indicator.isHidden = true
        indicator.color = myColors.btnColor.uiColor()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imagePressed(_:)))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tap)
        
        textComm.text       = "Комментарий..."
        textComm.textColor  = UIColor.lightGray
        textComm.delegate   = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    @objc func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            viewTop.constant = keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        viewTop.constant = 0
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textComm.textColor == UIColor.lightGray {
            textComm.text = nil
            textComm.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textComm.text.isEmpty {
            textComm.text = "Комментарий..."
            textComm.textColor = UIColor.lightGray
        }
    }
    
    //Работа с изображением
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        DispatchQueue.main.async{
            self.image.image = img
//            if img!.size.width > img!.size.height{
                let k = img!.size.width / img!.size.height
                self.imageWidth.constant = self.imageHeight.constant * k
                print(">", img!.size.width, img!.size.height, k)
                print(self.imageWidth.constant, self.imageHeight.constant)
//            }else{
//                let k = img!.size.width / img!.size.height
//                self.imageWidth.constant = self.imageHeight.constant * k
//                self.image.frame.size.width = self.imageWidth.constant
//                print("<", img!.size.width, img!.size.height, k)
//                print(self.imageWidth.constant, self.imageHeight.constant)
//            }
        }
        addFileView.isHidden    = true
        delBtn.isHidden         = false
        delIcon.isHidden        = false
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func imagePressed(_ sender: UITapGestureRecognizer) {
        self.imgPressed(sender)
    }
    
    private func imgPressed(_ sender: UITapGestureRecognizer) {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .black
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        let k = Double((imageView.image?.size.height)!) / Double((imageView.image?.size.width)!)
        let l = Double((imageView.image?.size.width)!) / Double((imageView.image?.size.height)!)
        if k > l{
            newImageView.frame.size.height = self.view.frame.size.width * CGFloat(k)
        }else{
            newImageView.frame.size.height = self.view.frame.size.width / CGFloat(l)
        }
        newImageView.frame.size.width = self.view.frame.size.width
        let y = (UIScreen.main.bounds.size.height - newImageView.frame.size.height) / 2
        newImageView.frame = CGRect(x: 0, y: y, width: newImageView.frame.size.width, height: newImageView.frame.size.height)
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleToFill
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        view.addGestureRecognizer(tap)
        view.addSubview(newImageView)
        self.view.addSubview(view)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview()
    }
}
