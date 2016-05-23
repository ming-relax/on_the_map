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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        // init student annotation
        for student in StudentInformation.students {
            let studentAnnotation = StudentAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: NSString(string: student.latitude!).doubleValue, longitude: NSString(string: student.longitude!).doubleValue))
            map.addAnnotation(studentAnnotation)
        }
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
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
}

class StudentAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}