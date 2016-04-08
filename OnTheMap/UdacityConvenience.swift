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
        
        let jsonBody = "{\"udacity\": {\"\(UdacityClient.URLKeys.LoginID)\": \"\(userID)\", \"\(UdacityClient.URLKeys.UserPassword)\": \"\(userPassword)\"}}"
        
        taskForPOSTMethod(UdacityClient.Methods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                print("\(error.localizedDescription)\n")
                if error.localizedDescription == "Your request returned a status code other than 2xx!" {
                    completionHandlerForGetSessionID(success: false, errorString: "Invalid Email or Password")
                } else {
                    completionHandlerForGetSessionID(success: false, errorString: "The internet connection appears to be offline.")
                }
            } else {
                print(results)
                if let session = results[UdacityClient.JSONresponseKeys.Account] as? [String: AnyObject] {
                    if let user = session[UdacityClient.JSONresponseKeys.UserID] as? String {
                        UdacityClient.sharedInstance().userID = user
//                        print(UdacityClient.sharedInstance().userID)
                        completionHandlerForGetSessionID(success: true, errorString: nil)
                    }
                    
                } else {
                    completionHandlerForGetSessionID(success: false, errorString: "Unkown")
                }
            }
        }
    }
    
    // Get Public User Data and store the user's first and last name
    func getPublicUserData(userID: String, completionHandlerForUserData: (success: Bool?, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        var mutableMethod = UdacityClient.Methods.PublicUserData
//        print(UdacityClient.sharedInstance().userID)
        mutableMethod = subtituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: userID)!
        
        taskForGETMethod(mutableMethod, parameters: parameters) { (results, error) in
            if let error = error {
                completionHandlerForUserData(success: nil, errorString: "Could not get public user data")
            } else {
                if let results = results as? [String: AnyObject]{
                    if let userData = results["user"] as? [String: AnyObject] {
                        if let firstName = userData["first_name"] as? String {
                            if let lastName = userData["last_name"] as? String {
                                completionHandlerForUserData(success: true, errorString: nil)
                            }
                        }
                    }
                } else {
                    completionHandlerForUserData(success: nil, errorString: "Could not parse user data")
                }
            }
        }
    }
    
    
    
}