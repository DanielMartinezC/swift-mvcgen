//
//  Utils+UIView.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Ineer Shadow View

extension UIView {

    // different inner shadow styles
    public enum innerShadowSide
    {
        case all, left, right, top, bottom, topAndLeft, topAndRight, bottomAndLeft, bottomAndRight, exceptLeft, exceptRight, exceptTop, exceptBottom
    }
    
    // define function to add inner shadow
    public func addInnerShadow(onSide: innerShadowSide, shadowColor: UIColor, shadowSize: CGFloat, cornerRadius: CGFloat = 0.0, shadowOpacity: Float)
    {
        // define and set a shaow layer
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowSize
        shadowLayer.fillRule = kCAFillRuleEvenOdd
        
        // define shadow path
        let shadowPath = CGMutablePath()
        
        // define outer rectangle to restrict drawing area
        let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
        
        // define inner rectangle for mask
        let innerFrame: CGRect = { () -> CGRect in
            switch onSide
            {
            case .all:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
            case .left:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .right:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .top:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case.bottom:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndLeft:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndRight:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndLeft:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndRight:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .exceptLeft:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptRight:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptTop:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            case .exceptBottom:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            }
        }()
        
        // add outer and inner rectangle to shadow path
        shadowPath.addRect(insetRect)
        shadowPath.addRect(innerFrame)
        
        // set shadow path as show layer's
        shadowLayer.path = shadowPath
        
        // add shadow layer as a sublayer
        layer.addSublayer(shadowLayer)
        
        // hide outside drawing area
        clipsToBounds = true
    }
}

// MARK: - GrdientView

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


