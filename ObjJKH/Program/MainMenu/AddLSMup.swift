import Foundation
import UIKit

class AddLSMup: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var separator1: UILabel!
    @IBOutlet weak var separator2: UILabel!
    
    // Массивы для хранения данных
    var streets_names: [String] = []
    var streets_ids: [String] = []
    var teck_street: Int = -1
    var streetString: String?
    
    var numbers_names: [String] = []
    var numbers_ids: [String] = []
    var teck_number: Int = -1
    
    var flats_names: [String] = []
    var flats_ids: [String] = []
    var teck_flat: Int = -1
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnReg: UIButton!
    
    // Телефон, который регистрируется
    var phone: String = ""
    var response_add_ident: String?
    
    @IBOutlet weak var txtNumberLS: UILabel!
    @IBOutlet weak var txtPassword: UILabel!
    
    @IBOutlet weak var edLS: UITextField!
    @IBOutlet weak var edPass: UITextField!
    
    @IBAction func AddLS(_ sender: UIButton) {
        // Регистрация лицевого счета
        var urlPath = "http://uk-gkh.org/muprcmytishi_admin/api/muprkcdatasync/startsync?"
        urlPath = urlPath + "ident=" + (edLS.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
        urlPath = urlPath + "&pwd=" + (edPass.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)!
        urlPath = urlPath + "&phone=" + phone.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        let alert = UIAlertController(title: "Ошибка сервера", message: "Попробуйте позже", preferredStyle: .alert)
                                                        let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
                                                        alert.addAction(cancelAction)
                                                        self.present(alert, animated: true, completion: nil)
                                                    })
                                                    return
                                                }
                                                
                                                self.response_add_ident = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                // print("responseString = \(String(describing: self.response_add_ident))")
                                                self.choice_add_ident()
                                                
        })
        task.resume()
    }
    
    func choice_add_ident() {
        if (self.response_add_ident == "ok") {
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Успешно", message: "Лицевой счет - " + (self.edLS.text)! + " привязан к аккаунту " + self.phone, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    
                    let defaults = UserDefaults.standard
                    defaults.set(self.phone, forKey: "login")
                    defaults.set(true, forKey: "go_to_app")
                    defaults.synchronize()
                    
                    // Перейдем на главную страницу со входом в приложение
                    self.performSegue(withIdentifier: "go_to_app", sender: self)
                    
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Ошибка", message: self.response_add_ident?.replacingOccurrences(of: "error: ", with: ""), preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in
                    
                    // Если я тут - регистрация уже прошла, логин, пароль есть - можно перекинуть в приложение
                    let defaults = UserDefaults.standard
                    defaults.set(self.phone, forKey: "login")
                    defaults.synchronize()
                    
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        HideIndicators(num_ind: 1)
        
        let defaults = UserDefaults.standard
        phone = defaults.string(forKey: "phone")!
        
        edLS.delegate = self
        
        // Установим цвета для элементов в зависимости от Таргета
        btnAdd.backgroundColor = myColors.btnColor.uiColor()
        btnReg.backgroundColor = myColors.btnColor.uiColor()
        back.tintColor = myColors.btnColor.uiColor()
        separator1.backgroundColor = myColors.labelColor.uiColor()
        separator2.backgroundColor = myColors.labelColor.uiColor()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        edLS.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func end_choice() {
        DispatchQueue.main.async(execute: {
            self.HideIndicators(num_ind: 1)
            //            self.update_view()
        })
    }
    
    // Переходы - выбор
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "get_street_new") {
            
            prepare_seque_for_choice(teck: teck_street, names: streets_names, segue: segue, numb: 1)
            
        } else if (segue.identifier == "get_number_new") {
            
            prepare_seque_for_choice(teck: teck_number, names: numbers_names, segue: segue, numb: 2)
            
        } else if (segue.identifier == "get_flat_new") {
            
            prepare_seque_for_choice(teck: teck_flat, names: flats_names, segue: segue, numb: 3)
            
        }
    }
    
    func prepare_seque_for_choice(teck: Int, names: [String], segue: UIStoryboardSegue, numb: Int) {
        let selectItemController = (segue.destination as! UINavigationController).viewControllers.first as! SelectItemController
        selectItemController.strings = names
        selectItemController.selectedIndex = teck
        selectItemController.selectHandler = { selectedIndex in
            
            if (numb == 1) {
                self.teck_street = selectedIndex
                self.ClearNumbers()
                self.ClearFlats()
                
                let choice_name_street   = self.streets_names[selectedIndex]
                self.AddNumbers(name: choice_name_street)
            } else if (numb == 2) {
                self.teck_number = selectedIndex
                self.ClearFlats()
                
                let choice_id_number   = self.numbers_ids[selectedIndex]
                self.AddFlats(id: choice_id_number)
            } else {
                self.teck_flat = selectedIndex
            }
            
            self.edStreet.text   = self.appString(teck: self.teck_street, names: self.streets_names)
            self.edNumber.text   = self.appString(teck: self.teck_number, names: self.numbers_names)
            self.edFlat.text     = self.appString(teck: self.teck_flat, names: self.flats_names)
            
        }
    }
    
    // Очистка значений при перевыборе
    func ClearNumbers() {
        numbers_names = []
        numbers_ids = []
        teck_number = -1
    }
    
    func ClearFlats() {
        flats_names = []
        flats_ids = []
        teck_flat = -1
    }
    
    // Процедура отображения названий
    func appString(teck: Int, names: [String]) -> String {
        if teck == -1 {
            return "    "
        }
        if teck >= 0 && teck < names.count {
            return names[teck]
        }
        return "    "
    }
    
    // Подтягивание данных динамически
    func AddNumbers(name: String) {
        ShowIndicators(num_ind: 2)
        let urlPath = Server.SERVER + Server.GET_NUMBERS_HOUSE + "st=" + name.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    return
                                                }
                                                
                                                do {
                                                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                    
                                                    // Получим список домов по улице
                                                    if let numbers = json["Houses"] {
                                                        if ((numbers.count)! == 0) {
                                                        } else {
                                                            for index in 0...(numbers.count)!-1 {
                                                                let obj_number = numbers.object(at: index) as! [String:AnyObject]
                                                                for obj in obj_number {
                                                                    if obj.key == "Number" {
                                                                        self.numbers_names.append(obj.value as! String)
                                                                    }
                                                                    if obj.key == "ID" {
                                                                        self.numbers_ids.append(String(describing: obj.value))
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                } catch let error as NSError {
                                                    print(error)
                                                }
                                                
                                                self.end_choice()
                                                
        })
        task.resume()
    }
    
    func AddFlats(id: String) {
        ShowIndicators(num_ind: 3)
        let urlPath = Server.SERVER + Server.GET_HOUSE_DATA + "id=" + id.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    return
                                                }
                                                
                                                do {
                                                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                                    
                                                    // Получим список домов по улице
                                                    if let flats = json["Premises"] {
                                                        if ((flats.count)! == 0) {
                                                        } else {
                                                            for index in 0...(flats.count)!-1 {
                                                                let obj_flat = flats.object(at: index) as! [String:AnyObject]
                                                                for obj in obj_flat {
                                                                    if obj.key == "Number" {
                                                                        self.flats_names.append(obj.value as! String)
                                                                    }
                                                                    if obj.key == "ID" {
                                                                        self.flats_ids.append(String(describing: obj.value))
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                } catch let error as NSError {
                                                    print(error)
                                                }
                                                
                                                self.end_choice()
                                                
        })
        task.resume()
    }
    
    // Показать индикаторы
    func HideIndicators(num_ind: Int) {
        if (num_ind == 1) {
            ShowHideStreets(show_hide: false)
            ShowHideNumbers(show_hide: false)
            ShowHideFlats(show_hide: false)
        } else if (num_ind == 2) {
            ShowHideNumbers(show_hide: false)
            ShowHideFlats(show_hide: false)
        } else if (num_ind == 3) {
            ShowHideFlats(show_hide: false)
        }
    }
    
    // Скрыть индикаторы
    func ShowIndicators(num_ind: Int) {
        if (num_ind == 1) {
            ShowHideStreets(show_hide: true)
            ShowHideNumbers(show_hide: true)
            ShowHideFlats(show_hide: true)
        } else if (num_ind == 2) {
            ShowHideNumbers(show_hide: true)
            ShowHideFlats(show_hide: true)
        } else if (num_ind == 3) {
            ShowHideFlats(show_hide: true)
        }
    }
    
    func ShowHideStreets(show_hide: Bool) {
        edStreet.isHidden         = show_hide
        txtStreet.isHidden        = show_hide
        imgStreet.isHidden        = show_hide
        
        indicator_street.isHidden = !show_hide
    }
    
    func ShowHideNumbers(show_hide: Bool) {
        edNumber.isHidden         = show_hide
        txtNumber.isHidden        = show_hide
        imgNumber.isHidden        = show_hide
        
        indicatorNumber.isHidden = !show_hide
    }
    
    func ShowHideFlats(show_hide: Bool) {
        edFlat.isHidden         = show_hide
        txtFlat.isHidden        = show_hide
        imgFlat.isHidden        = show_hide
        
        indicatorFlat.isHidden = !show_hide
    }
    
}
