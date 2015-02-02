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
  
  @IBOutlet weak var barcode: UILabel!
  
  @IBOutlet weak var nextItem: UIButton!
  
  var alertView : UIView!
  
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
  var matches = [String]() //this variable will store allergen derivatives that exist in the ingredients list
  var myMatches = [String]()
  var allergenCategories = [String]() //this stores allergen categories detected in the scanned ingredient list
  var myAllergens = [Allergen]()
  var userProfiles = [UserProfile]()
  
  var sessionTimer = NSTimer()
  var newSessionTimer = NSTimer()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Add user profile button:
    let buttonUserProfiles = UIBarButtonItem(image: UIImage(named: "three115"), style: UIBarButtonItemStyle.Plain, target: self, action: "pressedButtonUserProfiles")
    self.navigationItem.rightBarButtonItem = buttonUserProfiles
    
    //load allergenData
    if let allergenData = NSBundle.mainBundle().pathForResource("allergens", ofType: "plist") {
      var myDict = NSDictionary(contentsOfFile: allergenData)
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        self.allergenDerivatives = myDict as [String : String]
      })
      self.allergenDerivatives = myDict as [String : String]
    }
    
    //formatting so that the barcode reader line resizes automatically
    self.highlightView.autoresizingMask =   UIViewAutoresizing.FlexibleTopMargin |
      UIViewAutoresizing.FlexibleBottomMargin |
      UIViewAutoresizing.FlexibleLeftMargin |
      UIViewAutoresizing.FlexibleRightMargin
    
    //color for the barcode reader line
    self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
    self.highlightView.layer.borderWidth = 3
    self.view.addSubview(highlightView)
    
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
    previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as AVCaptureVideoPreviewLayer
    previewLayer.frame = CGRect(x: 0, y: 40, width: self.view.bounds.width, height: self.view.bounds.height * 0.6)
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    self.view.layer.addSublayer(previewLayer)
    
    self.session.startRunning()
  }
  

  
  override func viewWillAppear(animated: Bool) {
    self.sessionTimer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "displayAlertView", userInfo: nil, repeats: true)
  }
  
  
  func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    
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
          barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as AVMetadataMachineReadableCodeObject)
          
          highlightViewRect = barCodeObject.bounds
          
          detectionString = (metadata as AVMetadataMachineReadableCodeObject).stringValue
          
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
      
      self.networkController.fetchIngredientListForUPC(self.barcodeScanned, completionHandler: { (ingredients, errorDescription) -> () in
        
        if ingredients != nil {
        self.list = ingredients
        self.ingredientsList = self.list.seperatedList
          if self.list.ingredientsList != nil {
            self.originIngredientsList = self.list.ingredientsList!
          }
        self.crossSearchForAllergens()
        self.barcode.text = self.list.itemName
        
        }
        
        if errorDescription != nil {
          let networkIssueAlert = UIAlertController(title: "Network Error", message: errorDescription, preferredStyle: .Alert)
          let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
          networkIssueAlert.addAction(cancelButton)
          self.presentViewController(networkIssueAlert, animated: true, completion: nil)
          println("fail")
        }
        println("Does this have the product name? \(self.list)")
        self.displayAlertView()
        })
    }

    //else in if barcode != nil
    return
  }//func captureOutput

  
  //MARK: Timed AlertView
  func displayAlertView() {
    if self.detectionString == nil {
      self.alertView = NSBundle.mainBundle().loadNibNamed("AlertView", owner: self, options: nil).first as UIView
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
        self.newSessionTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "displayAlertView", userInfo: nil, repeats: false)
        }
  }
  
  
  
  @IBAction func ingredientsDetailButtonClicked(selector: UIButton) {
    let alertCon = UIAlertController(title: NSLocalizedString("Ingredients", comment: "This is the main menu"), message: NSLocalizedString("\(originIngredientsList) : Powered by Nutritionix API", comment: "Choose View"), preferredStyle: UIAlertControllerStyle.ActionSheet)
    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertCon.addAction(okButton)
    self.presentViewController(alertCon, animated: true, completion: nil)
  }
    
  
  //MARK:  Start new scan.
  @IBAction func newScan(sender: UIButton) {
    detectionString = nil
    self.view.layer.borderColor = UIColor(red: 0, green: 0, blue: 0).CGColor
    self.matches = [String]()
    self.myMatches = [String]()
    self.allergenCategories = [String]()
    self.session.startRunning()
    
  }
      
  //MARK: Cross-search ingredients list against allergen derivatives list

  func crossSearchForAllergens() {
//    for item in self.ingredients {
//      println(ingredients)
//      if let c = allergens.indexForKey(item) {
//        self.matches.append(item)
    
        //loop over the ingredients list for all allergen derivatives, put matches into self.matches
        for item in self.ingredientsList {
          for allergen in allergenDerivatives.keys {
            if item.rangeOfString(allergen.lowercaseString) != nil {
            self.matches.append(allergen)
            self.allergenCategories.append(self.allergenDerivatives[allergen]!)
            }
          }
        }
    println(self.allergenCategories)
    
        //load user profile data
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.userProfiles = appDelegate.loadUserProfilesFromArchive()!
        
        var dictionaryOfAllergens = [String : Bool]()
        
        //load allergens that active users have and put them in myAllergens
        for categories in self.allergenCategories {
          dictionaryOfAllergens[categories] = true
          for user in userProfiles {
            var allergens = user.allergens
            for allergy in allergens {
              if allergy.sensitive == true {
                let match = dictionaryOfAllergens[allergy.name]
                if match == true {
                  self.myAllergens.append(allergy)
                }
              }
            }
          }
        }
   
    
        //change border color
        if !self.myAllergens .isEmpty {
          self.view.layer.borderWidth = 9
          self.view.layer.borderColor = UIColor(red: 153, green: 0, blue: 0).CGColor
          }
        else {
          self.view.layer.borderWidth = 8
          self.view.layer.borderColor = UIColor(red: 0, green: 153, blue: 0).CGColor
        }
      }
      
      
      //Function: Handle event when User Profiles button is pressed.
      func pressedButtonUserProfiles() {
        let vcUserProfiles = self.storyboard?.instantiateViewControllerWithIdentifier("VC_USER_PROFILES") as UserProfilesViewController
        self.navigationController?.pushViewController(vcUserProfiles, animated: true)
      }//end func
}
