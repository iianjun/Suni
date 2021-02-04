//
//  ScheduleVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/20.
//

import UIKit

@IBDesignable
class ScheduleVC : UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var remainingBackgroundColor = UIColor.pastel
    
    var existedView : [CourseTimetableView] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    var cellWidth : CGFloat {
        get {
            return self.collectionView.frame.width / 6
        }
    }
    var cellHeight : CGFloat {
        get {
            return self.collectionView.frame.height / 13 - (cellWidth / 26)
        }
    }
    override func viewDidLoad() {
        
        self.setup()
        
    }
    
    func setup() {
        self.initHeader()
        self.initTimetable()

    }
    override func viewDidAppear(_ animated: Bool) {
        let sd = UserDefaults.standard
        do {

            let selectedCourses = try sd.getObject(forKey: "course", castTo: [CourseVO].self)
            
            for course in selectedCourses {
                //여기서
                if !appDelegate.existedCourses.contains(course) {
                    for day in course.days! {
                        
                        let row = convertStringToRow(day: day)
                        let startTime = convertDateToString(time: course.time!.start)
                        let section = convertStringToSection(time: String(startTime.split(separator: ":")[0]))
                        
                        let x = CGFloat((course.time?.duration)!) / CGFloat(3600)
                        let lectureHeight = ((x * 10).rounded() / 10) * cellHeight
                        
                        var min = Double(startTime.split(separator: ":")[1])!
                        min /= 60.0
                        
                        guard let cell = self.collectionView.cellForItem(at: IndexPath(row: row, section: section)) else { return }
                        let v = CourseTimetableView(frame: CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y + (cellHeight * CGFloat(min)), width: self.cellWidth - Constant.timetableBorderWidth, height: lectureHeight))
                        v.label.text = course.name!
                        v.label.textColor = .themeTextColor
                        v.containedCourse = course
                        if course.bgColor.color != UIColor(red: 0, green: 0, blue: 0, alpha: 0) {
                            v.backgroundColor = course.bgColor.color
                        }
                        
                        else {
                            let ranColor = remainingBackgroundColor.removeFirst()
                            v.backgroundColor = ranColor
                            course.bgColor.color = ranColor
                        }
                        
                        v.isUserInteractionEnabled = true
                        let gesture = UITapGestureRecognizer(target: self, action: #selector(presentDetailViewOfSelectedCourse(_ :)))
                        v.addGestureRecognizer(gesture)
                        
                        self.collectionView.addSubview(v)
                        self.collectionView.bringSubviewToFront(v)
                        
                        

                    }
                    
                    appDelegate.existedCourses.append(course)
                }

            }
            sd.synchronize()

        } catch {
            print(error.localizedDescription)
        }

    }
    @objc func presentDetailViewOfSelectedCourse(_ sender : UIGestureRecognizer) {
        if let v = sender.view as? CourseTimetableView {
            let customModalVC = SelectedCourseModalVC()
            customModalVC.paramView = v
            customModalVC.paramSubviews = self.collectionView.subviews
            customModalVC.currentCourse = v.containedCourse
            customModalVC.modalPresentationStyle = .custom
            customModalVC.transitioningDelegate = self
            self.present(customModalVC, animated: true, completion: nil)
//    
//            moreInfoVC.modalPresentationStyle = .custom
//            moreInfoVC.transitioningDelegate = self
//            self.navigationController?.pushViewController(moreInfoVC, animated: true)
        }
    }
    //MARK: Header init
    func initHeader() {
        
        //Title left alignment
        let viewTitle = UILabel()
        viewTitle.text = "My Schedule"
        viewTitle.font = getRigteous(size: Constant.titleFontSize)
        
        viewTitle.sizeToFit()
        viewTitle.textColor = .themeColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitle)
        
        //Button Right alignment
        let combinedView = UIView(frame: CGRect(x: 0, y: 0, width: Constant.addBtnWidth * 2 + Constant.freeSpaceBtwCollectionView, height: Constant.addBtnWidth))
        let screenshotBtn = CSButton(frame: CGRect(x: 0, y: 0, width: Constant.addBtnWidth, height: Constant.addBtnWidth), type: .camera)
        let addBtn = CSButton(frame: CGRect(x: Constant.addBtnWidth + Constant.freeSpaceBtwCollectionView, y: 0, width: Constant.addBtnWidth, height: Constant.addBtnWidth), type: .add)
        
        screenshotBtn.addTarget(self, action: #selector(takeScreenshot(_ :)), for: .touchUpInside)
        addBtn.addTarget(self, action: #selector(addCourse(_ :)), for: .touchUpInside)
 
        combinedView.addSubview(addBtn)
        combinedView.addSubview(screenshotBtn)
        combinedView.sizeToFit()

        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: combinedView)
        
        
    }
    @objc func temp (_ sender: UIButton) {
        let sd = UserDefaults.standard
    
        if appDelegate.existedCourses.count != 0 {
            let ran = appDelegate.existedCourses.removeFirst()
            do {
                try sd.setObject(appDelegate.existedCourses, forKey: "course")
                print("Removed Completed!")
            }
            catch { print(error.localizedDescription)}
            for v in collectionView.subviews {
                if let courseView = v as? CourseTimetableView {
                    if courseView.containedCourse == ran {
                        courseView.removeFromSuperview()
                    }
                }
            }
        }
    }
    @objc func addCourse (_ sender: UIButton) {
        guard let addvc = self.storyboard?.instantiateViewController(identifier: Constant.addVCId) else { return }
        self.navigationController?.pushViewController(addvc, animated: true)
    }
    @objc func takeScreenshot(_ sender: UIButton) {

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, scale)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let screenshot = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        guard let croppedcgImage = screenshot.cgImage?.cropping(to: CGRect(x: 0, y: (self.collectionView.frame.origin.y - 15) * scale, width: self.view.frame.width * scale, height: (self.collectionView.frame.height + 30) * scale)) else { return }
        self.showScreenshotEffect()
        let croppedImage = UIImage(cgImage: croppedcgImage)
        UIImageWriteToSavedPhotosAlbum(croppedImage, self, nil, nil)

    }

   
    func showScreenshotEffect() {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        UIView.animate(withDuration: 0.7, delay: 0.1, options: [], animations: {
            blurEffectView.alpha = 0.0
        }, completion: { _ in
            blurEffectView.removeFromSuperview()
        })
    }
    
    //MARK: Timetable init
    func initTimetable() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = layout
        self.collectionView.layer.borderWidth = Constant.timetableBorderWidth
        self.collectionView.layer.borderColor = UIColor.themeColor.cgColor
        self.collectionView.layer.cornerRadius = Constant.cornerRadius
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isScrollEnabled = false
        
        
        
    }
    

    
}

