//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/16/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit
import Foundation

// Mark: UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    func getSessionID(userID userID: String, userPassword: String) {
        
        let parameters = [String: AnyObject]()
        
        let jsonBody = "{\"udacity\": {\"\(UdacityClient.URLKeys.UserID)\": \"\(userID)\", \"\(UdacityClient.URLKeys.UserPassword)\": \"\(userPassword)\"}}"
        
        UdacityClient.sharedInstance().taskForPOSTMethod(UdacityClient.Methods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), {
                    print(error)
                    })
            } else {
                if let results = results {
                    print(results)
                }
            }
        }
    }

    
}