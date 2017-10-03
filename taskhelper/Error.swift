//
//  Error.swift
//  taskhelper
//
//  Created by Yijie Zhang on 28/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthError {
    
    var errorMessage: String!
    
    init(error: AuthErrorCode) {
        switch error {
            
        case .invalidEmail:
            errorMessage = "Whoops! That's not a valid email!"
            
        case .userDisabled:
            errorMessage = "This user is blocked."
            
        case .emailAlreadyInUse:
            errorMessage = "There's already an account with this email!"
            
        default:
            errorMessage = "Looks like something went wrong. Please try again!"
        }
    }
    
}
