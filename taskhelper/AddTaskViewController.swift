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
    @IBOutlet weak var verifier2: UIButton!
    @IBOutlet weak var verifier3: UIButton!
    @IBOutlet weak var verified1: UIButton!
    @IBOutlet weak var verified2: UIButton!
    @IBOutlet weak var verified3: UIButton!
    @IBOutlet weak var isCompeleted: UIButton!
    @IBOutlet weak var isSuccessful: UIButton!
    
    var task: TaskMO  = TaskMO()
    var friends: [Friend] = []

    
    @IBAction func findVerifier(_ sender: UIButton) {
        if sender.isSelected {
            
        }
        
    }
    
    @IBAction func verifiedStatus(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func checkBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        isCompeleted.setBackgroundImage(UIImage(named: "checkbox"), for: .normal)
        isCompeleted.setBackgroundImage(UIImage(named: "checkedbox"), for: .selected)
        
        isSuccessful.setBackgroundImage(UIImage(named: "checkbox"), for: .normal)
        isSuccessful.setBackgroundImage(UIImage(named: "checkedbox"), for: .selected)
        
        verifier2.isHidden = true
        verifier3.isHidden = true
        verified2.isHidden = true
        verified3.isHidden = true
        
        dueDateLabel.text = "\(datePicker.date)"
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: UIControlEvents.valueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func datePickerChanged(datePicker: UIDatePicker) {
        var dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        var strDate = dateFormatter.string(from: datePicker.date)
        dueDateLabel.text = strDate
    }
    
    @IBAction func cancelTap(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    
    
    @IBAction func saveTap(_ sender: UIBarButtonItem) {
        //get the app delegate
        /*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //save the data
        task = TaskMO(context: appDelegate.persistentContainer.viewContext)
        task.taskID = localUser.email + "\(taskNum)"
        task.content = taskContent.text
        task.dueDate = "\(datePicker.date)"
        task.verifier = friends as! NSData
        task.isFinished = isCompeleted.isSelected
        task.isVerified = verified1.isSelected && verified2.isSelected && verified3.isSelected
        task.isSuccessful = task.isFinished && task.isVerified
        taskNum += 1
        appDelegate.saveContext()
        */
        
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
