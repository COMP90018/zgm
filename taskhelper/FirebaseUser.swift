//
//  FirebaseUser.swift
//  taskhelper
//
//  Created by Yijie Zhang on 28/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import Foundation

class FirebaseUser {
    
    var email: String!
    var id: String!
    
    init(userEmail: String, userID: String) {
        self.email = userEmail
        self.id = userID
    }
    
}
