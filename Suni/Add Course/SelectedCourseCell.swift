//
//  SelectedCourseCell.swift
//  Suni
//
//  Created by 전하성 on 2021/01/24.
//

import UIKit

class SelectedCourseCell: UICollectionViewCell {
//    let label = UILabel()
    
    public let removeBtn = UIButton()
    
    @IBOutlet var label: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = Constant.cornerRadius
        self.backgroundColor = .themeColor
        let closeBtnWidth : CGFloat = 20
        self.removeBtn.setImage(UIImage(named: "close.png"), for: .normal)

        self.label.sizeToFit()
        self.label.textColor = .themeTextColor

        let space = (self.frame.width - (self.label.frame.width + closeBtnWidth)) / 2
        let combinedView = UIView(frame: CGRect(x: space, y: 0, width: self.label.frame.width + closeBtnWidth, height: self.frame.height))

        self.label.frame = CGRect(x: 0, y: 0, width: self.label.frame.width, height: self.frame.height)
        self.removeBtn.frame = CGRect(x: self.label.frame.maxX, y: 0, width: closeBtnWidth, height: self.frame.height)
        combinedView.addSubview(self.label)
        combinedView.addSubview(self.removeBtn)
        self.addSubview(combinedView)
        
    
    }
}
