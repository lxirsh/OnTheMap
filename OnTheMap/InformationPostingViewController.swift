//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/31/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var middleTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    
    let defaultMiddleTextFieldText = "Enter your location here."
    let shareLinkText = "Enter a Link to Share Here."
    var searchString: String?
    var pinned: Bool?
    var returnToMapView: Bool?
    
    enum UIState: String {
        case Initial, Searching
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true

        self.topTextField.delegate = self
        self.middleTextField.delegate = self
        self.middleTextField.text = defaultMiddleTextFieldText
        
        
        configureUIForState(.Initial)
       
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func butonTouched(sender: AnyObject) {
        
        switch button.titleLabel!.text! {
            case "Find on the map":
                findLocation()

            case "Submit":
                submitInformation()
            
            default: ()
        }
    }
    
    func findLocation() {
        if middleTextField.text == "" || middleTextField.text == defaultMiddleTextFieldText {
            let ac = UIAlertController(title: "", message: "Must enter a location", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            
        } else {
            searchString = middleTextField.text
            activityIndicator.startAnimating()
            
            OTMClient.sharedInstance().getUserLocation(searchString!) { (success, error) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    if error != nil  {
                        let ac = UIAlertController(title: "", message: "Unable to find location", preferredStyle: .Alert)
                        ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                        self.presentViewController(ac, animated: true, completion: nil)
                    } else {
                        self.configureUIForState(.Searching)
                        self.showUserLocation()
                    }
                })
            }
        }
    }
    
    func submitInformation() {
        if topTextField.text == "" || topTextField.text == shareLinkText {
            let ac = UIAlertController(title: "", message: "Must enter a link", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            
        } else {
            let mediaURL = topTextField.text
            // Has the user already pinned a location?
            if pinned == true {
                OTMClient.sharedInstance().updateStudentLocation(mediaURL!) { (success, error) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if error != nil  {
                            let ac = UIAlertController(title: "", message: "Unable to update location", preferredStyle: .Alert)
                            ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                            self.presentViewController(ac, animated: true, completion: nil)
                        } else {
                            let rootViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController") as! UITabBarController
                            self.presentViewController(rootViewController, animated: true, completion: nil)
                            
                        }
                    })
                }
            } else {
                OTMClient.sharedInstance().postStudentLocation(mediaURL!) { (success, error) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if error != nil  {
                            let ac = UIAlertController(title: "", message: "Unable to update location", preferredStyle: .Alert)
                            ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                            self.presentViewController(ac, animated: true, completion: nil)
                            
                        } else {
                            let rootViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController") as! UITabBarController
                            self.presentViewController(rootViewController, animated: true, completion: nil)
                            
                        }
                    })
                }
            }
            
        }
    }
    
    func showUserLocation() {
        let latitude = OTMClient.sharedInstance().latitude!
        let longitude = OTMClient.sharedInstance().longitude!
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let regionRadius: CLLocationDistance = 1000
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func configureUIForState(state: UIState) {
        
        switch state {
            
        case .Initial:
            middleView.alpha = 1
            bottomView.alpha = 1
            mapView.alpha = 0
            topTextField.enabled = false
            middleTextField.enabled = true
            button.setTitle("Find on the map", forState: .Normal)
            topTextField.textColor = CustomColor.InformationPostingState.TextBlueColor
            middleTextField.textColor = CustomColor.InformationPostingState.TextGrayColor
            button.backgroundColor = CustomColor.InformationPostingState.ButtonColor
            cancelButton.setTitleColor(CustomColor.InformationPostingState.CancelButtonColor, forState: .Normal)
            
        case .Searching:
            view.backgroundColor = CustomColor.InformationPostingState.BackgroundBlueColor
            navigationController?.navigationBar.translucent = false
            navigationController?.navigationBar.barTintColor = CustomColor.InformationPostingState.BackgroundBlueColor
            middleView.alpha = 0
            bottomView.alpha = 0.75
            mapView.alpha = 1
            topTextField.text = shareLinkText
            topTextField.textColor = CustomColor.InformationPostingState.TextGrayColor
            topTextField.enabled = true
            button.setTitle("Submit", forState: .Normal)
            cancelButton.setTitleColor(CustomColor.InformationPostingState.TextGrayColor, forState: .Normal)
            }
    }

    @IBAction func cancel(sender: UIButton) {
        
        // Return to the same tab
        
        if returnToMapView == true {
            let rootViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController") as! UITabBarController
            self.presentViewController(rootViewController, animated: true, completion: nil)
        } else {
            let rootViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController") as! UITabBarController
            rootViewController.selectedViewController = rootViewController.viewControllers![1]
            self.presentViewController(rootViewController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Text Field Delegates
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == middleTextField && middleTextField.text == "" {
            middleTextField.text = defaultMiddleTextFieldText
        }
        
        if textField == topTextField && topTextField.text == "" {
            topTextField.text = shareLinkText
        }
        return false
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
