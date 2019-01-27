//
//  TwoPageController.swift
//  DJ
//
//  Created by Sergey Ivanov on 25/01/2019.
//  Copyright © 2019 The Best. All rights reserved.
//

import UIKit

class TwoPageController: UIViewController {

    @IBOutlet weak var width1: NSLayoutConstraint!
    @IBOutlet weak var width2: NSLayoutConstraint!
    @IBOutlet weak var width3: NSLayoutConstraint!
    @IBOutlet weak var width4: NSLayoutConstraint!
    @IBOutlet weak var width5: NSLayoutConstraint!
    @IBOutlet weak var width6: NSLayoutConstraint!
    @IBOutlet weak var width7: NSLayoutConstraint!
    @IBOutlet weak var width8: NSLayoutConstraint!
    @IBOutlet weak var width9: NSLayoutConstraint!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    @IBAction func nextAction(_ sender: UIButton) {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width1.constant = view.frame.width - 48
        width2.constant = view.frame.width - 48
        width3.constant = view.frame.width - 48
        width4.constant = view.frame.width - 48
        width5.constant = view.frame.width - 48
        width6.constant = view.frame.width - 48
        width7.constant = view.frame.width - 48
        width8.constant = view.frame.width - 48
        width9.constant = view.frame.width - 48
        nextBtn.backgroundColor = myColors.indicatorColor.uiColor()
        if view.frame.height == 568{
            scrollHeight.constant = 750
        }
    }
}
