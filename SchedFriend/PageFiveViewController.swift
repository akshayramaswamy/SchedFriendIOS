//
//  PageFiveViewController.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/19/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

import UIKit

class PageFiveViewController: UIViewController {

    @IBOutlet weak var begin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //rounds the begin button
        begin.layer.cornerRadius = 8
        begin.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
