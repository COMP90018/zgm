//  PopupViewController.swift
//  Author: Meng Qi
//  Declaration: the function was build based on the tutorials from the following sources:
//      Tutorial: https://www.youtube.com/watch?v=FgCIRMz_3dE
//      Source: https://github.com/awseeley/Swift-Pop-Up-View-Tutorial

import UIKit

class PopupViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.showAnimate()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    @IBAction func retryLogin(_ sender: UIButton) {
        
        performSegue(withIdentifier: "unwindVerifyFail", sender: self)
    }
    
    
    //verified successfully
    @IBAction func faceLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindVerifyDone", sender: self)
        
    }
    
    
    
    
    
    
    @IBAction func faceCreated(_ sender: UIButton) {
        
        performSegue(withIdentifier: "unwindFaceToSignup", sender: self)
    }
    
    
    
    
    @IBAction func voiceCreated(_ sender: UIButton) {
        
        performSegue(withIdentifier: "unwindVoiceToSignup", sender: self)
    }
    
    
    
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
    }
    
}

