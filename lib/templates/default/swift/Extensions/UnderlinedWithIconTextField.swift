//
//  UITextFieldExtension.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

class UnderlinedWithIconTextField: UITextField {
    
    var border = CALayer()
    
    let padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
    
    func underlined(color: UIColor, width: CGFloat){
        
        let newBorder = CALayer()
        if let contains =  self.layer.sublayers?.contains(border) {
            if contains {
                self.layer.replaceSublayer(border, with: newBorder)
            }
        }
        
        newBorder.borderColor = color.cgColor
        // TODO: check isnt trailling same width
        newBorder.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width , height: width)
        newBorder.borderWidth = width
        self.layer.addSublayer(newBorder)
        border = newBorder
        self.layer.masksToBounds = true
    }
    
    func addLeftIcon(_ named: String) {
        let image = UIImage(named: named)
        let imageView = UIImageView()
        
        var iconOriginalWidth = image!.size.width
        if iconOriginalWidth > 15 {
            iconOriginalWidth = 15
        }
        imageView.frame = CGRect(x: 0, y: 0, width: iconOriginalWidth + 30, height: image!.size.height)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: iconOriginalWidth+30, height: image!.size.height))
        leftView.addSubview(imageView)
        imageView.bounds = imageView.frame.insetBy(dx: 15.0, dy: 0.0);
        
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
        
    }
}
