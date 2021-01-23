//
//  AddCourseCell.swift
//  Suni
//
//  Created by 전하성 on 2021/01/23.
//

import UIKit

class AddCourseCell: UICollectionViewCell {
    let label = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = Constant.cornerRadius
        self.layer.borderColor = UIColor.themeColor.cgColor
        self.layer.borderWidth = Constant.addCourseCellBorderWidth
        
        self.label.sizeToFit()
        self.label.font = getRigteous(size: self.label.font.pointSize)
        self.label.adjustsFontSizeToFitWidth = true
        self.label.textColor = .themeTextColor
        self.label.frame = CGRect(x: (self.frame.width - self.label.frame.width) / 2, y: 0, width: self.label.frame.width, height: self.frame.height)
        self.addSubview(self.label)
    
        
    }
}
