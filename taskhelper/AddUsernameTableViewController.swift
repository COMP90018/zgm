//
//  AddUsernameTableViewController.swift
//  taskhelper
//
//  Created by Yijie Zhang on 7/10/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit
import Firebase

class AddUsernameTableViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    let searchController = UISearchController(searchResultsController: nil)
    let USER_REF = Database.database().reference().child("users")
    var userList = [FirebaseUser]()
    var searchResult = [FirebaseUser]()
    
    func searchFilter(text: String) {
        searchResult = userList.filter({ (userList) -> Bool in
            return(userList.username.contains(text))
        })
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(rightSwipe)
        
        FriendSystem.system.getCurrentUser { (user) in
            self.usernameLabel.text = user.username
            self.usernameLabel.sizeToFit()
        }
        
        addUserObserver { () in
            self.tableView.reloadData()
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func addUserObserver(_ update: @escaping () -> Void) {
        USER_REF.observe(DataEventType.value, with: { (snapshot) in
            self.userList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let email = child.childSnapshot(forPath: "email").value as! String
                let username = child.childSnapshot(forPath: "username").value as! String
                if email != Auth.auth().currentUser?.email! {
                    self.userList.append(FirebaseUser(userID: child.key, userEmail: email, userName: username))
                }
                
            }
            update()
        })
    }
    
    func swipeAction(swipe:UISwipeGestureRecognizer) {
        switch swipe.direction.rawValue {
        case 1:
            performSegue(withIdentifier: "goLeft", sender: self)
        default:
            break
        }
    }
    
    
}

extension AddUsernameTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text != "" {
            return searchResult.count
        } else {
            return userList.count
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
            user = userList[indexPath.row]
        }
        
        // Modify cell
        cell!.emailLabel.text = user.username
        
        cell!.setFunction {
            let id = user.id
            FriendSystem.system.sendRequestToUser(id!)
        }
        
        // Return cell
        return cell!
    }
    
}

extension AddUsernameTableViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        searchFilter(text: searchController.searchBar.text!)
    }
}
