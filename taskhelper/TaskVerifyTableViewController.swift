//
//  TaskVerifyTableViewController.swift
//  taskhelper
//
//  Created by DongGao on 8/10/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class TaskVerifyTableViewController: UITableViewController {
    
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var taskContent: UITextField!
    @IBOutlet weak var isFinished: UIImageView!
    
    var requestTask: RequestTask = RequestTask()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ownerLabel.text = requestTask.taskOwner
        dueDateLabel.text = requestTask.dueDate
        taskContent.text = requestTask.content
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AfterVerify", sender: self)
    }
    
    
    
    @IBAction func saveVerify(_ sender: UIBarButtonItem) {
        
        
        
        
        performSegue(withIdentifier: "AfterVerify", sender: self)
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
