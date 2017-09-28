//
//  User.swift
//  taskhelper
//
//  Created by DongGao on 23/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import Foundation

// To store the information of user
struct User {
    var username: String
    var profilioImage: Bool
    var baseImage: Bool
    var selfieImage: Bool
    var baseVoice: Bool
    var selfieVoice: Bool
    var isVerified: Bool
    var friends: [String]
    var friendsNum: Int
    var taskNum: Int
    var taskCompeleteNum: Int
    var requestNum: Int
    var msgUnreadNum: Int
    
    init(username: String, profilioImage: Bool, baseImage: Bool, selfieImage: Bool, baseVoice: Bool, selfieVoice: Bool, isVerified: Bool , friends: [String], friendsNum: Int, taskNum: Int, taskCompeleteNum: Int, requestNum: Int,msgUnreadNum: Int) {
        self.username = username
        self.profilioImage = profilioImage
        self.baseImage = baseImage
        self.selfieImage = selfieImage
        self.baseVoice = baseVoice
        self.selfieVoice = selfieVoice
        self.isVerified = isVerified
        self.friends = friends
        self.friendsNum = friendsNum
        self.taskNum = taskNum
        self.taskCompeleteNum = taskCompeleteNum
        self.requestNum = requestNum
        self.msgUnreadNum = msgUnreadNum
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
        self.friendsNum = 0
        self.taskNum = 0
        self.taskCompeleteNum = 0
        self.requestNum = 0
        self.msgUnreadNum = 0
    }
    
}

struct Friend {
    var friendName: String
    var friendIcon: UIImage
    
    init(friendName: String, friendIcon: UIImage) {
        self.friendName = friendName
        self.friendIcon = friendIcon
    }
    
    init() {
        self.friendName = ""
        self.friendIcon = UIImage()
    }
}


