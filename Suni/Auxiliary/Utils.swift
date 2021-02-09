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
    func getWMPRegular (size: CGFloat) -> UIFont {
        if let wmp = UIFont(name: "wamakeprice-regular", size: size) {
            return wmp
        }
        else {
            print("Failed to get wemakeprice-regular Font")
            return UIFont.systemFont(ofSize: size)
        }
    }
    func getWMPSemiBold (size: CGFloat) -> UIFont {
        if let wmp = UIFont(name: "wemakeprice-semibold", size: size) {
            return wmp
        }
        else {
            print("Failed to get wemakeprice-semibod Font")
            return UIFont.systemFont(ofSize: size)
        }
    }
    func getWMPBold (size: CGFloat) -> UIFont {
        if let wmp = UIFont(name: "wemakeprice-bold", size: size) {
            return wmp
        }
        else {
            print("Failed to get wemakeprice-bold Font")
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
    
    static var todayColor : UIColor {
        get {
            return UIColor(red: 0.49, green: 0.31, blue: 0.87, alpha: 1.0)
        }
    }
    
    static var pastel : [UIColor] {
        get {
            return [UIColor(red: 0.95, green: 0.69, blue: 0.81, alpha: 1.00), UIColor(red: 0.73, green: 0.84, blue: 0.94, alpha: 1.00), UIColor(red: 0.84, green: 0.94, blue: 0.96, alpha: 1.00), UIColor(red: 0.65, green: 0.84, blue: 0.84, alpha: 1.00), UIColor(red: 0.95, green: 0.91, blue: 0.80, alpha: 1.00), UIColor(red: 0.76, green: 0.84, blue: 0.66, alpha: 1.00), UIColor(red: 0.69, green: 0.67, blue: 0.79, alpha: 1.00), UIColor(red: 0.94, green: 0.84, blue: 0.73, alpha: 1.00), UIColor(red: 0.67, green: 0.45, blue: 0.45, alpha: 1.00), UIColor(red: 0.82, green: 0.81, blue: 0.78, alpha: 1.00), UIColor(red: 0.34, green: 0.79, blue: 0.80, alpha: 1.00), UIColor(red: 0.99, green: 0.73, blue: 0.67, alpha: 1.00)]
            
        }
    }
}
extension UIView {
    func roundedCorners (_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIViewController {
    func alert(_ title: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: title, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                completion?()
            })
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
    func convertMajorPriority (major : String) -> Int {
        switch major {
        case "AMS" : return 0
        case "BUS" : return 1
        case "CSE" : return 2
        case "TSM" : return 3
        case "MEC" : return 4
        case "ETC" : return 5
        default : return -1
        }
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
    static let infoCellId : String = "InfoCell"
    static let courseListCellId : String = "CourseListCell"
    static let phoneNumberCellId : String = "PhoneNumberCell"
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

//MARK: User Defaults To Save Object
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

//MARK: Extension UITextField
extension UITextField {

    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = dateFormatter.date(from: "09:00")!
        datePicker.minimumDate = dateFormatter.date(from: "09:00")
        datePicker.maximumDate = dateFormatter.date(from: "21:00")
        
        self.inputView = datePicker

        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

        self.inputAccessoryView = toolBar
 }

   @objc func cancelPressed() {
         self.resignFirstResponder()
   }
}

//MARK: Clear UIImage
extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.init(data: image.pngData()!)!
    }
}

//MARK: Extension CALayer
extension CALayer {
    func chooseBorder (edge: UIRectEdge, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
            case UIRectEdge.top:
             border.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: thickness)

            case UIRectEdge.bottom:
             border.frame = CGRect(x: 0, y: self.bounds.height - thickness,  width: self.bounds.width, height: thickness)

            case UIRectEdge.left:
             border.frame = CGRect(x: 0, y: 0,  width: thickness, height: self.bounds.height)

            case UIRectEdge.right:
             border.frame = CGRect(x: self.bounds.width - thickness, y: 0,  width: thickness, height: self.bounds.height)

            default:
             break
        }
        border.backgroundColor = UIColor.themeColor.cgColor
        self.addSublayer(border)
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

