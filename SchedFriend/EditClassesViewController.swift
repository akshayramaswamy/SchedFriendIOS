//
//  EditClassesViewController.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/16/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//
//  This file allows the user to add classes to their schedule using a UIPicker
//  and sends notifications to the parent view controller to update the user's schedule in realtime

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class EditClassesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var classPicker: UIPickerView!
    
    var selectedPick:String = "CS221"
    var pickerData: [String] = [String]()
    var user: User!
    let ref = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.classPicker.delegate = self
        self.classPicker.dataSource = self
        pickerData = ["CS221", "CS229", "CS193P", "PHIL2", "MATH51", "ECON1", "CS274"]
        FIRAuth.auth()!.addStateDidChangeListener { [weak self] auth, user in
            guard let user = user else { return }
            self?.user = User(authData: user)

        }
    }
    
    
    @IBAction func addFallClasses(_ sender: UIButton) {
        var fallClasses:[String]?
        let userRef  = ref.child(self.user.uid)
        
        userRef.queryOrdered(byChild: "uid").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            if let retrievedFallClasses = (snapshot.childSnapshot(forPath: "fallClasses").value as? Array<String>){
                if (!((retrievedFallClasses.contains((self?.selectedPick)!)))){
                    fallClasses = retrievedFallClasses
                    fallClasses?.append((self?.selectedPick)!)
                    
                } else {
                    fallClasses = retrievedFallClasses
                }
            } else{
                fallClasses = [(self?.selectedPick)!]
            }
            
            userRef.updateChildValues(["fallClasses":fallClasses ?? "No class"], withCompletionBlock: { (error, snapshot) in
                if error != nil {
                    
                    print("oops, an error")
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
                
            })
            
            //get first and last name of user, add under class name
            self?.addToDB(snapshot: snapshot)
            
            
            
        })
        
        
    }


    @IBAction func addWinterClasses(_ sender: UIButton) {
        var winterClasses:[String]?
        let userRef  = ref.child(self.user.uid)
        userRef.queryOrdered(byChild: "uid").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            if let retrievedWinterClasses = (snapshot.childSnapshot(forPath: "winterClasses").value as? Array<String>){
                if (!((retrievedWinterClasses.contains((self?.selectedPick)!)))){
                    winterClasses = retrievedWinterClasses
                    winterClasses?.append((self?.selectedPick)!)
                    
                } else {
                    winterClasses = retrievedWinterClasses
                }
            } else{
                winterClasses = [(self?.selectedPick)!]
            }
            
            userRef.updateChildValues(["winterClasses":winterClasses ?? "No class"], withCompletionBlock: { (error, snapshot) in
                if error != nil {
                    
                    print("oops, an error")
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
                
            })
            self?.addToDB(snapshot: snapshot)
        })
    }
    
    @IBAction func addSpringClasses(_ sender: UIButton) {
        var springClasses:[String]?
        let userRef  = ref.child(self.user.uid)
        userRef.queryOrdered(byChild: "uid").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            if let retrievedSpringClasses = (snapshot.childSnapshot(forPath: "springClasses").value as? Array<String>){
                if (!((retrievedSpringClasses.contains((self?.selectedPick)!)))){
                    springClasses = retrievedSpringClasses
                    springClasses?.append((self?.selectedPick)!)
                    
                } else {
                    springClasses = retrievedSpringClasses
                }
            } else{
                springClasses = [(self?.selectedPick)!]
            }
            
            userRef.updateChildValues(["springClasses":springClasses ?? "No class"], withCompletionBlock: { (error, snapshot) in
                if error != nil {
                    
                    print("oops, an error")
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
                
            })
            
            self?.addToDB(snapshot: snapshot)
        })
    }
    
    //add user's name to list of people in class they added
    func addToDB(snapshot:FIRDataSnapshot){
        
        let classRef = ref.child(self.selectedPick)
        if let firstName = (snapshot.childSnapshot(forPath: "firstName").value as? String){
            if let lastName = (snapshot.childSnapshot(forPath: "lastName").value as? String){
                //add name to class list
                classRef.queryOrdered(byChild: "students").observeSingleEvent(of: .value, with: { snapshot in
                    if let retrievedStudents = (snapshot.childSnapshot(forPath: "students").value as? Array<String>){
                        var students = retrievedStudents
                        if(!students.contains(firstName + " " + lastName)){
                            students.append(firstName + " " + lastName)
                        }
                        classRef.updateChildValues(["students":students], withCompletionBlock: { (error, snapshot) in
                            if error != nil {
                                
                                print("oops, an error")
                            }
                            
                        })
                    } else{
                        let students = [firstName + " " + lastName]
                        classRef.updateChildValues(["students":students], withCompletionBlock: { (error, snapshot) in
                            if error != nil {
                                
                                print("oops, an error")
                            }
                        })
                    }
                })
                
            }
        }
        
    }
    
    /* Setup for using UIPickerView */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedPick = pickerData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = pickerData[row]
        return NSAttributedString(string: str, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }

    
}
