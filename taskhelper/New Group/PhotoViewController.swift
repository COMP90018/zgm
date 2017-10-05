//  PhotoViewController.swift
//  Author: Meng Qi
//  Declaration: the function was build based on the tutorials from the following sources:
//      Tutorial: https://www.youtube.com/watch?v=2gs5QTRC8Yk&t=101s
//      Source: https://bitbucket.org/team-devslopes/ios-10-speech-recognition-api
//      Tutorial: https://www.youtube.com/watch?v=FgCIRMz_3dE
//      Source: https://github.com/awseeley/Swift-Pop-Up-View-Tutorial
//      Tutorial: https://www.youtube.com/watch?v=hIW6atqmig0
//      Tutorial： https://www.youtube.com/watch?v=r-0YyveITWU&t=178s

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

