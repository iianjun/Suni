//
//  CSButton.swift
//  Suni
//
//  Created by 전하성 on 2021/01/21.
//

import UIKit
public enum CSButtonType : Int {
    case add = 0
    case camera
    
}
class CSButton: UIButton {
    private var type = CSButtonType.add
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
  
    }
    override init(frame : CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, type : CSButtonType) {
        super.init(frame: frame)
        self.type = type
        switch self.type {
        case .add :
            self.makeAddBtn()
        case .camera :
            self.makeCameraBtn()
        }

    }
    
    func makeAddBtn () {
        self.setImage(UIImage(named: "add"), for: .normal)
        self.layer.cornerRadius = Constant.cornerRadius
        self.backgroundColor = .themeColor
    }

    func makeCameraBtn () {
        self.setImage(UIImage(named: "camera"), for: .normal)
        self.layer.cornerRadius = Constant.cornerRadius
        self.backgroundColor = .themeColor
    }

}
