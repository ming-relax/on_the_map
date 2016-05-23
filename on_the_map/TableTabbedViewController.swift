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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
    }
    
    @IBAction func pressRefresh(sender: AnyObject) {
        StudentInformation.initStudentsFromParse {
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OnTheMapCell", forIndexPath: indexPath)
        let icon = UIImage(named: "pin")
        
        let firstName = StudentInformation.students[indexPath.row].firstName!
        let lastName = StudentInformation.students[indexPath.row].lastName!
        let name = "\(firstName) \(lastName)"

        cell.imageView!.image = icon
        cell.textLabel!.text = name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let url = NSURL(string: StudentInformation.students[indexPath.row].mediaURL!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}