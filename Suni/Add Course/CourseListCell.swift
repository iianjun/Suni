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
        
        self.detailTextLabel?.textColor = .themeTextColor
        
        self.detailTextLabel?.sizeToFit()
        self.detailTextLabel?.textAlignment = .right
        
        
    }
    

}
