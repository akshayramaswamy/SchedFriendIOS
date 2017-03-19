//
//  ExploreCoursesViewController.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/18/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//
// This file uses WebKit to pull explorecourses webpage if student wants to get more
// descriptions on classes to take

import UIKit
import WebKit

class ExploreCoursesViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://explorecourses.stanford.edu/")!
        print(url)
        print(webView)
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        print(webView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
