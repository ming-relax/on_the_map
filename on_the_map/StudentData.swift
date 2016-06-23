//
//  StudentData.swift
//  on_the_map
//
//  Created by Ming Hu on 6/17/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import Foundation


struct StudentInformation {
    
    var objectID: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: String?
    var longitude: String?
    var createdAt: String?
    var updatedAt: String?
    var ACL: String?
    
    init(studentLocation: [String: String]) {
        objectID = studentLocation["objectID"]
        uniqueKey = studentLocation["uniqueKey"]
        firstName = studentLocation["firstName"]
        lastName = studentLocation["lastName"]
        mapString = studentLocation["mapString"]
        mediaURL = studentLocation["mediaURL"]
        latitude = studentLocation["latitude"]
        longitude = studentLocation["longitude"]
        createdAt = studentLocation["createdAt"]
        updatedAt = studentLocation["updatedAt"]
        ACL = studentLocation["ACL"]
    }
    
    static var myself: StudentInformation?
    
    static func postMyself(completionHandler: (() -> Void)?) {
        let headers = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        ]
        let parameters = [
            "uniqueKey": myself!.uniqueKey!,
            "firstName": myself!.firstName!,
            "lastName": myself!.lastName!,
            "mapString": myself!.mapString!,
            "mediaURL": myself!.mediaURL!,
            "latitude": myself!.latitude!,
            "longitude": myself!.longitude!
        ]
    }
}

class StudentData {
    static var students: [StudentInformation] = []
    static var myself: StudentInformation?
    
    static func initMyself(userKey: String) {
        
        UdacityClient.getUser(userKey) { user in
            myself = StudentInformation(
                studentLocation: [
                    "firstName": user["firstName"]!,
                    "lastName": user["lastName"]!,
                    "uniqueKey": userKey
                ]
            )
        }
    }
    
    static func postMyself(completionHandler: (() -> Void)?, errorHandler: ((errorMsg: String) -> Void)?) {
        ParseClient.postStudentLocation(myself!, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    static func initStudentsFromParse(completionHandler: (() -> Void)?) {
        ParseClient.getStudentLocations { results in            
            for result in results {
                let student = StudentInformation(
                    studentLocation: [
                        "firstName": "\(result["firstName"]!)",
                        "lastName": "\(result["lastName"]!)",
                        "longitude": "\(result["longitude"]!)",
                        "latitude": "\(result["latitude"]!)",
                        "objectID": "\(result["objectId"]!)",
                        "mediaURL": "\(result["mediaURL"]!)",
                        "uniqueKey": "\(result["uniqueKey"]!)",
                        "mapString": "\(result["mapString"]!)",
                        "createdAt": "\(result["createdAt"]!)",
                        "updatedAt": "\(result["updatedAt"]!)"
                    ]
                )
                students.append(student)
            }
                        
            if let completionHandler = completionHandler {
                completionHandler()
            }
        }
    }
}
