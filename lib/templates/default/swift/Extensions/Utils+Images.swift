//
//  Utils+Images.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIImage
    typealias Image = UIImage
#elseif os(OSX)
    import AppKit.NSImage
    typealias Image = NSImage
#endif

enum Asset: String {
    case logo = "logo"
    case tick = "Tick"
    case userTestPhoto = "photo"
    case notifications = "notificaciones"
    case notification = "notification"
    case back = "Back"
    case welcome_01 = "Welcome_001"
    case welcome_02 = "Welcome_002"
    case welcome_03 = "Welcome_003"
    case welcome_04 = "Welcome_004"
    
    var image: Image {
        let bundle = Bundle(for: BundleToken.self)
        #if os(iOS) || os(tvOS)
            let image = Image(named: rawValue, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            let image = bundle.image(forResource: rawValue)
        #elseif os(watchOS)
            let image = Image(named: rawValue)
        #endif
        guard let result = image else { fatalError("Unable to load image \(rawValue).") }
        return result
    }
}

extension Image {
    convenience init!(asset: Asset) {
        #if os(iOS) || os(tvOS)
            let bundle = Bundle(for: BundleToken.self)
            self.init(named: asset.rawValue, in: bundle, compatibleWith: nil)
        #elseif os(OSX) || os(watchOS)
            self.init(named: asset.rawValue)
        #endif
    }
}

private final class BundleToken {}

extension UIImage{
    func resize(targetSize: CGSize) -> UIImage {
        
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
