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
    
    var firstName: String?
    var lastName: String?
    
    init(studentLocation: [String: String]) {
        firstName = studentLocation["firstName"]
        lastName = studentLocation["lastName"]
    }
    
    static var students: [StudentInformation] = []
    
    static func initStudentsFromParse() {
        let headers = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        ]
        Alamofire.request(.GET, "https://api.parse.com/1/classes/StudentLocation", headers: headers, parameters: ["limit": "100"])
            .responseJSON { response in
                let json = JSON(response.result.value!)
                let jsonResults = json["results"]
                for (_,subJSON):(String,JSON) in jsonResults {
                    let student = StudentInformation(studentLocation: ["firstName": subJSON["firstName"].string!, "lastName": subJSON["lastName"].string!])
                    students.append(student)
                }
                print(students)
        }
    }
}