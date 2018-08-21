//
//  Config.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import Alamofire
import SwiftyJSON
import NotificationBannerSwift

class APIHelper {
    
    static let sharedInstance = APIHelper()
    
    lazy var servicesURL = Config.sharedInstance.servicesURL()
    
    lazy var servicesVersion = Config.sharedInstance.servicesVersion()
    
    lazy var successBanner = NotificationBanner(title: "", subtitle: "", style: .success)
    
    lazy var errorBanner = NotificationBanner(title: "", subtitle: "", style: .danger)
    
    func getHeaders() -> [String : String]? {
        if let userId = UserDefaults.standard.value(forKey: UserDefaultsConstants.savedUserKey) as? String, let token = UserDefaults.standard.value(forKey: UserDefaultsConstants.userAuthTokenKey) as? String {
            // Token stored in UserDefaults.
            var userAuthB64 = "Basic "
            let userAuth = "\(userId):\(token)"
            let userAuthData = userAuth.data(using: .utf8)!
            userAuthB64 += userAuthData.base64EncodedString(options: [])
            
            // TODO: check Accept variable, change mvcgen for project name
            return [
                "Authorization" : userAuthB64,
                "Content-Type" : "application/json",
                "Accept" : "application/vnd.mvcgen.v"+self.servicesVersion+"+json",
                "X-app-version" : self.getVersionBuild(),
                "X-app-device" : self.getDeviceInfo()
            ]
        }
        return nil
        
    }
    
    func getVersionBuild() -> String {
        var versionBuild = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionBuild = version
        }
        if let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versionBuild += " " + buildVersion
        }
        return versionBuild
    }
    
    func getDeviceInfo() -> String {
        return UIDevice.current.model + " iOS: " + UIDevice.current.systemVersion
    }
    
    func wsResponse(onError error: Int){
        switch error {
        case 300..<400:
            // Bad auth error
            print("error is \(error)")
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.logout()
        case 801:
            break
        default:
            print("error is \(error)")
            break
        }
    }
    
    func showSuccesMessage(with title : String, and subtitle : String){
        NotificationBannerQueue.default.removeAll()
        if !successBanner.isDisplaying{
            successBanner.titleLabel?.text = title
            successBanner.subtitleLabel?.text = subtitle
            successBanner.show()
        }
    }
    
    func showErrorMessage(with title : String, and subtitle : String){
        NotificationBannerQueue.default.removeAll()
        if !errorBanner.isDisplaying{
            errorBanner.titleLabel?.text = title
            errorBanner.subtitleLabel?.text = subtitle
            errorBanner.show()
        }
    }
}

enum VoidResult {
    case success
    case failure
}
