//
//  Utils.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

// Helper to determine if we're running on simulator or device
struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

struct UserDefaultsConstants {
    static let savedUserKey = "savedUser"
    static let userAuthTokenKey = "userAuthToken"
}

struct Endpoints {
    static let login = "login"
    static let fbLogin = "fb_login"
    static let logout = "logout"
    static let signup = "signup"
    static let forgotPwd = "forgot_pwd"
    static let getNotifications = "get_notifications"
    static let readNotifications = "read_notifications"
}

struct ColorConstants {
    static let firstGradientColor = UIColor(hex: "71F0DF")
    static let secondGradientColor = UIColor(hex: "397EB7")
    static let thirdGradientColor = UIColor(hex: "425893")
    static let firstWhite = UIColor(hex: "EDEFF4")
    static let secondWhite = UIColor(hex: "EDEFF4")
    static let thirdWhite = UIColor(hex: "D8D8D9")
    static let textColor = UIColor(hex: "5DCBCF")
}

struct Fonts {
    
    static func roboto(type : Int, fontSize: CGFloat) -> UIFont {
        var fontName = "Roboto"
        
        switch type {
        case 1:
            fontName += "-Thin"
        case 2:
            fontName += "-Light"
        case 3:
            fontName += "-Medium"
        case 4:
            fontName += "-Bold"
        case 5:
            fontName += "-Black"
        default:
            fontName += "-Regular"
        }
        
        guard let font = UIFont(name: fontName, size: fontSize) else { return UIFont.systemFont(ofSize: 17) }
        
        return font
    }
}
