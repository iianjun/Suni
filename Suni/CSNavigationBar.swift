//
//  CSNavigationBar.swift
//  Suni
//
//  Created by 전하성 on 2021/01/22.
//

import UIKit

class CSNavigationBar: UINavigationBar {

    var csHeight : CGFloat = 60
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: self.csHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Remove bottom border line
        self.shadowImage = UIImage()
        self.barTintColor = .white
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        //Customized height
        
//        self.frame = CGRect(x: frame.origin.x, y: (UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.height)!, width: frame.size.width, height: csHeight)
//
        for subview in self.subviews {
            var stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("UIBarBackground") {
                subview.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: csHeight)
                subview.backgroundColor = self.backgroundColor
                subview.sizeToFit()
            }
            stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("UINavigationBarContentView") {
                subview.frame = CGRect(x: 0, y: (self.csHeight - subview.frame.height) / 2, width: self.frame.width, height: csHeight)
                subview.backgroundColor = self.backgroundColor
                subview.sizeToFit()
            }
        }
//        for subview in self.subviews {
//            var stringFromClass = NSStringFromClass(subview.classForCoder)
//            if stringFromClass.contains("UIBarBackground") {
//                print("innder barbackground")
//                subview.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: csHeight)
//
//                subview.backgroundColor = self.backgroundColor
//                subview.sizeToFit()
//            }
//
//            stringFromClass = NSStringFromClass(subview.classForCoder)
//
//            //Can't set height of the UINavigationBarContentView
//            if stringFromClass.contains("UINavigationBarContentView") {
//                print("UINavigationBarContentView")
//                //Set Center Y
//                let centerY = (csHeight - subview.frame.height) / 2.0
//                subview.frame = CGRect(x: 0, y: centerY, width: self.frame.width, height: subview.frame.height)
//                subview.backgroundColor = self.backgroundColor
//                subview.sizeToFit()
//
//            }
//        }


    }
}


