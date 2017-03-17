//
//  EditClassesViewController.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/16/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

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
        
        // Connect data:
        self.classPicker.delegate = self
        self.classPicker.dataSource = self
        
        // Input data into the Array:
        pickerData = ["CS221", "CS229", "CS193P", "PHIL2", "MATH51", "ECON1", "CS274"]
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            //self.userRef = self.rootRef.child(self.user.uid)
            print(self.user.uid)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addFallClasses(_ sender: UIButton) {
                var fallClasses:[String]?
        let userRef  = ref.child(self.user.uid)
        userRef.queryOrdered(byChild: "uid").observeSingleEvent(of: .value, with: { snapshot in
            fallClasses = (snapshot.childSnapshot(forPath: "fallClasses").value as? Array<String>)!
            if (!((fallClasses?.contains(self.selectedPick))!)){
                        fallClasses?.append(self.selectedPick)
   
            }
            
            userRef.updateChildValues(["fallClasses":fallClasses ?? "No class"], withCompletionBlock: { (error, snapshot) in
                if error != nil {
                    
                    print("oops, an error")
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }

            })

        })
        //var fallClasses = userRef.queryEqual(toValue: "fallClasses") as? Array<String>

    }
    
    @IBAction func addWinterClasses(_ sender: UIButton) {
    }
    
    @IBAction func addSpringClasses(_ sender: UIButton) {
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        self.selectedPick = pickerData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = pickerData[row]
        return NSAttributedString(string: str, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
