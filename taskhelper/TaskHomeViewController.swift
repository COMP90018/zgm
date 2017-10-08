//
//  TaskHomeViewController.swift
//  taskhelper
//
//  Created by DongGao on 23/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit
import CoreData
import FirebaseStorage
import FirebaseDatabase

var task: Task = Task()
var tasks: [Task] = []

class TaskHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    
    var ref: DatabaseReference!
    var storage: StorageReference!
    var databaseHandle: DatabaseHandle!

    //search bar
    var sc: UISearchController!
    var taskID: String = ""
    
    var searchResult: [Task] = []
    
    //the method for searching
    func searchFilter(text: String) {
        searchResult = tasks.filter({ (task) -> Bool in
            return task.content.localizedCaseInsensitiveContains(text)
        })
    }
    
    //the method required by UISearchResultsUpdating protocol to update the table and display the result
    func updateSearchResults(for searchController: UISearchController) {
        if var text = searchController.searchBar.text {
            
            //ignore whitespace
            text = text.trimmingCharacters(in: .whitespaces)
            
            searchFilter(text: text)
            tableView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseHandle = CURRENT_USER_REF.child("tasks").observe(.value, with: { (snapshot) in
            
            let cloudTask = snapshot.value as? [NSDictionary]
            print(cloudTask?.count)
            print(cloudTask)
            
        })
        
        
        
        getUserInfo()
        getTaskInfo()
        fetchTaskInfo()
        //fetchTaskInfo()
        //Set the firebase reference
        ref = Database.database().reference()
        
        //search bar
        sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        tableView.tableHeaderView = sc.searchBar
        
        //the background of the search bar
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search"
        sc.searchBar.searchBarStyle = .minimal
        
        //delete the text for the back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //fetch the data from Area entity
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        //NotificationCenter.default.addObserver(self, selector: "refreshTable:", name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchTaskInfo()
        tableView.reloadData()
        
    }
    
    func getTaskInfo() {
        
        
        
        
        //        var ID: String = ""
        //        var localTask: Task = Task()
        //        if localUser.taskNum > 0 {
        //            for i in 0..<localUser.taskNum {
        //                ID = CURRENT_USER_ID + "-task\(i)"
        //
        //                CURRENT_USER_REF.child("tasks").child(ID).observeSingleEvent(of: .value, with: { (snapshot) in
        //                    let value = snapshot.value as? NSDictionary
        //                    let taskID = value?["taskID"] as! String
        //                    print(taskID)
        //                    let content = value?["content"] as! String
        //                    let dueDate = value?["dueDate"] as! String
        //                    let isFinished = value?["isFinished"] as! Bool
        //                    let isSuccessful = value?["isSuccessful"] as! Bool
        //                    let isVerified = value?["isVerified"] as! Bool
        //                    let verifier = value?["verifier"] as? [Friend] ?? []
        //
        //
        //                    localTask.content = content
        //                    localTask.taskID = taskID
        //                    localTask.dueDate = dueDate
        //                    localTask.isFinished = isFinished
        //                    localTask.isVerified = isVerified
        //                    localTask.isSuccessful = isSuccessful
        //
        //                    self.addLocalTask(localTask)
        //                })
        //
        //
        //            }
        //
        //        }
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
        if segue.identifier == "unwindToHome" || segue.identifier == "unwindDetailToHome"  {
            fetchTaskInfo()
            tableView.reloadData()
        }
        
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            tableView.reloadData()
        }
        
        if let object = controller.fetchedObjects {
            tasks = object as! [Task]
        }
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sc.isActive ? searchResult.count : tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskTableViewCell
        
        let task = sc.isActive ? searchResult[indexPath.row] : tasks[indexPath.row]
        
        // Configure the cell
        cell.taskLabel.text = task.content
        cell.timeLabel.text = task.dueDate
        cell.finishBtn.setBackgroundImage(UIImage(named: "checkbox"), for: .normal)
        cell.finishBtn.setBackgroundImage(UIImage(named: "checkedbox"), for: .selected)
        
        cell.finishBtn.imageView?.image = cell.finishBtn.isSelected ? UIImage(named: "checkbox.png") : UIImage(named: "checkedbox.png")
        
        //read the data from the firebase and store them in a list.
        //        databaseHandle = ref.child("\(localUser.email)").child("\(localUser.email)").observe(DataEventType.value, with: { (snapshot) in
        //            let postDict = snapshot.value as! String
        //            self.alert[0].cameraId = postDict
        //        })
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionShare = UITableViewRowAction(style: .normal,title: "Share") {
            (_, indexPath) in
            let actionSheet = UIAlertController(title: "Share To", message: nil, preferredStyle: .actionSheet)
            let option1 = UIAlertAction(title: "Facebook", style: .default, handler: nil)
            let option2 = UIAlertAction(title: "Twitter", style: .default, handler: nil)
            let option3 = UIAlertAction(title: "Wechat", style: .default, handler: nil)
            let optionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            actionSheet.addAction(option1)
            actionSheet.addAction(option2)
            actionSheet.addAction(option3)
            actionSheet.addAction(optionCancel)
            self.present(actionSheet, animated: true, completion: nil)
        }
        
        actionShare.backgroundColor = UIColor.orange
        //Delete
        let actionDel = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            /*
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             let context = appDelegate.persistentContainer.viewContext
             
             context.delete(self.fc.object(at: indexPath))
             appDelegate.saveContext()
             */
        }
        
        let actionTop = UITableViewRowAction(style: .normal, title: "Top") { (_, indexPath) in
            
        }
        //RGB值记得除以255
        actionTop.backgroundColor = UIColor(red: 245/255, green: 221/255, blue: 199/255, alpha: 1)
        
        return [actionShare, actionDel, actionTop]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskID = tasks[indexPath.row].taskID
        performSegue(withIdentifier: "showDetailTask", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailTask" {
            let dest = segue.destination as! TaskDetailTableViewController
            dest.hidesBottomBarWhenPushed = true
            dest.taskID = taskID
            
            
        }
    }
    
    
    //Get user infor from firebase
    func getUserInfo() {
        
        CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as! String
            localUser.username = username
        })
        CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let isVerified = value?["isVerified"] as! Bool
            localUser.isVerified = isVerified
        })
        CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let faceRecog = value?["faceRecog"] as! Bool
            localUser.faceRecog = faceRecog
        })
        CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let voiceRecog = value?["voiceRecog"] as! Bool
            localUser.voiceRecog = voiceRecog
        })
        CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let friendList = value?["friendList"] as? [Friend] ?? []
            localUser.friendList = friendList
        })
        
        CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let requestFriends = value?["requestFriends"] as? [Friend] ?? []
            localUser.requestFriends = requestFriends
        })
        CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let taskNum = value?["taskNum"] as! Int
            localUser.taskNum = taskNum
        })
        CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let taskCompeleteNum = value?["taskCompeleteNum"] as! Int
            localUser.taskCompeleteNum = taskCompeleteNum
        })
        CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let requestTasks = value?["requestTasks"] as? [Task] ?? []
            localUser.requestTasks = requestTasks
        })
        CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let friendList = value?["friendList"] as? [Friend] ?? []
            localUser.friendList = friendList
        })
        CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let msgUnreadNum = value?["msgUnreadNum"] as! Int
            localUser.msgUnreadNum = msgUnreadNum
        })
        
        let storageRef = Storage.storage().reference()
        let islandRef = storageRef.child("images/\(localUser.email)jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                localUser.profileImage = UIImage(data: data!)!
            }
        }
        
        
        
    }
    
    
    
    
    
    //fetch the data from the task entity
    func fetchTaskInfo() {
        tasks.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if results.count != 0 {
                
                for result in results {
                    let taskID = (result as AnyObject).value(forKey: "taskID") as! String
                    if taskID.contains("\(CURRENT_USER_ID)"){
                        task.taskID = taskID
                        task.content = (result as AnyObject).value(forKey: "content") as! String
                        task.dueDate = (result as AnyObject).value(forKey: "dueDate") as! String
                        tasks.append(task)
                        
                    }
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    
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
    
    func addLocalTask(_ localTask: Task) {
        deleteAll(localTask.taskID)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "Task", in:managedContext)
        let task = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        let verifier = NSKeyedArchiver.archivedData(withRootObject: localTask.verifier)
        //save the data
        task.setValue(localTask.taskID, forKey: "taskID")
        task.setValue(localTask.content, forKey: "content")
        task.setValue(localTask.dueDate, forKey: "dueDate")
        task.setValue(verifier, forKey: "verifier")
        task.setValue(localTask.isFinished, forKey: "isFinished")
        task.setValue(localTask.isVerified, forKey: "isVerified")
        task.setValue(localTask.isSuccessful, forKey: "isSuccessful")
        
        do {
            try managedContext.save()
            userTasks.append(task)
            print("Save Successfully!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    
    func deleteAll(_ ID: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let results = try managedContext.fetch(request)
            if results.count != 0 {
                for result in results {
                    if (result as AnyObject).value(forKey: "taskID") as! String == ID {
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
