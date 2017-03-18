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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
