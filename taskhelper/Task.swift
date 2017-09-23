//
//  Task.swift
//  taskhelper
//
//  Created by DongGao on 23/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import Foundation

// To store the information of user
struct Task {
    var username: String
    var profilioImage: Bool
    var baseImage: Bool
    var selfieImage: Bool
    var baseVoice: Bool
    var selfieVoice: Bool
    var isVerified: Bool
    var friends: [String]
    
    init(username: String, profilioImage: Bool, baseImage: Bool, selfieImage: Bool, baseVoice: Bool, selfieVoice: Bool, isVerified: Bool , friends: [String]) {
        self.username = username
        self.profilioImage = profilioImage
        self.baseImage = baseImage
        self.selfieImage = selfieImage
        self.baseVoice = baseVoice
        self.selfieVoice = selfieVoice
        self.isVerified = isVerified
        self.friends = friends
        
    }
    
    init() {
        self.username = ""
        self.profilioImage = false
        self.baseImage = false
        self.selfieImage = false
        self.baseVoice = false
        self.selfieVoice = false
        self.isVerified = false //isVerified depends on
        self.friends = [String]()
    }
    
}
