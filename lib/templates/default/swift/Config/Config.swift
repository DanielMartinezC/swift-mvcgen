//
//  Config.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//


import UIKit

class Config: NSObject {
    
    // MARK: - Singleton
    
    static let sharedInstance = Config()
    
    var config: NSDictionary?
    
    private override init() {
        
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Config")!
        
        let path = Bundle.main.path(forResource: "Config", ofType: "plist")!
        
        self.config = NSDictionary(contentsOfFile: path)?.object(forKey: currentConfiguration) as? NSDictionary
    }
    
    func servicesURL() -> String {
        return self.config?.object(forKey: "ServicesURL") as? String ?? ""
    }
    
    func servicesVersion() -> String {
        return self.config?.object(forKey: "ServicesVersion") as? String ?? ""
    }
    
    func oneSignalAppId() -> String {
        return self.config?.object(forKey: "OneSignalAppId") as? String ?? ""
    }
    
    func s3BucketName() -> String {
        return self.config?.object(forKey: "S3BucketName") as? String ?? ""
    }
    
    func awsIdentityPoolId() -> String {
        return self.config?.object(forKey: "AWSIdentityPoolId") as? String ?? ""
    }
    
}

