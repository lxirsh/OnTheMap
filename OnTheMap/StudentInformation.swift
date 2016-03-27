//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/27/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    // MARK: Properties
    
    let firstName: String?
    let lastName: String?
    let latitude: Float?
    let longitude: Float?
    let mapString: String?
    let mediaURL: String?
    
    // MARK: Initializer
    
    init(dictionary: [String: AnyObject]) {
        firstName = dictionary[MapViewClient.JSONResponseKeys.firstName] as? String
        lastName = dictionary[MapViewClient.JSONResponseKeys.lastName] as? String
        latitude = dictionary[MapViewClient.JSONResponseKeys.latitude] as? Float
        longitude = dictionary[MapViewClient.JSONResponseKeys.longitude] as? Float
        mapString = dictionary[MapViewClient.JSONResponseKeys.mapString] as? String
        mediaURL = dictionary[MapViewClient.JSONResponseKeys.mediaURL] as? String
    }
    
    static func studentInformationFromResults(results: [[String: AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
}