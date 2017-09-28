//
//  ProfileTableViewController.swift
//  taskhelper
//
//  Created by DongGao on 23/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit
import SafariServices

class ProfileTableViewController: UITableViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    
    var sectionTitle = ["Personal Information","Task Helper","More Options","About Us"]
    var sectionContent = [["","","",""],["Helper","Friends"],["Settings"],["Website","Github"]]
    var links = ["https://taskhelper.azurewebsites.net","https://github.com/COMP90018/zgm"]
    
    var secNum:Int = 0
    var rowNum:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var method = ""
        if gameUser.baseImage {
            method = method + " Face ecognition"
        }
        if gameUser.baseVoice {
            method = method + " Speech Recognition"
        }
        
        if !gameUser.isVerified {
            method = " None!"
        }
        
        sectionContent[0][0] = "Username: " + gameUser.username
        sectionContent[0][1] = "Total Tasks: " + String(gameUser.taskNum)
        sectionContent[0][2] = "Compeleted Tasks: " + String(gameUser.taskCompeleteNum)
        sectionContent[0][3] = "Verification Methods:" + method
        
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
        header.contentView.backgroundColor = UIColor(red: 224/255, green: 227/255, blue: 218/255, alpha: 0.7)
        header.textLabel?.font = UIFont(name: "Futura-Medium", size: 15)
        header.textLabel?.textAlignment = .center
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
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
    

}
