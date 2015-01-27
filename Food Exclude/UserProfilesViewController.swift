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
    if currentUserProfile.includeProfile {
      cell.switchIncludeProfile.on = true
    } else {
      cell.switchIncludeProfile.on = false
    } //end else
    //Return cell.
    return cell
  } //end func

  //MARK: Table View Delegate
  
  //Function: Handle cell selected event.
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //Selcted user profile:
    var selectedRow = indexPath.row
    //User profile view controller:
    let vcUserProfile = self.storyboard?.instantiateViewControllerWithIdentifier("VC_USER_PROFILE") as UserProfileViewController
    vcUserProfile.selectedUserProfile = userProfiles[selectedRow]
    
    //Present view controller.
    self.navigationController?.pushViewController(vcUserProfile, animated: true)
  } //end func
  
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
