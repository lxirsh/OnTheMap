//
//  OTMTableViewController.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/30/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit

class OTMTableViewController: UIViewController, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMClient.sharedInstance().locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StudentInfoCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StudentInfoTableViewCell
        
        let studentInfo = OTMClient.sharedInstance().locations[indexPath.row]
        
        cell.studentName.text = studentInfo.firstName + " " + studentInfo.lastName
        cell.studentUrl.text = studentInfo.mediaURL
        
        return cell
    }
    
    // MARK: Navigation
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        let urlString = OTMClient.sharedInstance().locations[indexPath.row].mediaURL
        if let url = NSURL(string: urlString) {
            let canOpen = UIApplication.sharedApplication().canOpenURL(url)
            app.openURL(url)
            print(url)
        } // TODO: Create alert
        
    }
    
    
    
    
}
