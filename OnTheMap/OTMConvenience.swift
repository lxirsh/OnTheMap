//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/24/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

// MARK: OTMClient (Convenient Resource Methods)

extension OTMClient {
    
    // Get the locations for students who have previously used the app from the Parse API
    func getStudentLocations(completionHandlerForGetStudentLocations:(success: Bool, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        taskForGETMethod(OTMClient.Methods.StudentLocations, parameters: parameters) { (results, error) in
            
            if let error = error {
                // TODO: user alert
                print(error.localizedDescription)
            } else {                
                if let results = results[OTMClient.JSONResponseKeys.studentList] as? [[String: AnyObject]] {
                    OTMClient.sharedInstance().locations = StudentInformation.studentInformationFromResults(results)
                    completionHandlerForGetStudentLocations(success: true, errorString: nil)
                } else {
                    completionHandlerForGetStudentLocations(success: false, errorString: "Could not parse data")
                }
            }
        }
    }
    
    func queryStudentLocation(completionHandlerForQueryStudentLocation: (sucess: Bool?, errorString: String?) -> Void) {
        
        let parameters = [
            "where" : NSURLQueryItem(name: "fjfjhfg", value: "hfjfgj")
        ]
    }
    
    // Get the user's inputed location.
    func getUserLocation(addressString: String, completionHandlerForGetUserLocation: (success: Bool, errorString: String?) -> Void) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(addressString, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) in
            
            if error != nil {
                print("Geocode failed with error: \(error!.localizedDescription)")
                completionHandlerForGetUserLocation(success: false, errorString: error!.localizedDescription)
            } else if placemarks?.count > 0 {
                let placemark = placemarks![0] 
                let location = placemark.location
                
                
                // Set the variables in the OTMClient
                self.latitude = location?.coordinate.latitude
                self.longitude = location?.coordinate.longitude
                self.mapString = addressString
                print("latitude: \(self.latitude)")
                print("longitude: \(self.longitude)")
                
                completionHandlerForGetUserLocation(success: true, errorString: nil)
            }
        })
    }
    
    func postStudentLocation(completionHandlerForPostStudentLocation: (success: Bool?, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        let jsonBody = "{\"\(OTMClient.JSONBodyKeys.UniqueKey)\": \"\(UdacityClient.sharedInstance().userID!)\", \"\(OTMClient.JSONBodyKeys.FirstName)\": \"\(UdacityClient.sharedInstance().firstName!)\", \"\(OTMClient.JSONBodyKeys.LastName)\": \"\(UdacityClient.sharedInstance().lastName!)\",\"\(OTMClient.JSONBodyKeys.MapString)\": \"\(self.mapString!)\", \"\(OTMClient.JSONBodyKeys.MediaURL)\": \"https://udacity.com\",\"\(OTMClient.JSONBodyKeys.Latitude)\": \(self.latitude!), \"\(OTMClient.JSONBodyKeys.Longitude)\": \(self.longitude!)}"
        
        taskForPOSTMethod(OTMClient.Methods.StudentLocations, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                print("\(error.localizedDescription)")
                completionHandlerForPostStudentLocation(success: false, errorString: "Could not update new location")
            } else {
                print(results)
                completionHandlerForPostStudentLocation(success: true, errorString: nil)
            }
            
        }
        
        
    }
    
}