//
//  User.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/15/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//
//  This file creates and object for each user's ID and email

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

import Foundation

struct User {
    
    let uid: String
    let email: String
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
