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

class UserProfileViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  //REQUIRED: selected user profile index - set to -1 to add a new user profile
  var selectedUserProfileIndex: Int!
  var selectedUserProfile: UserProfile!
  
  //Image picker:
  var imagePickerController = UIImagePickerController()
  
  //Outlets:
  @IBOutlet weak var textUserName: UITextField!
  @IBOutlet weak var tableAllergens: UITableView!
  @IBOutlet weak var buttonContinue: UIButton!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var switchIncludeProfile: UISwitch!
  @IBOutlet weak var labelIncludeProfile: UILabel!
  @IBOutlet weak var labelSelectFoods: UILabel!
  
  //Function: Set up view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Appearance:
    labelIncludeProfile.font = UIFont(name: "Avenir", size: 15.0)
    labelSelectFoods.font = UIFont(name: "Avenir", size: 15.0)
    
    //Selected user profile:
    if selectedUserProfileIndex < 0 {
      selectedUserProfile = UserProfile()
    } //end if
    
    //Text field:
    textUserName.delegate = self
    self.textUserName.text = selectedUserProfile!.name
    
    //Avatar:
    if self.selectedUserProfile.avatar != nil {
      self.avatarImageView.image = self.selectedUserProfile.avatar
    } else {
      self.avatarImageView.image = UIImage(named: "Placeholder_person.png")
    } //end if
    avatarImageView.layer.cornerRadius = 10
    avatarImageView.layer.masksToBounds = true
    
    //Switch:
    switchIncludeProfile.on = selectedUserProfile!.includeProfile
    
    //Table:
    tableAllergens.registerNib(UINib(nibName: "AllergenCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL_ALLERGEN")
    tableAllergens.dataSource = self
    tableAllergens.delegate = self
    
    //Button:
    buttonContinue.addTarget(self, action: "pressedButtonContinue", forControlEvents: UIControlEvents.TouchUpInside)
    
    //Camera button:
    let cameraButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "avatarButtonPressed")
    self.navigationItem.rightBarButtonItem = cameraButton
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
  
  //MARK: Table View Delegate
  
  //Function: Handle event when cell is selected.
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //Edit cell.
    let cell = tableView.cellForRowAtIndexPath(indexPath) as AllergenCell
    cell.selected = false
    cell.switchIsAllergen.setOn(!cell.switchIsAllergen.on, animated: true)
    //Update user profile.
    selectedUserProfile.allergens[indexPath.row].sensitive = cell.switchIsAllergen.on
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
    if textUserName.text == "" { //no name
      let alertBlankUserName = UIAlertController(title: "Please enter a Name", message: "", preferredStyle: .Alert)
      let buttonCancel = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
      alertBlankUserName.addAction(buttonCancel)
      self.presentViewController(alertBlankUserName, animated: true, completion: nil)
    } else {
      let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
      //Add/Update selected user profile.
      var userProfiles = appDelegate.loadUserProfilesFromArchive() as [UserProfile]?
      if userProfiles != nil {
        if !userProfiles!.isEmpty { //users exist: edit/add user profile accordingly
          if selectedUserProfileIndex >= 0 { //edit user profile
            userProfiles![selectedUserProfileIndex] = selectedUserProfile
          } else { //add user profile
            userProfiles!.append(selectedUserProfile)
          } //end if
        } else { //no users exist: add user
          userProfiles!.append(selectedUserProfile)
        } //end if
      } else { //no users exist: add user
        userProfiles = [selectedUserProfile]
      } //end if
      selectedUserProfile.name = textUserName.text
      selectedUserProfile.includeProfile = switchIncludeProfile.on
      self.selectedUserProfile.avatar = avatarImageView.image

      //Save data.
      appDelegate.saveUserProfilesToArchive(userProfiles!)
      
      //Present next view controller.
      let vcScanner = self.storyboard?.instantiateViewControllerWithIdentifier("VC_SCANNER") as ScannerViewController
      self.navigationController?.pushViewController(vcScanner, animated: true)
    } //end if
  } //end func
  
  //Function: Handle event when Avatar button is selected.
  func avatarButtonPressed() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
      self.imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      self.imagePickerController.delegate = self
      self.imagePickerController.allowsEditing = true
      self.presentViewController(self.imagePickerController, animated: true, completion: nil)
    } else
  
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      let imagePickerController = UIImagePickerController()
      imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
      imagePickerController.delegate = self
      imagePickerController.allowsEditing = true
      self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
  }
  
  //Function: Handle event when avatar image is selected.
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image = info[UIImagePickerControllerEditedImage] as UIImage
    self.avatarImageView.image = image
    imagePickerController.dismissViewControllerAnimated(true, completion: nil)
  }

  //Function: Handle event when avatar image selection is cancelled.
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
