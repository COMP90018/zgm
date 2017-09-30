//
//  CircleButton.swift
//  FaceIdentification
//
//  Created by 奇奇 on 2017/9/23.
//  Copyright © 2017年 MelbUni. All rights reserved.
//

import UIKit

@IBDesignable

class CircleButton: UIButton {
    @IBInspectable var cornerRadious: CGFloat = 30.0{
        didSet{
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView(){
        layer.cornerRadius = cornerRadious
    }

}
