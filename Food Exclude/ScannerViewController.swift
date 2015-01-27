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
  @IBOutlet weak var dismissButton: UIButton!
  
  //this is adapted from http://www.bowst.com/mobile/simple-barcode-scanning-with-swift/
  let session : AVCaptureSession = AVCaptureSession()
  var previewLayer : AVCaptureVideoPreviewLayer!
  var highlightView = UIView()
  var resultView = UIView()
  var detectionString : String!
  var barcodeScanned : String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
      
      //      //add a pop-up alert to indicate something went wrong
      //
      //      let networkIssueAlert = UIAlertController(title: "Error", message: "Unable to access camera", preferredStyle: .Alert)
      //      //adds a cancell button to dismiss alert
      //      let cancelButton = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
      //      networkIssueAlert.addAction(cancelButton)
      //      //presents alert controller
      //      self.presentViewController(networkIssueAlert, animated: true, completion: nil)
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
    var butter = "0767707001067"
    var stamp = "1564568900"
    if self.barcodeScanned != nil {
      
      if self.barcodeScanned == butter {
        self.view.layer.borderWidth = 10
        self.barcode.backgroundColor = UIColor.greenColor()
        self.view.layer.borderColor = UIColor.greenColor().CGColor
        
      }
      else {
        self.view.layer.borderWidth = 10
        self.barcode.backgroundColor = UIColor.redColor()
        self.view.layer.borderColor = UIColor.redColor().CGColor
      }
    }
    else {
      
    }
    
    self.view.bringSubviewToFront(self.highlightView)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}