//
//  CSViewWithButton.swift
//  Suni
//
//  Created by 전하성 on 2021/02/09.
//

import UIKit

class CSViewWithButton: UIView {
    
    let button = UIButton()
    let v = UIView()
    var isExpanded = false

    
    override func layoutSubviews() {
        self.backgroundColor = .themeColor
        self.button.frame = CGRect(x: self.frame.width - 15, y: -15, width: 30, height: 30)
        self.button.backgroundColor = .white
        self.button.tag = self.v.hash
        if self.isExpanded {
            self.button.setImage(UIImage(named: "shrink"), for: .normal)
        }
        else {
            self.button.setImage(UIImage(named: "expand"), for: .normal)
        }
        self.v.frame = CGRect(x: 3, y: 3, width: self.frame.width - 6, height: self.frame.height - 6)
        self.v.backgroundColor = .white
        self.addSubview(self.button)
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let expansionButton = viewWithTag(self.v.hash) as! UIButton
        if expansionButton.point(inside: convert(point, to: expansionButton), with: event) {
            return true
        }
        return super.point(inside: point, with: event)
    }

}
