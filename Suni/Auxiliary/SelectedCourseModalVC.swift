//
//  CSModalViewController.swift
//  Suni
//
//  Created by 전하성 on 2021/02/03.
//

import UIKit

class SelectedCourseModalVC: UIViewController {
    
    @IBOutlet var slideIndicator: UIView!
    
    var currentCourse : CourseVO!
    var infoLabels = ["Time", "Instructor", "Room"]
    var paramView : UIView!
    var paramSubviews : [UIView]!
    @IBOutlet var courseTitle: UILabel!
    @IBOutlet var infoTableView: UITableView!
    @IBOutlet var deleteBtn: UIButton!
    
    
    var hasSetPointOrigin = false
    var originPoint : CGPoint?
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        self.view.frame.size.height = UIScreen.main.bounds.height * 0.3
        self.setupGesture()
        self.setupInfo()
        self.setupDeleteBtn()
    }
    
    func setupGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureToDismiss(_:)))
        self.view.addGestureRecognizer(gesture)
        self.slideIndicator.backgroundColor = .gray
        self.slideIndicator.roundedCorners(.allCorners, radius: 10)
    }
    
    func setupInfo() {
        guard let currentCourseName = self.currentCourse.name else { return }
        guard let currentCourseType = self.currentCourse.type else { return }
        self.courseTitle.text = "\(currentCourseName)(\(currentCourseType))"
        self.courseTitle.font = getRigteous(size: 25)
        self.courseTitle.textColor = .themeTextColor
        
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        self.infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.infoCellId)
        self.infoTableView.bounces = false
        self.infoTableView.isScrollEnabled = false
        self.infoTableView.separatorStyle = .none
        
        
    }
    func setupDeleteBtn() {
        deleteBtn.setImage(UIImage(named: "trash"), for: .normal)
        self.view.addSubview(deleteBtn)
    }
    @IBAction func deleteCourse(_ sender: Any) {
        let alert = UIAlertController(title: "Do you really want to delete \(currentCourse.name!)?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let sd = UserDefaults.standard
            do {
                var selectedCourses = try sd.getObject(forKey: "course", castTo: [CourseVO].self)
                selectedCourses = selectedCourses.filter { $0 != self.currentCourse }
                if self.currentCourse.hasLab != nil {
                    if self.currentCourse.hasLab! {
                        selectedCourses = selectedCourses.filter {
                            if $0.type != nil && $0.name != nil {
                                return !($0.type == "REC" || $0.type == "LAB") && !($0.name == self.currentCourse.name)
                            }
                            return true

                        }
                        self.removeCourseView()
                    }

                }
                do {
                    try sd.setObject(selectedCourses, forKey: "course")
                    self.removeCourseView()
                    self.dismiss(animated: true, completion: nil)
                }
                catch {
                    print(error.localizedDescription)
                    self.dismiss(animated: true, completion: nil)
                }


            }
            catch {
                print(error.localizedDescription)
            }
        }))
        self.present(alert, animated: true, completion: nil)

    }
    func removeCourseView() {
//        let presentingVC = self.presentingViewController as? ScheduleVC
//        if let subviews = presentingVC?.collectionView.subviews {
//            for v in subviews {
//                if let courseView = v as? CourseTimetableView, let name = courseView.containedCourse.name {
//                    if name == self.currentCourse.name! {
//                        courseView.removeFromSuperview()
//                    }
//                }
//            }
//        }
        for v in paramSubviews {
            if let courseView = v as? CourseTimetableView, let name = courseView.containedCourse.name {
                if name == self.currentCourse.name! {
                    courseView.removeFromSuperview()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SelectedCourseModalVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: Constant.infoCellId)
        cell.selectionStyle = .none
        cell.textLabel?.text = self.infoLabels[indexPath.row]
        cell.textLabel?.textAlignment = .left
        cell.detailTextLabel?.textAlignment = .right
        cell.textLabel?.font = getRigteous(size: 17)
        cell.detailTextLabel?.font = getRigteous(size: 15)
        
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
