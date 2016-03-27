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
    
    func getStudentLocations(completionHandlerForGetStudentLocations: (results: [StudentInformation]?, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        taskForGETMethod(MapViewClient.Methods.StudentLocations, parameters: parameters) { (results, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let results = results[MapViewClient.JSONResponseKeys.studentList] as? [[String: AnyObject]] {
//                    print(results)
                    let students = StudentInformation.studentInformationFromResults(results)
//                    print(students)
                    completionHandlerForGetStudentLocations(results: students, errorString: nil)
                } else {
                    completionHandlerForGetStudentLocations(results: nil, errorString: "Could not parse data")
                }
            }
        }
    }
    
}