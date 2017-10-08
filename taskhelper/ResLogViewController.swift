//
//  ResLogViewController.swift
//  taskhelper
//
//  Created by DongGao on 17/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

var localUser = User()
var taskList = [Task]()
var localFriend = Friend()
var dataControl = DatabaseControl()
var users = [NSManagedObject]()
var userTasks = [NSManagedObject]()
var userFriends = [NSManagedObject]()
var isVerified: Bool = false
var isFaceVerify: Bool = false
var isVoiceVerify: Bool = false
var taskFaceVerify: Bool = false
var taskVoiceVerify: Bool = false
var faceSegueFrom: String = ""
var voiceSegueFrom: String = ""

class ResLogViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var face: UIButton!
    @IBOutlet weak var voice: UIButton!
    @IBOutlet weak var login: UIButton!
    
    
    
    @IBAction func unwindToResLog(segue: UIStoryboardSegue) {
        
        if segue.identifier == "unwindVerifyDone" {
            isVerified = true
            localUser.isVerified = isVerified
            
        }

        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Set the UITextField transparent, not affect the placeholder.
        email.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        email.layer.cornerRadius = email.frame.size.height/2
        face.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        face.layer.cornerRadius = face.frame.size.height/2
        voice.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        voice.layer.cornerRadius = voice.frame.size.height/2
        login.layer.cornerRadius = login.frame.size.height/2
        
//        email.leftViewMode = .always
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
//        let image = UIImage(named: "email.png")
//        imageView.image = image
//        imageView.contentMode = .center
//        email.leftView = imageView
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        if !isVerified {
            verifyAlertView()
            return
            
        }
        
        print("ceshi")
        print(localUser.faceRecog)
        print(localUser.voiceRecog)
        if email.text != "" {
            localUser.email = email.text!
            FriendSystem.system.loginAccount(email.text!, password: "123456") { (success) in
                if success {
                    self.performSegue(withIdentifier: "showHomePage", sender: self)
                    
                } else {
                    // Error
                    self.presentLoginAlertView()
                }
            }
        } else {
            // Fields not filled
            presentLoginAlertView()
        }
    }
    
    func presentLoginAlertView() {
        let alertController = UIAlertController(title: "Error", message: "Email is invalid", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func verifyAlertView() {
        let alertController = UIAlertController(title: "Attention", message: "Please login after verifying your face or voice!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func OAuthLogin(_ sender: UIButton) {
        switch sender.tag {
        case 11:
            //
            print("")
        case 12:
            //
            print("")
        case 13:
            //
            print("")
        default:
            break
        }
        
        
    }
    
    
    @IBAction func findUsername(_ sender: UIButton) {
        
        
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
