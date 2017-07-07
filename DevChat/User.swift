//
//  User.swift
//  DevChat
//
//  Created by the Luckiest on 7/5/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import Foundation

struct User {
    private var _firstName: String!
    private var _uid: String!
    
    var uid: String {
        return _uid
    }
    
    var firstName: String {
        return _firstName
    }
    
    init(uid: String, firstname: String) {
        _uid = uid
        _firstName = firstname
    }
}
