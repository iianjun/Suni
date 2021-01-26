//
//  WebCourseInfoVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/25.
//

import UIKit
import WebKit

class WebCourseInfoVC : UIViewController, WKUIDelegate {
    @IBOutlet var wv: WKWebView!
    var paramURL : String?
    var paramTitle : String?
    @IBOutlet var titleText: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {

//        let url = URL(string: paramURL)
//        let req = URLRequest(url: url!)
//        self.wv.load(req)
        self.wv.navigationDelegate = self
        self.wv.uiDelegate = self
        self.titleText.text = paramTitle
        if let url = paramURL {
            if let urlObj = URL(string: url) {
                let req = URLRequest(url: urlObj)
                self.wv.load(req)
            } else {
                let alert = UIAlertController(title: "Error", message: "It is wrong URL", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Parameter is incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: {
            self.wv.stopLoading()
            
            
        })
    }
}

extension WebCourseInfoVC : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        
        let alert = UIAlertController(title: "Error", message: "Could not bring Course Website", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
