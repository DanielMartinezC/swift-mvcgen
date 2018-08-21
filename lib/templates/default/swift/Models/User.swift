//
//  User.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import ObjectMapper

class User: NSObject, Mappable, Codable {
    
    var id: Int = 0
    var email: String = ""
    var phone: String = ""
    var firstname: String = ""
    var lastname: String = ""
    var profilePic: String = ""

    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
        phone <- map["phone"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        lastname <- map["lastname"]
        profilePic <- map["profilePic"]
    }
}

//If codable:

// class User: Codable {
    
//     var id: Int = 0
//     var email: String = ""
//     var phone: String = ""
//     var firstname: String = ""
//     var lastname: String = ""

//     enum CodingKeys: String, CodingKey
//     {
//         //If you wish to rename a field key:
//         //case id = "iD"
//         case id
//         case email
//         case phone
//         case firstname
//         case lastname
//     }

//     // To Encode: 
//     // let encodedData = try? JSONEncoder().encode(userObject)
    
//     // To Decode:
//     if let jsonData = jsonString.data(using: .utf8)
//     {
//     let photoObject = try? JSONDecoder().decode(Photo.self, from: jsonData)
//     }


// }

// If you want to customize use this and delete Codable extension from user

// extension User: Encodable
// {
//     func encode(to encoder: Encoder) throws
//     {
//         var container = encoder.container(keyedBy: CodingKeys.self)
//         try container.encode(firstname, forKey: .firstname)
//     }
// }

// extension User: Decodable
// {
//     init(from decoder: Decoder) throws
//     {
//         let values = try decoder.container(keyedBy: CodingKeys.self)
//         firstname = try values.decode(String.self, forKey: .firstname)
//     }
// }


