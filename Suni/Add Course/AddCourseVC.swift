//
//  AddCourseVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/22.
//

import UIKit

class AddCourseVC: UIViewController, UIGestureRecognizerDelegate {
    
    //CourseView
    @IBOutlet var firstView: UIView!
    //Manual Add View
    @IBOutlet var secondView: UIView!
    
    @IBOutlet var segControl: UISegmentedControl!
    private let segIndicator = UIView()
    private var courseVC : CourseVC?
    private var manualVC : ManualVC?

    @IBOutlet var saveBtn: UIBarButtonItem!
    
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
    
    override func viewDidLoad() {
        self.setup()
    }
    private func setup() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.initHeader()
        self.setupSegControl()
    }
    
    private func initHeader() {
        let viewTitle = UILabel()
        viewTitle.text = "Add Course".localized
        viewTitle.font = localizedFont(size: Constant.titleFontSize)
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

        self.saveBtn.title = "Save".localized
        self.saveBtn.setTitleTextAttributes([
            NSAttributedString.Key.font : self.localizedFont(size: 17),
            NSAttributedString.Key.foregroundColor : UIColor.themeTextColor
        ], for: .normal)
        self.saveBtn.setTitleTextAttributes([
            NSAttributedString.Key.font : self.localizedFont(size: 17),
            NSAttributedString.Key.foregroundColor : UIColor.themeTextColor
        ], for: .highlighted)
        
    }
    
    private func setupSegControl () {
        //This makes segControl's background clear
        //Normal approach of self.segControl.backgroundColor = .clear dosen't work
        let clearImage = UIImage(color: .clear, size: CGSize(width: 1, height: self.segControl.frame.height))
        self.segControl.setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
        self.segControl.setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        self.segControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor : UIColor.lightGray,
            NSAttributedString.Key.font : self.localizedFont(size: 20)
        ], for: .normal)
        self.segControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor : UIColor.themeTextColor,
            NSAttributedString.Key.font : self.localizedFont(size: 20)
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

    @IBAction func saveClicked(_ sender: Any) {
        
        //MARK: Save From Course Container View
        if self.segControl.selectedSegmentIndex == 0 {
            if let cvc = self.courseVC  {
                
                //MARK: Checking inside Cart Courses
                //Append the lab first
                //To Prevent changing order of cvc.selectedCoruses
                var tempSelectedCourses = cvc.selectedCourses
                //If selected Courses has course that has lab or rec
                if tempSelectedCourses.isEmpty {
                    self.alert("Cart is Empty!".localized, message: "Selected at least one course".localized)
                    return
                }
                for course in tempSelectedCourses {
                    if course.hasLab! {
                        if course.number != nil {
                            let additionalCourse = cvc.additionalCourses.filter { $0.name == course.name && $0.number == course.number }
                            if additionalCourse.count > 1 {
                                print("Error: additionalCourse > 1")
                                return
                            }
                            tempSelectedCourses.append(additionalCourse[0])
                        }
                        else {
                            let additionalCourse = cvc.additionalCourses.filter { $0.name == course.name }
                            if additionalCourse.count > 1 {
                                print("Error: additionalCourse > 1")
                                return
                            }
                            tempSelectedCourses.append(additionalCourse[0])
                        }
                    }
                }
                
                //After appending lab
                if self.checkOverlaps(courses: tempSelectedCourses) {
                    return
                }

                //MARK: Check From Existing Schedule Courses
                let  ud = UserDefaults.standard
                do {
                    var originalCourses = try ud.getObject(forKey: "course", castTo: [CourseVO].self)
                    originalCourses.append(contentsOf: tempSelectedCourses)
                    
                    if self.checkOverlaps(courses: originalCourses) {
                        return
                    }
                    
                    //If everything is normal
                    do {
                        try ud.setObject(originalCourses, forKey: "course")
                    } catch {
                        print(error.localizedDescription)
                    }
                } catch {
                    print(error.localizedDescription)
                }
                self.navigationController?.popViewController(animated: true)
                ud.synchronize()
            }
        }

        //MARK: Save From Manual Add Container View
        else if self.segControl.selectedSegmentIndex == 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            var dateInterval = DateInterval()
            
            //No selected days
            if let mvc = self.manualVC {
                if mvc.selectedDays.isEmpty {
                    self.alert("No Selected days!".localized)
                    return
                }
                if let startTime = mvc.fromTime.text ,let endTime = mvc.toTime.text {
                    
                    //No proper start and end time
                    if let stDate = dateFormatter.date(from: startTime), let etDate = dateFormatter.date(from: endTime) {
                        if stDate >= etDate {
                            self.alert("Start time and End time are not correct!".localized)
                            return
                        }
                        dateInterval = DateInterval(start: stDate, end: etDate)
                    }
                }
                if let name = mvc.name_tf.text {
                    if name.isEmpty || name.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                        self.alert("Name of course is required!".localized, message: "Please enter the name".localized, completion: { mvc.name_tf.text = "" })
                        return
                    }
                    else if name.count > 10 {
                        self.alert("Name should be less than 10 characters".localized)
                        return
                    }
                }
                if let room = mvc.room_tf.text {
                    if room.count > 10 {
                        self.alert("Room should be less than 10 characters".localized)
                        return
                    }
                }
                let cvo = CourseVO()
                cvo.major = ""
                cvo.name = mvc.name_tf.text
                cvo.room = mvc.room_tf.text
                cvo.title = ""
                cvo.type = "MANUAL"
                cvo.credit = 0
                cvo.days = mvc.selectedDays
                cvo.time = dateInterval
                cvo.instructor = mvc.instructor_tf.text
                cvo.hasLab = false
                
                
                
                
                
                
                let ud = UserDefaults.standard
                do {
                    var originalCourses = try ud.getObject(forKey: "course", castTo: [CourseVO].self)
                    originalCourses.append(cvo)
                    
                    if checkOverlaps(courses: originalCourses) {
                        return
                    }

                    do {
                        try ud.setObject(originalCourses, forKey: "course")
                    } catch {
                        print(error.localizedDescription)
                    }
                } catch {
                    print(error.localizedDescription)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            NSLog("Error: Couldn't get proper segControl's index")
        }
        
          
    
    }
    
    private func checkOverlaps (courses : [CourseVO]) -> Bool {

        for i in 0..<courses.count {
            for j in i + 1..<courses.count {
                let firstCourse = courses[i]
                let secondCourse = courses[j]
                if let firstTime = firstCourse.time, let secondTime = secondCourse.time, let firstDays = firstCourse.days, let secondDays = secondCourse.days {
                    let hasOverlapDays = Set(firstDays).intersection(Set(secondDays)).count == 0 ? false : true
                    if firstTime.intersects(secondTime) && hasOverlapDays {
                        if firstCourse.type == "REC" || firstCourse.type == "LAB" {
                            self.alert("[Time Overlaps]".localized, message: String(format: "%@(%@)'s time overlaps with %@!".localized, firstCourse.name!, firstCourse.type!,secondCourse.name!))
    //                        self.alert(String(format: "%@(%@)'s time overlaps with %@! Please schedule again!".localized, [firstCourse.name!, firstCourse.type!, secondCourse.name!]))
                            return true
                        }
                        
                        else if secondCourse.type == "REC" || secondCourse.type == "LAB" {
    //                        let textt = String(format: "%@'s time overlaps with %@(%@)! Please schedule again!".localized, [firstCourse.name!, secondCourse.name!, secondCourse.type!])
                            self.alert("[Time Overlaps]".localized, message: String(format: "%@'s time overlaps with %@(%@)!".localized, firstCourse.name!, secondCourse.name!,secondCourse.type!))
                            
                            return true
                        }
                        else if (firstCourse.type == "REC" || firstCourse.type == "LAB") && (secondCourse.type == "REC" || secondCourse.type == "LAB") {
                            self.alert("[Time Overlaps]".localized, message: String(format: "%@(%@)'s time overlaps with %@(%@)!".localized, firstCourse.name!, firstCourse.type!, secondCourse.name!, secondCourse.type!))
                            return true
                        }
                        else {
                            self.alert("[Time Overlaps]".localized, message: String(format: "%@'s time overlaps with %@!".localized, firstCourse.name!, secondCourse.name!))
                            return true
                        }
                    }
                    
                }
                
            }
        }
        return false
    }
    @objc func back (_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
    

