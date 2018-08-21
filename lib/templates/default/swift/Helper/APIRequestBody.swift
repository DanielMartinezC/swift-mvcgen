//
//  APIRequestBody.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import Alamofire
import OneSignal

struct APIRequestBody {
    
    static func getLoginBody(withEmail email: String, withPassword password: String) -> Parameters{
        
        var loginBody: Parameters = Parameters()
        
        loginBody.updateValue(email, forKey: "email")
        
        if let pwdData = password.data(using: .utf8) {
            let hash = pwdData.sha256()
            loginBody.updateValue(hash.toHexString(), forKey: "password")
        }
        
        loginBody.updateValue(UIDevice.current.model + " iOS: " + UIDevice.current.systemVersion, forKey: "device")
        loginBody.updateValue(APIHelper.sharedInstance.getVersionBuild(), forKey: "version")
        
        if let playerId = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId{
            loginBody.updateValue(playerId, forKey: "onesignalPlayerId")
        }
        
        return loginBody
    }
    
    static func getFbLoginBody(withAccesToken accessToken: String) -> Parameters{
        
        var loginBody: Parameters = Parameters()
        
        loginBody.updateValue(accessToken, forKey: "accessToken")
        
        loginBody.updateValue(UIDevice.current.model + " iOS: " + UIDevice.current.systemVersion, forKey: "device")
        loginBody.updateValue(APIHelper.sharedInstance.getVersionBuild(), forKey: "version")
        
        if let playerId = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId{
            loginBody.updateValue(playerId, forKey: "onesignalPlayerId")
        }
        
        return loginBody
    }
    
    static func getSignupBody(withEmail email: String, withPassword password: String, withFirstName firstname: String, withLastname lastname: String, withPhone phone: String, withProfilePic profilePic: String, withStudies studies: String, withCertifications certifications: String, withAbout about: String) -> Parameters{
        
        var signupBody: Parameters = Parameters()
        
        signupBody.updateValue(email, forKey: "email")
        
        if let pwdData = password.data(using: .utf8) {
            let hash = pwdData.sha256()
            signupBody.updateValue(hash.toHexString(), forKey: "password")
        }
        
        signupBody.updateValue(firstname, forKey: "firstname")
        signupBody.updateValue(lastname, forKey: "lastname")
        signupBody.updateValue(phone, forKey: "phone")
        
        return signupBody
    }
    
    static func forgotPwd(withEmail email: String) -> Parameters{
        
        var forgotPwdBody: Parameters = Parameters()
        
        forgotPwdBody.updateValue(email, forKey: "email")
        
        return forgotPwdBody
    }
    
}

    

