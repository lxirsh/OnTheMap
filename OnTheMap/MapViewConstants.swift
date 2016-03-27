//
//  MapViewConstants.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/26/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import Foundation

extension MapViewClient {
    
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
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let studentList = "results"
    }
    
    
}