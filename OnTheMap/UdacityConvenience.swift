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
    
    func getSessionID(loginID loginID: String, userPassword: String, completionHandlerForGetSessionID: (success: Bool, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        let jsonBody = "{\"udacity\": {\"\(UdacityClient.URLKeys.LoginID)\": \"\(loginID)\", \"\(UdacityClient.URLKeys.UserPassword)\": \"\(userPassword)\"}}"
        
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
        mutableMethod = subtituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: userID)!
        
        taskForGETMethod(mutableMethod, parameters: parameters) { (results, error) in
            if error != nil {
                completionHandlerForUserData(success: nil, errorString: "Could not get public user data")
            } else {
                guard let results = results as? [String: AnyObject] else {
                    completionHandlerForUserData(success: false, errorString: "Could not parse JSON data as a dictionary")
                    return
                }
                guard let userData = results["user"] as? [String: AnyObject] else {
                    completionHandlerForUserData(success: false, errorString: "Could not find the key 'user' in the dictionary")
                    return
                }
                guard let firstName = userData["first_name"] as? String else {
                    completionHandlerForUserData(success: false, errorString: "Could not find the key 'first_name' in the dictionary")
                    return
                }
                guard let lastName = userData["last_name"] as? String else {
                    completionHandlerForUserData(success: false, errorString: "Could not find the key 'last_name' in the dictionary")
                    return
                }
                self.firstName = firstName
                self.lastName = lastName
                completionHandlerForUserData(success: true, errorString: nil)

            }
        }
    }
    
    // Log out from Udacity session
    func deleteSession(completionHandlerForDeleteSession: (success: Bool, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        let mutableMethod = UdacityClient.Methods.Session
        
        taskForDELETEMethod(mutableMethod, parameters: parameters) { (results, error) in
            if error != nil {
                completionHandlerForDeleteSession(success: false, errorString: "Could not delete session")
            } else {
                completionHandlerForDeleteSession(success: true, errorString: nil)
                
            }
        }
    }
    
    // Login via Facebook
    func getSessionIDviaFacebookLogin(completionHandlerForgetSessionIDviaFacebookLogin: (success: Bool, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        let jsonBody = "{\"facebook_mobile\": {\"access_token\": \"\(UdacityClient.sharedInstance().facebookAccessToken!.tokenString!)\"}}"
        
        taskForPOSTMethod(UdacityClient.Methods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                print("\(error.localizedDescription)\n")
                if error.localizedDescription == "Your request returned a status code other than 2xx!" {
                    completionHandlerForgetSessionIDviaFacebookLogin(success: false, errorString: "Invalid access token")
                } else {
                    completionHandlerForgetSessionIDviaFacebookLogin(success: false, errorString: "The internet connection appears to be offline.")
                }
            } else {
                print(results)
                if let session = results[UdacityClient.JSONresponseKeys.Account] as? [String: AnyObject] {
                    if let user = session[UdacityClient.JSONresponseKeys.UserID] as? String {
                        UdacityClient.sharedInstance().userID = user
                        UdacityClient.sharedInstance().loggedInViaFacebook = true
                        completionHandlerForgetSessionIDviaFacebookLogin(success: true, errorString: nil)
                    }
                    
                } else {
                    completionHandlerForgetSessionIDviaFacebookLogin(success: false, errorString: "Unkown")
                }
            }
        }
    }
    
    // Logoout of Facebook session
    func facebookLogout() {
        FBSDKLoginManager().logOut()
    }
    
    
}