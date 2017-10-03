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
    var verifier: [Friend]
    var isFinished: Bool
    var isVerified: Bool
    var isSuccessful: Bool
    
    init(taskID: String, content: String,dueDate: String, verifier: [Friend], isFinished: Bool, isVerified: Bool, isSuccessful: Bool) {
        self.taskID = taskID
        self.content = content
        self.dueDate = dueDate
        self.verifier = verifier
        self.isFinished = isFinished
        self.isVerified = isVerified
        self.isSuccessful = isSuccessful
    }
    
    init() {
        self.taskID = ""
        self.content = ""
        self.dueDate = ""
        self.verifier = [Friend]()
        self.isFinished = false
        self.isVerified = false
        self.isSuccessful = false
    }
}

