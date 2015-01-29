//
//  ScannerViewController.swift
//  Food Exclude
//
//  Created on 1/25/15.
//  Copyright (c) 2015
//David Rogers,
//Vania Kurniawati,
//Clint Atkins,
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
  var category = [String]()
    
  var ingredientsList = [String]()
  var allergenDerivatives = [String : String]()
  var matches = [String]() //this variable will store allergen derivatives that exist in the ingredients list
  var myMatches = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
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
        let sessionTimer = NSTimer.scheduledTimerWithTimeInterval(13, target: self, selector: "displayAlertView", userInfo: nil, repeats: true)
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
        self.barcode.text = "Barcode scanned: \(self.detectionString)"
        self.barcodeScanned = self.detectionString
        self.highlightView.frame = highlightViewRect
        
        if self.barcodeScanned != nil {
          
          
          //MARK: Network connection alert.
          
          if NetworkController.sharedNetworkController.nsError != nil {
            
            let networkIssueAlert = UIAlertController(title: "Network Error", message: "Please make sure you have an internet connecton and try again later", preferredStyle: .Alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            networkIssueAlert.addAction(cancelButton)
            self.presentViewController(networkIssueAlert, animated: true, completion: nil)
            println("fail")
            
            //self.session.stopRunning()
          }
          
          
          self.networkController.fetchIngredientListForUPC(barcodeScanned, completionHandler: { (ingredients, errorDescription) -> () in
            
            self.list = ingredients
            var prepList = self.list.ingredientsList!.lowercaseString
            self.ingredientsList = prepList.componentsSeparatedByString(",")
            for(var i=0; i<self.ingredientsList.count; i++) {
              self.ingredientsList[i] = self.ingredientsList[i].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
            
            self.crossSearchForAllergens()
            
            
            
            println("Does this have the product name? \(self.list)")
            
            
            //MARK: Item not in database alert
            if self.networkController.statusCode as NSObject == 404  {
              
              let itemNotFoundAlert = UIAlertController(title: "Item Not Found", message: "This item is not in the database", preferredStyle: .Alert)
              let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
              itemNotFoundAlert.addAction(okButton)
              self.presentViewController(itemNotFoundAlert, animated: true, completion: nil)
            }//if
            
            
            //MARK: API calls maxed alert.
            if self.networkController.statusCode as NSObject == 401  {
              
              let apiMaxed = UIAlertController(title: "API Call Limit", message: "The daily maximum for API calls has been reached", preferredStyle: .Alert)
              let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
              apiMaxed.addAction(okButton)
              self.presentViewController(apiMaxed, animated: true, completion: nil)
            }//if
            
          })
        } else {
          
          
          
          return
        }//else in if barcode != nil
        
        return
      }//func captureOutput
      
      
      //MARK: Timed AlertView
      
      func displayAlertView() {
        if detectionString == nil {
          self.alertView = NSBundle.mainBundle().loadNibNamed("AlertView", owner: self, options: nil).first as UIView
          alertView.center = self.view.center
          alertView.alpha = 0
          alertView.transform = CGAffineTransformMakeScale(0.4, 0.4)
          self.view.addSubview(alertView)
          
          UIView.animateWithDuration(0.4, delay: 0.5, options: nil, animations: { () -> Void in
            self.alertView.alpha = 1
            self.alertView.transform =  CGAffineTransformMakeScale(1.0, 1.0)
            }) { (finished) -> Void in
              
              let removeTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "removeAlertView", userInfo: nil, repeats: false)
          }
        } else {
          
        }
      }
      
      func removeAlertView() {
        self.alertView.removeFromSuperview()
      }
      
      //MARK:  Start new scan.
      @IBAction func newScan(sender: UIButton) {
        
        detectionString = nil
        self.session.startRunning()
        self.removeAlertView()
      }
      
      //MARK: Cross-search ingredients list against allergen derivatives list
      func crossSearchForAllergens() {
        for item in self.ingredientsList {
          
          if let c = allergenDerivatives.indexForKey(item) {
            self.matches.append(item)
            self.category.append(self.allergenDerivatives[item]!)
          }}
        println(self.matches)
        println(self.category)
        
        for item in self.matches {
          var myAllergens = ["milk" : "milk", "eggs" : "eggs", "fish" : "fish", "shellfish" : "shellfish", "treenuts" : "treenuts", "peanuts" : "peanuts", "wheat" : "wheat", "soy" : "soy", "gluten" : "gluten"]
          if let d = myAllergens.indexForKey(item) {
            self.myMatches.append(item)
          }
        }
        println("This product contains \(self.myMatches)")
  }
  
      
      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
      }
      
      
}