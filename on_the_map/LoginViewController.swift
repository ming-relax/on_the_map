//
//  ViewController.swift
//  on_the_map
//
//  Created by Ming Hu on 5/8/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import UIKit
import Alamofire


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let parameters = [
            "udacity": [
                "username": "humings@gmail.com",
                "password": "bertrandoosc0$"
            ]
        ]
        
        Alamofire.request(.POST, "https://www.udacity.com/api/session", parameters: parameters, encoding: .JSON)
            .responseString { response in
                print(response.data)
                print(response.result)
                print(response.result.value)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

