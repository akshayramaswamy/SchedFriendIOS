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
import FirebaseStorage

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate,     UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    
    var user: User!
    var userProfile: UserProfile!
    var rootRef = FIRDatabase.database().reference()
    var userRef: FIRDatabaseReference?
    
    @IBOutlet weak var profileImage: UIImageView!
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        picker.delegate = self
        //UI designing
        
        segmentedClassView.layer.cornerRadius = 10.0
        segmentedClassView.layer.borderColor = UIColor.blue.cgColor
        segmentedClassView.layer.borderWidth = 1.0
        segmentedClassView.layer.masksToBounds = true
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2;
        self.profileImage.clipsToBounds = true;
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            
            guard let user = user else { return }
            self.user = User(authData: user)
            
            self.userRef = self.rootRef.child(self.user.uid)
            //print(self.user.uid)
            
            self.userRef?.queryOrdered(byChild: "uid").observeSingleEvent(of: .value, with: { snapshot in
                
                if (self.user.uid == snapshot.key){
                    
                    if let fallList:[String] = (snapshot.childSnapshot(forPath: "fallClasses").value as? Array<String>){
                        self.fallList = fallList
                    }
                    if let winter:[String] = (snapshot.childSnapshot(forPath: "winterClasses").value as? Array<String>){
                        self.winterList = winter
                    }
                    
                    if let spring:[String] = (snapshot.childSnapshot(forPath: "springClasses").value as? Array<String>) {
                        self.springList = spring
                    }
                    
                    if let profilePicture:String = (snapshot.childSnapshot(forPath: "profilePicture").value as? String) {
                        if (profilePicture.characters.count != 0){
                            if(self.user.uid == snapshot.key){
                                let url = URL(string: profilePicture)
                                if let data = try? Data(contentsOf: url!){
                                    self.profileImage.image = UIImage(data: data)
                                }
                            }
                        }
                        
                    }
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
            //print(snapshot.key)
            if (self.user.uid == snapshot.key){
                
                if let fallList:[String] = (snapshot.childSnapshot(forPath: "fallClasses").value as? Array<String>) {
                    self.fallList = fallList
                }
                if let winter:[String] = (snapshot.childSnapshot(forPath: "winterClasses").value as? Array<String>){
                    self.winterList = winter
                }
                if let spring:[String] = (snapshot.childSnapshot(forPath: "springClasses").value as? Array<String>){
                    self.springList = spring
                }
                
                self.classTableView.reloadData()
            }
        })
    }
    
    
    @IBAction func uploadImage(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage //2
        profileImage.contentMode = .scaleAspectFill //3
        profileImage.image = chosenImage
        
        let storageRef = FIRStorage.storage().reference().child(self.user.uid)
        if let uploadData = UIImagePNGRepresentation(profileImage.image!){
            storageRef.put(uploadData, metadata: nil, completion:{
                (metadata, error) in
                
                let imageURL = (metadata?.downloadURL())!
                print (imageURL)
                let ref = FIRDatabase.database().reference()
                let userRef  = ref.child(self.user.uid)
                let imageString = imageURL.absoluteString
                print (imageString)
                userRef.updateChildValues(["profilePicture": imageString as Any ], withCompletionBlock: { (error, snapshot) in
                    print("updated profile pic")
                    if error != nil {
                        print("oops, an error with picture")
                    }
                    
                })
                
                
            })
        }
        
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
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
