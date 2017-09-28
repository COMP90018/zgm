//
//  ResLogViewController.swift
//  taskhelper
//
//  Created by DongGao on 17/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResLogViewController: UIViewController {
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var face: UIButton!
    @IBOutlet weak var voice: UIButton!
    @IBOutlet weak var login: UIButton!
    
    
    @IBAction func unwindToResLog(segue: UIStoryboardSegue) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Set the UITextField transparent, not affect the placeholder.
        username.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        username.layer.cornerRadius = username.frame.size.height/2
        face.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        face.layer.cornerRadius = face.frame.size.height/2
        voice.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        voice.layer.cornerRadius = voice.frame.size.height/2
        login.layer.cornerRadius = login.frame.size.height/2
        
        username.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        let image = UIImage(named: "user.png")
        imageView.image = image
        imageView.contentMode = .center
        username.leftView = imageView
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        if username.text != "" {
            FriendSystem.system.loginAccount(username.text!, password: "123456") { (success) in
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
    
    
    @IBAction func OAuthLogin(_ sender: UIButton) {
        
        
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
