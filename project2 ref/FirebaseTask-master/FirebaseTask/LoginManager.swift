//
//  LoginManager.swift
//  FirebaseTask
//
//  Created by 劉仲軒 on 2017/3/14.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginManager: NSObject {
    
    static let shared = LoginManager()
    let auth = FIRAuth.auth()
    let databaseRef = FIRDatabase.database().reference()
    
    typealias CreateSuccess = (User) -> Void
    typealias CreateError = (Error) -> Void
    
    func create(withEmail email: String, password: String, firstName: String, lastName: String, success: CreateSuccess?, fail: CreateError? = nil) {
        
        self.auth?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error?.localizedDescription == "The email address is already in use by another account." {
                print("Create user error: \(error?.localizedDescription)")
//                self.login(withEmail: email, password: password, success: { (email, uid) in
//                    let user = User(uid: uid, email: email, password: password, firstName: firstName, lastName: lastName)
//                    success?(user)
//                }, fail: { (error) in
//                    fail?(error)
//                })
                fail?(error!)
                return
            } else if error != nil {
                print("Create user error: \(error?.localizedDescription)")
                fail?(error!)
                return
            }
            
            self.databaseRef.child("Users").child(user!.uid).setValue(["Provider": password, "Email": email, "First Name": firstName, "Last Name": lastName])
        
            self.login(withEmail: email, password: password, success: { (email, uid) in
                let user = User(uid: uid, email: email, password: password, firstName: firstName, lastName: lastName)
                success?(user)
            }, fail: { (error) in
                fail?(error)
            })

        })
        
    }

    typealias LoginSuccess = (_ email: String, _ uid: String) -> Void
    typealias LoginError = (Error) -> Void
    
    func login(withEmail email: String, password: String, success: LoginSuccess?, fail: LoginError? = nil) {
        self.auth?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            
            if error != nil {
                print("Sign in error: \(error)")
                fail?(error!)
                return
            }
            
            guard let userEmail = user?.email, let uid = user?.uid else { return }

            success?(userEmail, uid)
            print("Success login with user: \(user?.email), uid: \(user?.uid)")
            
        })
        return
    }
    
}
