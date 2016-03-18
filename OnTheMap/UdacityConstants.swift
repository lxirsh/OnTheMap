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
        static let UdacityAuthorizationURL = "https://www.udacity.com/api/session"
        
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let Session = "/session"
    }
    
    // MARK: URLKeys
    struct URLKeys {
        static let UserID = "username"
        static let UserPassword = "password"
    }
}
