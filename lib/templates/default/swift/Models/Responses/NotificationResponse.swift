//
//  NotificationResponse.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import ObjectMapper

class NotificationResponse: BaseResponse {
    
    var data: [Notif]?
    
    required init?(map: Map) {
        super.init(map: map)
        
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}
