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
            self.makeBtn(type: .add)
        case .camera :
            self.makeBtn(type: .camera)
        }

    }
    
    func makeBtn (type: CSButtonType) {
        switch type {
        case .add :
            self.backgroundColor = .clear
            self.setImage(UIImage(named: "add"), for: .normal)
            
        case .camera :
            
            self.backgroundColor = .clear
            self.setImage(UIImage(named: "camera"), for: .normal)

        }
        
        
    }

}
