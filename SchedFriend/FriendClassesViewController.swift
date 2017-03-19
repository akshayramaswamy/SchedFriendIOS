//
//  FriendClassesViewController.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/18/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//
//  This file displays all the students in the class that the user searched for
//  Printing functionality to print the list of students in your class (if you want to mail it to your mom or something)

import UIKit

class FriendClassesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var classDisplay:Array<String> = []
    @IBOutlet weak var classTable: UITableView!

    /* Send screen to printer -- extension for getting view into image written below */
    @IBAction func printStudents(_ sender: UIBarButtonItem) {
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = "print Job"
        printController.printInfo = printInfo
        // Assign a UIImage version of my UIView as a printing iten
        printController.printingItem = self.view.toImage()
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return classDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let classCell = tableView.dequeueReusableCell(withIdentifier: "name", for: indexPath)
        classCell.textLabel!.text = classDisplay[indexPath.row]
        return classCell
    }
    @IBAction func newSearch(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    
    }

    
}
extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
