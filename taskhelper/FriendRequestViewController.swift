//
//  FriendRequestViewController.swift
//  taskhelper
//
//  Created by Yijie Zhang on 7/10/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class FriendRequestViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(rightSwipe)
        
        FriendSystem.system.addRequestObserver {
            self.tableView.reloadData()
        }
    }
    
    func swipeAction(swipe:UISwipeGestureRecognizer) {
        switch swipe.direction.rawValue {
        case 1:
            performSegue(withIdentifier: "goBack", sender: self)
        default:
            break
        }
    }
    
}

extension FriendRequestViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.requestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        if cell == nil {
            tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        }
        
        // Modify cell
        cell!.button.setTitle("Accept", for: UIControlState())
        cell!.emailLabel.text = FriendSystem.system.requestList[indexPath.row].username
        
        cell!.setFunction {
            let id = FriendSystem.system.requestList[indexPath.row].id
            FriendSystem.system.acceptFriendRequest(id!)
        }
        
        // Return cell
        return cell!
    }
    
}
