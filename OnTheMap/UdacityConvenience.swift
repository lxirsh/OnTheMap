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
    
    func getSessionID(userID userID: String, userPassword: String, completionHandlerForGetSessionID: (success: Bool, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        let jsonBody = "{\"udacity\": {\"\(UdacityClient.URLKeys.UserID)\": \"\(userID)\", \"\(UdacityClient.URLKeys.UserPassword)\": \"\(userPassword)\"}}"
        
        UdacityClient.sharedInstance().taskForPOSTMethod(UdacityClient.Methods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                print("\(error.localizedDescription)\n")
                if error.localizedDescription == "Your request returned a status code other than 2xx!" {
                    completionHandlerForGetSessionID(success: false, errorString: "Invalid Email or Password")
                } else {
                    completionHandlerForGetSessionID(success: false, errorString: "The internet connection appears to be offline.")
                }
            } else {
                if let results = results {
                    print(results)
                    completionHandlerForGetSessionID(success: true, errorString: nil)
                }
            }
        }
    }

    
}