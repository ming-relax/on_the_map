//
//  ViewController.swift
//  on_the_map
//
//  Created by Ming Hu on 5/8/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import UIKit


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
    
    func handleLoginOK(userKey: String) {
        print("handleLoginOK: \(userKey)")

        StudentData.initMyself(userKey)
        
        let vc: UITabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMap") as! UITabBarController
        
        StudentData.initStudentsFromParse {
            self.presentViewController(vc, animated: true, completion: nil)
        }

    }
    
    func handleLoginFailed(errorMsg: String) {
        print("handleLoginFailed: \(errorMsg)")
        displayErrorMessage(errorMsg)
    }
    
    func loginToUdacity() {
        var errorMessage: String?
        
        if email == nil || email == "" || password == nil || password == "" {
            errorMessage = "Email or Password is empty"
        }
        
        if let errorMessage = errorMessage {
            displayErrorMessage(errorMessage)
            return
        }

        UdacityClient.login(email: email!, password: password!, completionHandler: handleLoginOK, errorHandler: handleLoginFailed)

    }
}

extension LoginViewController: ErrorMessageDisplayer {}

