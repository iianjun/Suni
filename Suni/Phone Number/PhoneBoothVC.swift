//
//  PhoneVC.swift
//  Suni
//
//  Created by 전하성 on 2021/02/04.
//

import UIKit
class PhoneBoothVC : UIViewController {
    private let application = UIApplication.shared
    private var phoneNumbers : [[PhoneNumberVO]] = []
    private var igc : [PhoneNumberVO] = []
    private var coordinators : [PhoneNumberVO] = []
    private var studentAffair : [PhoneNumberVO] = []
    private var rcAndWorkStudy : [PhoneNumberVO] = []
    private var scholarship  : [PhoneNumberVO] = []
    private var others : [PhoneNumberVO] = []
    private var international  : [PhoneNumberVO] = []
    
    @IBOutlet var phoneNumberTableView: UITableView!
    
    override func viewDidLoad() {
        
        self.getPhoneNumbers()
        self.initHeader()
        self.phoneNumberTableView.delegate = self
        self.phoneNumberTableView.dataSource = self
    }
    private func getPhoneNumbers () {
        
        let sd = UserDefaults.standard
        if let jsonResult = sd.object(forKey: "phone_number") as? [NSDictionary] {
            for obj in jsonResult {
                let pvo = PhoneNumberVO()
                pvo.category = PhoneCategory(rawValue: (obj["category"] as? Int)!)
                pvo.number = obj["number"] as? String
                pvo.name = obj["name"] as? String
                if obj["email"] as? String != "" {
                    pvo.email = obj["email"] as? String
                }
                
                
                guard let category = pvo.category else { return }
                switch category {
                case .igc: self.igc.append(pvo)
                case .coordinators : self.coordinators.append(pvo)
                case .studentAffair : self.studentAffair.append(pvo)
                case .rcAndWorkStudy : self.rcAndWorkStudy.append(pvo)
                case .scholarship: self.scholarship.append(pvo)
                case .others : self.others.append(pvo)
                case .international : self.international.append(pvo)
                }
            }
        }
        else {
            NSLog("Error on parsing PhoneNumber from sd")
        }
        self.phoneNumbers = [self.igc, self.coordinators, self.studentAffair, self.rcAndWorkStudy, self.scholarship, self.others, self.international]
//
//        if let path = Bundle.main.path(forResource: "phone_number", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path))
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as! [NSDictionary]
//                for obj in jsonResult {
//                    let pvo = PhoneNumberVO()
//                    pvo.category = PhoneCategory(rawValue: (obj["category"] as? Int)!)
//                    pvo.number = obj["number"] as? String
//                    pvo.name = obj["name"] as? String
//                    if obj["email"] as? String != "" {
//                        pvo.email = obj["email"] as? String
//                    }
//
//
//                    guard let category = pvo.category else { return }
//                    switch category {
//                    case .igc: self.igc.append(pvo)
//                    case .coordinators : self.coordinators.append(pvo)
//                    case .studentAffair : self.studentAffair.append(pvo)
//                    case .rcAndWorkStudy : self.rcAndWorkStudy.append(pvo)
//                    case .scholarship: self.scholarship.append(pvo)
//                    case .others : self.others.append(pvo)
//                    case .international : self.international.append(pvo)
//                    }
//                }
//            }
//            catch {
//                NSLog(error.localizedDescription)
//            }
//
//        }
        
    }
    
    
    private func initHeader () {
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
        return self.phoneNumbers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.phoneNumbers[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.phoneNumberCellId) else { return UITableViewCell() }
        let pvo = self.phoneNumbers[indexPath.section][indexPath.row]
        cell.textLabel?.text = pvo.name!
        cell.detailTextLabel?.text = pvo.number!
        cell.textLabel?.font = getWMPRegular(size: (cell.textLabel?.font.pointSize)!)
        cell.detailTextLabel?.font = getWMPRegular(size: (cell.detailTextLabel?.font.pointSize)!)
        cell.selectionStyle = .default
        guard pvo.email != nil else {
            let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: Constant.phoneNumberCellId)
            cell.textLabel?.text = pvo.name!
            cell.detailTextLabel?.text = pvo.number!
            cell.textLabel?.font = getWMPRegular(size: (cell.textLabel?.font.pointSize)!)
            cell.detailTextLabel?.font = getWMPRegular(size: (cell.detailTextLabel?.font.pointSize)!)
            cell.selectionStyle = .default
            return cell
        }
        let accessory = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        accessory.setImage(UIImage(named: "envelope"), for: .normal)
        accessory.addTarget(self, action: #selector(accessoryTapped), for: .touchUpInside)
        cell.accessoryView = accessory
        return cell
        
    }
    
    @objc func accessoryTapped (_ sender: UIButton) {
        let buttonPosition : CGPoint = sender.convert(.zero, to: self.phoneNumberTableView)
        if let indexPath = self.phoneNumberTableView.indexPathForRow(at: buttonPosition) {
            let pvo = self.phoneNumbers[indexPath.section][indexPath.row]
            UIPasteboard.general.string = pvo.email
            self.showCopySuccessMsg()
        }
    }
    
    private func showCopySuccessMsg() {
        let copySucessView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: 40))
        copySucessView.center.x = self.view.frame.width / 2
        copySucessView.center.y = self.view.frame.height / 2
        copySucessView.backgroundColor = .lightGray
        copySucessView.layer.cornerRadius = copySucessView.frame.height / 2
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "Email has been copied!"
        label.textColor = .white
        label.sizeToFit()
        label.center.x = copySucessView.frame.width / 2
        label.center.y = copySucessView.frame.height / 2
        copySucessView.addSubview(label)
        self.view.addSubview(copySucessView)
        UIView.animate(withDuration: 1.7, delay: 0.3, options: [], animations: {
            copySucessView.alpha = 0.0
        }, completion: { _ in
            copySucessView.removeFromSuperview()
        })
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.phoneNumbers[section].first?.categoryToString()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pvo = phoneNumbers[indexPath.section][indexPath.row]
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
                alert("Couldn't bring the URL")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

