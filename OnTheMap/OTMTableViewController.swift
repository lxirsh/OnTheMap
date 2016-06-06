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
        
    @IBAction func refresh(sender: UIBarButtonItem) {
        OTMClient.sharedInstance().getStudentLocations() { (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    self.tableView.reloadData()
                } else {
                    if error != nil {
                        let ac = UIAlertController(title: "Could not load student data", message: "Please refresh to try again", preferredStyle: .Alert)
                        ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                        self.presentViewController(ac, animated: true, completion: nil)
                    }
                }
                
            })
        }
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
                    } else {
                        let ac = UIAlertController(title: "An unknown error has occurred", message: "Please try again", preferredStyle: .Alert)
                        ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                        self.presentViewController(ac, animated: true, completion: nil)
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
                    let ac = UIAlertController(title: "An unknown error has occurred", message: "Please try again", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                }
            })
        }
    }

    
    // MARK: Navigation
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        let urlString = OTMClient.sharedInstance().locations[indexPath.row].mediaURL
        if let url = NSURL(string: urlString) {
            if app.canOpenURL(url) {
                app.openURL(url)
            } else {
                let ac = UIAlertController(title: "Invalid Link", message: nil, preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
            }
        }
        
    }
}
