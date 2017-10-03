//
//  PhotoViewController.swift
//  FaceIdentification
//
//  Created by 奇奇 on 2017/9/21.
//  Copyright © 2017年 MelbUni. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var takenPhoto: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let availableImage = takenPhoto{
            imageView.image = availableImage
        }
    }
    
    
    
    @IBAction func done(_ sender: Any) {
        //store the photo locally
        
        if let data = UIImageJPEGRepresentation(takenPhoto, 0.8) {
            
            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let imageURL = docDir.appendingPathComponent("tmp.jpeg")
            try! data.write(to: imageURL)
            
            print("image saved")
        }
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "facePopup") as! PopupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

