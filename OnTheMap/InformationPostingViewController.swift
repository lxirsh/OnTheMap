//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/31/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var middleTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    enum UIState: String {
        case Initial, Searching, LocationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        mapView.alpha = 0
        configureUIForState(.Initial)
    }
    
    @IBAction func butonTouched(sender: AnyObject) {
        configureUIForState(.LocationView)
    }
    
    func configureUIForState(state: UIState) {
        
        switch state {
        case .Initial:
            print("Initial")
            middleView.alpha = 1
            bottomView.alpha = 1
            mapView.alpha = 0
            topTextField.enabled = false
        case .Searching:
            print("Searching")
        case .LocationView:
            middleView.alpha = 0
            bottomView.alpha = 0.5
            mapView.alpha = 1
            topTextField.text = "Enter a Link to Share Here"
            topTextField.enabled = true
            button.setTitle("Submit", forState: .Normal)
            print("Location view")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
