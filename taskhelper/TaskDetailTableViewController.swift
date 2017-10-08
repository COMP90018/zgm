
//  TaskDetailTableViewController.swift
//  taskhelper
//
//  Created by DongGao on 25/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var taskContent: UITextView!
    @IBOutlet weak var verifier1: UIButton!
//    @IBOutlet weak var verifier2: UIButton!
//    @IBOutlet weak var verifier3: UIButton!
//    @IBOutlet weak var verified2: UIButton!
//    @IBOutlet weak var verified3: UIButton!
    @IBOutlet weak var isCompeleted: UIButton!
    @IBOutlet weak var friendNameLabel: UILabel!
    
    @IBOutlet weak var hasVerified: UIImageView!
    @IBOutlet weak var hasSuccessful: UIImageView!
    
    var finish: Bool = false
    

    @IBAction func chooseFinshed(_ sender: UIButton) {
        isCompeleted.isSelected = !isCompeleted.isSelected
        finish = true
    }
    
    
    var taskID: String = ""
    var verifierID: String = ""
    //var verifierList: [Friend] = []
    var dateFormatter = DateFormatter()
    var dueDate: String = ""
    var task: Task = Task()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchTaskData()
        
        if task.isVerified {
            hasVerified.image = UIImage(named: "checkedbox")
        }
        
        if task.isSuccessful {
            hasSuccessful.image = UIImage(named: "checkedbox")
        }
        
        taskContent.text = task.content
        dueDate = task.dueDate
        // verifierList = (result as AnyObject).value(forKey: "verifier") as! [Friend]
        friendNameLabel.text = task.verifier

        if task.isFinished {
            isCompeleted.imageView?.image = UIImage(named: "checkedbox")
            isCompeleted.isSelected = true
        }
        
        
        isCompeleted.setBackgroundImage(UIImage(named: "checkbox"), for: .normal)
        isCompeleted.setBackgroundImage(UIImage(named: "checkedbox"), for: .selected)
        
        
        
//        verifier2.isHidden = true
//        verifier3.isHidden = true
//        verified2.isHidden = true
//        verified3.isHidden = true
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let date = dateFormatter.date(from: dueDate)
        datePicker.date = date!
        dueDateLabel.text = dueDate
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: UIControlEvents.valueChanged)
        
    }
    
    
    
    func datePickerChanged(datePicker: UIDatePicker) {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dueDate = dateFormatter.string(from: datePicker.date)
        dueDateLabel.text = dueDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "unwindDetailToHome", sender: self)
    }
    
    
    
    @IBAction func saveTaskChange(_ sender: UIBarButtonItem) {
        //Update task infor to firebase
        updateTask()
        updateRequesTask()
        //Update task infor to coredata
        updateAll()
        performSegue(withIdentifier: "unwindDetailToHome", sender: self)
    }
    
    
    
    
    func fetchTaskData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if results.count != 0 {
                for result in results {
                    let ID = (result as AnyObject).value(forKey: "taskID") as! String
                    if ID == taskID {
                        taskContent.text = (result as AnyObject).value(forKey: "content") as! String
                        dueDate = (result as AnyObject).value(forKey: "dueDate") as! String
                        // verifierList = (result as AnyObject).value(forKey: "verifier") as! [Friend]
                        friendNameLabel.text = (result as AnyObject).value(forKey: "verifier") as! String
                    }
                    
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    
    func updateAll(){
        
        deleteAll()
        
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
        task.setValue(verifierID, forKey: "verifierID")
        task.setValue(false, forKey: "isVerified")
        task.setValue(false, forKey: "isSuccessful")
        
        do {
            try managedContext.save()
            userTasks.append(task)
            print("Save Successfully!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    func deleteAll(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let results = try managedContext.fetch(request)
            if results.count != 0 {
                for result in results {
                    if (result as AnyObject).value(forKey: "taskID") as! String == taskID {
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
    
    //Save task information in Firebase
    func updateTask() {
        var taskInfo = [String: AnyObject]()
        taskInfo = [
            "taskID": taskID as AnyObject,
            "content": taskContent.text as AnyObject,
            "dueDate": dueDate as AnyObject,
            "verifier": friendNameLabel.text as AnyObject,
            "isFinished": finish as AnyObject,
            "isVerified": false as AnyObject,
            "verifierID": verifierID as AnyObject,
            "isSuccessful": false as AnyObject]
        CURRENT_USER_REF.child("tasks").child(taskID).setValue(taskInfo)
        
    }

    func updateRequesTask() {
        var requestTaskInfo = [String: AnyObject]()
        requestTaskInfo = [
            "userID": CURRENT_USER_ID as AnyObject,
            "taskOwner": localUser.username as AnyObject,
            "taskID": taskID as AnyObject,
            "content": taskContent.text as AnyObject,
            "dueDate": dueDate as AnyObject,
            "verifier": friendNameLabel.text as AnyObject,
            "isFinished": finish as AnyObject,
            "isVerified": false as AnyObject,
            "isSuccessful": false as AnyObject]
        USER_REF.child(verifierID).child("taskrequests").child(taskID).setValue(requestTaskInfo)
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
