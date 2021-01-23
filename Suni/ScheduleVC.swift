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
    
    var cellWidth : CGFloat {
        get {
            return self.collectionView.frame.width / 6
        }
    }
    override func viewDidLoad() {
        self.view.accessibilityScroll(.down)
        self.setup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //Code bring saved data from UserDefaults
        
    }
    
    func setup() {
        self.initHeader()
        self.initTimetable()
        
        
        
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
        let addBtn = CSButton(frame: CGRect(x: 0, y: 0, width: Constant.addBtnWidth, height: Constant.addBtnWidth), type: .add)
        addBtn.addTarget(self, action: #selector(addCourse(_ :)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addBtn)
        
        
    }
    
    @objc func addCourse (_ sender: UIButton) {
        guard let addvc = self.storyboard?.instantiateViewController(identifier: Constant.addVCId) else { return }
        self.navigationController?.pushViewController(addvc, animated: true)
    }
    
    //MARK: Timetable init
    func initTimetable() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = layout
        self.collectionView.layer.borderWidth = 2
        self.collectionView.layer.borderColor = UIColor.themeColor.cgColor
        self.collectionView.layer.cornerRadius = Constant.cornerRadius
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.bounces = false
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
            return CGSize(width: self.cellWidth, height: self.cellWidth)
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


