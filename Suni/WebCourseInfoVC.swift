//
//  WebCourseInfoVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/25.
//

import UIKit
import WebKit

class WebCourseInfoVC : UIViewController {
    @IBOutlet var wv: WKWebView!
    var paramURL : String!
    var paramTitle : String!
    
    override func viewDidLoad() {
        let naviBar = self.navigationItem
        
        naviBar.title = self.paramTitle
        
        let url = URL(string: paramURL)
        let req = URLRequest(url: url!)
        self.wv.load(req)
    }
}
