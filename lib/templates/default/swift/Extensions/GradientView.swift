//
//  GradientView.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import Foundation
import UIKit

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint: CGPoint {
        return points.startPoint
    }
    
    var endPoint: CGPoint {
        return points.endPoint
    }
    
    var points: GradientPoints {
        switch self {
        case .topRightBottomLeft:
            return (CGPoint.init(x: 0.0, y: 1.0), CGPoint.init(x: 1.0, y: 0.0))
        case .topLeftBottomRight:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 1, y: 1))
        case .horizontal:
            return (CGPoint.init(x: 0.0, y: 0.5), CGPoint.init(x: 1.0, y: 0.5))
        case .vertical:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 0.0, y: 1.0))
        }
    }
}

extension UIView {
    
    func applyGradient(withColours colours: [UIColor], cornerRadius: CGFloat = 0, locations: [NSNumber]? = nil) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.cornerRadius = cornerRadius
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation, cornerRadius: CGFloat = 0) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.cornerRadius = cornerRadius
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.backgroundColor = UIColor.black.cgColor
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], alpha: CGFloat, angle: Double!) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = "gradientLayer"
        let rect = CGRect(x: 0, y: 0, width: 375, height: 165)
        gradient.frame = rect
        gradient.colors = colours.map { $0.cgColor }
        let x: Double! = angle / 360.0
        let a = pow(sinf(Float(2.0 * Double.pi * ((x + 0.75) / 2.0))),2.0);
        let b = pow(sinf(Float(2 * Double.pi * ((x+0.0)/2))),2);
        let c = pow(sinf(Float(2 * Double.pi * ((x+0.25)/2))),2);
        let d = pow(sinf(Float(2 * Double.pi * ((x+0.5)/2))),2);
        gradient.endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
        gradient.startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
        self.alpha = alpha
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradientItinerary(withColours colours: [UIColor], alpha: CGFloat, angle: Double!) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = "gradientLayer"
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        let x: Double! = angle / 360.0
        let a = pow(sinf(Float(2.0 * Double.pi * ((x + 0.75) / 2.0))),2.0);
        let b = pow(sinf(Float(2 * Double.pi * ((x+0.0)/2))),2);
        let c = pow(sinf(Float(2 * Double.pi * ((x+0.25)/2))),2);
        let d = pow(sinf(Float(2 * Double.pi * ((x+0.5)/2))),2);
        gradient.endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
        gradient.startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
        self.alpha = alpha
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], rect: CGRect) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = "gradientLayer"
        //let rect = CGRect(x: 0, y: 0, width: 375, height: 165)
        gradient.frame = rect
        gradient.colors = colours.map { $0.cgColor }
        
        /*let a = rect.minX
        let b = rect.minY
        let c = rect.maxX
        let d = rect.maxY*/
        //gradient.endPoint = CGPoint(x: 10,y: 5)
        //gradient.endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
        //gradient.startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
        //gradient.startPoint = CGPoint(x: 0,y:0)
        //gradient.backgroundColor = UIColor.black.cgColor
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
