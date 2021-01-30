//
//  TimetableCell.swift
//  Suni
//
//  Created by 전하성 on 2021/01/21.
//

import UIKit

class TimetableCell: UICollectionViewCell {
    let label = UILabel()
    var labelType : LabelType!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.sizeToFit()
        switch labelType {
        case .time : self.label.frame = CGRect(x: (self.frame.width - self.label.frame.width) / 2, y: 0, width: self.label.frame.width, height: self.label.frame.height)
        case .day : self.label.frame = CGRect(x: (self.frame.width - self.label.frame.width) / 2, y: 0, width: self.label.frame.width, height: self.frame.height)
        default : ()
        }
        
        self.label.textColor = .themeColor
        self.addSubview(self.label)
//        switch self.label.text {
//        case "MON" : print("MON Size: \(self.label.frame.width)");print(self.label.frame.origin.x)
//        case "TUE" : print("Tue Size: \(self.label.frame.width)");print(self.label.frame.origin.x)
//        case "WED" : print("Wed Size: \(self.label.frame.width)");print(self.label.frame.origin.x)
//        case "THU" : print("Thu Size: \(self.label.frame.width)");print(self.label.frame.origin.x)
//        case "FRI" : print("Fri Size: \(self.label.frame.width)");print(self.label.frame.origin.x)
//        default : ()
//        }
        
        
    }
    
    
}

enum LabelType {
    case time
    case day
    case none
}

