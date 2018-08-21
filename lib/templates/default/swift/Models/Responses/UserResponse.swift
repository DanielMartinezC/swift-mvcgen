//
//  UserResponse.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import ObjectMapper

class UserResponse: BaseResponse {
    
    var user: User?
    var token: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.JSON["data"] != nil {
            // TODO: check how do you get user data
            user <- map["data.user"]
            token <- map["data.token"]
        }

    }
}
