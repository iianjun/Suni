//
//  CSModalViewController.swift
//  Suni
//
//  Created by 전하성 on 2021/02/03.
//

import UIKit

class SelectedCourseModalVC: UIViewController {
    
    @IBOutlet var slideIndicator: UIView!
    
    public var currentCourse : CourseVO!
    private var infoLabels = ["Time", "Instructor", "Room"]
    public var paramView : UIView!
    public var paramSubviews : [UIView]!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var courseTitle: UILabel!
    @IBOutlet var infoTableView: UITableView!
    @IBOutlet var deleteBtn: UIButton!
    
    
    private var hasSetPointOrigin = false
    private var originPoint : CGPoint?
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        self.view.frame.size.height = UIScreen.main.bounds.height * 0.3
        self.setupGesture()
        self.setupInfo()
        self.setupDeleteBtn()
    }
    
    private func setupGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureToDismiss(_:)))
        self.view.addGestureRecognizer(gesture)
        self.slideIndicator.backgroundColor = .gray
        self.slideIndicator.roundedCorners(.allCorners, radius: 10)
    }
    
    private func setupInfo() {
        guard let currentCourseName = self.currentCourse.name else { return }
        guard let currentCourseType = self.currentCourse.type else { return }
        self.courseTitle.text = "\(currentCourseName) (\(currentCourseType))"
        self.courseTitle.font = localizedFont(size: 25)
        self.courseTitle.textColor = .themeTextColor
        
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        self.infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.infoCellId)
        self.infoTableView.bounces = false
        self.infoTableView.isScrollEnabled = false
        self.infoTableView.separatorStyle = .none

    }
    private func setupDeleteBtn() {
        deleteBtn.setImage(UIImage(named: "trash"), for: .normal)
        self.view.addSubview(deleteBtn)
    }
    @IBAction func deleteCourse(_ sender: Any) {
        let alert = UIAlertController(title: String(format: "Do you really want to delete %@?".localized, currentCourse.name!), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
            //When the course is removed, I need to reset,
            //1. course.bgColor = nil
            //2. when removing rec or lab, the course that has that rec or lab should be also removed.
            //3. vise versa from #2
            
            //Initialization
            let ud = UserDefaults.standard
            if self.currentCourse.type == "MANUAL" {
                self.currentCourse.bgColor.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                if let index = self.appDelegate.existedCourses.firstIndex(where: { $0 == self.currentCourse }) {
                    self.appDelegate.existedCourses.remove(at: index)
                    self.removeCourseView()
                }
            }
            else {
                self.appDelegate.existedCourses.forEach({
                    if $0.name == self.currentCourse.name  && $0.type != "MANUAL" {
                        $0.bgColor.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                    }
                })
                self.appDelegate.existedCourses.removeAll(where: { $0.name == self.currentCourse.name && $0.type != "MANUAL" })
                self.removeCourseView()
            }
            do {
                try ud.setObject(self.appDelegate.existedCourses, forKey: "course")
                
            } catch {
                print(error.localizedDescription)
            }
//            print("MODAL VC")
//            self.appDelegate.existedCourses.forEach {
//                print("----------\($0.name!) (\($0.type!))")
//            }
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    private func removeCourseView() {
        if self.currentCourse.type == "MANUAL" {
            for v in paramSubviews {
                if let courseView = v as? CourseTimetableView {
                    if courseView.containedCourse == self.currentCourse {
                        courseView.removeFromSuperview()
                    }
                }
            }
        }
        
        //Regardless the type, if name matches, delete it
        else {
            for v in paramSubviews {
                if let courseView = v as? CourseTimetableView, let name = courseView.containedCourse.name {
                    if name == self.currentCourse.name! && courseView.containedCourse.type != "MANUAL" {
                        courseView.removeFromSuperview()
                    }
                }
            }
        }
        
    }
    override func viewDidLayoutSubviews() {
        if !self.hasSetPointOrigin {
            self.hasSetPointOrigin.toggle()
            self.originPoint = self.view.frame.origin
        }
    }
    
    
    @objc func panGestureToDismiss (_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        guard translation.y >= 0 else { return }
        self.view.frame.origin = CGPoint(x: 0, y: self.originPoint!.y + translation.y)
        
        if sender.state == .ended {
            let dragVel = sender.velocity(in: self.view)
            if dragVel.y >= 1000 {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame.origin = self.originPoint ?? CGPoint(x: 0, y: 400)
                })
            }
        }
        
    }

}
extension SelectedCourseModalVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: Constant.infoCellId)
        cell.selectionStyle = .none
        cell.textLabel?.text = self.infoLabels[indexPath.row].localized
        cell.textLabel?.textAlignment = .left
        cell.detailTextLabel?.textAlignment = .right
        print()
        cell.textLabel?.font = self.localizedFont(size: (cell.textLabel?.font.pointSize)!)
        cell.detailTextLabel?.font = getRighteous(size: 15)
        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = self.currentCourse.convertTimeAndDayToString()
        case 1:
            cell.detailTextLabel?.text = self.currentCourse.instructor
        case 2:
            cell.detailTextLabel?.text = self.currentCourse.room
        default : break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.infoTableView.frame.height / 3
    }
    
    
    
    
}
