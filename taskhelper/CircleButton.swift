//
//  CircleButton.swift
//  taskhelper
//
//  Created by 奇奇 on 2017/10/3.
//  Copyright © 2017年 Microsoft. All rights reserved.
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
