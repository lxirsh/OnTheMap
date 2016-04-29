//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/26/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import Foundation

extension OTMClient {
    
    // MARK: Constants
    struct Constants {
    
        // MARK: URLs
        static let ParseScheme = "https"
        static let ParseHost = "api.parse.com"
        static let ApiPath = "/1"
        static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPI = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    }
    
    // MARK: Methods
    struct Methods {
        
        static let StudentLocations = "/classes/StudentLocation"
    }
    // MARK: URL Keys
    struct URLKeys {
        static let ParseAppIDKey = "X-Parse-Application-Id"
        static let RESTAPIKey = "X-Parse-REST-API-Key"
        
    }
    
    // MARK: JSON Body keys
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let studentList = "results"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let uniqueKey = "uniqueKey"
    }
    
    
}