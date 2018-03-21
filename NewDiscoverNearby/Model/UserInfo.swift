//
//  User.swift
//  NewDiscoverNearby
//
//  Created by bhl on 3/16/18.
//  Copyright © 2018 UChicago. All rights reserved.
//

import Foundation

/**
    define user information structure 
 */
class UserInfo {
    var email: String?
    var profileImageUrl: String?
    var username: String?
}

extension UserInfo {
    static func transformUser(dict: [String: Any]) -> UserInfo {
        let user = UserInfo()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        
        return user
    }
}
