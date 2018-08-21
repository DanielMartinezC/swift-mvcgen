//
//  AWSManager.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import AWSCore
import AWSCognito

class AWSManager: NSObject {
    
    // MARK: - Singleton
    
    static let sharedInstance = AWSManager()
    
    private override init() {
        
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: Config.sharedInstance.awsIdentityPoolId())
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
    }
    
}
