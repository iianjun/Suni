//
//  PhoneVC.swift
//  Suni
//
//  Created by 전하성 on 2021/02/04.
//

import UIKit
class PhoneBoothVC : UIViewController {
    let application = UIApplication.shared
    var phoneNumbers : [PhoneNumberVO] = []
    var coordinators : [PhoneNumberVO] = []
    var scholarship  : [PhoneNumberVO] = []
    var finance  : [PhoneNumberVO] = []
    var admissions  : [PhoneNumberVO] = []
    var international  : [PhoneNumberVO] = []
    
    @IBOutlet var phoneNumberTableView: UITableView!
    
    override func viewDidLoad() {
        
        self.getPhoneNumbers()
        self.categorize()
        self.initHeader()
    }
    
    func getPhoneNumbers () {
        if let path = Bundle.main.path(forResource: "phone_number", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as! [NSDictionary]
                for obj in jsonResult {
                    let pvo = PhoneNumberVO()
                    pvo.category = PhoneCategory(rawValue: (obj["category"] as? Int)!)
                    pvo.number = obj["number"] as? String
                    pvo.name = obj["name"] as? String
                    phoneNumbers.append(pvo)
                }
            }
            catch {
                NSLog(error.localizedDescription)
            }
            
        }
    }
    
    func categorize () {
        coordinators = phoneNumbers.filter { $0.category?.rawValue == 0 }
        scholarship = phoneNumbers.filter { $0.category?.rawValue == 1 }
        finance = phoneNumbers.filter { $0.category?.rawValue == 2 }
        admissions = phoneNumbers.filter { $0.category?.rawValue == 3 }
        international = phoneNumbers.filter { $0.category?.rawValue == 4 }
        self.phoneNumberTableView.delegate = self
        self.phoneNumberTableView.dataSource = self
        
    }
    
    
    func initHeader () {
        let viewTitle = UILabel()
        viewTitle.text = "Phone Booth"
        viewTitle.font = getRigteous(size: Constant.titleFontSize)
        viewTitle.sizeToFit()
        viewTitle.textColor = .themeColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitle)
        self.navigationController?.navigationBar.backgroundColor = .white
        
    }
}

extension PhoneBoothVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let categoryForSection = self.phoneNumbers.filter { $0.category?.rawValue == section }
        
        switch section {
        case 0:
            return categoryForSection.count
        case 1:
            return categoryForSection.count
        case 2:
            return categoryForSection.count
        case 3:
            return categoryForSection.count
        case 4:
            return categoryForSection.count
        default : return 0
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.phoneNumberCellId) else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            let pvo = coordinators[indexPath.row]
            cell.textLabel?.text = pvo.name!
            cell.detailTextLabel?.text = pvo.number!
        
        case 1:
            let pvo = scholarship[indexPath.row]
            cell.textLabel?.text = pvo.name!
            cell.detailTextLabel?.text = pvo.number!
        case 2:
            let pvo = finance[indexPath.row]
            cell.textLabel?.text = pvo.name!
            cell.detailTextLabel?.text = pvo.number!
        case 3:
            let pvo = admissions[indexPath.row]
            cell.textLabel?.text = pvo.name!
            cell.detailTextLabel?.text = pvo.number!
        case 4:
            let pvo = international[indexPath.row]
            cell.textLabel?.text = pvo.name!
            cell.detailTextLabel?.text = pvo.number!
        default : break
        }
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            let pvo = coordinators[0]
            return pvo.categoryToString()
        case 1:
            let pvo = scholarship[0]
            return pvo.categoryToString()
        case 2:
            let pvo = finance[0]
            return pvo.categoryToString()
        case 3:
            let pvo = admissions[0]
            return pvo.categoryToString()
        case 4:
            let pvo = international[0]
            return pvo.categoryToString()
        default : return ""
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//    }
//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var pvo = PhoneNumberVO()
        switch indexPath.section {
        case 0:
            pvo = coordinators[indexPath.row]
        case 1:
            pvo = scholarship[indexPath.row]
        case 2:
            pvo = finance[indexPath.row]
        case 3:
            pvo = admissions[indexPath.row]
        case 4:
            pvo = international[indexPath.row]
        default : break
        }
        if let number = pvo.number {
            if let url = URL(string: "tel://\(number)"), application.canOpenURL(url) {
                if #available(iOS 10, *) {
                    application.open(url, options: [:], completionHandler: nil)
                }
                else {
                    application.openURL(url)
                }
            }
            else {
                alert("Couldn't not bring URL")
            }
        }
    }
}

