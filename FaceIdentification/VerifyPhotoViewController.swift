//
//  VerifyPhotoViewController.swift
//  FaceIdentification
//
//  Created by 奇奇 on 2017/9/22.
//  Copyright © 2017年 MelbUni. All rights reserved.
//

import UIKit

class VerifyPhotoViewController: UIViewController {
    
    var image: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let availableImage = image{
            imageView.image = availableImage
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAlert(titleText: String, messageText: String){
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
