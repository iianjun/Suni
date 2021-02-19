//
//  ScheduleVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/20.
//

import UIKit
import Network
import Photos

@IBDesignable
class ScheduleVC : UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var isFirstTime = false
    var blurEffectViewOnView : UIVisualEffectView!
    var blurEffectViewOnTabBar : UIVisualEffectView!
    var screenshotBtn : CSButton!
    var addBtn : CSButton!
    
    var isConnected = false {
        willSet {
            DispatchQueue.main.sync {
                if newValue == true {
                    self.view.isUserInteractionEnabled = true
                    self.tabBarController?.tabBar.items?[0].isEnabled = true
                    self.tabBarController?.tabBar.items?[1].isEnabled = true
                    self.tabBarController?.tabBar.items?[2].isEnabled = true
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
                else {
                    let alert = UIAlertController(title: "No Internet Connection".localized, message: "Make sure your device is connected Wi-Fi or Cellular".localized, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.view.isUserInteractionEnabled = false
                    self.tabBarController?.tabBar.items?[0].isEnabled = false
                    self.tabBarController?.tabBar.items?[1].isEnabled = false
                    self.tabBarController?.tabBar.items?[2].isEnabled = false
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
            }
            
        }
        
    }
    var isLoaded = false {
        willSet {
            if newValue == true {
                if self.activityIndicator.isAnimating {
                    self.removeToActivate()
                }
            }
        }
    }
    
    var cellWidth : CGFloat {
        get {
            return self.collectionView.frame.width / 6
        }
    }
    var cellHeight : CGFloat {
        get {
            return self.collectionView.frame.height / 13 - (self.cellWidth / 26)
        }
    }
    override func viewDidLoad() {
        self.prepareForDownload()
        self.checkInternetConnectivity()
        self.setup()
        
    }
    
    func prepareForDownload() {
        
        
        let ud = UserDefaults.standard
        let didLaunchBefore = ud.bool(forKey: "firstTime")
        
        if didLaunchBefore {
            Constant.manager.signInAnonyously(with: self)
            return
        }
        
        self.activityIndicator.startAnimating()
        Constant.manager.signInAnonyously(with: self)
        //View
        self.blurEffectViewOnView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        self.blurEffectViewOnView.alpha = 0.8
        self.blurEffectViewOnView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        //TabBar
        self.blurEffectViewOnTabBar = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        guard let tbc = self.tabBarController else { return }
        self.blurEffectViewOnTabBar.frame = CGRect(x: 0, y: 0, width: tbc.tabBar.frame.width, height: tbc.tabBar.frame.height)
        self.blurEffectViewOnTabBar.alpha = 0.8
    
        self.view.addSubview(self.blurEffectViewOnView)
        tbc.tabBar.addSubview(self.blurEffectViewOnTabBar)
    }

    private func checkInternetConnectivity() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isConnected = true
                self.monitor.cancel()
            }
            else {
                self.isConnected = false
            }
        }
        monitor.start(queue: queue)
    }
    
    func removeToActivate () {
        self.activityIndicator.stopAnimating()
        if self.blurEffectViewOnView != nil {
            self.blurEffectViewOnView.removeFromSuperview()
        }
        if self.blurEffectViewOnTabBar != nil {
            self.blurEffectViewOnTabBar.removeFromSuperview()
        }
        if self.addBtn != nil && !self.addBtn.isEnabled {
            self.addBtn.isEnabled = true
        }
        if self.screenshotBtn != nil && !self.screenshotBtn.isEnabled{
            self.screenshotBtn.isEnabled = true
        }
        
        
    }
    private func setup() {
        self.initHeader()
        self.initTimetable()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let ud = UserDefaults.standard
        do {
            var selectedCourses = try ud.getObject(forKey: "course", castTo: [CourseVO].self)
            selectedCourses = selectedCourses.filter { self.appDelegate.existedCourses.contains($0) == false }
            for course in selectedCourses {
                for day in course.days! {
                    //Layout View on Collection view
                    let row = self.convertStringToRow(day: day)
                    let startTime = self.convertDateToString(time: course.time!.start)
                    let section = self.convertStringToSection(time: String(startTime.split(separator: ":")[0]))
                    let x = CGFloat((course.time?.duration)!) / CGFloat(3600)
                    let lectureHeight = ((x * 10).rounded() / 10) * self.cellHeight
                    var min = Double(startTime.split(separator: ":")[1])!
                    min /= 60.0
                    guard let cell = self.collectionView.cellForItem(at: IndexPath(row: row, section: section)) else { return }
                    let v = CourseTimetableView(frame: CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y + (self.cellHeight * CGFloat(min)), width: self.cellWidth - Constant.timetableBorderWidth, height: lectureHeight))
                    v.label.text = course.name!
                    v.label.font = fontByLanguage(for: course.name!, size: 12)
                    if course.room != nil {
                        v.roomLabel.text = course.room!
                        v.roomLabel.font = fontByLanguage(for: course.name!, size: 12)
                    }
                    v.containedCourse = course
                    
                    if course.bgColor.color != UIColor(red: 0, green: 0, blue: 0, alpha: 0) && course.type != "MANUAL" {
                        v.backgroundColor = course.bgColor.color

                    }
                    else if course.type == "MANUAL" && course.bgColor.color != UIColor(red: 0, green: 0, blue: 0, alpha: 0) {
                        v.backgroundColor = course.bgColor.color
                    }
                    //If CourseVO doesn't have designated color
                    else {
                        //If it is lab or rec course
                        if (course.type == "REC" || course.type == "LAB") && course.name != "PHY133" {
                            //If there is lec course in existedCourses
                            if let lecCourse = (self.appDelegate.existedCourses.filter { $0.name == course.name }).first {
                                //match random color
                                if lecCourse.bgColor.color == UIColor(red: 0, green: 0, blue: 0, alpha: 0) {
                                    let ranColor = UIColor.pastel[Int.random(in: 0..<UIColor.pastel.count)]
                                    v.backgroundColor = ranColor
                                    course.bgColor.color = ranColor
                                }
                                //match with lec color
                                else {
                                    v.backgroundColor = lecCourse.bgColor.color
                                    course.bgColor.color = lecCourse.bgColor.color
                                    
                                }
                            }
                            //If there isn't lec course in existedCourses
                            else {
                                let ranColor = UIColor.pastel[Int.random(in: 0..<UIColor.pastel.count)]
                                v.backgroundColor = ranColor
                                course.bgColor.color = ranColor
                            }

                        }
                        //If it is lec course
                        else {
                            //If it is lec course that has rec or lab
                            if let hasLab = course.hasLab {
                                if hasLab {
                                    if let labCourse = (self.appDelegate.existedCourses.filter { $0.name == course.name && ($0.type == "LAB" || $0.type == "REC") }).first {
                                        //If
                                        if labCourse.bgColor.color == UIColor(red: 0, green: 0, blue: 0, alpha: 0) {
                                            let ranColor = UIColor.pastel[Int.random(in: 0..<UIColor.pastel.count)]
                                            v.backgroundColor = ranColor
                                            course.bgColor.color = ranColor
                                        }
                                        else {
                                            v.backgroundColor = labCourse.bgColor.color
                                            course.bgColor.color = labCourse.bgColor.color
                                        }
                                    }
                                    else {
                                        let ranColor = UIColor.pastel[Int.random(in: 0..<UIColor.pastel.count)]
                                        v.backgroundColor = ranColor
                                        course.bgColor.color = ranColor
                                    }
                                }
                                else {
                                    let ranColor = UIColor.pastel[Int.random(in: 0..<UIColor.pastel.count)]
                                    v.backgroundColor = ranColor
                                    course.bgColor.color = ranColor
                                }
                            }
                        }
                    }
                    
                    v.isUserInteractionEnabled = true
                    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.presentDetailViewOfSelectedCourse(_ :)))
                    v.addGestureRecognizer(gesture)
                    
                    self.collectionView.addSubview(v)
                    self.collectionView.bringSubviewToFront(v)
                }
                self.appDelegate.existedCourses.append(course)
            }
        } catch {
            print(error.localizedDescription)
        }

        //After finished, save the course to ud again (at this point, guranteed all courses are in existedCourses)
        //By here Course has designated color
        //When the course is removed, I need to reset,
        //1. course.bgColor = nil
        //2. when removing rec or lab, the course that has that rec or lab should be also removed.
        //3. vise versa from #2
        do {
            try ud.setObject(self.appDelegate.existedCourses, forKey: "course")
        } catch {
            print(error.localizedDescription)
        }
    }
    @objc private func presentDetailViewOfSelectedCourse(_ sender : UIGestureRecognizer) {
        if let v = sender.view as? CourseTimetableView {
            let customModalVC = SelectedCourseModalVC()
            customModalVC.paramView = v
            customModalVC.paramSubviews = self.collectionView.subviews
            customModalVC.currentCourse = v.containedCourse
            customModalVC.modalPresentationStyle = .custom
            customModalVC.transitioningDelegate = self
            self.present(customModalVC, animated: true, completion: nil)
        }
    }
    
    //MARK: Header init
    private func initHeader() {
        
        //Title left alignment
        let viewTitle = UILabel()
        viewTitle.text = "My Schedule".localized
        viewTitle.font = localizedFont(size: Constant.titleFontSize)
        
        viewTitle.sizeToFit()
        viewTitle.textColor = .themeColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitle)
        
        //Button Right alignment
        let combinedView = UIView(frame: CGRect(x: 0, y: 0, width: Constant.addBtnWidth * 2 + Constant.freeSpaceBtwCollectionView, height: Constant.addBtnWidth))
        self.screenshotBtn = CSButton(frame: CGRect(x: 0, y: 0, width: Constant.addBtnWidth, height: Constant.addBtnWidth), type: .camera)
        self.addBtn = CSButton(frame: CGRect(x: Constant.addBtnWidth + Constant.freeSpaceBtwCollectionView, y: 0, width: Constant.addBtnWidth, height: Constant.addBtnWidth), type: .add)
        
        self.screenshotBtn.addTarget(self, action: #selector(takeScreenshot(_ :)), for: .touchUpInside)
        self.addBtn.addTarget(self, action: #selector(addCourse(_ :)), for: .touchUpInside)
        
        
        let addBgView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        addBgView.center.x = self.addBtn.frame.midX
        addBgView.center.y = self.addBtn.frame.height / 2
        addBgView.layer.cornerRadius = Constant.cornerRadius
        addBgView.backgroundColor = .themeColor
        
        let cameraBgView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cameraBgView.center.x = self.screenshotBtn.frame.midX
        cameraBgView.center.y = self.screenshotBtn.frame.height / 2
        cameraBgView.layer.cornerRadius = Constant.cornerRadius
        cameraBgView.backgroundColor = .themeColor
        
        combinedView.addSubview(addBgView)
        combinedView.addSubview(cameraBgView)
        combinedView.addSubview(self.addBtn)
        combinedView.addSubview(self.screenshotBtn)
        combinedView.sizeToFit()
        if !Constant.didLaunchBefore {
            self.addBtn.isEnabled = false
            self.screenshotBtn.isEnabled = false
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: combinedView)

    }

    @objc private func addCourse (_ sender: UIButton) {
        guard let addvc = self.storyboard?.instantiateViewController(identifier: Constant.addVCId) as? AddCourseVC else { return }
        self.navigationController?.pushViewController(addvc, animated: true)
    }
    
    @objc private func takeScreenshot(_ sender: UIButton) {
        //For First time (status = Not determined)
        if PHPhotoLibrary.authorizationStatus(for: .addOnly) == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .addOnly, handler: { status in
                if status == .authorized {
                    DispatchQueue.main.sync {
                        self.drawAndSaveSchedule()
                    }
                }
            })
        }
        
        //Otherwise, it is denied or authorized
        else {
            if PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized {
                self.drawAndSaveSchedule()
            }
            else {
                let alert = UIAlertController(title: "", message: "Please allow access to adding Photos in order to take screenshot".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }))
                self.present(alert, animated: true)
            }
        }
    }
        
            
    
    private func drawAndSaveSchedule () {
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
    private func showScreenshotEffect() {
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
    private func initTimetable() {
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
        cell.label.font = getRighteous(size: fontSize)
        
        //First column -> should be empty
        if indexPath.section == 0 {
            
            //1 -> SUN
            //2 -> MON
            //7 -> SAT
            let day = Calendar.current.component(.weekday, from: Date())
            if day == indexPath.row + 1 {
                cell.backgroundColor = .todayColor
                
            }
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

//MARK: Collection View Delegate Flow Layout
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

//MARK: UIViewController TransitioningDelegate
extension ScheduleVC : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CustomPC(presentedViewController: presented, presenting: presenting)
    }
}
