//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/15/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        //MARK: URLs
        static let UdacityScheme = "https"
        static let UdacityHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let UdacitySignUpURL = "https://www.udacity.com/account/auth#!/signup"
        
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let Session = "/session"
        static let PublicUserData = "/users/{id}"
    }
    
    // MARK: URLKeys
    struct URLKeys {
        static let LoginID = "username"
        static let UserPassword = "password"
        static let UserID = "id"
    }
    
    // MARK: JSON response keys
    struct JSONresponseKeys {
        static let Account = "account"
        static let UserID = "key"
    }
}
