//
//  QuestionsTableCell.swift
//  ObjJKH
//
//  Created by Роман Тузин on 28.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit

class QuestionsTableCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    
    func display(_ item: QuestionDataJson, width: CGFloat) {
        
        title.text = item.name
        
        var isAnswered = true
        item.questions?.forEach {
            if !($0.isCompleteByUser ?? false) {
                isAnswered = false
            }
        }
        titleHeight.constant = heightForView(text: item.name ?? "", font: title.font, width: width - 40)
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
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        print(label.frame.height, width)
        return label.frame.height
    }
    
}
