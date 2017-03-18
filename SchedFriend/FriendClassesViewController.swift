//
//  FriendClassesViewController.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/18/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

import UIKit

class FriendClassesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var classDisplay:Array<String> = []
    @IBOutlet weak var classTable: UITableView!

    
    @IBAction func printStudents(_ sender: UIBarButtonItem) {
        let printController = UIPrintInteractionController.shared
        // 2
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = "print Job"
        printController.printInfo = printInfo
        // Assign a UIImage version of my UIView as a printing iten
        printController.printingItem = self.view.toImage()
        
        // Do it
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil)
        // 3
        //let classDisplayString = classDisplay.joined(separator: ",")
        //let formatter = UIMarkupTextPrintFormatter(markupText: classDisplayString)
        //formatter.perPageContentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
        //printController.printFormatter = formatter
        
        // 4
        //printController.present(animated: true, completionHandler: nil)
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
