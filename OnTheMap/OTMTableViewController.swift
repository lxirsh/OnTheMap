//
//  OTMTableViewController.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/30/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit

class OTMTableViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
    @IBAction func refresh(sender: UIBarButtonItem) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
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
    
    @IBAction func addUserInfo(sender: UIBarButtonItem) {
        OTMClient.sharedInstance().queryStudentLocation() { (success, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    let destinationVC = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
                    destinationVC.pinned = false
                    print("User not pinned")
                    self.presentViewController(destinationVC, animated: true, completion: nil)
                    
                } else {
                    if error == "Already pinned" {
                        let ac = UIAlertController(title: "", message: "User \"\(UdacityClient.sharedInstance().firstName!) \(UdacityClient.sharedInstance().lastName!)\" has already posted a location. Would you like to overwrite their location?", preferredStyle: .Alert)
                        ac.addAction(UIAlertAction(title: "Overwrite", style: .Default, handler: { (action: UIAlertAction!) in
                            let destinationVC = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
                            destinationVC.pinned = true
                            self.presentViewController(destinationVC, animated: true, completion: nil)
                            
                        }))
                        
                        ac.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                            return
                        }))
                        self.presentViewController(ac, animated: true, completion: nil)
                        print("User pinned")
                    } else {
                        // TODO: Add alert
                        print("error")
                    }
                }
            })
            
        }
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().deleteSession() { (success, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
                    self.presentViewController(vc, animated: true, completion: nil)
                    
                } else {
                    // Add an alert?
                    print(error)
                }
            })
        }
        
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
