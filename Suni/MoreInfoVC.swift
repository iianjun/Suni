//
//  MoreInfoVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/25.
//

import UIKit

class MoreInfoVC: UIViewController {
    
    @IBOutlet var courseTitle: UILabel!
    var params : CourseVO!
    @IBOutlet var paramTime: UILabel!
    @IBOutlet var paramRoom: UILabel!
    @IBOutlet var paramCredit: UILabel!
    @IBOutlet var paramInstructor: UILabel!
    @IBOutlet var labelContainerView: [UIView]!
    @IBOutlet var paramLink: UIButton!
    
    override func viewDidLoad() {
        for cv in labelContainerView {
            cv.layer.borderWidth = Constant.addCourseCellBorderWidth
            cv.layer.cornerRadius = Constant.moreVCCornerRadius
            cv.layer.borderColor = UIColor.themeColor.cgColor

        }
        self.courseTitle.text = self.params.name
        self.courseTitle.textColor = .themeTextColor
        
        var courseTime = ""
        if let days = params.days {
            for i in 0..<days.count {
                courseTime += days[i]
                if i + 1 != days.count {
                    courseTime += "/"
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let startDate = params.time?.start, let endDate = params.time?.end {
            let startTime = dateFormatter.string(from: startDate)
            let endTime = dateFormatter.string(from: endDate)
            self.paramTime.text = "\(courseTime) \(startTime)-\(endTime)"
        }
        else {
            self.paramTime.text = ""
        }
 
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
