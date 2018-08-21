//
//  Notification.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import ObjectMapper

@objc enum NotificationType: Int {
    
    case generic = 0
    case broadcast = 1
    
}

class Notif : NSObject, Mappable {
    
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var body = ""
    @objc dynamic var notifType: NotificationType = .generic
    @objc dynamic var payload : NotifPayload? = NotifPayload()
    @objc dynamic var read = false
    @objc dynamic var createdDate = Date()
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        if map.mappingType == .toJSON {
            var id = self.id
            id <- map["_id"]
        }
        else {
            id <- map["_id"]
        }
        title <- map["title"]
        body <- map["body"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        createdDate <- (map["createdAt"], DateFormatterTransform(dateFormatter: dateFormatter))
        payload <- map["payload"]
        notifType <- map["notifType"]
        read <- map["read"]
        
    }
}

class NotifPayload: NSObject, Mappable {
    
    @objc dynamic var property1: String = ""
    
    /*override static func primaryKey() -> String? {
        return "id"
    }*/
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        property1 <- map["property1"]
    }
}
