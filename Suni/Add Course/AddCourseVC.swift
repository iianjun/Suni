//
//  AddCourseVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/22.
//

import UIKit

class AddCourseVC: UIViewController {
    
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
        self.addGesture()
        self.tabBarController?.tabBar.isHidden = true
        self.initHeader()
        self.setupSegControl()
    }
    
    private func addGesture() {
        let dragLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back(_ :)))
        dragLeft.edges = UIRectEdge.left
        self.view.addGestureRecognizer(dragLeft)
    }
    
    private func initHeader() {
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
    
    private func setupSegControl () {
        //This makes segControl's background clear
        //Normal approach of self.segControl.backgroundColor = .clear dosen't work
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
                    self.alert("Cart is Empty!")
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
                
                //Sort After appending lab
                tempSelectedCourses.sort(by: {
                    if let firstEnd = $0.time?.end, let secondEnd = $1.time?.end {
                        return firstEnd < secondEnd
                    }
                    print("Error: On Sorting By End Time (Checking from cart courses)")
                    return true
                })
                if self.checkOverlaps(courses: &tempSelectedCourses) {
                    return
                }

                //MARK: Check From Existing Schedule Courses
                let  sd = UserDefaults.standard
                do {
                    var originalCourses = try sd.getObject(forKey: "course", castTo: [CourseVO].self)
                    originalCourses.append(contentsOf: tempSelectedCourses)
                    
                    if self.checkOverlaps(courses: &originalCourses) {
                        return
                    }
                    
                    //If everything is normal
                    do {
                        try sd.setObject(originalCourses, forKey: "course")
                    } catch {
                        print(error.localizedDescription)
                    }
                } catch {
                    print(error.localizedDescription)
                }
                self.navigationController?.popViewController(animated: true)
                self.tabBarController?.tabBar.isHidden = false
                sd.synchronize()
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
                    self.alert("No Selected days!")
                    return
                }
                if let startTime = mvc.fromTime.text ,let endTime = mvc.toTime.text {
                    
                    //No proper start and end time
                    if let stDate = dateFormatter.date(from: startTime), let etDate = dateFormatter.date(from: endTime) {
                        if stDate >= etDate {
                            self.alert("Start time and End time are not correct!")
                            return
                        }
                        dateInterval = DateInterval(start: stDate, end: etDate)
                    }
                }
                if let name = mvc.name_tf.text {
                    if name.isEmpty || name.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                        self.alert("Name of course is required!", completion: { mvc.name_tf.text = "" })
                        return
                    }
                    else if name.count > 10 {
                        self.alert("Please name less than 10 characters")
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
                    originalCourses.append(cvo)
                    
                    if checkOverlaps(courses: &originalCourses) {
                        return
                    }

                    do {
                        try sd.setObject(originalCourses, forKey: "course")
                    } catch {
                        print(error.localizedDescription)
                    }
                } catch {
                    print(error.localizedDescription)
                }
                self.navigationController?.popViewController(animated: true)
                self.tabBarController?.tabBar.isHidden = false
            }
        }
        else {
            NSLog("Error: Couldn't get proper segControl's index")
        }
        
          
    
    }
    
    private func checkOverlaps (courses : inout [CourseVO]) -> Bool {
        
        courses.sort(by: {
            if let firstEnd = $0.time?.end, let secondEnd = $1.time?.end {
                return firstEnd < secondEnd
            }
            print("Error: On Sorting By End Time (Checking from existing schedule courses)")
            return true
        })
        for i in 0..<courses.count - 1 {
            let firstCourse = courses[i]
            let secondCourse = courses[i+1]
            if let firstEnd = firstCourse.time?.end, let secondStart = secondCourse.time?.start, let firstDays = firstCourse.days, let secondDays = secondCourse.days {
                let hasOverlapDays = Set(firstDays).intersection(Set(secondDays)).count == 0 ? false : true
                if (firstEnd > secondStart) && hasOverlapDays {
                    if firstCourse.type == "REC" || firstCourse.type == "LAB" {
                        self.alert("\(firstCourse.name!)(\(firstCourse.type!))'s time overlaps with \(secondCourse.name!)! Please schedule again!")
                        return true
                    }
                    else if secondCourse.type == "REC" || secondCourse.type == "LAB" {
                        self.alert("\(firstCourse.name!)'s time overlaps with \(secondCourse.name!)(\(secondCourse.type!))! Please schedule again!")
                        return true
                    }
                    else {
                        self.alert("\(firstCourse.name!)'s time overlaps with \(secondCourse.name!)! Please schedule again!")
                        return true
                    }
                    
                }
            }
        }
        return false
    }
    @objc func back (_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
    

