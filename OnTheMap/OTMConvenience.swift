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
    
    // Successful only if the user has not already pinned a location
    func queryStudentLocation(completionHandlerForQueryStudentLocation: (success: Bool, errorString: String?) -> Void) {
        
        let query = "{\"\(OTMClient.JSONBodyKeys.UniqueKey)\": \"\(UdacityClient.sharedInstance().userID!)\"}"
//        let query = "{\"\(OTMClient.JSONBodyKeys.UniqueKey)\": \"6666666666\"}"
        
        let parameters = [
            "where" : query
        ]
        
        taskForGETMethod(OTMClient.Methods.StudentLocations, parameters: parameters) { (results, error) in
            
            if let error = error {
                // TODO: user alert
                print(error.localizedDescription)
            } else {
                print("JSON: \(results)")
                if let results = results as? [String: AnyObject] {
                    if let resultsArray = results["results"] { //as? [AnyObject] {
                        print(resultsArray.count)
                        if resultsArray.count > 0 {
                            if let dict = resultsArray[0] {
                                guard let ID = dict["objectId"] as? String else {
                                    completionHandlerForQueryStudentLocation(success: false, errorString: "Could not find the user's ID")
                                    return
                                }
                                print("objectId: \(dict["objectId"])")
                                self.objectId = ID
//                                OTMClient.sharedInstance().objectId = dict["objectId"]
                            }
                            completionHandlerForQueryStudentLocation(success: false, errorString: "Already pinned")
                        } else {
                            completionHandlerForQueryStudentLocation(success: true, errorString: nil)
                        }
                    }
                    
                } else {
                    print(results)
                    completionHandlerForQueryStudentLocation(success: false, errorString: "Could not parse results")
                }
                
            
            }
        }
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
    
    func postStudentLocation(mediaURL: String, completionHandlerForPostStudentLocation: (success: Bool?, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        let jsonBody = "{\"\(OTMClient.JSONBodyKeys.UniqueKey)\": \"\(UdacityClient.sharedInstance().userID!)\", \"\(OTMClient.JSONBodyKeys.FirstName)\": \"\(UdacityClient.sharedInstance().firstName!)\", \"\(OTMClient.JSONBodyKeys.LastName)\": \"\(UdacityClient.sharedInstance().lastName!)\",\"\(OTMClient.JSONBodyKeys.MapString)\": \"\(self.mapString!)\", \"\(OTMClient.JSONBodyKeys.MediaURL)\": \"\(mediaURL)\",\"\(OTMClient.JSONBodyKeys.Latitude)\": \(self.latitude!), \"\(OTMClient.JSONBodyKeys.Longitude)\": \(self.longitude!)}"
        
        taskForPOSTMethod(OTMClient.Methods.StudentLocations, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                print("\(error.localizedDescription)")
                completionHandlerForPostStudentLocation(success: false, errorString: "Could not add location")
            } else {
                print(results)
                completionHandlerForPostStudentLocation(success: true, errorString: nil)
            }
            
        }
        
        
    }
    
    func updateStudentLocation(mediaURL: String, completionHandlerForUpdatetStudentLocation: (success: Bool?, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        var mutableMethod: String = Methods.UpdateLocation
        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.ObjectId, value: objectId!)!
        print("uniqueKey: \(UdacityClient.sharedInstance().userID!)")
        
        let jsonBody = "{\"\(OTMClient.JSONBodyKeys.UniqueKey)\": \"\(UdacityClient.sharedInstance().userID!)\", \"\(OTMClient.JSONBodyKeys.FirstName)\": \"\(UdacityClient.sharedInstance().firstName!)\", \"\(OTMClient.JSONBodyKeys.LastName)\": \"\(UdacityClient.sharedInstance().lastName!)\",\"\(OTMClient.JSONBodyKeys.MapString)\": \"\(self.mapString!)\", \"\(OTMClient.JSONBodyKeys.MediaURL)\": \"\(mediaURL)\",\"\(OTMClient.JSONBodyKeys.Latitude)\": \(self.latitude!), \"\(OTMClient.JSONBodyKeys.Longitude)\": \(self.longitude!)}"
        
        taskForPUTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                print("\(error.localizedDescription)")
                completionHandlerForUpdatetStudentLocation(success: false, errorString: "Could not update new location")
            } else {
                print(results)
                completionHandlerForUpdatetStudentLocation(success: true, errorString: nil)
            }
            
        }
        
        
    }

}