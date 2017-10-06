//
//  SignupViewController.swift
//  taskhelper
//
//  Created by DongGao on 17/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignupViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilio: UIImageView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var face: UIButton!
    @IBOutlet weak var voice: UIButton!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var termsText: UITextView!
    
    var storageRef: StorageReference!
    
    @IBAction func unwindToSignup(segue: UIStoryboardSegue) {
        
    }
    
    
    @IBAction func chooseImage(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Photo album cannot be used！")
            return
        }
        //If the photo album can be used
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        
        //If you want to use the camera, change photoLibrary to camera.
        picker.sourceType = .photoLibrary
        
        //Set the delegate as itself
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Configure the appearance of register information
        profilio.layer.cornerRadius = profilio.frame.size.width/2
        profilio.clipsToBounds = true
        
        email.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
        email.layer.cornerRadius = email.frame.size.height/2
        email.clipsToBounds = true
        username.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
        username.layer.cornerRadius = username.frame.size.height/2
        face.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        face.layer.cornerRadius = face.frame.size.height/2
        voice.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        voice.layer.cornerRadius = voice.frame.size.height/2
        signup.layer.cornerRadius = signup.frame.size.height/2
        
//        email.leftViewMode = .always
//        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
//        var image = UIImage(named: "email.png")
//        imageView.image = image
//        imageView.contentMode = .center
//        email.leftView = imageView
//        
//        username.leftViewMode = .always
//        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
//        image = UIImage(named: "user.png")
//        imageView.image = image
//        imageView.contentMode = .center
//        username.leftView = imageView
        

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
        termsText.font = UIFont(name: "Futura-Medium", size: 12)
        
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
        if email.text != ""  && username.text != "" {
            localUser.email = email.text!
            localUser.username = username.text!
            FriendSystem.system.createAccount(email.text!, username.text!, password: "123456") { (success) in
                if success {
                    //Sign up successful
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let managedContext = appDelegate.managedObjectContext
                    let entity =  NSEntityDescription.entity(forEntityName: "User", in:managedContext)
                    let user = NSManagedObject(entity: entity!, insertInto: managedContext)
                    
                    let friendList = NSKeyedArchiver.archivedData(withRootObject: localUser.friendList)
                    let requestTasks = NSKeyedArchiver.archivedData(withRootObject: localUser.requestTasks)
                    let requestFriends = NSKeyedArchiver.archivedData(withRootObject: localUser.requestFriends)
                    //Save user information in CoreData
                    
                    if let imageData = UIImageJPEGRepresentation(self.profilio.image!, 0.7) {
                        user.setValue(NSData(data: imageData), forKey: "profileImage")
                    }
                    user.setValue(localUser.email, forKey: "email")
                    user.setValue(localUser.username, forKey: "username")
                    user.setValue(localUser.isVerified, forKey: "isVerified")
                    user.setValue(localUser.faceRecog, forKey: "faceRecog")
                    user.setValue(localUser.voiceRecog, forKey: "voiceRecog")
                    user.setValue(friendList, forKey: "friendList")
                    user.setValue(requestFriends, forKey: "requestFriends")
                    user.setValue(localUser.taskNum, forKey: "taskNum")
                    user.setValue(localUser.taskCompeleteNum, forKey: "taskCompeleteNum")
                    user.setValue(requestTasks, forKey: "requestTasks")
                    user.setValue(localUser.msgUnreadNum, forKey: "msgUnreadNum")
                    do {
                        try managedContext.save()
                        users.append(user)
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                    
                    //Save user information in Firebase
                    self.uploadImage()
                    var userInfo = [String: AnyObject]()
                    userInfo = [
                        "email": localUser.email as AnyObject,
                        "username": localUser.username as AnyObject,
                        "isVerified": localUser.isVerified as AnyObject,
                        "faceRecog": localUser.faceRecog as AnyObject,
                        "voiceRecog": localUser.voiceRecog as AnyObject,
                        "friendList": localUser.friendList as AnyObject,
                        "requestFriends": localUser.requestFriends as AnyObject,
                        "taskNum": localUser.taskNum as AnyObject,
                        "taskCompeleteNum": localUser.taskCompeleteNum as AnyObject,
                        "requestTasks": localUser.requestTasks as AnyObject,
                        "msgUnreadNum": localUser.msgUnreadNum as AnyObject]
                    CURRENT_USER_REF.setValue(userInfo)

                    let alert = UIAlertController(title: "Signup Successfully!", message: "Login Now!", preferredStyle: .alert)
                    let goLogin  = UIAlertAction(title: "OK", style: .default, handler: { action in self.performSegue(withIdentifier: "showLoginPage", sender: self)})
                    alert.addAction(goLogin)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    //Error
                    self.presentSignupAlertView()
                }
            }
        } else {
            // Fields not filled
            presentSignupAlertView()
        }
    }
    
    func presentSignupAlertView() {
        let alertController = UIAlertController(title: "Error", message: "Couldn't create account", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
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
    
    //Pass username from signup page to login page.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLoginPage" {
            let dest = segue.destination as! ResLogViewController
            dest.email.text = email.text
        }
            
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
    
    func uploadImage() {
        // Points to the root reference
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child("images")
        let iconRef = imagesRef.child("\(localUser.email).jpg")
        // Data in memory
        var data = Data()
        if let imageData = UIImageJPEGRepresentation(self.profilio.image!, 0.7) {
            data = NSData(data: imageData) as Data
        }
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = iconRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profilio.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        profilio.contentMode = .scaleAspectFill
        profilio.layer.cornerRadius = profilio.frame.size.width/2
        profilio.clipsToBounds = true
        
        //constrain
        let coverWidthCons = NSLayoutConstraint(item: profilio, attribute: .width, relatedBy: .equal, toItem: profilio, attribute: .width, multiplier: 1, constant: 0)
        
        let coverHeightCons = NSLayoutConstraint(item: profilio, attribute: .height, relatedBy: .equal, toItem: profilio, attribute: .height, multiplier: 1, constant: 0)
        
        coverWidthCons.isActive = true
        coverHeightCons.isActive = true
        
        //dimiss the view
        dismiss(animated: true, completion: nil)
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
