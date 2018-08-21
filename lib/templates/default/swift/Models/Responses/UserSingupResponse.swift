//
//  UserSingupResponse.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import ObjectMapper

class UserSignupResponse: BaseResponse {
    
    var user: User?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        // TODO: check how to get the data
        if map.JSON["data"] != nil {
            user <- map["data.user"]
        }
        
    }
}
