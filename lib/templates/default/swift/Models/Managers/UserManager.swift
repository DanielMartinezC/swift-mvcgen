//
//  UserManager.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import Foundation

class UserManager {
    
    static let sharedInstance = UserManager()
        
    var user: User?

    func saveUser(newUser: User, withToken token: String) {
        if let userJSON: Data = try? JSONEncoder().encode(newUser) {
            self.user = newUser
            UserDefaults.standard.set(userJSON, forKey: UserDefaultsConstants.savedUserKey)
            UserDefaults.standard.set(token, forKey: UserDefaultsConstants.userAuthTokenKey)
            UserDefaults.standard.synchronize()
        }

    }

    func getUser() -> User? {
        
        if let userJSON = UserDefaults.standard.data(forKey: UserDefaultsConstants.savedUserKey) {
            
            if let user = try? JSONDecoder().decode(User.self, from: userJSON) {
                self.user = user
                return user
            }
        }
        
        self.user = nil
        return nil
    }
    
    func userLoggedIn() -> Bool{
        guard self.user != nil else {
            return false
        }
        return true
        
    }

    func removeUser() {
        self.user = nil
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.savedUserKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.userAuthTokenKey)
        UserDefaults.standard.synchronize()
    }
}

