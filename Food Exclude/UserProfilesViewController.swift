//
//  UserProfilesViewController.swift
//  Food Exclude
//
//  Created by Alexandra Norcross on 1/27/15.
//  Copyright (c) 2015
//David Rogers,
//Vania Kurniawati,
//Clint Atkins,
//Alexandra Norcross,
//Eric Mentele. All rights reserved.

/*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class UserProfilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  //Table: to display user profiles
  @IBOutlet weak var tableUserProfiles: UITableView!
  var userProfiles: [UserProfile]!
  
  //Function: Set up the view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Table:
    tableUserProfiles.registerNib(UINib(nibName: "UserProfileCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL_USER_PROFILE")
    tableUserProfiles.dataSource = self
    tableUserProfiles.delegate = self
    
    //Add user profile button:
    let buttonAddUserProfile = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "pressedButtonAddUserProfile")
    self.navigationItem.rightBarButtonItem = buttonAddUserProfile
  } //end func
  
  //Function: Set up view controller.
  override func viewWillAppear(animated: Bool) {
    //User profile data: latest
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    userProfiles = appDelegate.loadUserProfilesFromArchive()
    //Reload table.
    tableUserProfiles.reloadData()
  } //end func
  
  //MARK: Table View Data Source
  
  //Function: Set table count.
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userProfiles.count
  } //end func
  
  //Function: Set table cell content.
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //Cell:
    let cell = tableView.dequeueReusableCellWithIdentifier("CELL_USER_PROFILE", forIndexPath: indexPath) as UserProfileCell
    //Cell contents:
    let currentUserProfile = userProfiles[indexPath.row] as UserProfile
    cell.labelUserName.text = currentUserProfile.name
    cell.switchIncludeProfile.on = currentUserProfile.includeProfile
    cell.avatarImageView.image = currentUserProfile.avatar
    cell.avatarImageView.layer.cornerRadius = 10
    cell.avatarImageView.layer.masksToBounds = true 
    //Return cell.
    return cell
  } //end func
  
  //Function: Determine if table cell can be edited.
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return userProfiles.count > 1 //only if there are 1+ profiles
  } //end func
  
  //Function: Set table cell edit functionality.
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      //Update & Save data.
      userProfiles.removeAtIndex(indexPath.row)
      let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
      appDelegate.saveUserProfilesToArchive(userProfiles)
      //Reload table.
      tableUserProfiles.reloadData()
    } //end if
    
    
    //    if listTableView.editing{
    //      //listTableView.editing = false;
    //      listTableView.setEditing(false, animated: true);
    //      //listTableView.reloadData();
    //    }
    //    else{
    //      //listTableView.editing = true;
    //      listTableView.setEditing(true, animated: true);
    //      barButton.title = "Done";
    //      barButton.style =  UIBarButtonItemStyle.Done;
    //      //listTableView.reloadData();
    //    }
    
  } //end func
  
  //MARK: Table View Delegate
  
  //Function: Handle cell selected event.
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //Selcted user profile:
    var selectedRow = indexPath.row
    //User profile view controller:
    let vcUserProfile = self.storyboard?.instantiateViewControllerWithIdentifier("VC_USER_PROFILE") as UserProfileViewController
    vcUserProfile.selectedUserProfileIndex = selectedRow
    vcUserProfile.selectedUserProfile = userProfiles[selectedRow]
    //Present view controller.
    self.navigationController?.pushViewController(vcUserProfile, animated: true)
  } //end func
  
  //MARK: Selectors
  
  //Function: Handle Add User Profile button pressed.
  func pressedButtonAddUserProfile() {
    //User profile view controller:
    let vcUserProfile = self.storyboard?.instantiateViewControllerWithIdentifier("VC_USER_PROFILE") as UserProfileViewController
    vcUserProfile.selectedUserProfileIndex = -1
    //Present next view controller.
    self.navigationController?.pushViewController(vcUserProfile, animated: true)
  } //end func
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
