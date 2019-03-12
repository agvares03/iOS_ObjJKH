import Foundation
import UIKit

class AddLSMup: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var separator1: UILabel!
    @IBOutlet weak var separator2: UILabel!
    
    @IBOutlet weak var support: UIImageView!
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var showPass: UIButton!
    
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
    
    @IBAction func showPassAction(_ sender: UIBarButtonItem) {
        edPass.isSecureTextEntry.toggle()
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
    
    @IBAction func supportBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "support", sender: self)
    }
    
    @IBAction func AddLS(_ sender: UIButton) {
        if edPass.text == "" || edLS.text == "" {
            let alert = UIAlertController(title: "Заполните все поля", message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ок", style: .default) { (_) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
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
                                                
                                                self.response_add_ident = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                                                 print("responseString = \(String(describing: self.response_add_ident))")
                                                self.choice_add_ident()
                                                
        })
        task.resume()
    }
    
    func choice_add_ident() {
        if ((self.response_add_ident?.contains("ok"))!) {
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
        
        support.setImageColor(color: myColors.btnColor.uiColor())
        supportBtn.setTitleColor(myColors.btnColor.uiColor(), for: .normal)
        showPass.tintColor = myColors.btnColor.uiColor()
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
    
}
