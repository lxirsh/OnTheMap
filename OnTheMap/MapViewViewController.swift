//
//  MapViewViewController.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/24/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit
import MapKit

class MapViewViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        OTMClient.sharedInstance().getStudentLocations() { (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    print(OTMClient.sharedInstance().locations)
                    self.loadDataToMap()
                } else {
                    if let error = error {
                        print(error)
                    }
                }

            })
        }
        
     }
    
    func loadDataToMap() {
        var annotations = [MKPointAnnotation]()
        
        for studentInfo in OTMClient.sharedInstance().locations {
//            print(studentInfo.firstName)
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
        performSegueWithIdentifier("ShowInformationPostingView", sender: self)
    }
    
    
    func userIsAlreadyPinned () -> Bool {
        for student in OTMClient.sharedInstance().locations {
            if student.uniqueKey == UdacityClient.sharedInstance().userID
            {
                return true
            }
        }
        return false
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
