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
    
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    
    // MARK: Initializer
    
    init(dictionary: [String: AnyObject]) {
        firstName = dictionary[OTMClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[OTMClient.JSONResponseKeys.lastName] as! String
        latitude = dictionary[OTMClient.JSONResponseKeys.latitude] as! Double
        longitude = dictionary[OTMClient.JSONResponseKeys.longitude] as! Double
        mapString = dictionary[OTMClient.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[OTMClient.JSONResponseKeys.mediaURL] as! String
    }
    
    static func studentInformationFromResults(results: [[String: AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
}