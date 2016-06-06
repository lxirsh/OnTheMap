//
//  MapViewViewController.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/24/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class MapViewViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        // Set the user's first and last name so that they can be accessed for an alert if needed
        UdacityClient.sharedInstance().getPublicUserData(UdacityClient.sharedInstance().userID!) { (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if let error = error  {
                    let ac = UIAlertController(title: "Could not retrieve user's name", message: "Please re-login to try again", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                    print(error)
                    UdacityClient.sharedInstance().firstName = "First"
                    UdacityClient.sharedInstance().lastName = "Last"
                } else {
                    self.retrieveStudentData()
                }
            })
        }
        
        
     }
    
    // Get the student data and load it to the map
    func retrieveStudentData() {
        OTMClient.sharedInstance().getStudentLocations() { (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    self.loadDataToMap()
                } else {
                    if let error = error {
                        let ac = UIAlertController(title: "Could not load student data", message: "Please refresh to try again", preferredStyle: .Alert)
                        ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                        self.presentViewController(ac, animated: true, completion: nil)
                    }
                }
                
            })
        }
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        retrieveStudentData()
    }
    
    func loadDataToMap() {
        var annotations = [MKPointAnnotation]()
        
        for studentInfo in StudentData.sharedInstance().locations {
            let lat = CLLocationDegrees(studentInfo.latitude)
            let long = CLLocationDegrees(studentInfo.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = studentInfo.firstName
            let last = studentInfo.lastName
            let mediaUrl = studentInfo.mediaURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaUrl
            
            annotations.append(annotation)
            
        }
        self.mapView.addAnnotations(annotations)
    }
    
    @IBAction func addUserInfo(sender: UIBarButtonItem) {
        OTMClient.sharedInstance().queryStudentLocation() { (success, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                if success { // User has not already pinned a location
                    let destinationVC = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
                    destinationVC.pinned = false
                    destinationVC.returnToMapView = true
                    self.presentViewController(destinationVC, animated: true, completion: nil)

                } else {
                    if error == "Already pinned" {
                        let ac = UIAlertController(title: "", message: "User \"\(UdacityClient.sharedInstance().firstName!) \(UdacityClient.sharedInstance().lastName!)\" has already posted a location. Would you like to overwrite their location?", preferredStyle: .Alert)
                        ac.addAction(UIAlertAction(title: "Overwrite", style: .Default, handler: { (action: UIAlertAction!) in
                            let destinationVC = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
                            destinationVC.pinned = true
                            destinationVC.returnToMapView = true
                            self.presentViewController(destinationVC, animated: true, completion: nil)

                        }))
                        
                        ac.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                            return
                        }))
                        self.presentViewController(ac, animated: true, completion: nil)
                    } else {
                        let ac = UIAlertController(title: "Unkown error", message: "Please try again", preferredStyle: .Alert)
                        ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                        self.presentViewController(ac, animated: true, completion: nil)                    }
                }
            })
            
        }
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().deleteSession() { (success, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    if (UdacityClient.sharedInstance().loggedInViaFacebook == true) {
                        UdacityClient.sharedInstance().facebookLogout()
                    }
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
                    self.presentViewController(vc, animated: true, completion: nil)
                    
                } else {
                    let ac = UIAlertController(title: "Could not logout", message: "Please try again", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let url = NSURL(string:(view.annotation?.subtitle!)!) {
                if app.canOpenURL(url) {
                    app.openURL(url)
                } else {
                    let ac = UIAlertController(title: "Invalid Link", message: nil, preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                }            }
        }
    }
    

    // MARK: - Navigation

}
