//
//  SignupViewController.swift
//  taskhelper
//
//  Created by DongGao on 17/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profilio: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var termsText: UITextView!
    
    @IBAction func unwindToSignup(segue: UIStoryboardSegue) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Configure the appearance of register information
        profilio.layer.cornerRadius = profilio.frame.size.width/2
        profilio.clipsToBounds = true
        
        username.backgroundColor = UIColor(white: 0.6, alpha: 0.3)
        username.layer.cornerRadius = username.frame.size.height/2
        email.backgroundColor = UIColor(white: 0.6, alpha: 0.3)
        email.layer.cornerRadius = email.frame.size.height/2
        password.backgroundColor = UIColor(white: 0.6, alpha: 0.3)
        password.layer.cornerRadius = email.frame.size.height/2
        signup.layer.cornerRadius = signup.frame.size.height/2
        
        username.leftViewMode = .always
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        var image = UIImage(named: "user.png")
        imageView.image = image
        imageView.contentMode = .center
        username.leftView = imageView
        
        email.leftViewMode = .always
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        image = UIImage(named: "email.png")
        imageView.image = image
        imageView.contentMode = .center
        email.leftView = imageView
        
        password.leftViewMode = .always
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        image = UIImage(named: "password.png")
        imageView.image = image
        imageView.contentMode = .center
        password.leftView = imageView

        //Configure Terms and Conditions
        // Create an attributed string
        let stringOne = "By clicking Signup, you agree with \n Taskhelper's Terms of Service and Privary Policy"
        let stringTwo = "Terms of Service and Privary Policy"
        let range1 = (stringOne as NSString).range(of: stringOne)
        let range2 = (stringOne as NSString).range(of: stringTwo)
        let attributedText = NSMutableAttributedString.init(string: stringOne)
        // Set an attribute on part of the string
        let myCustomAttribute = [ "MyCustomAttributeName": "some value"]
        attributedText.addAttributes(myCustomAttribute, range: range2)
        
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray , range: range1)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.black , range: range2)
        
        
        
        // Set attributed string
        termsText.attributedText = attributedText
        termsText.textAlignment = .center
        termsText.font = UIFont(name: "Futura-Medium", size: 10)
        
        // Add tap gesture recognizer to Text View
        let tap = UITapGestureRecognizer(target: self, action: #selector(myMethodToHandleTap(_:)))
        tap.delegate = self
        termsText.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        
    }
    
    func myMethodToHandleTap(_ sender: UITapGestureRecognizer) {
        
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
        }
        self.performSegue(withIdentifier: "showDetailTerms", sender: Any?.self)
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
