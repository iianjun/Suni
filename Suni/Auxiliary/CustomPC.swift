//
//  CustomPC.swift
//  Suni
//
//  Created by 전하성 on 2021/02/04.
//

import UIKit

class CustomPC: UIPresentationController {
    
    private let blurEffectView : UIVisualEffectView!
    private var tapToDismiss = UITapGestureRecognizer()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: self.containerView!.frame.height * 0.7, width: self.containerView!.frame.width, height: self.containerView!.frame.height * 0.3)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialDark))
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapToDismiss.addTarget(self, action: #selector(dismiss(_ :)))
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapToDismiss)
    }
    
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0.0
        self.containerView?.addSubview(self.blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0.7
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0.0
        }, completion: { _ in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.presentedView!.roundedCorners([.topLeft, .topRight], radius: 20)
        self.blurEffectView.frame = containerView!.bounds
    }
    
    
    @objc private func dismiss (_ sender : Any) {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
}
