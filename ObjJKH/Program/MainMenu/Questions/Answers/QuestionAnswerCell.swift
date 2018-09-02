//
//  QuestionAnswerCell.swift
//  ObjJKH
//
//  Created by Роман Тузин on 01.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class QuestionAnswerCell: UICollectionViewCell {
    
    @IBOutlet weak var toggle: OnOffButton!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var toggleView: UIView!
    
    var isAccepted      = false
    var selectedAnswers: [Int] = []
    
    @objc fileprivate func didTapOnOffButton(_ sender: UITapGestureRecognizer? = nil) {
        if sender != nil {
            isAccepted = false
            NotificationCenter.default.post(name: NSNotification.Name("Uncheck"), object: nil)
        }
        
        if isAccepted && checked { return }
        if !isAccepted { isAccepted = true }
        
        if checked {
            selectedAnswers.append(index)
            
            toggle.strokeColor  = blueColor
            toggleView.isHidden = false
            toggle.lineWidth    = 2
            toggle.setBackgroundImage(nil, for: .normal)
            
            checked                 = false
            isAccepted              = true
            
        } else {
            
            for (ind, item) in selectedAnswers.enumerated() {
                if item == index {
                    selectedAnswers.remove(at: ind)
                }
            }
            toggle.strokeColor  = .lightGray
            toggleView.isHidden = true
            toggle.lineWidth    = 0
            toggle.setBackgroundImage(UIImage(named: "ic_choice"), for: .normal)
            
            isAccepted              = false
            checked                 = true
        }
    }
    
    private let blueColor = UIColor(red: 0/255, green: 100/255, blue: 255/255, alpha: 1)
    fileprivate var checked  = false
    private var index = 0
    
    func display(_ item: QuestionsTextJson, index: Int) {
        self.index = index
        
        toggle.checked = false
        
        toggle.strokeColor  = .lightGray
        toggle.lineWidth    = 2
        
        question.text = item.text
        
        checked = false
        didTapOnOffButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnOffButton(_:)))
        toggle.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Uncheck"), object: nil, queue: nil) { _ in
            self.checked = false
            self.didTapOnOffButton()
        }
    }
    
}
