//
//  ProfileViewController.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/10/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate{
    @IBOutlet weak var profileImage: UIImageView!
    
    var user: User!
    var userProfile: UserProfile!
    var rootRef = FIRDatabase.database().reference()
    var userRef: FIRDatabaseReference?

    override func viewDidLoad() {
        
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in

            guard let user = user else { return }
            self.user = User(authData: user)
 
            self.userRef = self.rootRef.child(self.user.uid)
            print(self.user.uid)

            self.userRef?.queryOrdered(byChild: "uid").observeSingleEvent(of: .value, with: { snapshot in
                //print(snapshot)
                print("transition")
                print(snapshot.value)
                if (self.user.uid == snapshot.key){
                    
                    let fallList:[String] = (snapshot.childSnapshot(forPath: "fallClasses").value as? Array<String>)!
                    self.fallList = fallList
                    
                    let winter:[String] = (snapshot.childSnapshot(forPath: "winterClasses").value as? Array<String>)!
                    self.winterList = winter
                    
                    let spring:[String] = (snapshot.childSnapshot(forPath: "springClasses").value as? Array<String>)!
                    self.springList = spring
                    self.classTableView.reloadData()

                }
            })
        }

        


    }
    
    func loadList(){
        print ("reloaded")
        //load data here
        self.userRef?.queryOrdered(byChild: "uid").observeSingleEvent(of: .value, with: { snapshot in
            //print(snapshot)
            print(snapshot.key)
            if (self.user.uid == snapshot.key){
                
                let fallList:[String] = (snapshot.childSnapshot(forPath: "fallClasses").value as? Array<String>)!
                self.fallList = fallList
        self.classTableView.reloadData()
            }
        })
    }
    
    var fallList:[String]?
    var winterList:[String]?
    var springList:[String]?
    @IBOutlet weak var segmentedClassView: UISegmentedControl!
    @IBOutlet weak var classTableView: UITableView!

    @IBOutlet weak var profileName: UILabel!

    @IBAction func signOut(_ sender: UIBarButtonItem) {
        try? FIRAuth.auth()!.signOut()
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var returnValue = 0
        
        switch(segmentedClassView.selectedSegmentIndex)
        {
        case 0:
            returnValue = fallList?.count ?? 0
            break
        case 1:
            returnValue = winterList?.count ?? 0
            break
            
        case 2:
            returnValue = springList?.count ?? 0
            break
            
        default:
            break
            
        }
        
        return returnValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let classCell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath)
        
        switch(segmentedClassView.selectedSegmentIndex)
        {
        case 0:
            classCell.textLabel!.text = fallList?[indexPath.row]
            break
        case 1:
            classCell.textLabel!.text = winterList?[indexPath.row]
            break
            
        case 2:
            classCell.textLabel!.text = springList?[indexPath.row]
            break
            
        default:
            break
            
        }
        
        
        return classCell
    }
    
    @IBAction func segmentedClassViewChanged(_ sender: UISegmentedControl) {
        
        classTableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(" no segue")
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destination 
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
            print("segue")
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle
    {
        return .none
    }
    
    
}
