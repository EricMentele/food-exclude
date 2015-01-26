//
//  ViewController.swift
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

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  @IBOutlet weak var barcode: UILabel!
  
  let session : AVCaptureSession = AVCaptureSession()
  var previewLayer : AVCaptureVideoPreviewLayer!
  var highlightView = UIView()
  var resultView = UIView()
  var detectionString : String!
  var barcodeScanned : String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //view formatting
    self.highlightView.autoresizingMask =   UIViewAutoresizing.FlexibleTopMargin |
      UIViewAutoresizing.FlexibleBottomMargin |
      UIViewAutoresizing.FlexibleLeftMargin |
      UIViewAutoresizing.FlexibleRightMargin
    
    //color for the barcode reader line
    self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
    self.highlightView.layer.borderWidth = 3
    self.view.addSubview(highlightView)
    
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    var error : NSError? = nil
    
    let input : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
    
    if input != nil {
      session.addInput(input)
    }
    else {
      //add a pop-up alert to indicate something went wrong 
      println("Meow mix: something went wrong")
    }
    
    let output = AVCaptureMetadataOutput()
    output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
    self.session.addOutput(output)
    output.metadataObjectTypes = output.availableMetadataObjectTypes
    
    previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as AVCaptureVideoPreviewLayer
    previewLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 0.7)
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    self.view.layer.addSublayer(previewLayer)
    
    self.session.startRunning()
  }
  
  func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    
    var highlightViewRect = CGRect(x: 0, y: 0, width: 600, height: 300)
    
    var barCodeObject : AVMetadataObject!
    
    //these are the types of objects supported within Apple's AVMetaData
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
    
    
    //scanner can read multiple barcodes at once
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
    println("\(self.detectionString)")
    self.barcodeScanned = self.detectionString
    self.highlightView.frame = highlightViewRect
    self.view.bringSubviewToFront(self.highlightView)
  }
  
  func checkForAllergy(barcode: String) {
    let barcode = self.barcodeScanned
    
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

