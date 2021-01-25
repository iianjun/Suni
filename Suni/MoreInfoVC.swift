//
//  MoreInfoVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/25.
//

import UIKit

class MoreInfoVC: UIViewController {
    
    @IBOutlet var courseTitle: UILabel!
    var params : NSDictionary!
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
        self.courseTitle.text = params["name"] as? String ?? ""
        self.courseTitle.textColor = .themeTextColor
        self.paramTime.text = params["time"] as? String ?? ""
        self.paramTime.textColor = .themeTextColor
        self.paramRoom.text = params["room"] as? String ?? ""
        self.paramRoom.textColor = .themeTextColor
        self.paramCredit.text = "\(params["credit"] as? String ?? "") credit"
        self.paramCredit.textColor = .themeTextColor
        self.paramInstructor.text = params["instructor"] as? String ?? ""
        self.paramInstructor.textColor = .themeTextColor
        self.paramLink.setTitle(params["link"] as? String ?? "", for: .normal)
        self.paramLink.titleLabel?.numberOfLines = 0

        // Do any additional setup after loading the view.
    }
    @IBAction func clickedLink(_ sender: Any) {
        guard let wvc = self.storyboard?.instantiateViewController(identifier: Constant.webVCId) as? WebCourseInfoVC else { return }
        wvc.paramURL = self.params["link"] as? String ?? ""
        wvc.paramTitle = self.params["name"] as? String ?? ""
        self.presentingViewController?.dismiss(animated: true, completion: nil)
//        wvc.present(wvc, animated: true, completion: nil)
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
