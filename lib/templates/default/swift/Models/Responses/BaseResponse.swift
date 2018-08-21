//
//  BaseResponse.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import ObjectMapper

class BaseResponse: Mappable {
    
    var result: Bool = false
    var needUpdate: Bool = false
    var errorCode: Int = 0
    var message: String = ""
    var showMessage: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        if map.JSON["result"] != nil {
            result   <- map["result"]
            needUpdate <- map["needUpdate"]
            errorCode <- map["errorCode"]
            message <- map["message"]
            showMessage <- map["showMessage.\(self.getCurrentLocaleCode())"]
            if showMessage == ""{
                showMessage <- map["showMessage.EN"]
            }
        }
    }
    
    // By default show messages in English
    func getCurrentLocaleCode() -> String {
        var locale = "EN"
        if let currentLocaleCode = NSLocale.current.languageCode {
            locale = currentLocaleCode.uppercased()
        }
        return locale
    }
}

//If codable:

// struct BaseResponse: Codable {
    
//     var result: Bool = false
//     var needUpdate: Bool = false
//     var errorCode: Int = 0
//     var message: String = ""
//     var showMessage: String = ""

//     enum CodingKeys: String, Int, Bool, CodingKey
//     {
//         //If you wish to rename a field key:
//         //case id = "iD"
//         case result
//         case needUpdate
//         case errorCode
//         case message
//         case showMessage = "showMessage.\(self.getCurrentLocaleCode())"
//     }

//     // By default show messages in English
//     func getCurrentLocaleCode() -> String {
//         var locale = "EN"
//         if let currentLocaleCode = NSLocale.current.languageCode {
//             locale = currentLocaleCode.uppercased()
//         }
//         return locale
//     }
// }
