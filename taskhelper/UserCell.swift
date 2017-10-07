//
//  UserCell.swift
//  taskhelper
//
//  Created by Yijie Zhang on 30/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    
    var buttonFunc: (() -> (Void))!
    
    @IBAction func buttonTapped(sender: UIButton) {
        buttonFunc()
    }
    
    func setFunction(_ function: @escaping () -> Void) {
        self.buttonFunc = function
    }
    
}
