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
    
    static var pastel : [UIColor] {
        get {
            return [UIColor(red: 0.95, green: 0.69, blue: 0.81, alpha: 1.00), UIColor(red: 0.73, green: 0.84, blue: 0.94, alpha: 1.00), UIColor(red: 0.84, green: 0.94, blue: 0.96, alpha: 1.00), UIColor(red: 0.65, green: 0.84, blue: 0.84, alpha: 1.00), UIColor(red: 0.95, green: 0.91, blue: 0.80, alpha: 1.00), UIColor(red: 0.76, green: 0.84, blue: 0.66, alpha: 1.00), UIColor(red: 0.69, green: 0.67, blue: 0.79, alpha: 1.00), UIColor(red: 0.94, green: 0.84, blue: 0.73, alpha: 1.00), UIColor(red: 0.67, green: 0.45, blue: 0.45, alpha: 1.00), UIColor(red: 0.82, green: 0.81, blue: 0.78, alpha: 1.00), UIColor(red: 0.34, green: 0.79, blue: 0.80, alpha: 1.00), UIColor(red: 0.99, green: 0.73, blue: 0.67, alpha: 1.00)]
            
        }
    }
}

extension UIViewController {
    func alert(_ title: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                completion?()
            })
            let titleAttributed = NSMutableAttributedString(string: title,
                attributes: [
                    NSAttributedString.Key.font: self.getRigteous(size: 15)
//                        NSAttributedString.Key.foregroundColor: UIColor.themeTextColor
            ])
            alert.setValue(titleAttributed, forKey: "attributedTitle")
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func convertStringToDateInterval(startTime st: String, endTime et: String) -> DateInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
//        dateFormatter.locale = Locale(identifier: "ko_KR")
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let startDate = dateFormatter.date(from: st), let endDate = dateFormatter.date(from: et) {
            let dateInterval = DateInterval(start: startDate, end: endDate)
            return dateInterval
        }
        return DateInterval()
        
        
    }
    func convertDateToString(time : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: time)
    }
    func convertStringToRow (day : String) -> Int {
        switch day {
        case "MON" : return Day.mon.rawValue
        case "TUE" : return Day.tue.rawValue
        case "WED" : return Day.wed.rawValue
        case "THU" : return Day.thu.rawValue
        case "FRI" : return Day.fri.rawValue
        default : return 0
        }
    }
    func convertStringToSection (time: String) -> Int {
        
        switch time {
        case "09" : return Time.nine.rawValue
        case "10" : return Time.ten.rawValue
        case "11" : return Time.eleven.rawValue
        case "12" : return Time.twelve.rawValue
        case "13" : return Time.thirteen.rawValue
        case "14" : return Time.fourteen.rawValue
        case "15" : return Time.fifteen.rawValue
        case "16" : return Time.sixteen.rawValue
        case "17" : return Time.seventeen.rawValue
        case "18" : return Time.eighteen.rawValue
        case "19" : return Time.nineteen.rawValue
        case "20" : return Time.twenty.rawValue
        case "21" : return Time.twentyone.rawValue
        default : return 0
        
        }
    }
}

struct Constant {
    static let addBtnWidth : CGFloat = 30.0
    static let cornerRadius : CGFloat = 10.0
    static let moreVCCornerRadius : CGFloat = 25.0
    static let timetableBorderWidth : CGFloat = 2.0
    static let addCourseCellBorderWidth : CGFloat = 4.0
    static let timeTableCellId : String = "tcell"
    static let addCourseCellId : String = "addCourseCell"
    static let selectCellId : String = "selectCell"
    static let courseListCellId : String = "CourseListCell"
    static let addVCId : String = "AddCourseVC"
    static let moreInfoVCId : String = "MoreInfoVC"
    static let webVCId : String = "WebVC"
    static let titleFontSize : CGFloat = 30.0
    static let freeSpaceBtwBackAndTitle : CGFloat = 30.0
    static let freeSpaceBtwCollectionView : CGFloat = 5.0
}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}
extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

