//
//  AddCourseCell.swift
//  Suni
//
//  Created by 전하성 on 2021/01/23.
//

import UIKit

class AddCourseCell: UICollectionViewCell {
    
   
    @IBOutlet var label: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = Constant.cornerRadius
        self.layer.borderColor = UIColor.themeColor.cgColor
        self.layer.borderWidth = Constant.addCourseCellBorderWidth
        self.label?.sizeToFit()
        self.label?.textColor = .themeTextColor
        
    
        
    }
}
