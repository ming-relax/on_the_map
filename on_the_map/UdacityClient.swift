//
//  UdacityClient.swift
//  on_the_map
//
//  Created by Ming Hu on 6/18/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import Foundation

struct UdacityClient {
    static func login(email email: String, password: String, completionHandler: ((userKey: String) -> Void)?, errorHandler: ((errorMsg: String) -> Void)?) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    if let errorHandler = errorHandler {
                        if error.domain == NSURLErrorDomain && error.code == NSURLErrorTimedOut {
                            errorHandler(errorMsg: "Network timeout")
                        } else {
                            errorHandler(errorMsg: "Fail to connect to Udacity")
                        }
                    }
                }
                return
            }

            let httpResponse = response as? NSHTTPURLResponse
            if httpResponse?.statusCode != 200 {
                dispatch_async(dispatch_get_main_queue()) {
                    if let errorHandler = errorHandler {
                        errorHandler(errorMsg: "Email or Password is wrong")
                    }
                }
                return
                
            }
            
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            let jsonString = NSString(data: newData, encoding: NSUTF8StringEncoding)
            var json: [String: AnyObject]!
            
            do {
                json = try NSJSONSerialization.JSONObjectWithData((jsonString?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions()) as? [String: AnyObject]
            } catch {
                print(error)
            }
            
            guard let account = json["account"] as? [String: AnyObject],
                let key = account["key"] as? String else {
                    return
            }
            
            print(key)
            
            dispatch_async(dispatch_get_main_queue()) {
                if let completionHandler = completionHandler {
                    completionHandler(userKey: key)
                }
            }
        }
        task.resume()

    }
    
    static func logout(completionHandler: (() -> Void)?, errorHandler: ((errorMsg: String) -> Void)?) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error
                dispatch_async(dispatch_get_main_queue()) {
                    if let errorHandler = errorHandler {
                        errorHandler(errorMsg: "Logout error")
                    }
                }
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            dispatch_async(dispatch_get_main_queue()) {
                if let completionHandler = completionHandler {
                    completionHandler()
                }
            }
        }
        task.resume()
    }
    
    static func getUser(userKey: String, completionHandler: ((user: [String: String]) -> Void)?) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userKey)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            let jsonString = NSString(data: newData, encoding: NSUTF8StringEncoding)
            var json: [String: AnyObject]!
            
            do {
                json = try NSJSONSerialization.JSONObjectWithData((jsonString?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions()) as? [String: AnyObject]
            } catch {
                print(error)
            }
            
            guard let user = json["user"] as? [String: AnyObject],
                let firstName = user["first_name"] as? String,
                let lastName = user["last_name"] as? String else {
                    return
            }
            if let completionHandler = completionHandler {
                completionHandler(user: ["firstName": firstName, "lastName": lastName])
            }
        }
        task.resume()
       
    }
}