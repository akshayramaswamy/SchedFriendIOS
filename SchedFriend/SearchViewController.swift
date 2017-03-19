//
//  SearchViewController.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/17/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    var filteredClasses = [Class]()
    
    struct Class {
        var name = String()
        var department = String()
    }
    
    var classes = [Class(name: "CS109", department: "Computer Science"),
                   Class(name: "CS221", department: "Computer Science"),
                   Class(name: "MATH51", department: "MATH"),
                   Class(name: "PHIL2", department: "Philosophy"),
                   Class(name: "CS229", department: "Computer Science"),
                   Class(name: "CS193P", department: "Computer Science"),
                   Class(name: "ECON1", department: "Economics")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredClasses.count
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredClasses = classes
        } else {
            // Filter the results
            filteredClasses = classes.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        print(filteredClasses)
        
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.filteredClasses[indexPath.row].name
        cell.detailTextLabel?.text = self.filteredClasses[indexPath.row].department
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
        
        self.performSegue(withIdentifier: "searchClass", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let classController = segue.destination as? FriendClassesViewController{
            let indexPath = self.tableView.indexPathForSelectedRow
            let text = self.filteredClasses[(indexPath?.row)!].name
            let ref = FIRDatabase.database().reference()
            let userRef  = ref.child(text)
            print(userRef)
            userRef.queryOrdered(byChild: "uid").observeSingleEvent(of: .value, with: { snapshot in
                if let retrievedStudents = (snapshot.childSnapshot(forPath: "students").value as? Array<String>){
                    print(retrievedStudents)
                    classController.classDisplay = retrievedStudents
                    print(classController.classDisplay)
                }
            })
            
        }
        
        
    }
    
}
