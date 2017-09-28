//
//  TaskHomeViewController.swift
//  taskhelper
//
//  Created by DongGao on 23/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class TaskHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        cell.imageView?.image = UIImage(named: "profile_image")
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionShare = UITableViewRowAction(style: .normal,title: "Share") {
            (_, indexPath) in
            let actionSheet = UIAlertController(title: "Share To", message: nil, preferredStyle: .actionSheet)
            let option1 = UIAlertAction(title: "Facebook", style: .default, handler: nil)
            let option2 = UIAlertAction(title: "Twitter", style: .default, handler: nil)
            let optionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            actionSheet.addAction(option1)
            actionSheet.addAction(option2)
            actionSheet.addAction(optionCancel)
            self.present(actionSheet, animated: true, completion: nil)
        }
        
        actionShare.backgroundColor = UIColor.orange
        
        let actionDel = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in

            
        }
        
        let actionTop = UITableViewRowAction(style: .normal, title: "Top") { (_, indexPath) in
            
        }
        //RGB值记得除以255
        actionTop.backgroundColor = UIColor(red: 245/255, green: 221/255, blue: 199/255, alpha: 1)
        
        return [actionShare, actionDel, actionTop]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailTask", sender: Any?)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTaskDetail" {
            //as! 是强制类型转换的意思
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
