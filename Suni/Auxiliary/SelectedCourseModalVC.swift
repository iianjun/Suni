//
//  CSModalViewController.swift
//  Suni
//
//  Created by 전하성 on 2021/02/03.
//

import UIKit

class SelectedCourseModalVC: UIViewController {
    
    @IBOutlet var slideIndicator: UIView!
    
    var hasSetPointOrigin = false
    var originPoint : CGPoint?
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureToDismiss(_:)))
        self.view.addGestureRecognizer(gesture)
        self.slideIndicator.backgroundColor = .gray
        self.slideIndicator.roundedCorners(.allCorners, radius: 10)
        
    }
    override func viewDidLayoutSubviews() {
        if !self.hasSetPointOrigin {
            self.hasSetPointOrigin.toggle()
            self.originPoint = self.view.frame.origin
        }
    }
    
    
    @objc func panGestureToDismiss (_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        guard translation.y >= 0 else { return }
        self.view.frame.origin = CGPoint(x: 0, y: self.originPoint!.y + translation.y)
        
        if sender.state == .ended {
            let dragVel = sender.velocity(in: self.view)
            if dragVel.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame.origin = self.originPoint ?? CGPoint(x: 0, y: 400)
                })
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
