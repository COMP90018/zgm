//
//  FriendSystem.swift
//  taskhelper
//
//  Created by Yijie Zhang on 28/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth


// MARK: - Firebase references
/** The base Firebase reference */
let BASE_REF = Database.database().reference()
/* The user Firebase reference */
let USER_REF = Database.database().reference().child("users")

/** The Firebase reference to the current user tree */
var CURRENT_USER_REF: DatabaseReference {
    let id = Auth.auth().currentUser!.uid
    return USER_REF.child("\(id)")
}

/** The Firebase reference to the current user's friend tree */
var CURRENT_USER_FRIENDS_REF: DatabaseReference {
    return CURRENT_USER_REF.child("friends")
}

/** The Firebase reference to the current user's friend request tree */
var CURRENT_USER_REQUESTS_REF: DatabaseReference {
    return CURRENT_USER_REF.child("requests")
}

/** The current user's id */
var CURRENT_USER_ID: String {
    let id = Auth.auth().currentUser!.uid
    return id
}




class FriendSystem {
    
    static let system = FriendSystem()
    /** Gets the current User object for the specified user id */
    func getCurrentUser(_ completion: @escaping (FirebaseUser) -> Void) {
        CURRENT_USER_REF.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let email = snapshot.childSnapshot(forPath: "email").value as! String
            let username = snapshot.childSnapshot(forPath: "username").value as! String
            let id = snapshot.key
            completion(FirebaseUser(userID: id,userEmail: email, userName: username))
        })
    }
    /** Gets the User object for the specified user id */
    func getUser(_ userID: String, completion: @escaping (FirebaseUser) -> Void) {
        USER_REF.child(userID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let email = snapshot.childSnapshot(forPath: "email").value as! String
            let username = snapshot.childSnapshot(forPath: "username").value as! String
            let id = snapshot.key
            completion(FirebaseUser(userID: id, userEmail: email, userName: username))
        })
    }
    
    
    
    // MARK: - Account Related
    
    /**
     Creates a new user account with the specified email and password
     - parameter completion: What to do when the block has finished running. The success variable
     indicates whether or not the signup was a success
     */
    func createAccount(_ email: String, _ username: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if (error == nil) {
                // Success
                var userInfo = [String: AnyObject]()
                userInfo = ["email": email as AnyObject, "username": username as AnyObject]
                CURRENT_USER_REF.setValue(userInfo)
                completion(true)
            } else {
                // Failure
                completion(false)
            }
            
        })
    }
    
    /**
     Logs in an account with the specified email and password
     
     - parameter completion: What to do when the block has finished running. The success variable
     indicates whether or not the login was a success
     */
    func loginAccount(_ email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if (error == nil) {
                // Success
                completion(true)
            } else {
                // Failure
                completion(false)
                print(error!)
            }
            
        })
    }
    
    /** Logs out an account */
    func logoutAccount() {
        try! Auth.auth().signOut()
    }
    
    
    
    // MARK: - Request System Functions
    
    /** Sends a friend request to the user with the specified id */
    func sendRequestToUser(_ userID: String) {
        USER_REF.child(userID).child("requests").child(CURRENT_USER_ID).setValue(true)
    }
    
    /** Unfriends the user with the specified id */
    func removeFriend(_ userID: String) {
        CURRENT_USER_REF.child("friends").child(userID).removeValue()
        USER_REF.child(userID).child("friends").child(CURRENT_USER_ID).removeValue()
    }
    
    /** Accepts a friend request from the user with the specified id */
    func acceptFriendRequest(_ userID: String) {
        CURRENT_USER_REF.child("requests").child(userID).removeValue()
        CURRENT_USER_REF.child("friends").child(userID).setValue(true)
        USER_REF.child(userID).child("friends").child(CURRENT_USER_ID).setValue(true)
        // USER_REF.child(userID).child("requests").child(CURRENT_USER_ID).removeValue()
    }
    
    
    
    // MARK: - All users
    /** The list of all users */
    var userList = [FirebaseUser]()
    /** Adds a user observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addUserObserver(_ update: @escaping () -> Void) {
        USER_REF.observe(DataEventType.value, with: { (snapshot) in
            self.userList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let email = child.childSnapshot(forPath: "email").value as! String
                let username = child.childSnapshot(forPath: "username").value as! String
                if email != Auth.auth().currentUser?.email! {
                    self.userList.append(FirebaseUser(userID: child.key, userEmail: email, userName: username))
                }
            
            }
            update()
        })
    }
    /** Removes the user observer. This should be done when leaving the view that uses the observer. */
    func removeUserObserver() {
        USER_REF.removeAllObservers()
    }
    
    
    
    //The list of all tasks
    /** Adds a user observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addTaskObserver(_ update: @escaping () -> Void) {
        USER_REF.child("tasks").observe(DataEventType.value, with: { (snapshot) in
            taskList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let taskID = child.childSnapshot(forPath: "taskID").value as! String
                let content = child.childSnapshot(forPath: "content").value as! String
                let dueDate = child.childSnapshot(forPath: "dueDate").value as! String
                let verifier = child.childSnapshot(forPath: "verifier").value as! [Friend]
                let isFinished = child.childSnapshot(forPath: "isFinished").value as! Bool
                let isVerified = child.childSnapshot(forPath: "isVerified").value as! Bool
                let isSuccessful = child.childSnapshot(forPath: "isSuccessful").value as! Bool
                
                taskList.append(Task(taskID: taskID, content: content, dueDate: dueDate, verifier: verifier, isFinished: isFinished, isVerified: isVerified, isSuccessful: isSuccessful))

                
            }
            update()
        })
    }
    /** Removes the user observer. This should be done when leaving the view that uses the observer. */
    func removeTaskObserver() {
        USER_REF.child("tasks").removeAllObservers()
    }

    
    
    
    // MARK: - All friends
    /** The list of all friends of the current user. */
    var friendList = [FirebaseUser]()
    /** Adds a friend observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addFriendObserver(_ update: @escaping () -> Void) {
        CURRENT_USER_FRIENDS_REF.observe(DataEventType.value, with: { (snapshot) in
            self.friendList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let id = child.key
                self.getUser(id, completion: { (user) in
                    self.friendList.append(user)
                    update()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                update()
            }
        })
    }
    /** Removes the friend observer. This should be done when leaving the view that uses the observer. */
    func removeFriendObserver() {
        CURRENT_USER_FRIENDS_REF.removeAllObservers()
    }
    
    
    
    // MARK: - All requests
    /** The list of all friend requests the current user has. */
    var requestList = [FirebaseUser]()
    /** Adds a friend request observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addRequestObserver(_ update: @escaping () -> Void) {
        CURRENT_USER_REQUESTS_REF.observe(DataEventType.value, with: { (snapshot) in
            self.requestList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let id = child.key
                self.getUser(id, completion: { (user) in
                    self.requestList.append(user)
                    update()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                update()
            }
        })
    }
    /** Removes the friend request observer. This should be done when leaving the view that uses the observer. */
    func removeRequestObserver() {
        CURRENT_USER_REQUESTS_REF.removeAllObservers()
    }
    
}
