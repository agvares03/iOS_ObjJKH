//
//  CloseAppAlert.swift
//  ObjJKH
//
//  Created by Роман Тузин on 31.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import CoreData

protocol CloseAppDelegate : class {
    func closeAppDone(closeApp: CloseAppAlert)
}

class CloseAppAlert: UIViewController, FloatRatingViewDelegate {
    
    weak var delegate: CloseAppDelegate?
    var App: Applications? = nil
    
    // Номер заявки
    var number:String = ""
    var responseString:NSString = ""
    
    // Данные для создания комментария
    var id_author: String = ""
    var name_account: String = ""
    var id_account: String = ""
    var teck_id: Int64 = 1

    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var closeComm: UITextField!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    @IBAction func close_action_close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close_action_do(_ sender: UIButton) {
        self.StartIndicator()
        let urlPath = Server.SERVER + Server.CLOSE_APP +
            "&reqID=" + self.number.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! +
            "&text=" + self.closeComm.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! +
            "&mark=" + self.mark.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! +
            "&base=5"
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
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
                                                
                                                self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                                                print("responseString = \(self.responseString)")
                                                
                                                self.choice()
        })
        task.resume()
    }
    
    func choice() {
        if (responseString == "0") {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                let alert = UIAlertController(title: "Ошибка", message: "Не удалось закрыть заявку, попробуйте позже", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else if (responseString == "1") {
            DispatchQueue.main.async(execute: {
                
                // Успешно - обновим значение в БД
                self.App?.is_close = 0
                CoreDataManager.instance.saveContext()
                
                let db = DB()
                db.add_comm(ID: self.teck_id, id_request: Int64(self.number)!, text: "Заявка закрыта с оценкой - " + self.mark, added: self.date_teck()!, id_Author: self.id_author, name: self.name_account, id_account: self.id_account)
                
                self.StopIndicator()
                
                let alert = UIAlertController(title: "Успешно", message: "Заявка закрыта с оценкой - " + self.mark, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    if self.delegate != nil {
                        self.delegate?.closeAppDone(closeApp: self)
                    }
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.StopIndicator()
                var stringError: String = String(self.responseString)
                if stringError.containsIgnoringCase(find: "error:"){
                    stringError = stringError.replacingOccurrences(of: "error: ", with: "")
                }
                let alert = UIAlertController(title: "Ошибка", message: stringError, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    // Оценка
    var mark = "3"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Rating
        // Required float rating view params
        self.floatRatingView.emptyImages = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 3
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = false
        self.floatRatingView.floatRatings = false
        
        self.StopIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func StartIndicator(){
        self.btnClose.isHidden = true
        self.btnOk.isHidden = true
        
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    
    func StopIndicator(){
        self.btnClose.isHidden = false
        self.btnOk.isHidden = false
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    func date_teck() -> (String)? {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
        
    }
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        print(NSString(format: "%.0f", self.floatRatingView.rating) as String)
        self.mark = NSString(format: "%.0f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        print(NSString(format: "%.0f", self.floatRatingView.rating) as String)
        self.mark = NSString(format: "%.0f", self.floatRatingView.rating) as String
    }

}
