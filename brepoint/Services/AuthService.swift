//
//  AuthService.swift
//  brepoint
//
//  Created by Bela Mate Barandi on 4/9/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()

    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping CompletionHandler) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            let userData = ["provider": user.providerID, "email": user.email]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            userCreationComplete(true, nil)
            
        }
    }

    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping CompletionHandler) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if user != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
            
        }
    }

}
