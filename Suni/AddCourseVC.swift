//
//  AddCourseVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/22.
//

import UIKit

class AddCourseVC: UIViewController {
    
    //MARK: MajorCollectionView's Tag = 101
    //MARK: DayCollectionView's Tag = 102
    //MARK: CartCollectionView's Tag = 103
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var majorCollectionView: UICollectionView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayCollectionView: UICollectionView!
    @IBOutlet var horizontalLines: [UIView]!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cartLabel: UILabel!
    @IBOutlet weak var cartCollectionView: UICollectionView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var listTableContainerView: UIView!
    @IBOutlet var doneBtn: CSButton!
    
    
    
    var tempNumber = 123
    var course : [String] = ["AMS", "BUS", "CSE", "TSM", "MEC"]
    var days : [String] = ["MON", "TUE", "WED", "THU", "FRI"]
    var cartWidth : CGFloat?
    var selectedCourse : [String] = ["CSE220", "CSE316"] {
        willSet (newValue) {
            self.cartCollectionView.reloadData()
            self.cartCollectionView.isScrollEnabled = newValue.count > 3 ? true : false
            
            
        }
    }
    
    var dummyData : [NSDictionary] = [
        ["name" : "CSE101", "instructor": "Alex Kuhn", "credit" : "3", "time" : "TUE/THU 17:00-18:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE101", "hasLab" : false],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true],
        ["name" : "CSE214", "instructor": "YoungMin Kwon", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE214", "hasLab" : true],
        ["name" : "CSE215", "instructor": "Dennis Wang", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE215", "hasLab" : false],
        ["name" : "CSE220", "instructor": "Amos Omondi", "credit": "4", "time": "TUE/THU 10:30-11:50", "room" : "B 203", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE220", "hasLab" : true],
        ["name" : "CSE316", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE316", "hasLab" : false],
        ["name" : "CSE416", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE416", "hasLab" : false],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true],
        ["name" : "CSE114", "instructor": "Alex Kuhn", "credit" : "3", "time" : "MON/WED 13:00-14:20", "room" : "B 106", "link" : "https://sunyk.cs.stonybrook.edu/students/Undergraduate-Studies/courses/CSE114", "hasLab" : true]
    ]
    
    override func viewDidLoad() {
        self.setup()
        cartWidth = self.cartCollectionView.frame.width
        // Do any additional setup after loading the view.
        
    }
    
    
    func setup() {

        self.tabBarController?.tabBar.isHidden = true
        self.initHeader()
        self.initBody()
        
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
        
        
        //MARK: TEST!@!!!!!!!
        let temp = UIButton(type: .system)
        temp.setTitle("temp", for: .normal)
        temp.sizeToFit()
        temp.addTarget(self, action: #selector(temp(_ :)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: temp)
    }
    
    @objc func temp(_ sender: UIButton) {
        selectedCourse.append("TEM\(tempNumber)")
        tempNumber += 1
    }
    
    @objc func back (_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func initBody () {
        //HR line
        for line in self.horizontalLines {
            line.backgroundColor = .themeColor
        }
        self.setupMajor()
        self.setupDay()
        self.setupSearchBar()
        self.setupCart()
        self.setupCourseList()
       

        
        
        

    }
    
    func setupMajor() {
        //"Major' label set up
        self.majorLabel.text = "Major"
        self.majorLabel.textColor = .themeColor
        self.majorLabel.font = getRigteous(size: self.majorLabel.font.pointSize)
        self.majorLabel.adjustsFontSizeToFitWidth = true
        
        //Major cells set up
        self.majorCollectionView.delegate = self
        self.majorCollectionView.dataSource = self
        self.majorCollectionView.bounces = false
        
        //If new major is regiestered
        self.majorCollectionView.isScrollEnabled = self.course.count == 5 ? false : true
        self.majorCollectionView.showsHorizontalScrollIndicator = false
        
    }
    
    func setupDay() {
        //"Day" label set up
        self.dayLabel.text = "Day"
        self.dayLabel.textColor = .themeColor
        self.dayLabel.font = getRigteous(size: self.majorLabel.font.pointSize)
        self.dayLabel.adjustsFontSizeToFitWidth = true
        
        //Day cells set up
        self.dayCollectionView.delegate = self
        self.dayCollectionView.dataSource = self
        self.dayCollectionView.bounces = false
        self.dayCollectionView.isScrollEnabled = false
    }
    
    func setupSearchBar() {
        searchBar.layer.borderWidth = 3.0
        searchBar.layer.borderColor = UIColor.themeColor.cgColor
        if let tf = searchBar.value(forKey: "searchField") as? UITextField {
            tf.borderStyle = .none
            tf.font = getRigteous(size: 18)
            tf.textColor = .themeColor
            tf.autocapitalizationType = .none
            tf.autocorrectionType = .no
            tf.returnKeyType = .search
            tf.spellCheckingType = .no
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
            toolbar.barTintColor = .lightGray
            
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(closeKeyboard(_:)))
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([flexSpace, doneBtn], animated: true)
            
            tf.inputAccessoryView = toolbar
            
            if let leftView = tf.leftView as? UIImageView {
                leftView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = .themeColor
            }
        }
    }
    
    @objc func closeKeyboard(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    func setupCart() {
        self.cartLabel.text = "Cart"
        self.cartLabel.textColor = .themeColor
        self.cartLabel.font = getRigteous(size: self.cartLabel.font.pointSize)
        self.cartLabel.adjustsFontSizeToFitWidth = true
        
        self.cartCollectionView.delegate = self
        self.cartCollectionView.dataSource = self
        self.cartCollectionView.bounces = false
        self.cartCollectionView.showsHorizontalScrollIndicator = false
        
    }
    
    @objc func removeCourse (_ sender : UIButton) {
        
        
    }
    
    func setupCourseList() {
        self.listTableContainerView.layer.borderWidth = self.horizontalLines[0].frame.height
        self.listTableContainerView.layer.borderColor = UIColor.themeColor.cgColor

        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.listTableView.bounces = false
       
        //Done Button
        self.doneBtn.makeBasicBtn()
        self.doneBtn.setTitle("Done", for: .normal)
        self.doneBtn.titleLabel?.font = getRigteous(size: 20)
        
    }
    @IBAction func doenBtnClick(_ sender: Any) {
        
    }
    
}
//MARK: Collection View Delegate & Data Source
extension AddCourseVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 101 {
            return self.course.count
        }
        else if collectionView.tag == 102 {
            return self.days.count
        }
        else {
            return self.selectedCourse.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 101 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.addCourseCellId, for: indexPath) as! AddCourseCell
            cell.label?.text = self.course[indexPath.row]
            return cell
        case 102 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.addCourseCellId, for: indexPath) as! AddCourseCell
            cell.label?.text = self.days[indexPath.row]
            return cell
        case 103 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.selectCellId, for: indexPath) as! SelectedCourseCell
            cell.label.text = self.selectedCourse[indexPath.row]
            cell.removeBtn.addTarget(self, action: #selector(self.removeCourse(_ :)), for: .touchUpInside)
            
            
            return cell
        default :
            return UICollectionViewCell()
        }
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let moreInfoVC = self.storyboard?.instantiateViewController(identifier: Constant.moreInfoVCId) as? MoreInfoVC else { return }
        moreInfoVC.params = dummyData[indexPath.section]
        
//        moreInfoVC.modalPresentationStyle = .custom
//        moreInfoVC.transitioningDelegate = self
//        self.navigationController?.pushViewController(moreInfoVC, animated: true)
        self.present(moreInfoVC, animated: true, completion: nil)
    }
}

//MARK: Collection View Delegate Flow Layout
extension AddCourseVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 101 || collectionView.tag == 102 {
            return CGSize(width: collectionView.frame.width / (CGFloat(self.course.count)) - Constant.freeSpaceBtwCollectionView, height: collectionView.frame.height)
        }
        else {
            return CGSize(width: collectionView.frame.width / 3 - Constant.freeSpaceBtwCollectionView, height: collectionView.frame.height)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return Constant.freeSpaceBtwCollectionView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.freeSpaceBtwCollectionView
    }

}

//MARK: UISearchBar Delegate
extension AddCourseVC : UISearchBarDelegate {
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//
//    }
}

//MARK: TableView Delegate & Data Source
extension AddCourseVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.courseListCellId) as? CourseListCell else { return UITableViewCell() }
        cell.textLabel?.text = self.dummyData[indexPath.section]["name"] as? String
        cell.detailTextLabel?.text = "By \(self.dummyData[indexPath.section]["instructor"] as? String ?? "")"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}

//MARK: Custom Modal Presentation Style
//extension AddCourseVC : UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
//
//
//
//}
