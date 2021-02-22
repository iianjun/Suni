//
//  CourseListCell.swift
//  Suni
//
//  Created by 전하성 on 2021/01/25.
//

import UIKit

class CourseListCell: UITableViewCell {
    
  
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = Constant.addCourseCellBorderWidth
        self.layer.borderColor = UIColor.themeColor.cgColor
        self.layer.cornerRadius = Constant.cornerRadius
        if let label = self.textLabel {
            label.textColor = .themeTextColor
            label.sizeToFit()
            label.frame = CGRect(x: label.frame.origin.x, y: (self.frame.height - label.frame.height) / 2, width: label.frame.width, height: label.frame.height)
            
        }
        if let detailTextLabel = self.detailTextLabel {
            detailTextLabel.sizeToFit()
            detailTextLabel.textAlignment = .right
            detailTextLabel.textColor = .themeTextColor
            let isfourInchScreenWidth = UIScreen.main.bounds.width < 325 ? true : false
            if isfourInchScreenWidth {
                detailTextLabel.font = getRighteous(size: 12)
            }
            detailTextLabel.frame = CGRect(x: detailTextLabel.frame.origin.x, y: (self.frame.height - detailTextLabel.frame.height) / 2, width: detailTextLabel.frame.width, height: detailTextLabel.frame.height)
        }
        
        
        
        
        
        
        
    }
    

}
