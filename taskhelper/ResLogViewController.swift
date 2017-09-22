//
//  ResLogViewController.swift
//  taskhelper
//
//  Created by DongGao on 17/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class ResLogViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    
    @IBAction func unwindToResLog(segue: UIStoryboardSegue) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Set the UITextField transparent, not affect the placeholder.
        email.backgroundColor = UIColor(white: 0.6, alpha: 0.3)
        password.backgroundColor = UIColor(white: 0.6, alpha: 0.3)
        email.layer.cornerRadius = email.frame.size.height/2
        password.layer.cornerRadius = email.frame.size.height/2
        login.layer.cornerRadius = login.frame.size.height/2
        
        email.leftViewMode = .always
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        var image = UIImage(named: "email.png")
        imageView.image = image
        imageView.contentMode = .center
        email.leftView = imageView
        
        password.leftViewMode = .always
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        image = UIImage(named: "password.png")
        imageView.image = image
        imageView.contentMode = .center
        password.leftView = imageView
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        
        
        
    }
    
    
    @IBAction func OAuthLogin(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func resetPassword(_ sender: UIButton) {
        
        
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
