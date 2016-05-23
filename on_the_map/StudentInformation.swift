//
//  StudentInformation.swift
//  on_the_map
//
//  Created by Ming Hu on 5/17/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

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
    
    static var students: [StudentInformation] = []
    
    static func initStudentsFromParse(completionHandler: (() -> Void)?) {
        let headers = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        ]
        Alamofire.request(.GET, "https://api.parse.com/1/classes/StudentLocation", headers: headers, parameters: ["limit": "100", "order": "-updatedAt"])
            .responseJSON { response in
                let json = JSON(response.result.value!)
                let jsonResults = json["results"]
                for (_,subJSON):(String,JSON) in jsonResults {
                    let student = StudentInformation(studentLocation:
                        ["objectID": subJSON["objectId"].stringValue,
                            "uniqueKey": subJSON["uniqueKey"].stringValue,
                        "firstName": subJSON["firstName"].stringValue,
                        "lastName": subJSON["lastName"].stringValue,
                    "mapString": subJSON["mapString"].stringValue,
                        "mediaURL": subJSON["mediaURL"].stringValue,
                    "latitude": subJSON["latitude"].stringValue,
                        "longitude": subJSON["longitude"].stringValue,
                            "createdAt": subJSON["createdAt"].stringValue,
                        "updatedAt": subJSON["updatedAt"].stringValue,
                        "ACL": subJSON["ACL"].stringValue])
                    students.append(student)
                }
                if let completionHandler = completionHandler {
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler()
                    }
                }
        }
    }
}