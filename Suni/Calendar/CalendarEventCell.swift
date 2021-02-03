//
//  CalendarEventCell.swift
//  Suni
//
//  Created by 전하성 on 2021/02/03.
//

import UIKit
class CalendarEventCell : UITableViewCell {
    let bulletPoint = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bulletPoint.frame = CGRect(x: 10, y: (self.frame.height - 10) / 2, width: 10, height: 10)
        self.bulletPoint.backgroundColor = .black
        self.bulletPoint.layer.cornerRadius = self.bulletPoint.frame.width / 2
        self.textLabel?.frame.origin.x += 10
        self.detailTextLabel?.frame.origin.x += 10
        
        self.addSubview(bulletPoint)
        self.bringSubviewToFront(bulletPoint)
        
    }
}
