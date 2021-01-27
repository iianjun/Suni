//
//  CourseVO.swift
//  Suni
//
//  Created by 전하성 on 2021/01/26.
//

import UIKit
class CourseVO {
    var major : String?
    var name : String?
    var title : String?
    var type : CourseType?
    var credit : Int?
    var days : Array<String>?
    var startTime : String?
    var endTime : String?
    var room : String?
    var instructor : String?
    var hasLab : Bool?
    var link : String?
    var number : Int?
    var hash : Int?
    var selected : Bool?

}

enum CourseType : String {
    case lec, rec, lab, sem
}
extension CourseVO : Equatable, CustomStringConvertible {
    var description: String {
        return "[Major: \(self.major!) \nName: \(self.name!) \nTitle:\(self.title!) \nDays: \(self.days!) \nTime: \(self.startTime!)-\(self.endTime!) \nInstructor: \(self.instructor!)] \n"

        
    }
    
    static func ==(lhs: CourseVO, rhs: CourseVO) -> Bool {
        return lhs.major == rhs.major && lhs.name == rhs.name && lhs.startTime == rhs.startTime && lhs.endTime == rhs.endTime && lhs.number == rhs.number
    }
    
    
}

