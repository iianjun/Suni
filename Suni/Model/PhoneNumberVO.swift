//
//  PhoneNumberVO.swift
//  Suni
//
//  Created by 전하성 on 2021/02/04.
//

import UIKit
class PhoneNumberVO {
    var category : PhoneCategory?
    var number : String?
    var name : String?
    var email : String?

    
    
    func categoryToString () -> String {
        switch self.category {
        case .igc : return "IGC"
        case .coordinators : return "Coordinator"
        case .studentAffair : return "Student Affair"
        case .rcAndWorkStudy : return "RC / Work-Study"
        case .scholarship : return "Scholarship / Millitary Service"
        case .others : return "Other Offices"
        case .international : return "International Student Services"
        default : return ""
        }
    }
}

enum PhoneCategory : Int {
    case igc = 0
    case coordinators = 1
    case studentAffair = 2
    case rcAndWorkStudy = 3
    case scholarship = 4
    case others = 5
    case international = 6
    
}
