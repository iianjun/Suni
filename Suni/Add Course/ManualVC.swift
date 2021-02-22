//
//  ManualVC.swift
//  Suni
//
//  Created by 전하성 on 2021/02/07.
//

import UIKit

class ManualVC: UIViewController {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var dayCollectionView: UICollectionView!
    @IBOutlet var manualCourseView: UIView!
    @IBOutlet var fromTime: UITextField!
    @IBOutlet var toTime: UITextField!
    @IBOutlet var name_tf: UITextField!
    @IBOutlet var room_tf: UITextField!
    @IBOutlet var instructor_tf: UITextField!
    @IBOutlet weak var hyphen: UILabel!
    
    private var days = ["MON", "TUE", "WED" , "THU", "FRI"]
    public var selectedDays : [String] = []

    override func viewDidLoad() {
        self.setup()
    }
    
    private func setup() {
        self.dayLabel.text = "Day".localized
        self.dayLabel.textColor = .themeColor
        self.dayLabel.font = self.localizedFont(size: self.dayLabel.font.pointSize)
        self.dayLabel.textAlignment = .center
        self.dayCollectionView.delegate = self
        self.dayCollectionView.dataSource = self
        self.dayCollectionView.bounces = false
        self.dayCollectionView.isScrollEnabled = false
        self.dayCollectionView.allowsMultipleSelection = true
        
        self.setupTimetf()
        self.setupInfoTf()
        
    }
    
    private func setupTimetf() {
        self.hyphen.textColor = .themeTextColor
        self.fromTime.borderStyle = .none
        self.toTime.borderStyle = .none
        self.fromTime.layer.borderColor = UIColor.themeColor.cgColor
        self.toTime.layer.borderColor = UIColor.themeColor.cgColor
        self.fromTime.layer.borderWidth = Constant.addCourseCellBorderWidth
        self.toTime.layer.borderWidth = Constant.addCourseCellBorderWidth
        self.fromTime.layer.cornerRadius = Constant.cornerRadius
        self.toTime.layer.cornerRadius = Constant.cornerRadius
        
        self.fromTime.text = "09:00"
        self.toTime.text = "10:00"
        self.fromTime.textAlignment = .center
        self.toTime.textAlignment = .center
        self.fromTime.font = getRighteous(size: 20)
        self.toTime.font = getRighteous(size: 20)
        self.fromTime.textColor = .themeTextColor
        self.toTime.textColor = .themeTextColor
        
        self.fromTime.tintColor = .clear
        self.toTime.tintColor = .clear
        
        self.fromTime.addInputViewDatePicker(target: self, selector: #selector(fromTimeDone(_:)))
        self.toTime.addInputViewDatePicker(target: self, selector: #selector(toTimeDone(_:)))
     
    }

    @objc private func fromTimeDone(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let datePicker = self.fromTime.inputView as? UIDatePicker {
            self.fromTime.text = dateFormatter.string(from: datePicker.date)
            self.fromTime.resignFirstResponder()
        }
    }
    @objc private func toTimeDone(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let datePicker = self.toTime.inputView as? UIDatePicker {
            
            self.toTime.text = dateFormatter.string(from: datePicker.date)
            self.toTime.resignFirstResponder()
        }
    }
    private func setupInfoTf () {
        let arrTf = [self.name_tf, self.room_tf, self.instructor_tf]
        self.name_tf.placeholder = "Name(Required)".localized
        self.room_tf.placeholder = "Room(Optional)".localized
        self.instructor_tf.placeholder = "Instructor(Optional)".localized
        
        for tf in arrTf {
            tf?.borderStyle = .none
            tf?.layer.borderWidth = Constant.addCourseCellBorderWidth
            tf?.layer.borderColor = UIColor.themeColor.cgColor
            tf?.layer.cornerRadius = Constant.cornerRadius
            tf?.font = self.localizedFont(size: tf?.font?.pointSize ?? 18)
            tf?.textColor = .themeTextColor
            tf?.clearButtonMode = .whileEditing
            tf?.autocapitalizationType = .none
            tf?.autocorrectionType = .no
            tf?.returnKeyType = .done
            tf?.spellCheckingType = .no
            tf?.delegate = self
        }
        
    }
}

//MARK: Collection View Delegate & Data Source
extension ManualVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.addCourseCellId, for: indexPath) as! AddCourseCell
        cell.label?.text = self.days[indexPath.row]
        if cell.frame.width < 45 {
            cell.label?.font = getRighteous(size: 15)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AddCourseCell {
            cell.backgroundColor = .themeColor
            self.selectedDays.append(self.days[indexPath.row])
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AddCourseCell {
            cell.backgroundColor = .white
     
            if let index = self.selectedDays.firstIndex(of: days[indexPath.row]) {
                self.selectedDays.remove(at: index)
            } else { return }
        }
    }
    
}

//MARK: Collection View Delegate Flow Layout
extension ManualVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / (CGFloat(self.days.count)) - Constant.freeSpaceBtwCollectionView, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.freeSpaceBtwCollectionView
    }
}


//MARK: UITextField Delegate
extension ManualVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
class Textfield : UITextField {
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
