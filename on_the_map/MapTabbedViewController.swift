//
//  MapTabbedViewController.swift
//  on_the_map
//
//  Created by Ming Hu on 5/23/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class MapTabbedViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!

    
    @IBAction func pressRefresh(sender: AnyObject) {
        StudentInformation.initStudentsFromParse {
            self.map.removeAnnotations(self.currentAnnotations)
            self.addAnnotationsFromStudentInfo()
        }
    }
    
    var currentAnnotations: [StudentAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        let worldRegion = MKCoordinateRegionMake(map.centerCoordinate, MKCoordinateSpanMake(180, 360))
        map.setRegion(worldRegion, animated: true)
        
        addAnnotationsFromStudentInfo()
    }
    
    func addAnnotationsFromStudentInfo() {
        for student in StudentInformation.students {
            let studentAnnotation = StudentAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: NSString(string: student.latitude!).doubleValue, longitude: NSString(string: student.longitude!).doubleValue),
                title: "\(student.firstName!) \(student.lastName!)",
                subtitle: student.mediaURL!)
            currentAnnotations.append(studentAnnotation)
        }
        map.addAnnotations(currentAnnotations)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StudentAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView =
                    UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation {
            if let url = (NSURL(string: annotation.subtitle!!)) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
    }
}

class StudentAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle

    }
}