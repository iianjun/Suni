//
//  CourseTimetableView.swift
//  Suni
//
//  Created by 전하성 on 2021/02/01.
//

import UIKit

class CourseTimetableView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let label = UILabel()
    var containedCourse = CourseVO()
    var bgColor = UIColor()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.label.font = getRigteous(size: 12)
        self.label.frame = CGRect(x: 5, y: 5, width: self.frame.width, height: 10)
        self.addSubview(label)
    }

}

