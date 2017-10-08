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
    @IBOutlet weak var hasFinished: UIButton!
    @IBOutlet weak var hasVerified: UIButton!
    @IBOutlet weak var hasSuccessful: UIButton!
    var requestTask: RequestTask = RequestTask()
    var finished: Bool = false
    var verified: Bool = false
    var success: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ownerLabel.text = requestTask.taskOwner
        dueDateLabel.text = requestTask.dueDate
        taskContent.text = requestTask.content
        finished = requestTask.isFinished
        verified = requestTask.isVerified
        success = requestTask.isSuccessful
        if finished {
            hasFinished.imageView?.image = UIImage(named: "checkedbox")
        }
        
        if verified {
            hasVerified.imageView?.image = UIImage(named: "checkedbox")
        }
        if success {
            hasSuccessful.imageView?.image = UIImage(named: "checkedbox")
        }

        
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        
//        if taskFaceVerify || taskVoiceVerify {
//            hasVerified.imageView?.image = UIImage(named: "checkedbox")
//            hasSuccessful.imageView?.image = UIImage(named: "checkedbox")
//            verified = true
//            success = true
//        }
//        
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AfterVerify", sender: self)
    }
    
    
    
    @IBAction func saveVerify(_ sender: UIBarButtonItem) {
        
        updateTask()
        updateRequesTask()
        
        //
        taskFaceVerify = false
        taskVoiceVerify = false
        performSegue(withIdentifier: "AfterVerify", sender: self)
    }
    
    
    @IBAction func taskVerifyFace(_ sender: UIButton) {
        if !finished {
            presentAlertView()
            return
        }
        
        performSegue(withIdentifier: "taskFaceVerify", sender: self)
    }
    
    
    @IBAction func taskVerifyVoice(_ sender: UIButton) {
        if !finished {
            presentAlertView()
            return
        }
        
        performSegue(withIdentifier: "taskVoiceVerify", sender: self)
    }

    
    func presentAlertView() {
        let alertController = UIAlertController(title: "Attention", message: "You must verify your friends' tasks after they finished! So remind them to finish tasks!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskFaceVerify" {
            let dest = segue.destination as! VerifyViewController
            dest.hidesBottomBarWhenPushed = true
            faceSegueFrom = "taskVerify"
            
        }
        
        if segue.identifier == "taskVoiceVerify" {
            let dest = segue.destination as! SpeechViewController
            dest.hidesBottomBarWhenPushed = true
            voiceSegueFrom = "taskVerify"
            
        }
        
        
        
    }

    @IBAction func unwindToTaskVerify(segue: UIStoryboardSegue) {
        
        if segue.identifier == "unwindToTaskVerify"  {
            if taskFaceVerify || taskVoiceVerify {
                hasVerified.imageView?.image = UIImage(named: "checkedbox")
                hasSuccessful.imageView?.image = UIImage(named: "checkedbox")
                verified = true
                success = true
            }

        }
        
    }

    
    func updateTask() {
        let taskID = requestTask.taskID
        let ownerID = requestTask.userID

        USER_REF.child(ownerID).child("tasks").child(taskID).child("isVerified").setValue(verified)
        USER_REF.child(ownerID).child("tasks").child(taskID).child("isSuccessful").setValue(success)
        
    }
    
    func updateRequesTask() {
        let taskID = requestTask.taskID
        CURRENT_USER_REF.child("taskrequests").child(taskID).child("isVerified").setValue(verified)
        CURRENT_USER_REF.child("taskrequests").child(taskID).child("isSuccessful").setValue(success)
        
        
    }


}
