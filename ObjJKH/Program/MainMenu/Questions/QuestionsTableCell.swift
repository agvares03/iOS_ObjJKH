//
//  QuestionsTableCell.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class QuestionsTableCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    func display(_ item: QuestionDataJson, width: CGFloat) {
        
        title.text = item.name
        
        var isAnswered = true
        item.questions?.forEach {
            if !($0.isCompleteByUser ?? false) {
                isAnswered = false
            }
        }
        var txt = " вопроса"
        if ((item.questions?.count)! == 1) {
            txt = " вопрос"
        } else if ((item.questions?.count)! > 4) {
            txt = " вопросов"
        }
        desc.text = (isAnswered)
            ? "Вы начали опрос"
            : String(item.questions?.count ?? 0) + txt
        desc.textColor = (isAnswered)
            ? .gray
            : UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1)
    }
    
}
