//
//  QuestionAnswerHeader.swift
//  ObjJKH
//
//  Created by Роман Тузин on 01.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class QuestionAnswerHeader: UICollectionViewCell {
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var title: UILabel!
    
    func display(_ item: QuestionJson, currentQuestion: Int, questionCount: Int) {
        question.text = item.question
        title.text = "\(currentQuestion + 1) из \(questionCount)"
    }
    
    class func fromNib() -> QuestionAnswerHeader? {
        var cell: QuestionAnswerHeader?
        let views = Bundle.main.loadNibNamed("DynamicCellsNib", owner: nil, options: nil)
        views?.forEach {
            if let view = $0 as? QuestionAnswerHeader {
                cell = view
            }
        }
        cell?.question.preferredMaxLayoutWidth = cell?.question.bounds.size.width ?? 0.0
        
        return cell
    }
    
}
