//
//  User.swift
//  FirebaseTask
//
//  Created by 劉仲軒 on 2017/3/14.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation

class User {
    static let email = "abc@gmail.com"
    static let password = "123456"
    static let firstName = "Roy"
    static let lastName = "Hsu"
    
    let email: String!
    let password: String!
    let firstName: String!
    let lastName: String!
    let uid: String!
    
    init(uid: String, email: String, password: String, firstName: String, lastName: String) {
        self.uid = uid
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
}
