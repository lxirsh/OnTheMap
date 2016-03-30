//
//  OTMTableViewController.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/30/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit

class OTMTableViewController: UIViewController {
    
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
    
    
}
