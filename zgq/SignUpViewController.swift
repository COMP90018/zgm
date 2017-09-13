//
//  SignUpViewController.swift
//  zgq
//
//  Created by DongGao on 9/9/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBAction func signUpGoogle(_ sender: UIButton) {
    }
    
    
    @IBAction func signUpFacebook(_ sender: UIButton) {
    }
    
    
    @IBAction func signUpLinkedin(_ sender: UIButton) {
    }
    
    
    @IBAction func signUpEmail(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let agreeDeal = UILabel()
        
        //富文本,不同字体颜色大小和颜色
        
        let labelString = "登录注册，表示您同意《服务条款及隐私政策》"as NSString
        
        let rang = labelString.range(of: "《")
        
        let firstRang = NSMakeRange(0, rang.location)
        
        let secondRang = NSMakeRange(rang.location, labelString.length - rang.location)
        
        let labelText = NSMutableAttributedString(string: labelString as String as String)
        
        labelText.addAttributes([NSForegroundColorAttributeName:UIColor.init(white: 1, alpha: 0.8),NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)], range: firstRang)
        
        labelText.addAttributes([NSForegroundColorAttributeName:UIColor.red,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)], range: secondRang)
        
        agreeDeal.attributedText = labelText
        
        agreeDeal.textAlignment = .center
        
        agreeDeal.numberOfLines = 0
        
        self.view.addSubview(agreeDeal)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
