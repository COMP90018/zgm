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

class TaskHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var storage: StorageReference!
    var databaseHandle: DatabaseHandle!
    //search bar
    var sc: UISearchController!
    
    var fc: NSFetchedResultsController<TaskMO>!
    
    var tasks: [TaskMO] = []
    
    var searchResult: [TaskMO] = []
    
    //the method for searching
    func searchFilter(text: String) {
        searchResult = tasks.filter({ (task) -> Bool in
            return task.content!.localizedCaseInsensitiveContains(text)
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
        fetchAllData()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
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
            tasks = object as! [TaskMO]
        }
    }
    
    //fetch the data from the task entity
    func fetchAllData() {
        let request: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()
        let sd = NSSortDescriptor(key: "content", ascending: true)
        request.sortDescriptors = [sd]
        
        /*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        fc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fc.delegate = self
        
        do {
            try fc.performFetch()
            if let object = fc.fetchedObjects {
                tasks = object
            }
        } catch {
            print(error)
        }
 */
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
        performSegue(withIdentifier: "showDetailTask", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTaskDetail" {
            let dest = segue.destination as! TaskDetailTableViewController
            dest.hidesBottomBarWhenPushed = true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
