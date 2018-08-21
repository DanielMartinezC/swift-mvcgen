//
//  Country.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import ObjectMapper

class Country : NSObject, Mappable {
    
    @objc dynamic var name = ""
    @objc dynamic var flag = ""
    @objc dynamic var code = ""
    @objc dynamic var dial_code = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        flag <- map["flag"]
        code <- map["code"]
        dial_code <- map["dial_code"]
    }
}
