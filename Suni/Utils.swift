//
//  Utils.swift
//  Suni
//
//  Created by 전하성 on 2021/01/21.
//

import UIKit

extension UIResponder {
   
    func getRigteous(size: CGFloat) -> UIFont {
        if let righteous =  UIFont(name: "Righteous-Regular", size: size) {
            return righteous
        }
        else {
            print("Failed to get Righteous Font")
            return UIFont.systemFont(ofSize: size)
        }
    }
}
extension UIColor {
    static var themeColor : UIColor {
        get {
            return UIColor(red: 0.82, green: 0.68, blue: 1.0, alpha: 1.0)
        }
    }
    static var themeTextColor : UIColor {
        get {
            return UIColor(red: 0.31, green: 0.0, blue: 1.0, alpha: 1.0)
        }
    }
}


struct Constant {
    static let addBtnWidth : CGFloat = 30.0
    static let cornerRadius : CGFloat = 10.0
    static let timetableBorderWidth : CGFloat = 2.0
    static let addCourseCellBorderWidth : CGFloat = 4.0
    static let timeTableCellId : String = "tcell"
    static let addCourseCellId : String = "addCourseCell"
    static let selectCellId : String = "selectCell"
    static let courseListCellId : String = "CourseListCell"
    static let addVCId : String = "AddCourseVC"
    static let titleFontSize : CGFloat = 30.0
    static let freeSpaceBtwBackAndTitle : CGFloat = 30.0
    static let freeSpaceBtwCollectionView : CGFloat = 5.0
    
    
}
