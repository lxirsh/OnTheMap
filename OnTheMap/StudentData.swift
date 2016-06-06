//
//  StudentData.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 6/6/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import Foundation

class StudentData: NSObject {
    
    var locations: [StudentInformation] = [StudentInformation]()
    
    // MARK: Shared instance
    class func sharedInstance() -> StudentData {
        struct Singleton {
            static var sharedInstance = StudentData()
        }
        return Singleton.sharedInstance
    }
    
}