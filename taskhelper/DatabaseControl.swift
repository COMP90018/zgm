//
//  DatabaseControl.swift
//  taskhelper
//
//  Created by DongGao on 6/10/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import Foundation


class DatabaseControl {
    
    //Update user information in CoreData
    func updateUser() {
        deleteUser()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "User", in:managedContext)
        let user = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        let friendList = NSKeyedArchiver.archivedData(withRootObject: localUser.friendList)
        let requestTasks = NSKeyedArchiver.archivedData(withRootObject: localUser.requestTasks)
        let requestFriends = NSKeyedArchiver.archivedData(withRootObject: localUser.requestFriends)
        
        user.setValue(localUser.email, forKey: "email")
        user.setValue(localUser.username, forKey: "username")
        user.setValue(localUser.isVerified, forKey: "isVerified")
        user.setValue(localUser.faceRecog, forKey: "faceRecog")
        user.setValue(localUser.voiceRecog, forKey: "voiceRecog")
        user.setValue(friendList, forKey: "friendList")
        user.setValue(requestFriends, forKey: "requestFriends")
        user.setValue(localUser.taskNum, forKey: "taskNum")
        user.setValue(localUser.taskCompeleteNum, forKey: "taskCompeleteNum")
        user.setValue(requestTasks, forKey: "requestTasks")
        user.setValue(localUser.msgUnreadNum, forKey: "msgUnreadNum")
        if let imageData = UIImageJPEGRepresentation(localUser.profileImage, 0.7) {
            user.setValue(NSData(data: imageData), forKey: "profileImage")
        }
        
        do {
            try managedContext.save()
            users.append(user)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    
    func deleteUser() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let results = try managedContext.fetch(request)
            if results.count != 0 {
                for result in results {
                    if (result as AnyObject).value(forKey: "email") as! String == localUser.email {
                        managedContext.delete(result as! NSManagedObject)
                    }
                }
                do {
                    try managedContext.save()
                } catch {
                    print(error)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }

}
