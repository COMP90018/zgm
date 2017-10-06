//
//  ProfileTableViewController.swift
//  taskhelper
//
//  Created by DongGao on 23/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import SafariServices

class ProfileTableViewController: UITableViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    
    var sectionTitle = ["Personal Information","Task Helper","More Options","About Us"]
    var sectionContent = [["","","",""],["Help Your Friends","Friends"],["Settings"],["Website","Github"]]
    var links = ["https://taskhelper.azurewebsites.net","https://github.com/COMP90018/zgm"]
    
    var secNum:Int = 0
    var rowNum:Int = 0
    
    
    @IBAction func changeImage(_ sender: UIButton) {
       
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
        
        var method = ""
        if localUser.faceRecog {
            method = method + " Face ecognition"
        }
        if localUser.voiceRecog {
            method = method + " Speech Recognition"
        }
        
        if !localUser.isVerified {
            method = " None!"
        }
        
        sectionContent[0][0] = "Username: " + localUser.username
        sectionContent[0][1] = "Total Tasks: " + String(localUser.taskNum)
        sectionContent[0][2] = "Compeleted Tasks: " + String(localUser.taskCompeleteNum)
        sectionContent[0][3] = "Verification Methods:" + method
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if results.count != 0 {
                
                for result in results {
                    
                    if (result as AnyObject).value(forKey: "email") as! String == localUser.email {
                        
                        let data = (result as AnyObject).value(forKey: "profileImage") as! Data
                        profileImage.image = UIImage(data: data)
                        
                    } else {
                        downloadImage()
                        profileImage.image = localUser.profileImage
                    }
                }
                
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        


        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        uploadImage()
        updateAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 4
        case 1:
            return 2
        case 2:
            return 1
        case 3:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        if indexPath.section != 0 {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 1:
            secNum = 1
            performSegue(withIdentifier: "showDetailProfile", sender: self)
        case 2:
            secNum = 2
            rowNum = indexPath.row
            performSegue(withIdentifier: "showDetailProfile", sender: self)
        case 3:
            if let url = URL(string: links[indexPath.row]) {
                let sfVc = SFSafariViewController(url: url)
                present(sfVc, animated: true, completion: nil)
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.font = UIFont(name: "Futura-Medium", size: 17)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        header.textLabel?.font = UIFont(name: "Futura-Medium", size: 15)
        header.textLabel?.textAlignment = .center
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        //constrain
        let coverWidthCons = NSLayoutConstraint(item: profileImage, attribute: .width, relatedBy: .equal, toItem: profileImage, attribute: .width, multiplier: 1, constant: 0)
        
        let coverHeightCons = NSLayoutConstraint(item: profileImage, attribute: .height, relatedBy: .equal, toItem: profileImage, attribute: .height, multiplier: 1, constant: 0)
        
        coverWidthCons.isActive = true
        coverHeightCons.isActive = true
        
        //dimiss the view
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage() {
        // Points to the root reference
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child("images")
        let iconRef = imagesRef.child("\(localUser.email).jpg")
        // Data in memory
        var data = Data()
        if let imageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.7) {
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
    
    
    func downloadImage() {
        let storageRef = Storage.storage().reference()
        let islandRef = storageRef.child("images/\(localUser.email)jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                localUser.profileImage = UIImage(data: data!)!
            }
        }
    }

    
    
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

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }


    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showDetailProfile" {
            let dest = segue.destination as! DetailProfileTableViewController
            //            dest.hidesBottomBarWhenPushed = true
            dest.secNum = secNum
            dest.rowNum = rowNum
        }
        
        // Pass the selected object to the new view controller.
    }
    
    func updateAll(){
        
        deleteAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "User", in:managedContext)
        let user = NSManagedObject(entity: entity!,
                                   insertInto: managedContext)
        let friendList = NSKeyedArchiver.archivedData(withRootObject: localUser.friendList)
        let requestTasks = NSKeyedArchiver.archivedData(withRootObject: localUser.requestTasks)
        let requestFriends = NSKeyedArchiver.archivedData(withRootObject: localUser.requestFriends)
        //save the data
        
        if let imageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.7) {
            user.setValue(NSData(data: imageData), forKey: "profileImage")
        }
        user.setValue(localUser.email, forKey: "email")
        user.setValue(localUser.username, forKey: "username")
        user.setValue(localUser.faceRecog, forKey: "isVerified")
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
    }
    
    
    
    func deleteAll(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let results = try managedContext.fetch(request)
            if results.count != 0 {
                for result in results {
                    if (result as AnyObject).value(forKey: "email") as! String == localUser.email {
                        managedContext.delete(result as! NSManagedObject)
                    }
                }
                do {
                    try managedContext.save()
                } catch {
                    print(error)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    

}
