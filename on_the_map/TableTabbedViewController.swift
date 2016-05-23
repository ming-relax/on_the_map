//
//  TableTabbedViewController.swift
//  on_the_map
//
//  Created by Ming Hu on 5/23/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import Foundation
import UIKit

class TableTabbedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(StudentInformation.students.count)
        return StudentInformation.students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OnTheMapCell", forIndexPath: indexPath)
        let icon = UIImage(named: "pin")
        
        let firstName = StudentInformation.students[indexPath.row].firstName!
        let lastName = StudentInformation.students[indexPath.row].lastName!
        let name = "\(firstName) \(lastName)"

        print(name)
        cell.imageView!.image = icon
        cell.textLabel!.text = name
        
        return cell
    }
    
}