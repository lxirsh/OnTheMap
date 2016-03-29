//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/24/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit
import Foundation

// MARK: OTMClient (Convenient Resource Methods)

extension OTMClient {
    
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
    
}