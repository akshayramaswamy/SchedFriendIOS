//
//  SchedFriendLoginViewController.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/15/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SchedFriendLoginViewController: UIViewController {
    var user: User!
    let ref = FIRDatabase.database().reference()

    override func viewDidLoad() {
        try? FIRAuth.auth()!.signOut()
        self.hideKeyboardWhenTappedAround()
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("should")
        var goToLogin = false
        if identifier == "loginToProfile" {
            if (FIRAuth.auth()!.currentUser != nil){
                
                //goToLogin = true
            }
            
            FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
                
                if user == nil {
                    print("changed")
                    goToLogin = true
                }
            }
            

            return goToLogin
            }

        
        return true
    }
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            // 1
            let firstNameField = alert.textFields![0]
            let lastNameField = alert.textFields![1]
            let emailField = alert.textFields![2]
            let passwordField = alert.textFields![3]
            let fallClasses = [String]()
            let winterClasses = [String]()
            let springClasses = [String]()
            let profilePicture = String()
            
            // 2
            FIRAuth.auth()!.createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil {
                    // 3
                    FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!, password: self.textFieldLoginPassword.text!)
                    self.user = User(authData: user!)
                    let userProfile = UserProfile(uid: self.user.uid, firstName: firstNameField.text!, lastName: lastNameField.text!, fallClasses: fallClasses, winterClasses: winterClasses, springClasses: springClasses, profilePicture: profilePicture)
                    let userProfileRef = self.ref.child((user?.uid)!)
                    
                    // 4
                    userProfileRef.setValue(userProfile.toAnyObject(), withCompletionBlock: { (error, snapshot) in
                        if error != nil {

                            print("oops, an error")
                        } else {
                            self.performSegue(withIdentifier: "loginToProfile", sender: nil)
                            print("completed")
                        }
                    })
                    

                } else{
                    
                    print (error?.localizedDescription as Any)
                }
            }
            
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField { textFirstName in
            textFirstName.placeholder = "Enter your first name"
        }
        alert.addTextField { textLastName in
            textLastName.placeholder = "Enter your last name"
        }
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginUser(_ sender: UIButton) {
        print(textFieldLoginEmail.text!)
        print(textFieldLoginPassword.text!)
        FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
                               password: textFieldLoginPassword.text!, completion: { (user, snapshot) in
   
                                        print("segued in log in")
                                        self.performSegue(withIdentifier: "loginToProfile", sender: nil)
                                
                                
        })
    
    }
    
    
    
    
}

extension SchedFriendLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
