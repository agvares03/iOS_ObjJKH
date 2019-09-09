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
    @IBOutlet weak var phoneHeight: NSLayoutConstraint!
    @IBOutlet weak var urlLblHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneLblHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var urlLbl: UILabel!
    @IBOutlet weak var substring: UILabel!
    @IBOutlet weak var urlBtn: UIButton!
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
    public var item: Services?
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let item = item else { return }
        let url:NSURL = NSURL(string: (item.logo)!)!
        let data = try? Data(contentsOf: url as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
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
        }
        backBtn.tintColor = myColors.btnColor.uiColor()
        // Do any additional setup after loading the view.
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
