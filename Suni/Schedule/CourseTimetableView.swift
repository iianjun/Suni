//
//  CourseTimetableView.swift
//  Suni
//
//  Created by 전하성 on 2021/02/01.
//

import UIKit

class CourseTimetableView: UIView {

    public let label = UILabel()
    public var containedCourse = CourseVO()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.label.font = getRighteous(size: 12)
        self.label.frame = CGRect(x: 5, y: 5, width: self.frame.width, height: 10)
        self.label.numberOfLines = 0
        self.addSubview(label)
    }

}

