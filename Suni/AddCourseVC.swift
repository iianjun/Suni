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

    var majors : [String] = ["AMS", "BUS", "CSE", "TSM", "MEC", "ETC"]
    var days : [String] = ["MON", "TUE", "WED", "THU", "FRI"]
    var cartWidth : CGFloat?
    
    //This is collection of lab and recitation courses
    
    
    
    var additionalCourses : [CourseVO] = []
    
    var filteredCourse : [CourseVO] = []
    var selectedCourse : [CourseVO] = [] {
        willSet (newValue) {
            self.cartCollectionView.reloadData()
            self.cartCollectionView.isScrollEnabled = newValue.count > 3 ? true : false
            
            
        }
    }
    var selectedMajor : [String] = [] {
        willSet (newVal) {
            print(newVal)
        }
    }
    var selectedDays : [String] = [] {
        willSet (newVal) {
            print(newVal)
        }
    }
    var courselist = [CourseVO]()
    lazy var filteredList : [CourseVO] = {
        var datalist = [CourseVO]()
        return datalist
    }()
    
    @objc func removeCourse (_ sender : UIButton) {
        
        if let index = selectedCourse.firstIndex(where: { $0.hash! == sender.tag }) {
            print(index)
            selectedCourse.remove(at: index)
        }
        //sender.tag == course.hash == cell.tag

      
        
        

      
    
    }
    
    
    override func viewDidLoad() {
        self.setup()
        cartWidth = self.cartCollectionView.frame.width
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func setup() {

        self.tabBarController?.tabBar.isHidden = true
        self.getCourseData()
        self.initHeader()
        self.initBody()
        
    }
    
    func getCourseData() {
        
        if let path = Bundle.main.path(forResource: "all_courses", ofType: "json") {
            do {
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as! [NSDictionary]
                for course in jsonResult {
                    let cvo = CourseVO()
                    cvo.major = course["major"] as? String
                    cvo.name = course["name"] as? String
                    cvo.title = course["title"] as? String
                    if let stringType = course["type"] as? String {
                        if let type = CourseType(rawValue: stringType.lowercased()) {
                            cvo.type = type
                        }
                    }
                    cvo.credit = course["credit"] as? Int
                    cvo.days = course["days"] as? NSArray
                    cvo.startTime = course["startTime"] as? String
                    cvo.endTime = course["endTime"] as? String
                    cvo.room = course["room"] as? String
                    cvo.instructor = course["instructor"] as? String
                    cvo.hasLab = course["hasLab"] as? Bool
                    cvo.link = course["link"] as? String
                    cvo.number = course["number"] as? Int
                    var hasher = Hasher()
                    hasher.combine(cvo.name)
                    hasher.combine(cvo.startTime)
                    cvo.hash = hasher.finalize()
                    cvo.selected = false
                    
                    
                    
                    
                    if (cvo.type == .lab || cvo.type == .rec) && (cvo.name != "PHY133") {
                        self.additionalCourses.append(cvo)
                    }
                    else {
                        self.courselist.append(cvo)
                    }
                    
                    
                }
            } catch {
                NSLog("Error for Parsing JSON format file!")
                
            }
        }
       
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
    @objc func temp(_ sender : UIButton) {
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
        self.majorCollectionView.isScrollEnabled = self.majors.count > 5 ? true : false
        self.majorCollectionView.showsHorizontalScrollIndicator = false
        self.majorCollectionView.allowsMultipleSelection = true
        
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
        self.dayCollectionView.allowsMultipleSelection = true
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
    
    
    func setupCourseList() {
        self.listTableContainerView.layer.borderWidth = self.horizontalLines[0].frame.height
        self.listTableContainerView.layer.borderColor = UIColor.themeColor.cgColor

        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.listTableView.bounces = false
        self.listTableView.allowsMultipleSelection = false
        
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
        switch collectionView.tag {
        case 101: return self.majors.count
        case 102: return self.days.count
        case 103: return self.selectedCourse.count
        default : return 0
            
        }
      
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 101 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.addCourseCellId, for: indexPath) as! AddCourseCell
            cell.label?.text = self.majors[indexPath.row]
            return cell
        case 102 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.addCourseCellId, for: indexPath) as! AddCourseCell
            cell.label?.text = self.days[indexPath.row]
            return cell
        case 103 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.selectCellId, for: indexPath) as! SelectedCourseCell
            cell.label.text = self.selectedCourse[indexPath.row].name
            cell.removeBtn.addTarget(self, action: #selector(self.removeCourse(_ :)), for: .touchUpInside)
            cell.removeBtn.tag = self.selectedCourse[indexPath.row].hash!
            
            
            
            return cell
        default :
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 101:
            if let cell = collectionView.cellForItem(at: indexPath) as? AddCourseCell {
                cell.backgroundColor = .themeColor
                selectedMajor.append(self.majors[indexPath.row])
            }
        case 102:
            if let cell = collectionView.cellForItem(at: indexPath) as? AddCourseCell {
                cell.backgroundColor = .themeColor
                selectedDays.append(days[indexPath.row])
            }
        case 103: ()
        default: ()
        }
            
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 101:
            if let cell = collectionView.cellForItem(at: indexPath) as? AddCourseCell {
                cell.backgroundColor = .white
                if let index = selectedMajor.firstIndex(of: majors[indexPath.row]) {
                    selectedMajor.remove(at: index)
                } else { return }
            }
        case 102:
            if let cell = collectionView.cellForItem(at: indexPath) as? AddCourseCell {
                cell.backgroundColor = .white
         
                if let index = selectedDays.firstIndex(of: days[indexPath.row]) {
                    selectedDays.remove(at: index)
                } else { return }
            }
        case 103: ()
            
        default: ()
            
        }
    }
}

