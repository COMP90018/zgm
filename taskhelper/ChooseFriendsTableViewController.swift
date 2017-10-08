//
//  ChooseFriendsTableViewController.swift
//  taskhelper
//
//  Created by DongGao on 7/10/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit
import Firebase


class ChooseFriendsTableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var friendName: String = ""
    var friendID: String = ""
    var friendIcon: UIImage = UIImage()
    

    let searchController = UISearchController(searchResultsController: nil)
    var firebaseFriendList = [FirebaseUser]()
    var searchResult = [FirebaseUser]()
    
    func searchFilter(text: String) {
        searchResult = firebaseFriendList.filter({ (firebaseFriendList) -> Bool in
            return(firebaseFriendList.username.contains(text))
        })
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addFriendObserver {
            self.tableView.reloadData()
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    
    @IBAction func cancelTap(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToAddTask", sender: self)
        
        
    }
    
    

    
    
    func addFriendObserver(_ update: @escaping () -> Void) {
        CURRENT_USER_FRIENDS_REF.observe(.value, with: { (snapshot) in
            self.firebaseFriendList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let id = child.key
                FriendSystem.system.getUser(id, completion: { (user) in
                    self.firebaseFriendList.append(user)
                    update()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                update()
            }
        })
    }
    
    
    func downloadImage(_ email: String) {
        let storageRef = Storage.storage().reference()
        let islandRef = storageRef.child("images/\(email).jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 200 * 200) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("download error")
            } else {
                // Data for "images/island.jpg" is returned
                localFriend.friendIcon = UIImage(data: data!)!
            }
        }
    }

    
    
    
    
}

extension ChooseFriendsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text != "" {
            return searchResult.count
        } else {
            return firebaseFriendList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        if cell == nil {
            tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        }
        
        let user: FirebaseUser
        if searchController.searchBar.text != "" {
            user = searchResult[indexPath.row]
        } else {
            user = firebaseFriendList[indexPath.row]
        }
        
        // Modify cell
        cell!.button.setTitle("Remove", for: UIControlState())
        cell!.emailLabel.text = user.username
        
        cell!.setFunction {
            let id = user.id
            FriendSystem.system.removeFriend(id!)
        }
        
        // Return cell
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        friendName = firebaseFriendList[indexPath.row].username
        friendID = firebaseFriendList[indexPath.row].id
        localFriend.friendIcon = UIImage(named: "arrow.png")!
        var friendEmail = firebaseFriendList[indexPath.row].email
        downloadImage(friendEmail!)
        
        performSegue(withIdentifier: "unwindToAddTask", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

extension ChooseFriendsTableViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        searchFilter(text: searchController.searchBar.text!)
    }
}
