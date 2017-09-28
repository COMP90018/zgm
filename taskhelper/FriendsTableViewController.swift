//
//  FriendsTableViewController.swift
//  taskhelper
//
//  Created by DongGao on 25/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit
import CoreData

class FriendsTableViewController: UITableViewController, UISearchResultsUpdating{
    
    var friendsList: [Friend] = []
    var searchResult: [Friend] = []
    var sc: UISearchController!
    
    
    
    func searchFilter(text: String) {
        searchResult = friendsList.filter({ (friend) -> Bool in
            return friend.friendName.localizedCaseInsensitiveContains(text)
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if var text = searchController.searchBar.text {
            text = text.trimmingCharacters(in: .whitespaces)
            searchFilter(text: text)
            tableView.reloadData()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
        //Static friend data
        friendsList.append(Friend(friendName: "Arthur", friendIcon: UIImage(named: "profile_image")!))
        friendsList.append(Friend(friendName: "Bob", friendIcon: UIImage(named: "profile_image")!))
        
        //There should be a function to get all friends from server
        getAllFriends(username: "")
        sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        tableView.tableHeaderView = sc.searchBar
        //不变暗，搜索之后可以直接点击进入
        sc.dimsBackgroundDuringPresentation = false
        //定制搜索条
        //        sc.searchBar.barTintColor = UIColor.orange
        //        sc.searchBar.tintColor = UIColor.white
        sc.searchBar.placeholder = "Search"
        sc.searchBar.searchBarStyle = .minimal
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func getAllFriends(username: String) -> [Friend] {
        //Get all friends from server
        return friendsList
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
        return sc.isActive ? searchResult.count : FriendSystem.system.userList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
//        let friend = sc.isActive ? searchResult[indexPath.row] :friendsList[indexPath.row]
//
//        cell.textLabel?.text = friend.friendName
//        cell.imageView?.image = friend.friendIcon
//        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.width)!/2
//        cell.imageView?.clipsToBounds = true
//
//        return cell
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        // Modify cell
        cell?.textLabel?.text = FriendSystem.system.userList[indexPath.row].username
        cell?.detailTextLabel?.text = FriendSystem.system.userList[indexPath.row].email
        cell?.imageView?.image = UIImage(named: "user.png")
        
        // Return cell
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
