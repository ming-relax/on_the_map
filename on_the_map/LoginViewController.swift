//
//  ViewController.swift
//  on_the_map
//
//  Created by Ming Hu on 5/8/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import UIKit
import Alamofire
import Reachability
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    var email: String?
    var password: String?
    
    var userKey: String?
    var sessionID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            email = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        } else if textField == passwordTextField {
            password = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loginToUdacity()
        return true
    }


    @IBAction func pressLoginButton(sender: AnyObject) {
        self.becomeFirstResponder()
        loginToUdacity()
    }
    
    func loginToUdacity() {
//        print(email)
//        print(password)
        var errorMessage: String?
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }

        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                self.displayErrorMessage("Network not reachable")
            }
        }
        
        email = "humings@gmail.com"
        password = "bertrandoosc0$"
        
        if email == nil || email == "" || password == nil || password == "" {
            errorMessage = "Email or Password is empty"
        }
        
        if let errorMessage = errorMessage {
            displayErrorMessage(errorMessage)
        }

        // login here
        let parameters = [
            "udacity": [
                "username": email!,
                "password": password!
            ]
        ]

        Alamofire.request(.POST, "https://www.udacity.com/api/session", parameters: parameters, encoding: .JSON)
            .responseString { response in
                switch response.result {
                case .Success:
                    if let result = response.result.value {
                        let jsonString = result.substringFromIndex(result.startIndex.advancedBy(5))
                        
                        if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                            
                            let jsonResult = JSON(data: dataFromString)
                            if jsonResult["status"] == 403 {
                                self.displayErrorMessage("Email or Passowrd is wrong")
                            } else {
                                self.userKey = jsonResult["account"]["key"].string
                                self.sessionID = jsonResult["session"]["id"].string
                                print(jsonResult)
                                print(self.userKey)
                                print(self.sessionID)
                                StudentInformation.initMyself(self.userKey!)
                                
                                let vc: UITabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMap") as! UITabBarController
                                StudentInformation.initStudentsFromParse({
                                    self.presentViewController(vc, animated: true, completion: nil)
                                    print("OK!")
                                })
                                
                            }
                        }
                    }
                case .Failure(let error):
                    print(error)
                }
        }
        

    }
    
    func displayErrorMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

