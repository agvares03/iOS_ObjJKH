//
//  MockupController.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 30/01/2020.
//  Copyright © 2020 The Best. All rights reserved.
//

import UIKit
import FSPagerView

class MockupController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate {
      
    @IBOutlet private weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    
//    @IBAction func SwipeRight(_ sender: UISwipeGestureRecognizer) {
//        if selectImg > 0{
//            selectImg -= 1
//            pageControl.currentPage = selectImg
//        }
//    }
        
    @IBAction func SwipeLeft(_ sender: UISwipeGestureRecognizer) {
        if selectImg >= 5{
            if UserDefaults.standard.bool(forKey: "registerWithoutSMS"){
                self.performSegue(withIdentifier: "reg_app2", sender: self)
            }else{
                self.performSegue(withIdentifier: "reg_app", sender: self)
            }
        }
    }
    
    var selectImg = 0
    var imgArr: [String] = []
    var imgs: [UIImage] = []
    public var firstEnter = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Server().machineName().containsIgnoringCase(find: "iphone") && Server().biometricType() == "touch"{
            imgArr = ["iPhone_touch_1", "iPhone_touch_2", "iPhone_touch_3", "iPhone_touch_4", "iPhone_touch_5", "iPhone_touch_6"]
        }else if Server().machineName().containsIgnoringCase(find: "iphone") && Server().biometricType() == "face"{
            imgArr = ["iPhone_face_1", "iPhone_face_2", "iPhone_face_3", "iPhone_face_4", "iPhone_face_5", "iPhone_face_6"]
        }else if Server().machineName().containsIgnoringCase(find: "ipad") && Server().biometricType() == "touch"{
            imgArr = ["iPad_touch_1", "iPad_touch_2", "iPad_touch_3", "iPad_touch_4", "iPad_touch_5", "iPad_touch_6"]
        }else if Server().machineName().containsIgnoringCase(find: "ipad") && Server().biometricType() == "face"{
            imgArr = ["iPad_face_1", "iPad_face_2", "iPad_face_3", "iPad_face_4", "iPad_face_5", "iPad_face_6"]
        }
        imgArr.forEach{
            imgs.append(UIImage(named: $0)!)
        }
        pagerView.interitemSpacing = 20
        pagerView.dataSource = self
        pagerView.delegate   = self
        pageControl.numberOfPages = 6
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = myColors.btnColor.uiColor()
        self.pagerView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imgs.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = imgs[index]
        return cell
    }
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reg_app2" {
            let payController = segue.destination as! NewRegistration
            payController.firstEnter = true
        }
        if segue.identifier == "reg_app" {
            let payController = segue.destination as! Registration
            payController.firstEnter = true
        }
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        print("pagerViewDidEndDecelerating", pagerView.currentIndex, end)
        if pagerView.currentIndex == imgs.count - 1 && end{
            if UserDefaults.standard.bool(forKey: "registerWithoutSMS"){
                self.performSegue(withIdentifier: "reg_app2", sender: self)
            }else{
                self.performSegue(withIdentifier: "reg_app", sender: self)
            }
        }else if pagerView.currentIndex == imgs.count - 1{
            end = true
        }else{
            end = false
        }
    }
    var end = false

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
