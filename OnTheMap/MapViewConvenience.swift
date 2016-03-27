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
    
    func getStudentLocations(completionHandlerForGetStudentLocations: (success: Bool, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        MapViewClient.sharedInstance().taskForGETMethod(MapViewClient.Methods.StudentLocations, parameters: parameters) { (resuts, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let resuts = resuts {
                    print(resuts)
                }
            }
        }
    }
    
}