//
//  CourseVO.swift
//  Suni
//
//  Created by 전하성 on 2021/01/26.
//

import UIKit
class CourseVO : Codable {
    var major : String?
    var name : String?
    var title : String?
    var type : String?
    var credit : Int?
    var days : Array<String>?
    var time : DateInterval?
    var room : String?
    var instructor : String?
    var hasLab : Bool?
    var link : String?
    var number : Int?
    var hash : Int?
    var bgColor = Color(color: UIColor())
//    required init?(coder: NSCoder) {
//        fatalError()
//    }

    func convertTimeAndDayToString () -> String {
        var courseTime = ""
        if let days = self.days {
            for i in 0..<days.count {
                courseTime += days[i]
                if i + 1 != days.count {
                    courseTime += "/"
                }
            }
        }
        let timeString = convertTimeToString()
       
        return "\(courseTime) \(timeString)"

    }
    func convertTimeToString () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let startDate = self.time?.start, let endDate = self.time?.end {
            let startTime = dateFormatter.string(from: startDate)
            let endTime = dateFormatter.string(from: endDate)
            return "\(startTime)-\(endTime)"
        }
        return ""
    }
  

}

extension CourseVO : Equatable {
    
    static func ==(lhs: CourseVO, rhs: CourseVO) -> Bool {
        return lhs.major == rhs.major && lhs.name == rhs.name && lhs.time == rhs.time && lhs.number == rhs.number
    }
    
    
}
class Color:Codable{
    var red : CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

    init(color:UIColor) {
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }

    var color:UIColor{
        get{
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        set{
            newValue.getRed(&red, green:&green, blue: &blue, alpha:&alpha)
        }
    }

    var cgColor:CGColor{
        get{
            return color.cgColor
        }
        set{
            UIColor(cgColor: newValue).getRed(&red, green:&green, blue: &blue, alpha:&alpha)
        }
    }
}
