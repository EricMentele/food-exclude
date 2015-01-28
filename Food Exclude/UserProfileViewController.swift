//
//  UserProfileViewController.swift
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

class UserProfileViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
  //Outlets:
  @IBOutlet weak var textUserName: UITextField!
  @IBOutlet weak var tableAllergens: UITableView!
  @IBOutlet weak var buttonContinue: UIButton!
  
  //Selected user profile:
  var selectedUserProfile: UserProfile!
  var addingNewUserProfile = false
  
  //Function: Set up view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Selected user profile:
    if addingNewUserProfile {
      selectedUserProfile = UserProfile()
    } //end if
    
    //Text field:
    textUserName.delegate = self
    self.textUserName.text = selectedUserProfile!.name
    
    //Table:
    tableAllergens.registerNib(UINib(nibName: "AllergenCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL_ALLERGEN")
    tableAllergens.dataSource = self
    
    //Button:
    buttonContinue.addTarget(self, action: "pressedButtonContinue", forControlEvents: UIControlEvents.TouchUpInside)
  } //end func
  
  //MARK: Table View Data Source
  
  //Function: Set table cell count.
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedUserProfile!.allergens.count
  } //end func
  
  //Function: Set table view cell content.
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //Cell:
    let cell = tableAllergens.dequeueReusableCellWithIdentifier("CELL_ALLERGEN") as AllergenCell
    //Cell content:
    let userAllergen = selectedUserProfile!.allergens[indexPath.row]
    cell.labelAllergen.text = userAllergen.name
    cell.switchIsAllergen.on = userAllergen.sensitive
    //Return cell.
    return cell
  } //end func
  
  //MARK: Text Field Delegate
  
  //Function: Handle event when text field keyboard is dismissed.
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder() //Dismiss keyboard.
    return true
  } //end func
  
  //MARK: Selectors
  
  //Function: Handle Continue button pressed.
  func pressedButtonContinue() {
    //Save data.
    if textUserName.text == "" {
      println("Please enter a user name")
    } else {
      let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
      
      //Add user profile accordingly.
      if addingNewUserProfile {
        appDelegate.userProfiles.append(UserProfile())
        selectedUserProfile = appDelegate.userProfiles.last
      } //end if
      
      //Update selected user profile.
      selectedUserProfile.name = textUserName.text
      let allergenCells = tableAllergens.visibleCells() as [AllergenCell]
      for allergenCell in allergenCells {
        let indexPath = self.tableAllergens.indexPathForCell(allergenCell)
        let allergen = selectedUserProfile.allergens[indexPath!.row]
        allergen.sensitive = allergenCell.switchIsAllergen.on
      } //end for
      
      //Save data.
      appDelegate.saveUserProfilesToArchive()
    } //end if
    
    //Present next view controller.
    let vcScanner = self.storyboard?.instantiateViewControllerWithIdentifier("VC_SCANNER") as ScannerViewController
    self.navigationController?.pushViewController(vcScanner, animated: true)
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
