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

        OTMClient.sharedInstance().getStudentLocations() { (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    print("Number of locations: \(OTMClient.sharedInstance().locations.count)")
                    self.loadDataToMap()
                } else {
                    if let error = error {
                        print(error)
                        let ac = UIAlertController(title: "", message: "Could not load student data", preferredStyle: .Alert)
                        ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                        self.presentViewController(ac, animated: true, completion: nil)
                    }
                }

            })
        }
        
     }
    
    func loadDataToMap() {
        var annotations = [MKPointAnnotation]()
        
        for studentInfo in OTMClient.sharedInstance().locations {
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
                if success {
                    let destinationVC = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
                    destinationVC.pinned = false
                    print("User not pinned")
                    self.presentViewController(destinationVC, animated: true, completion: nil)

                } else {
                    if error == "Already pinned" {
                        let ac = UIAlertController(title: "", message: "User \"\(UdacityClient.sharedInstance().firstName) \(UdacityClient.sharedInstance().lastName)\" has already posted a location. Would you like to overwrite their location?", preferredStyle: .Alert)
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
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    

    // MARK: - Navigation

}
