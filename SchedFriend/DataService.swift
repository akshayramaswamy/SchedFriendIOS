//
//  DataService.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/14/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DataService {
    static let dataService = DataService()
    
    var BASE_REF = FIRDatabaseReference().child(BASE_URL)
    var USER_REF = FIRDatabaseReference().child("\(BASE_URL)/users")
    var JOKE_REF = FIRDatabaseReference().child("\(BASE_URL)/jokes")
    

    
    var CURRENT_USER_REF: FIRDatabaseReference {
        let userID = UserDefaults.standard.value(forKey: "uid") as! String
        
        let currentUser = FIRDatabaseReference().child("\(BASE_REF)").child("users").child(userID)
        
        return currentUser
    }
    

}
