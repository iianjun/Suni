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
    var time : DateInterval?
    var room : String?
    var instructor : String?
    var hasLab : Bool?
    var link : String?
    var number : Int?
    var hash : Int?
    var selected : Bool?
    
    func convertTimeToString () -> String {
        var courseTime = ""
        if let days = self.days {
            for i in 0..<days.count {
                courseTime += days[i]
                if i + 1 != days.count {
                    courseTime += "/"
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let startDate = self.time?.start, let endDate = self.time?.end {
            let startTime = dateFormatter.string(from: startDate)
            let endTime = dateFormatter.string(from: endDate)
            return "\(courseTime) \(startTime)-\(endTime)"
        }
        return ""
    }

}

enum CourseType : String {
    case lec, rec, lab, sem
}
extension CourseVO : Equatable, CustomStringConvertible {
    var description: String {
        return "[Major: \(self.major!) \nName: \(self.name!) \nTitle:\(self.title!) \nDays: \(self.days!) \nTime: \(self.time!) \nInstructor: \(self.instructor!)] \n"
    }
    
    static func ==(lhs: CourseVO, rhs: CourseVO) -> Bool {
        return lhs.major == rhs.major && lhs.name == rhs.name && lhs.time == rhs.time && lhs.number == rhs.number
    }
    
}

