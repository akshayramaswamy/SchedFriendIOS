//
//  UserProfile.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/15/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//
// This file creates and object for customized user data (ID, name, classes, profile picture)

import Foundation

import FirebaseAuth
import FirebaseDatabase
import Firebase

struct UserProfile {
    
    let key: String
    let uid: String
    let firstName: String
    let lastName:String
    let fallClasses: [String]
    let winterClasses: [String]
    let springClasses: [String]
    let profilePicture: String
    let ref: FIRDatabaseReference?
    
    
    init(uid: String, firstName: String, lastName: String, fallClasses: Array<String>, winterClasses: Array<String>, springClasses: Array<String>, profilePicture: String, key: String = "") {
        self.key = key
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.fallClasses = fallClasses
        self.winterClasses = winterClasses
        self.springClasses = springClasses
        self.profilePicture = profilePicture
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        uid = snapshotValue["uid"] as! String
        firstName = snapshotValue["firstName"] as! String
        lastName = snapshotValue["lastName"] as! String
        fallClasses = snapshotValue["fallClasses"] as! Array<String>
        winterClasses = snapshotValue["winterClasses"] as! Array<String>
        springClasses = snapshotValue["springClasses"] as! Array<String>
        profilePicture = snapshotValue["profilePicture"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "uid": uid,
            "firstName": firstName,
            "lastName": lastName,
            "fallClasses": fallClasses,
            "winterClasses": winterClasses,
            "springClasses": springClasses,
            "profilePicture": profilePicture
        ]
    }
    
}
