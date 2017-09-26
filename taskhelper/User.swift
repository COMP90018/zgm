//
//  User.swift
//  taskhelper
//
//  Created by DongGao on 23/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import Foundation

class User {
    
    var email: String!
    var id: String!
    
    init(userEmail: String, userID: String) {
        self.email = userEmail
        self.id = userID
    }
    
}