//MARK: Collection View Delegate Flow Layout
extension AddCourseVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 101 : return CGSize(width: collectionView.frame.width / (CGFloat(self.majors.count)) - Constant.freeSpaceBtwCollectionView, height: collectionView.frame.height)
        case 102 : return CGSize(width: collectionView.frame.width / (CGFloat(self.days.count)) - Constant.freeSpaceBtwCollectionView, height: collectionView.frame.height)
        case 103 : return CGSize(width: collectionView.frame.width / 3 - Constant.freeSpaceBtwCollectionView, height: collectionView.frame.height)
        default: return CGSize.zero
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
        return self.filteredCourse.count > 0 ? self.filteredCourse.count : self.courselist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.courseListCellId) as? CourseListCell else {
            return UITableViewCell()
        }
        if filteredCourse.isEmpty == false {
            let course = self.filteredCourse[indexPath.section]
            cell.textLabel?.text = course.name
            cell.detailTextLabel?.text = (course.instructor)! == "TBD" ? "TBD" : "By \(course.instructor!)"
            
            
        }
        else {
            
            let course = self.courselist[indexPath.section]

            
            cell.textLabel?.text = course.name
            cell.detailTextLabel?.text = (course.instructor)! == "TBD" ? "TBD" : "By \(course.instructor!)"

            cell.tag = course.hash!
            cell.selectionStyle = .none
            
        }
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
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let moreInfoVC = self.storyboard?.instantiateViewController(identifier: Constant.moreInfoVCId) as? MoreInfoVC else { return }
        moreInfoVC.params = courselist[indexPath.section]
        
//        moreInfoVC.modalPresentationStyle = .custom
//        moreInfoVC.transitioningDelegate = self
//        self.navigationController?.pushViewController(moreInfoVC, animated: true)
        self.present(moreInfoVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? CourseListCell  {
            let course = self.courselist[indexPath.section]
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                cell.backgroundColor = .themeColor
                cell.backgroundColor = .white
            }, completion: { finisied in
                
            })
            course.selected = true
            self.selectedCourse.append(course)
            
            

        }
    }
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? CourseListCell {
//            
//            let course = self.courselist[indexPath.section]
//            course.selected = false
//            if let index = selectedCourse.firstIndex(of: course) {
//                selectedCourse.remove(at: index)
//                
//            } else { return }
//            
//        }
//    }
}

//MARK: Custom Modal Presentation Style
//extension AddCourseVC : UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
//
//
//
//}
