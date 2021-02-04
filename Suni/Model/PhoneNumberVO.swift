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

    
    
    func categoryToString () -> String {
        switch self.category {
        case .coordinator : return "Coordinator"
        case .scholarship : return "Enrollment Check / Scholarship / Millitary Service"
        case .finance : return "Finance (tuition information etc.)"
        case .admissions : return "Admissions Team"
        case .international : return "International Student Services"
        default : return ""
        }
    }
}

enum PhoneCategory : Int {
    case coordinator = 0
    case scholarship = 1
    case finance = 2
    case admissions = 3
    case international = 4
    
}
