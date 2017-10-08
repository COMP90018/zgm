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
    var taskID: String
    var content: String
    var dueDate: String
    var verifier: String
    var verifierID: String
    var isFinished: Bool
    var isVerified: Bool
    var isSuccessful: Bool
    
    init(taskID: String, content: String,dueDate: String, verifier: String, isFinished: Bool, isVerified: Bool, isSuccessful: Bool, verifierID: String) {
        self.taskID = taskID
        self.content = content
        self.dueDate = dueDate
        self.verifier = verifier
        self.isFinished = isFinished
        self.isVerified = isVerified
        self.isSuccessful = isSuccessful
        self.verifierID = verifierID
    }
    
    init() {
        self.taskID = ""
        self.content = ""
        self.dueDate = ""
        self.verifier = ""
        self.isFinished = false
        self.isVerified = false
        self.isSuccessful = false
        self.verifierID = ""
    }
    
    
}


struct RequestTask {
    var userID: String
    var taskOwner: String
    var taskID: String
    var content: String
    var dueDate: String
    var verifier: String
    var isFinished: Bool
    var isVerified: Bool
    var isSuccessful: Bool
    
    init(userID: String, taskOwner: String, taskID: String, content: String,dueDate: String, verifier: String, isFinished: Bool, isVerified: Bool, isSuccessful: Bool) {
        self.userID = userID
        self.taskOwner = taskOwner
        self.taskID = taskID
        self.content = content
        self.dueDate = dueDate
        self.verifier = verifier
        self.isFinished = isFinished
        self.isVerified = isVerified
        self.isSuccessful = isSuccessful
    }
    
    init() {
        self.userID = ""
        self.taskOwner = ""
        self.taskID = ""
        self.content = ""
        self.dueDate = ""
        self.verifier = ""
        self.isFinished = false
        self.isVerified = false
        self.isSuccessful = false
    }
}
