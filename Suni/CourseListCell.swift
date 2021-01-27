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
        self.textLabel?.textColor = .themeTextColor
        self.detailTextLabel?.textColor = .themeTextColor
        self.textLabel?.sizeToFit()
        self.detailTextLabel?.sizeToFit()
        self.detailTextLabel?.textAlignment = .right
        
    }
    

}
