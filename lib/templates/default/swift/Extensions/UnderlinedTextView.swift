//
//  UnderlinedTextView.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

class UnderlinedTextView: UITextView {
    
    var border: UIView!
    var originalBorderFrame: CGRect!
    var originalInsetBottom: CGFloat = 0.0
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.border = UIView()
        self.originalBorderFrame = CGRect(origin: CGPoint(x: 0, y: frame.height - 1.5), size: CGSize(width: frame.width, height: 1.5))
        addBottomBorderWithColor(color: UIColor.lightGray, width: 1.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.border = UIView()
        self.originalBorderFrame = CGRect(origin: CGPoint(x: 0, y: frame.height - 1.5), size: CGSize(width: frame.width, height: 1.5))
        self.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        addBottomBorderWithColor(color: UIColor.lightGray, width: 1.5)
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            border.frame = originalBorderFrame.offsetBy(dx: 0, dy: contentOffset.y)
            
        }
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        border.backgroundColor = color
        
        border.frame = CGRect(origin: CGPoint(x: 0, y: frame.height+contentOffset.y-width), size: CGSize(width: self.frame.width, height: width))
        originalBorderFrame = CGRect(origin: CGPoint(x: 0, y: frame.height-width), size: CGSize(width: self.frame.width, height: width))
        textContainerInset.bottom = originalInsetBottom + width
        self.textInputView.addSubview(border)
    }
    
    func changeBorderColor(newColor: UIColor) {
        border.removeFromSuperview()
        
        addBottomBorderWithColor(color: newColor, width: 1.5)
        //border.backgroundColor = newColor
        self.originalBorderFrame = CGRect(origin: CGPoint(x: 0, y: frame.height - 1.0), size: CGSize(width: frame.width, height: 1.0))
        // self.textInputView.addSubview(border)
    }
}
