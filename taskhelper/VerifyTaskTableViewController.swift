//
//  VerifyTaskTableViewController.swift
//  taskhelper
//
//  Created by DongGao on 7/10/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class VerifyTaskTableViewController: UITableViewController {
    
    var requestTask: RequestTask = RequestTask()

    override func viewDidLoad() {
        super.viewDidLoad()

        FriendSystem.system.taskRequestObserver {
            self.tableView.reloadData()
        }

    }
    
    @IBAction func unwindRequestTask(segue: UIStoryboardSegue) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return FriendSystem.system.taskRequestList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = FriendSystem.system.taskRequestList[indexPath.row].content
        cell.detailTextLabel?.text = FriendSystem.system.taskRequestList[indexPath.row].dueDate
        
    
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        requestTask = FriendSystem.system.taskRequestList[indexPath.row]
        performSegue(withIdentifier: "showVerifyTask", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVerifyTask" {
            let dest = segue.destination as! TaskVerifyTableViewController
            dest.hidesBottomBarWhenPushed = true
            dest.requestTask = requestTask
            
            
        }

        
    }


}
