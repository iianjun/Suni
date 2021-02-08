//
//  AddCourseVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/22.
//

import UIKit

class AddCourseVC: UIViewController {
    
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var segControl: UISegmentedControl!
    let segIndicator = UIView()
    var courseVC : CourseVC?
    var manualVC : ManualVC?

    @IBOutlet var saveBtn: UIBarButtonItem!
    override func viewDidLoad() {
        self.setup()
    }
    
    func setupSegControl () {
        let clearImage = UIImage(color: .clear, size: CGSize(width: 1, height: self.segControl.frame.height))
        self.segControl.setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
        self.segControl.setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        self.segControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor : UIColor.lightGray,
            NSAttributedString.Key.font : getRigteous(size: 20)
        ], for: .normal)
        self.segControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor : UIColor.themeTextColor,
            NSAttributedString.Key.font : getRigteous(size: 20)
        ], for: .selected)

        self.segIndicator.backgroundColor = .themeTextColor
        self.segControl.addSubview(self.segIndicator)
        self.segIndicator.frame = CGRect(x: 0, y: self.segControl.frame.height - 5, width: self.view.frame.width / 2, height: 5)
        self.segControl.selectedSegmentIndex = 0
        self.firstView.isHidden = false
        self.secondView.isHidden = true
        

    }
    @IBAction func indexChange(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3, animations: {
            switch sender.selectedSegmentIndex {
            case 0:
                self.segIndicator.frame.origin.x -= self.segIndicator.frame.width
                self.firstView.isHidden = false
                self.secondView.isHidden = true

            case 1:
                self.segIndicator.frame.origin.x += self.segIndicator.frame.width
                self.firstView.isHidden = true
                self.secondView.isHidden = false

            default : break;
            }
        })
    }
    
    func setup() {
        self.addGesture()
        self.tabBarController?.tabBar.isHidden = true
        self.initHeader()
        self.setupSegControl()

        
    }
    func addGesture() {
        let dragLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back(_ :)))
        dragLeft.edges = UIRectEdge.left
        self.view.addGestureRecognizer(dragLeft)
        
        
    }

    
    func initHeader() {
        let viewTitle = UILabel()
        viewTitle.text = "Add Course"
        viewTitle.font = getRigteous(size: Constant.titleFontSize)
        viewTitle.sizeToFit()
        viewTitle.textColor = .themeColor
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "back.png"), for: .normal)
        backBtn.addTarget(self, action: #selector(back(_ :)), for: .touchUpInside)
        backBtn.sizeToFit()
        backBtn.frame.size.height = viewTitle.frame.height
        
        let comBinedView = UIView(frame: CGRect(x: 0, y: 0, width: viewTitle.frame.width + backBtn.frame.width + Constant.freeSpaceBtwBackAndTitle, height: viewTitle.frame.height))
        viewTitle.frame.origin.x = backBtn.frame.width + Constant.freeSpaceBtwBackAndTitle
        comBinedView.addSubview(backBtn)
        comBinedView.addSubview(viewTitle)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: comBinedView)

        self.saveBtn.title = "Save"
        self.saveBtn.setTitleTextAttributes([
            NSAttributedString.Key.font : self.getRigteous(size: 17),
            NSAttributedString.Key.foregroundColor : UIColor.themeTextColor
        ], for: .normal)
        self.saveBtn.setTitleTextAttributes([
            NSAttributedString.Key.font : self.getRigteous(size: 17),
            NSAttributedString.Key.foregroundColor : UIColor.themeTextColor
        ], for: .highlighted)
        
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        if self.segControl.selectedSegmentIndex == 0 {
            if let cvc = self.courseVC  {
                if cvc.selectedCourses.isEmpty {
                    self.alert("Cart is Empty!")
                    return
                }
                else {
                    //Need to Refactor
                    for i in 0..<cvc.selectedCourses.count {
                        for j in i + 1..<cvc.selectedCourses.count {
                            let firstCourse = cvc.selectedCourses[i]
                            let secondCourse = cvc.selectedCourses[j]
                            if let firstTime = firstCourse.time, let secondTime = secondCourse.time, let firstDays = firstCourse.days, let secondDays = secondCourse.days {
                                let hasOverlapDays = firstDays.filter { secondDays.contains($0) == true }.count == 0 ? false : true
                                if firstTime.intersects(secondTime) && hasOverlapDays {
                                    self.alert("\(firstCourse.name!)'s time overlaps with \(secondCourse.name!)! Please schedule again!")
                                    return
                                }
                            }
                        }
        
                    }
                }
                //If each course has lab, append to selected Courses
                for course in cvc.selectedCourses {
                    if course.hasLab! {
                        if course.number != nil {
                            let additionalCourse = cvc.additionalCourses.filter { $0.name == course.name && $0.number == course.number }
                            if additionalCourse.count > 1 {
                                print("Error: additionalCourse > 1")
                            }
                            cvc.selectedCourses.append(additionalCourse[0])
                        }
                        else {
                            let additionalCourse = cvc.additionalCourses.filter { $0.name == course.name }
                            if additionalCourse.count > 1 {
                                print("Error: additionalCourse > 1")
                            }
                            cvc.selectedCourses.append(additionalCourse[0])
        
                        }
                    }
                }
        
                //original
                let  sd = UserDefaults.standard
                //If original courses exist
                do {
        
                    let originalCourses = try sd.getObject(forKey: "course", castTo: [CourseVO].self)
                    //Check anything overlaps
                    for i in 0..<originalCourses.count {
                        for j in 0..<cvc.selectedCourses.count {
                            let firstCourse = originalCourses[i]
                            let secondCourse = cvc.selectedCourses[j]
                            if let firstTime = firstCourse.time, let secondTime = secondCourse.time, let firstDays = firstCourse.days, let secondDays = secondCourse.days {
                                let hasOverlapDays = firstDays.filter { secondDays.contains($0) == true }.count == 0 ? false : true
                                if firstTime.intersects(secondTime) && hasOverlapDays {
                                    alert("\(firstCourse.name!)'s time overlaps with \(secondCourse.name!)! Please schedule again!")
                                    if secondCourse.type! == "LEC" || secondCourse.type! == "REC" {
                                        cvc.selectedCourses.remove(at: j)
                                    }
                                    return
                                }
                            }
                        }
                    }
                    //If not append to orignal courses
                    cvc.selectedCourses.append(contentsOf: originalCourses)
                    do {
                        try sd.setObject(cvc.selectedCourses, forKey: "course")
                        self.navigationController?.popViewController(animated: true)
                        self.tabBarController?.tabBar.isHidden = false
                        return
        
                    } catch {
                        print(error.localizedDescription)
                    }
        
                } catch {
                    print(error.localizedDescription)
                }
        
                //If it doesn't exist
                do {
                    try sd.setObject(cvc.selectedCourses, forKey: "course")
                } catch {
                    print(error.localizedDescription)
                }
        
        
                self.navigationController?.popViewController(animated: true)
                self.tabBarController?.tabBar.isHidden = false
            }
            
            
        }
        else if self.segControl.selectedSegmentIndex == 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            var dateInterval = DateInterval()
            if let mvc = self.manualVC {
                if mvc.selectedDays.isEmpty {
                    self.alert("No Selected days!")
                    return
                }
                if let startTime = mvc.fromTime.text ,let endTime = mvc.toTime.text {
                    
                    if let stDate = dateFormatter.date(from: startTime), let etDate = dateFormatter.date(from: endTime) {
                        print(stDate)
                        print(etDate)
                        if stDate >= etDate {
                            self.alert("Start time and End time are not correct!")
                            return
                        }
                        dateInterval = DateInterval(start: stDate, end: etDate)
                    }
                }
                if let name = mvc.name_tf.text {
                    if name.isEmpty {
                        self.alert("Name of course is required!")
                        return
                    }
                }
                
                let cvo = CourseVO()
                cvo.name = mvc.name_tf.text
                cvo.room = mvc.room_tf.text
                cvo.instructor = mvc.instructor_tf.text
                cvo.days = mvc.selectedDays
                cvo.time = dateInterval
                cvo.type = "MANUAL"
                
                let sd = UserDefaults.standard
                do {
                    var originalCourses = try sd.getObject(forKey: "course", castTo: [CourseVO].self)
                    
                    for i in 0..<originalCourses.count {
                        let firstCourse = originalCourses[i]
                        if let firstTime = firstCourse.time, let secondTime = cvo.time, let firstDays = firstCourse.days, let secondDays = cvo.days {
                            let hasOverlapDays = firstDays.filter { secondDays.contains($0) == true }.count == 0 ? false : true
                            if firstTime.intersects(secondTime) && hasOverlapDays {
                                self.alert("\(firstCourse.name!)'s time overlaps with \(cvo.name!)! Please schedule again!")
                                return
                            }
                        }
                    }
                    originalCourses.append(cvo)
                    
                    do {
                        try sd.setObject(originalCourses, forKey: "course")
                        self.navigationController?.popViewController(animated: true)
                        self.tabBarController?.tabBar.isHidden = false
                        return
                    } catch {
                        print(error.localizedDescription)
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                do {
                    try sd.setObject([cvo], forKey: "course")
                } catch {
                    print(error.localizedDescription)
                }
                self.navigationController?.popViewController(animated: true)
                self.tabBarController?.tabBar.isHidden = false
            }
        }
    }

    
    @objc func back (_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sugue_courseVC" {
            if let courseVC = segue.destination as? CourseVC {
                self.courseVC = courseVC

            }
        }
        else if segue.identifier == "segue_manualVC" {
            if let manualVC = segue.destination as? ManualVC {
                self.manualVC = manualVC
            }
        }
    }
    

    
}
    

