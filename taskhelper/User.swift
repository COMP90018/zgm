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
    //If the user login using OAuth, isVerified is false.
    var isVerified: Bool
    var faceRecog: Bool
    var voiceRecog: Bool
    var friendList: [Friend]
    var requestFriends: [Friend]
    var taskNum: Int
    var taskCompeleteNum: Int
    var requestTasks: [Task]
    var msgUnreadNum: Int
    
    init(email: String, username: String, profileImage: UIImage, isVerified: Bool, faceRecog: Bool, voiceRecog: Bool, friendList: [Friend], requestFriends: [Friend], taskNum: Int, taskCompeleteNum: Int, requestTasks: [Task], msgUnreadNum: Int) {
        self.email = email
        self.username = username
        self.profileImage = profileImage
        self.isVerified = isVerified
        self.faceRecog = faceRecog
        self.voiceRecog = voiceRecog
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
        self.isVerified = false
        self.faceRecog = false
        self.voiceRecog = false
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




