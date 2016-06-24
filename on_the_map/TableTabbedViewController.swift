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
        StudentData.initStudentsFromParse({
            self.tableView.reloadData()
        },
        errorHandler: { errorMsg in
            self.displayErrorMessage(errorMsg)
        })
    }
    
    @IBAction func pressLogout(sender: AnyObject) {
        UdacityClient.logout(handleLogoutOk, errorHandler: handleLogoutFail)
    }
    
    @IBAction func postMap(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PostMap")
        presentViewController(vc!, animated: true, completion: nil)

    }
    
    func handleLogoutOk() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleLogoutFail(errorMsg: String) {
        displayErrorMessage(errorMsg)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentData.students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OnTheMapCell", forIndexPath: indexPath)
        let icon = UIImage(named: "pin")
        
        let firstName = StudentData.students[indexPath.row].firstName!
        let lastName = StudentData.students[indexPath.row].lastName!
        let name = "\(firstName) \(lastName)"
        
        cell.imageView!.image = icon
        cell.textLabel!.text = name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let url = NSURL(string: StudentData.students[indexPath.row].mediaURL!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}

extension TableTabbedViewController: ErrorMessageDisplayer {}