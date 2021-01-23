//
//  AddCourseVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/22.
//

import UIKit

class AddCourseVC: UIViewController {

    override func viewDidLoad() {
        self.setup()

        // Do any additional setup after loading the view.
    }
    func setup() {
        self.initHeader()
    }
    
    func initHeader() {
        let viewTitle = UILabel()
        viewTitle.text = "Add Course"
        viewTitle.font = getRigteous(size: Constant.titleFontSize)
        
    
        self.navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(back(_ :)))
    }
    @objc func back (_ sender : Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
