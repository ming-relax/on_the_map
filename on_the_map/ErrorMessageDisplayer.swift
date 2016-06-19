//
//  DisplayErrorMessage.swift
//  on_the_map
//
//  Created by Ming Hu on 6/19/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorMessageDisplayer {
    func displayErrorMessage(message: String)
}

extension ErrorMessageDisplayer where Self: UIViewController {
    func displayErrorMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}