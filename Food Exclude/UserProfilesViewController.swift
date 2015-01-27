//
//  UserProfilesViewController.swift
//  Food Exclude
//
//  Created by Alexandra Norcross on 1/27/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class UserProfilesViewController: UIViewController {
//  , UITableViewDelegate, UITableViewDataSource
  //Table: to display user profiles
  @IBOutlet weak var tableUserProfiles: UITableView!
  var userProfiles: [UserProfile]!
  
  //Function: Set up the view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()

    //Table:
//    tableUserProfiles.delegate = self
//    tableUserProfiles.dataSource = self
  } //end func
  
  //Function: Set table count.
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userProfiles.count
  } //end func
  
  //Function: Set table cell content.
//  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
////    let cell = d
//    //Return cell.
////    return cell
//  } //end func
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
