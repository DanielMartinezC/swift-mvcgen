//
//  Utils+UIViewController.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

// MARK: - Animations

extension UIViewController {
    
    func setUnselectedColors(backgroundView: UIView, label: UILabel) {
        backgroundView.backgroundColor = UIColor.white
        label.textColor = UIColor.black
    }
    
    func setSelectedColors(backgroundView: UIView, label: UILabel) {
        backgroundView.backgroundColor = Colors.firstGradientColor
        label.textColor = UIColor.white
    }
    
    func animateViewBounceAndZoom(viewToAnimate: UIView) {
        
        scaleView(by: 0.8, viewToTransform: viewToAnimate)
        
        UIView.animate(withDuration: 0.3/2, animations: {
            self.scaleView(by: 1.1, viewToTransform: viewToAnimate)
        }, completion: { finished in
            UIView.animate(withDuration: 0.5/2, animations: {
                self.resetViewScale(viewToTransform: viewToAnimate)
            }, completion: { finished in
                UIView.animate(withDuration: 0.3/2, animations: {
                    self.scaleView(by: 1.0, viewToTransform: viewToAnimate)
                })
            })
        })
    }
    
    func scaleView(by scale: CGFloat, viewToTransform: UIView) {
        
        viewToTransform.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
    }
    
    func resetViewScale(viewToTransform: UIView) {
        viewToTransform.transform = CGAffineTransform.identity
    }
}

// MARK: - Keyboard

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
