//
//  PostMapViewController.swift
//  on_the_map
//
//  Created by Ming Hu on 5/25/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class PostMapViewController: UIViewController {
    
    @IBOutlet weak var submitStudentInfoTextField: UITextField!
    
    @IBOutlet weak var submitStudentInfoTopView: UIView!
    
    
    @IBOutlet weak var submitStudentInfoMap: MKMapView!
    
    @IBOutlet weak var submitStudentInfoButton: UIButton!
    
    @IBOutlet weak var findOnTheMapLocationTextField: UITextField!
    
    @IBAction func cancelPostMap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func pressFindOnTheMap(sender: AnyObject) {
        hideFindOnTheMapUI()
        showSubmitStudentInfoUI()
        if let searchText = findOnTheMapLocationTextField.text {
            let searchRequest = MKLocalSearchRequest()
            searchRequest.naturalLanguageQuery = searchText
            let search = MKLocalSearch(request: searchRequest)
            search.startWithCompletionHandler { response, _ in
                guard let response = response else {
                    return
                }
                let matchingItems = response.mapItems
                if matchingItems.count <= 0 {
                    self.displayErrorMessage("Cannot find your location")
                } else {
                    let item = matchingItems[0]
                    let coordinate = item.placemark.coordinate
                    let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.05, 0.05))
                    
                    self.submitStudentInfoMap.setRegion(region, animated: true)
                    let studentAnnotation = StudentAnnotation(coordinate: coordinate, title: "", subtitle: "")
                    self.submitStudentInfoMap.addAnnotation(studentAnnotation)
                    StudentInformation.myself?.latitude = coordinate.latitude.description
                    StudentInformation.myself?.longitude = coordinate.longitude.description
                    StudentInformation.myself?.mapString = searchText
                }
            }
            
        } else {
            displayErrorMessage("Please enter your location")
        }
        
    }
    
    @IBAction func submitStudentInfo(sender: AnyObject) {
        print(StudentInformation.myself)
        if let medialURL = submitStudentInfoTextField.text {
            StudentInformation.myself?.mediaURL = medialURL
            StudentInformation.postMyself {
                print("Posted myself")
            }
        } else {
            
        }
    }
    
    @IBOutlet weak var findOnTheMapTop: UIView!
    
    @IBOutlet weak var findOnTheMapMiddle: UIView!
    
    @IBOutlet weak var findOnTheMapBottom: UIView!
    
    var myAnnotation: StudentAnnotation?
    
    func showSubmitStudentInfoUI() {
        submitStudentInfoTextField.enabled = true
        submitStudentInfoTextField.hidden = false
        submitStudentInfoMap.hidden = false
        submitStudentInfoButton.enabled = true
        submitStudentInfoButton.hidden = false
    }
    
    
    func hideFindOnTheMapUI() {
        findOnTheMapTop.hidden = true
        findOnTheMapMiddle.hidden = true
        findOnTheMapBottom.hidden = true
    }
    
    func displayErrorMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
