//
//  CalendarVO.swift
//  Suni
//
//  Created by 전하성 on 2021/02/03.
//

import UIKit
class CalendarVO {
    var isHoliday : Bool?
    var date : Date?
    var title : Array<String>?
    var contents : Array<String>?
    
}
extension CalendarVO : CustomStringConvertible {
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date!)
    }
    
    
}
