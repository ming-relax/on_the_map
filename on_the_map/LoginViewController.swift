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

class LoginViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    var email: String?
    var password: String?
    
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
            email = textField.text
        } else if textField == passwordTextField {
            password = textField.text
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
        print(email)
        print(password)
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
                print(response.data)
                print(response.result)
                print(response.result.value)
        }
        

    }
    
    func displayErrorMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

