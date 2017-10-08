//
//  AddTaskViewController.swift
//  taskhelper
//
//  Created by DongGao on 24/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit
import CoreData

var taskNum: Int = 0

class AddTaskViewController: UITableViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var taskContent: UITextView!
    @IBOutlet weak var verifier1: UIButton!
//    @IBOutlet weak var verifier2: UIButton!
//    @IBOutlet weak var verifier3: UIButton!
    @IBOutlet weak var verified1: UIButton!
//    @IBOutlet weak var verified2: UIButton!
//    @IBOutlet weak var verified3: UIButton!
    @IBOutlet weak var isCompeleted: UIButton!
    @IBOutlet weak var isSuccessful: UIButton!
    @IBOutlet weak var friendNameLabel: UILabel!
    
    
    //var verifierList: [Friend] = []
    var dateFormatter = DateFormatter()
    var taskID: String = ""
    var dueDate: String = ""
    var friendName: String = ""
    var friendID: String = ""

    
    @IBAction func findVerifier(_ sender: UIButton) {
        performSegue(withIdentifier: "showChooseFriend", sender: self)
        
    }
    
    @IBAction func verifiedStatus(_ sender: UIButton) {
        
        
    }
    
    
    
    @IBAction func checkBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func unwindToChooseFriend(segue: UIStoryboardSegue) {
        
        if segue.identifier == "unwindToAddTask" {
            
            if let sourceViewController = segue.source as? ChooseFriendsTableViewController {
                friendNameLabel.text = sourceViewController.friendName
                friendID =  sourceViewController.friendID

                
            }

        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            let username = value?["username"] as? String ?? ""
//            localUser.username = username
//        })
        
        

        isCompeleted.setBackgroundImage(UIImage(named: "checkbox"), for: .normal)
        isCompeleted.setBackgroundImage(UIImage(named: "checkedbox"), for: .selected)
        
        isSuccessful.setBackgroundImage(UIImage(named: "checkbox"), for: .normal)
        isSuccessful.setBackgroundImage(UIImage(named: "checkedbox"), for: .selected)
        
//        verifier2.isHidden = true
//        verifier3.isHidden = true
//        verified2.isHidden = true
//        verified3.isHidden = true
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dueDate = dateFormatter.string(from: datePicker.date)
        
        dueDateLabel.text = dueDate
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: UIControlEvents.valueChanged)
        
        //Firebase path cannot contain "."
        taskID = "\(CURRENT_USER_ID)-task\(localUser.taskNum)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func datePickerChanged(datePicker: UIDatePicker) {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dueDate = dateFormatter.string(from: datePicker.date)
        dueDateLabel.text = dueDate
    }
    

    @IBAction func cancelTap(_ sender: UIBarButtonItem) {
         performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    
    
    @IBAction func saveTap(_ sender: UIBarButtonItem) {
        uploadTask()
        uploadRequesTask()
        //get the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "Task", in:managedContext)
        let task = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //let friendList = NSKeyedArchiver.archivedData(withRootObject: verifierList)
        //save the data
        task.setValue(taskID, forKey: "taskID")
        task.setValue(taskContent.text, forKey: "content")
        task.setValue(dueDate, forKey: "dueDate")
        task.setValue(friendNameLabel.text, forKey: "verifier")
        task.setValue(isCompeleted.isSelected, forKey: "isFinished")
        task.setValue(false, forKey: "isVerified")
        task.setValue(false, forKey: "isSuccessful")
        localUser.taskNum += 1
        dataControl.updateUser()
        CURRENT_USER_REF.child("taskNum").setValue(localUser.taskNum)
        
        do {
            try managedContext.save()
            userTasks.append(task)
            print("Save Successfully!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    
    //Save task information in Firebase
    func uploadTask() {
        var taskInfo = [String: AnyObject]()
        taskInfo = [
            "taskID": taskID as AnyObject,
            "content": taskContent.text as AnyObject,
            "dueDate": dueDate as AnyObject,
            "verifier": friendNameLabel.text as AnyObject,
            "isFinished": isCompeleted.isSelected as AnyObject,
            "isVerified": isCompeleted.isSelected as AnyObject,
            "isSuccessful": isCompeleted.isSelected as AnyObject]
        CURRENT_USER_REF.child("tasks").child(taskID).setValue(taskInfo)
        
    }
    
    
    //Send the task infor to the verifier
    func uploadRequesTask() {
        var requestTaskInfo = [String: AnyObject]()
        requestTaskInfo = [
            "userID": CURRENT_USER_ID as AnyObject,
            "taskID": taskID as AnyObject,
            "content": taskContent.text as AnyObject,
            "dueDate": dueDate as AnyObject,
            "verifier": friendNameLabel.text as AnyObject,
            "isFinished": isCompeleted.isSelected as AnyObject,
            "isVerified": isCompeleted.isSelected as AnyObject,
            "isSuccessful": isCompeleted.isSelected as AnyObject]
        USER_REF.child(friendID).child("taskrequests").child(taskID).setValue(requestTaskInfo)

        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    

}
