//
//  ScannerViewController.swift
//  Food Exclude
//
//  Created on 1/25/15.
//  Copyright (c) 2015
//David Rogers,
//Vania Kurniawati,
//Clint Akins,
//Alexandra Norcross,
//Eric Mentele. All rights reserved.
//
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

import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  @IBOutlet weak var toolBar: UIToolbar!
  @IBOutlet weak var barcode: UILabel!
  @IBOutlet weak var nextItem: UIButton!
  @IBOutlet weak var ingredientListView: UIView!
  
  @IBOutlet weak var ingredientTextView: UITextView!
  
  @IBOutlet var superView: UIView!
  
  @IBOutlet weak var maskView: UIView!
  
  @IBOutlet weak var warningLabel = UILabel()
  
  var alertView : UIView!
  
  enum CrossSearchForAllergensResult {
    case allergenPositive
    case allergenNegative
  } //end enum
  
  //this is adapted from http://www.bowst.com/mobile/simple-barcode-scanning-with-swift/
  let session : AVCaptureSession = AVCaptureSession()
  var previewLayer : AVCaptureVideoPreviewLayer!
  var highlightView = UIView()
  var resultView = UIView()
  var detectionString : String!
  var barcodeScanned : String!
  var networkController = NetworkController()
  var list : Ingredients!
  
  var ingredientsList = [String]()
  var originIngredientsList = String()
  var allergenDerivatives = [String : String]()
  var matches = [String]() //this variable will store allergen categories that exist in the ingredients list
  var myMatches = [String]()
  var allergenCategories = [String]() //this stores allergen categories detected in the scanned ingredient list
  var myAllergens = [Allergen]()
  var userProfiles = [UserProfile]()
  
  var sessionTimer = NSTimer()
  var newSessionTimer = NSTimer()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.warningLabel?.hidden = true
    
    self.ingredientListView.alpha = 0
    self.maskView.alpha = 0
    
    //user profile button
    let buttonUserProfiles = UIBarButtonItem(image: UIImage(named: "three115"), style: UIBarButtonItemStyle.Plain, target: self, action: "pressedButtonUserProfiles")
    let spaceLeft = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    toolBar.items = [spaceLeft, buttonUserProfiles]
    
    //formatting so that the barcode reader line resizes automatically
    self.highlightView.autoresizingMask =   UIViewAutoresizing.FlexibleTopMargin |
      UIViewAutoresizing.FlexibleBottomMargin |
      UIViewAutoresizing.FlexibleLeftMargin |
      UIViewAutoresizing.FlexibleRightMargin
    
    //color for the barcode reader line
    self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
    self.highlightView.layer.borderWidth = 3
    //    self.view.addSubview(highlightView)
    
    //dismissButton
    //    self.dismissButton.addTarget(self, action: "dismissButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var error : NSError? = nil
    let input : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
    
    if input != nil {
      session.addInput(input)
    }
    else {
    }
    
    let output = AVCaptureMetadataOutput()
    output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
    self.session.addOutput(output)
    output.metadataObjectTypes = output.availableMetadataObjectTypes
    
    //this is the scanning scene, setting the frame to the view.bounds will cover up other views
    previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as! AVCaptureVideoPreviewLayer
    previewLayer.frame = CGRect(x: 0, y: 65, width: self.view.bounds.width, height: self.view.bounds.height * 0.6)
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    self.view.layer.addSublayer(previewLayer)
    
    self.session.startRunning()
    
    self.sessionTimer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: "displayAlertView", userInfo: nil, repeats: true)
  }
  
  
  override func viewDidAppear(animated: Bool) {
    //go to default profile, if no profile exists
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    if let userProfilesFromArchive = appDelegate.loadUserProfilesFromArchive() as [UserProfile]? {
      if userProfilesFromArchive.isEmpty { //no users: direct to default profile
        gotoUserProfileDefault()
      } //end if
    } else { //no users: direct to default profile
      gotoUserProfileDefault()
    } //end if
  }
  
  
  func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    
    self.matches.removeAll(keepCapacity: false)
    self.myMatches.removeAll(keepCapacity: false)
    self.allergenCategories.removeAll(keepCapacity: false)
    self.myAllergens.removeAll(keepCapacity: false);
    
    
    //load allergen data
    if let allergenData = NSBundle.mainBundle().pathForResource("allergens", ofType: "plist") {
      if let  myDict = NSDictionary(contentsOfFile: allergenData) {
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          self.matches = [""]
          self.myMatches = [""]
          self.allergenDerivatives = myDict as! Dictionary<String,String>
        }) //end closure
      } //end if
    } //end if
    
    
    var highlightViewRect = CGRectZero
    
    var barCodeObject : AVMetadataObject!
    
    //these are the allowed object types within Apple's AVMetaData, we probably only need the first one and the EANs
    let barCodeTypes = [AVMetadataObjectTypeUPCECode,
      AVMetadataObjectTypeCode39Code,
      AVMetadataObjectTypeCode39Mod43Code,
      AVMetadataObjectTypeEAN13Code,
      AVMetadataObjectTypeEAN8Code,
      AVMetadataObjectTypeCode93Code,
      AVMetadataObjectTypeCode128Code,
      AVMetadataObjectTypePDF417Code,
      AVMetadataObjectTypeQRCode,
      AVMetadataObjectTypeAztecCode
    ]
    
    for metadata in metadataObjects {
      
      for barcodeType in barCodeTypes {
        
        if metadata.type == barcodeType {
          barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
          
          highlightViewRect = barCodeObject.bounds
          
          detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
          
          self.session.stopRunning()
          
          break
        }
      }
    }
    
    self.barcodeScanned = self.detectionString
    self.highlightView.frame = highlightViewRect
    
    if self.barcodeScanned != nil {
      
      //MARK: Network connection alert.
      
      if NetworkController.sharedNetworkController.nsError != nil {
        //self.session.stopRunning()
      }
      self.originIngredientsList = ""
      
      
      self.networkController.fetchIngredientListForUPC(self.barcodeScanned, completionHandler: { (ingredients, errorDescription) -> () in
        
        
        if ingredients != nil {
          
          self.list = ingredients
          self.ingredientsList = self.list.seperatedList
          if self.list.ingredientsList != nil {
            self.originIngredientsList = self.list.ingredientsList!
          }
          self.matches = [""]
          
          let crossSearchResult = self.crossSearchForAllergens()
          self.barcode.text = self.list.itemName
          
          //ingredients not available
          if self.originIngredientsList == "" {
            
            self.view.addSubview(self.ingredientListView)
            self.view.layer.borderColor = UIColor.yellowColor().CGColor
            self.view.addSubview(self.maskView)
            self.maskView.hidden = false
            self.maskView.alpha = 0.2
            self.ingredientListView.hidden = false
            self.ingredientListView.alpha = 0.95
            self.ingredientTextView.text = "Ingredients for this item are not yet available, but may become available soon. Please try another item."
            
            //ingredients available; check cross search result
          } else {
            
            self.ingredientListView.hidden = true
            
            if crossSearchResult == CrossSearchForAllergensResult.allergenNegative {
              self.view.addSubview(self.ingredientListView)
              self.view.addSubview(self.maskView)
              self.maskView.hidden = false
              self.maskView.alpha = 0.2
              self.ingredientListView.hidden = false
              self.ingredientListView.alpha = 0.95
              self.ingredientTextView.text = "Please double check the ingredients label."
            } //end if
            
          } //end if
        } //end if
        
        if errorDescription != nil {
          let networkIssueAlert = UIAlertController(title: "Error", message: errorDescription, preferredStyle: .Alert)
          
          let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
          networkIssueAlert.addAction(cancelButton)
          self.presentViewController(networkIssueAlert, animated: true, completion: nil)
          println("fail")
        }
        //println("Does this have the product name? \(self.list)")
      })
    }
    
    //else in if barcode != nil
    return
  }//func captureOutput
  
  
  //MARK: Timed AlertView
  func displayAlertView() {
    if self.detectionString == nil {
      self.alertView = NSBundle.mainBundle().loadNibNamed("AlertView", owner: self, options: nil).first as! UIView
      alertView.center = self.view.center
      alertView.alpha = 0
      alertView.transform = CGAffineTransformMakeScale(0.01, 0.01)
      self.view.addSubview(alertView)
      
      UIView.animateWithDuration(0.4, delay: 0.5, options: nil, animations: { () -> Void in
        self.alertView.alpha = 1
        self.alertView.transform =  CGAffineTransformMakeScale(1.0, 1.0)}) { (finished) -> Void in
          let removeTimer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "removeAlertView", userInfo: nil, repeats: false)
      }
    } else {
      return
    }
  }
  
  func removeAlertView() {
    UIView.animateWithDuration(0.4, delay: 0.5, options: nil, animations: { () -> Void in
      self.alertView.alpha = 0
      self.alertView.transform =  CGAffineTransformMakeScale(0.01, 0.01)}) { (finished) -> Void in
        self.alertView.removeFromSuperview()
        self.sessionTimer.invalidate()
        self.newSessionTimer = NSTimer.scheduledTimerWithTimeInterval(16, target: self, selector: "displayAlertView", userInfo: nil, repeats: false)
    }
  }
  
  
  
  @IBAction func ingredientsDetailButtonClicked(selector: UIButton) {
    
    self.view.addSubview(ingredientListView)
    self.ingredientListView.hidden = false
    self.ingredientListView.alpha = 0.95
    
    if originIngredientsList == "" {
      ingredientTextView.text = "Ingredients for this item are not yet available, but may become available soon. Please try another item."
      
      
    } else if self.matches == [""] {
      
      
      self.ingredientTextView.text = "\(originIngredientsList)  : Powered by Nutritionix API"
      
    } else {
      
      
      self.ingredientTextView.text = "\(originIngredientsList) May contain the allergen derivatives:\(self.matches) in the allergen category: \(self.allergenCategories)    : Powered by Nutritionix API"
      
    }
    
  }
  
  
  @IBAction func okPressed(sender: AnyObject) {
    
    self.ingredientListView.alpha = 0
  }
  
  
  //MARK:  Start new scan.
  @IBAction func newScan(sender: UIButton) {
    
    println("new scan pressed")
    self.warningLabel?.hidden = true
    detectionString = nil
    self.barcode.text = nil
    self.view.layer.borderColor = UIColor.clearColor().CGColor
    self.maskView.backgroundColor = UIColor.clearColor()
    
    //tried recreating arrays
    self.matches = [String]()
    self.myMatches = [String]()
    self.allergenCategories = [String]()
    self.myAllergens = [Allergen]()
    self.session.startRunning()
    self.allergenDerivatives = [String : String]()
    
    self.originIngredientsList = String()
    
    //clearing the arrays here as well
    self.matches = [""]
    self.myMatches = [""]
    
    
    //reload allergenData
    if let allergenData = NSBundle.mainBundle().pathForResource("allergens", ofType: "plist") {
      if let  myDict = NSDictionary(contentsOfFile: allergenData) {
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          self.allergenDerivatives = myDict as! [String : String]
        }) //end closure
      } //end if
    } //end if
    //however this results in the original array still being passed - !
    
  }
  
  //MARK: Cross-search ingredients list against allergen derivatives list
  var ngrams: [String: String] = [:]
  
  func crossSearchForAllergens() -> CrossSearchForAllergensResult {
    
    println("crosssearch")
    //loop over the ingredients list for all allergen derivatives, put matches into self.matches
    //generate the n-grams for the ingredients
    for ingredient in self.ingredientsList {
      var ingredientComp = ingredient.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).componentsSeparatedByString(" ")
      for (var i=0; i<ingredientComp.count; i++) {
        var ngram = ""
        for (var j=i; j<ingredientComp.count; j++) {
          if(!ngram.isEmpty) {
            ngram += " "
          }
          ngram += ingredientComp[j]
          ngrams[ngram] = ingredient
          
        }
      }
    }
    
    var matches: [String : String] = [:]
    for (key, value) in self.allergenDerivatives {
      if let match = ngrams[key] {
        matches[key] = match
      }
    }
    self.ngrams = [:]
    
    for (key, value) in matches {
      self.matches.append(key)
      self.allergenCategories.append(self.allergenDerivatives[key]!)
    }
    
    println("Contains the following known allergen derivatives \(self.matches)")
    println("Contains allergens in the following categories \(self.allergenCategories)")
    println(matches.count)
    
    //load user profile data
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    self.userProfiles = appDelegate.loadUserProfilesFromArchive()!
    
    var dictionaryOfAllergens = [String : Bool]()
    
    //load allergens that active users have and put them in myAllergens
    for categories in self.allergenCategories {
      //println("allergen category \(categories)")
      dictionaryOfAllergens[categories] = true
      for user in userProfiles {
        if user.includeProfile {
          var allergens = user.allergens
          for allergy in allergens {
            if allergy.sensitive == true {
              //println("allergy name \(allergy.name)")
              //println(dictionaryOfAllergens[allergy.name])
              let match = dictionaryOfAllergens[allergy.name]
              if match == true {
                self.myAllergens.append(allergy)
              } //end if
            } //end if
          } //end for
        } //end if
      } //end for
    } //end for
    
    println(self.myAllergens)
    
    //change border color
    if !self.myAllergens .isEmpty {
      self.view.layer.borderWidth = 15
      self.view.layer.borderColor = UIColor(red: 153, green: 0, blue: 0).CGColor
      self.view.addSubview(maskView)
      
      self.warningLabel?.textColor = UIColor.redColor()
      self.warningLabel?.alpha = 0.9
      self.warningLabel?.text = "Allergen Detected"
      self.warningLabel?.hidden = false
      
      self.maskView.hidden = false
      self.maskView.backgroundColor = UIColor.redColor()
      self.maskView.alpha = 0.2
      
      return CrossSearchForAllergensResult.allergenPositive
    }
    else {
      self.view.layer.borderWidth = 15
      self.view.layer.borderColor = UIColor(red: 0, green: 153, blue: 0).CGColor
      self.view.addSubview(maskView)
      
      self.warningLabel?.textColor = UIColor.greenColor()
      self.warningLabel?.alpha = 0.9
      self.warningLabel?.text = "Allergen Free"
      self.warningLabel?.hidden = false
      
      self.maskView.hidden = false
      self.maskView.backgroundColor = UIColor.greenColor()
      self.maskView.alpha = 0.2
      
      return CrossSearchForAllergensResult.allergenNegative
    }
    
  }
  
  
  //Function: Handle event when User Profiles button is pressed.
  func pressedButtonUserProfiles() {
    let vcUserProfiles = self.storyboard?.instantiateViewControllerWithIdentifier("NAV_USER_PROFILES") as! UINavigationController
    self.presentViewController(vcUserProfiles, animated: true, completion: nil)
  }//end func
  
  //Function: Go to default User Profile.
  func gotoUserProfileDefault() {
    
    let vcUserProfiles = self.storyboard?.instantiateViewControllerWithIdentifier("NAV_USER_PROFILES") as! UINavigationController
    let vcUserProfile = storyboard?.instantiateViewControllerWithIdentifier("VC_USER_PROFILE") as! UserProfileViewController
    vcUserProfile.selectedUserProfileIndex = -1
    
    vcUserProfiles.pushViewController(vcUserProfile, animated: false)
    self.presentViewController(vcUserProfiles, animated: true, completion: nil)
  } //end func
}