//MARK: CollectionView Delegate and DataSource Protocols
extension ScheduleVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //Ending Time (21:00) - Start Time (9:00)
        return 14
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.timeTableCellId, for: indexPath) as? TimetableCell else {
            return UICollectionViewCell()
            
        }
        

        let layerOfCell = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        let thickness = self.collectionView.layer.borderWidth
        let fontSize = cell.frame.width / 4
        cell.label.font = getRigteous(size: fontSize)
        
        //First column -> should be empty
        if indexPath.section == 0 {
            cell.labelType = .day
            switch indexPath.row {
            case 0 : cell.label.text = ""
            case 1 : cell.label.text = "MON"
            case 2 : cell.label.text = "TUE"
            case 3 : cell.label.text = "WED"
            case 4 : cell.label.text = "THU"
            case 5 : cell.label.text = "FRI"
            default : ()

            }
            
            
            
            
        }
        //First Column : right
        if indexPath.row == 0 {
            layerOfCell.layer.chooseBorder(edge: UIRectEdge.right, thickness: thickness)
            cell.labelType = .time
            if indexPath.section != 0 {
                switch indexPath.section {
                case 1 : cell.label.text = "09:00"
                case 2 : cell.label.text = "10:00"
                case 3 : cell.label.text = "11:00"
                case 4 : cell.label.text = "12:00"
                case 5 : cell.label.text = "13:00"
                case 6 : cell.label.text = "14:00"
                case 7 : cell.label.text = "15:00"
                case 8 : cell.label.text = "16:00"
                case 9 : cell.label.text = "17:00"
                case 10 : cell.label.text = "18:00"
                case 11 : cell.label.text = "19:00"
                case 12 : cell.label.text = "20:00"
                case 13 : cell.label.text = "21:00"
                default : ()
                }
            }
          
        }
        //Second to Fifth Column : right & bottom
        else if indexPath.row != 0 && indexPath.row != 5 {
            layerOfCell.layer.chooseBorder(edge: UIRectEdge.right, thickness: thickness)
            layerOfCell.layer.chooseBorder(edge: UIRectEdge.bottom, thickness: thickness)
        }
        //Sixth Column : bottom
        else {
            layerOfCell.layer.chooseBorder(edge: UIRectEdge.bottom, thickness: thickness)
        }


        cell.addSubview(layerOfCell)
        return cell
        
    }

}
extension ScheduleVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: cellWidth, height: cellWidth / 2)
        }
        else {
            return CGSize(width: self.cellWidth, height: self.cellHeight)
        }
    }
}


extension CALayer {
    func chooseBorder (edge: UIRectEdge, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
            case UIRectEdge.top:
             border.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: thickness)

            case UIRectEdge.bottom:
             border.frame = CGRect(x: 0, y: self.bounds.height - thickness,  width: self.bounds.width, height: thickness)

            case UIRectEdge.left:
             border.frame = CGRect(x: 0, y: 0,  width: thickness, height: self.bounds.height)

            case UIRectEdge.right:
             border.frame = CGRect(x: self.bounds.width - thickness, y: 0,  width: thickness, height: self.bounds.height)

            default:
             break
        }
        border.backgroundColor = UIColor.themeColor.cgColor
        self.addSublayer(border)
    }
    
        
}
//MARK: UIViewController TransitioningDelegate
extension ScheduleVC : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CustomPC(presentedViewController: presented, presenting: presenting)
    }
}
