//
//  FirebaseUser.swift
//  taskhelper
//
//  Created by Yijie Zhang on 28/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import Foundation

class FirebaseUser {
    var id: String!
    var email: String!
    var username: String!
    
    init(userID: String,userEmail: String, userName: String) {
        self.id = userID
        self.email = userEmail
        self.username = userName
    }
    
}
