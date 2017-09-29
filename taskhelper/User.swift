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
    var email: String
    var username: String
    var profileImage: UIImage?
    var baseImage: UIImage?
    var selfieImage: UIImage?
    var baseVoice: NSData?
    var selfieVoice: NSData?
    //If the user login using OAuth, isVerified is false.
    var isVerified: Bool
    var friendList: [Friend]
    var requestFriends: [Friend]
    var taskNum: Int
    var taskCompeleteNum: Int
    var requestTasks: [Task]
    var msgUnreadNum: Int
    
    init(email: String, username: String, profileImage: UIImage, baseImage: UIImage, selfieImage: UIImage, baseVoice: NSData, selfieVoice: NSData, isVerified: Bool, friendList: [Friend], requestFriends: [Friend], taskNum: Int, taskCompeleteNum: Int, requestTasks: [Task], msgUnreadNum: Int) {
        self.email = email
        self.username = username
        self.profileImage = profileImage
        self.baseImage = baseImage
        self.selfieImage = selfieImage
        self.baseVoice = baseVoice
        self.selfieVoice = selfieVoice
        self.isVerified = isVerified
        self.friendList = friendList
        self.requestFriends = requestFriends
        self.taskNum = taskNum
        self.taskCompeleteNum = taskCompeleteNum
        self.requestTasks = requestTasks
        self.msgUnreadNum = msgUnreadNum
    }
    
    init() {
        self.email = ""
        self.username = ""
        self.profileImage = UIImage()
        self.baseImage = UIImage()
        self.selfieImage = UIImage()
        self.baseVoice = NSData()
        self.selfieVoice = NSData()
        self.isVerified = false
        self.friendList = []
        self.requestFriends = []
        self.taskNum = 0
        self.taskCompeleteNum = 0
        self.requestTasks = []
        self.msgUnreadNum = 0
    }
    
}

struct Friend {
    var friendName: String
    var friendEmail: String
    var friendIcon: UIImage
    
    init(friendName: String, friendEmail: String, friendIcon: UIImage) {
        self.friendName = friendName
        self.friendIcon = friendIcon
        self.friendEmail = friendEmail
    }
    
    init() {
        self.friendName = ""
        self.friendEmail = ""
        self.friendIcon = UIImage()
    }
}

extension Friend {
    var nameFirstLetter: String {
        return String(self.friendName[self.friendName.startIndex]).uppercased()
    }
}




