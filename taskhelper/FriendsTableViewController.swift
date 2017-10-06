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
    var sortedFirstLetters: [String] = []
    var sections: [[Friend]] = [[]]
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
        friendsList.append(Friend(friendName: "Arthur", friendEmail:"donngao@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        friendsList.append(Friend(friendName: "Arthur", friendEmail:"donngao@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        friendsList.append(Friend(friendName: "Arthur", friendEmail:"donngao@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        friendsList.append(Friend(friendName: "Arthur", friendEmail:"donngao@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        friendsList.append(Friend(friendName: "Arthur", friendEmail:"donngao@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        friendsList.append(Friend(friendName: "Arthur", friendEmail:"donngao@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        friendsList.append(Friend(friendName: "Arthur", friendEmail:"donngao@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        friendsList.append(Friend(friendName: "Arthur", friendEmail:"donngao@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        friendsList.append(Friend(friendName: "Arthur", friendEmail:"donngao@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        friendsList.append(Friend(friendName: "Arthur", friendEmail:"donngao@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        friendsList.append(Friend(friendName: "Arthur", friendEmail:"donngao@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        friendsList.append(Friend(friendName: "Arthur", friendEmail:"donngao@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        friendsList.append(Friend(friendName: "Bob", friendEmail:"bob@gmail.com",friendIcon: UIImage(named: "profile_image.png")!))
        
        //There should be a function to get all friends from server
        getAllFriends(username: "")
        sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        tableView.tableHeaderView = sc.searchBar
        sc.dimsBackgroundDuringPresentation = false
        //sc.searchBar.barTintColor = UIColor.orange
        //sc.searchBar.tintColor = UIColor.white
        sc.searchBar.placeholder = "Search"
        sc.searchBar.searchBarStyle = .minimal
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Generate index of names
        // All the first letters in the data
        let firstLetters = friendsList.map { $0.nameFirstLetter }
        //Remove duplicates
        let uniqueFirstLetters = Array(Set(firstLetters))
        //Sort and generate the index
        sortedFirstLetters = uniqueFirstLetters.sorted()
        //Generate sections and sort friend list
        sections = sortedFirstLetters.map { firstLetter in
            return friendsList
                .filter { $0.nameFirstLetter == firstLetter }
                .sorted { $0.friendName < $1.friendName }
        }
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
        return sc.isActive ? 1 : sortedFirstLetters.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sc.isActive ? nil : sortedFirstLetters[section]
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sc.isActive ? nil :sortedFirstLetters
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sc.isActive ? searchResult.count : sections[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        //Configure the cell...
        let friend = sc.isActive ? searchResult[indexPath.row] :sections[indexPath.section][indexPath.row]

        cell.textLabel?.text = friend.friendName
        cell.detailTextLabel?.text = friend.friendEmail
        cell.imageView?.image = imageWithImage(image: friend.friendIcon,scaledToSize: CGSize(width:40, height: 40))
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.width)!/2
        cell.imageView?.clipsToBounds = true

        return cell
        
        
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//
//        // Modify cell
//        cell?.textLabel?.text = FriendSystem.system.userList[indexPath.row].username
//        cell?.detailTextLabel?.text = FriendSystem.system.userList[indexPath.row].email
//        cell?.imageView?.image = UIImage(named: "user.png")
//
//        // Return cell
//        return cell!
    }
    
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
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
