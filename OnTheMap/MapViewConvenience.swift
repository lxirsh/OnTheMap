//
//  MapViewConvenience.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/24/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit
import Foundation

// MARK: MapViewClient (Convenient Resource Methods)

extension MapViewClient {
    
    func getStudentLocations(completionHandlerForGetStudentLocations:(success: Bool, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        taskForGETMethod(MapViewClient.Methods.StudentLocations, parameters: parameters) { (results, error) in
            
            if let error = error {
                // TODO: user alert
                print(error.localizedDescription)
            } else {
                if let results = results[MapViewClient.JSONResponseKeys.studentList] as? [[String: AnyObject]] {
                    MapViewClient.sharedInstance().locations = StudentInformation.studentInformationFromResults(results)
    completionHandlerForGetStudentLocations(success: true, errorString: nil)
                } else {
                    completionHandlerForGetStudentLocations(success: false, errorString: "Could not parse data")
                }
            }
        }
    }
    
}