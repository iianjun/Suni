//
//  MoreInfoVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/25.
//

import UIKit

class MoreInfoVC: UIViewController {
    
    @IBOutlet var courseNameLabel: UILabel!
    var params : CourseVO!
    var labCourse : CourseVO?
    @IBOutlet var paramTime: UILabel!
    @IBOutlet var paramRoom: UILabel!
    @IBOutlet var paramCredit: UILabel!
    @IBOutlet var paramInstructor: UILabel!
    @IBOutlet var labelContainerView: [UIView]!
    @IBOutlet var courseTitleLabel: UILabel!
    @IBOutlet var paramLink: UIButton!
    @IBOutlet var hasLabView: UIView!
    @IBOutlet var labTitleLabel: UILabel!
    @IBOutlet var labTimeLabel: UILabel!
    
    override func viewDidLoad() {
        for cv in labelContainerView {
            cv.layer.borderWidth = Constant.addCourseCellBorderWidth
            cv.layer.cornerRadius = Constant.moreVCCornerRadius
            cv.layer.borderColor = UIColor.themeColor.cgColor

        }
        if labCourse != nil {
            if let type = self.labCourse?.type {
                switch type {
                case "LAB" : self.labTitleLabel.text = type
                case "REC" : self.labTitleLabel.text = "Recitation"
                default : break
                }
            }
            self.labTimeLabel.text = labCourse?.convertTimeAndDayToString()
            self.labTimeLabel.textColor = .themeTextColor
            self.hasLabView.layer.borderColor = UIColor.themeColor.cgColor
            self.hasLabView.layer.cornerRadius = Constant.moreVCCornerRadius
            self.hasLabView.layer.borderWidth = Constant.addCourseCellBorderWidth
        }
        else {
            self.hasLabView.isHidden = true
        }
        self.courseNameLabel.text = self.params.name
        self.courseTitleLabel.text = self.params.title
        self.courseTitleLabel.numberOfLines = 0
        self.courseTitleLabel.textColor = .themeTextColor
        self.courseTitleLabel.textAlignment = .center
        self.courseNameLabel.sizeToFit()
        
        self.paramTime.text = params.convertTimeAndDayToString()
        self.paramTime.textColor = .themeTextColor
        self.paramTime.numberOfLines = 0
        self.paramRoom.text = self.params.room
        self.paramRoom.textColor = .themeTextColor
        self.paramCredit.text = "\(params.credit!) credit"
        self.paramCredit.textColor = .themeTextColor
        
        self.paramInstructor.text = self.params.instructor
        self.paramInstructor.textColor = .themeTextColor
       
        let link = self.params.link
        if link == "" {
            self.paramLink.setTitle("No Website", for: .normal)
            self.paramLink.isEnabled = false
        }
        else {
            self.paramLink.setTitle(link, for: .normal)
            self.paramLink.titleLabel?.numberOfLines = 0
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
extension MoreInfoVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_detail" {
            let webVC = segue.destination as? WebCourseInfoVC
            webVC?.paramURL = self.params.link
            webVC?.paramTitle = self.params.name

        }
    }
}
