//
//  NetworkController.swift
//  Food-Exclude
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

class NetworkController {
  
  var urlSession : NSURLSession
  let clientID = "48bd25da"
  let clientSecret = "698a373a3b0e6ecda8f223451efbe070"
  var statusCode: AnyObject?
  var nsError: NSError?
  
  
  class var sharedNetworkController : NetworkController {
    struct Static {
      static let instance : NetworkController = NetworkController()
      
    }
    return Static.instance
  }
  
  init() {
    //init with configuration
    let ephemConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    
    self.urlSession = NSURLSession(configuration: ephemConfig)
    
  }
  
  
  //MARK: fetchAllergensList
  func fetchAllergensList (completionHandler : (NSDictionary?, String?) -> ()) {
    
    let requestURL = "http://foodscanr.herokuapp.com/allergens"
    let url = NSURL(string: requestURL)
    
    let getRequest = NSMutableURLRequest(URL: NSURL(string: requestURL)!)
    
    let dataTask = self.urlSession.dataTaskWithRequest(getRequest, completionHandler: { (data, response, error) -> Void in
      
      self.nsError = error?
      
      if error == nil {
        
        if let httpResponse = response as? NSHTTPURLResponse {
          
          var status = httpResponse.statusCode
          self.statusCode = status
          
          switch httpResponse.statusCode {
          case 200...299:
            if let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(jsonDict,nil)
              }) //end block
              
            }//end if
          case 404:
            println("404")
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(nil, "Web service not found")
            })
            
          case 300...599:
            println("This is bad - it's an error that may or may not be your fault")
            completionHandler(nil, "this is bad!")
            
          default:
            println("This is odd - default case fired")
          }//end Switch
        }//httpResponse
      } else {
        completionHandler(nil,"Connectivity error. Try again later.")
      }
    })//dataTask
    dataTask.resume()
  }//fetchAllergensList

 

  
  
  //MARK: fetchIngredientList
  func fetchIngredientListForUPC (upcCode : String, completionHandler : (Ingredients?, String?) -> ()) {
    
 
    let requestURL = "https://api.nutritionix.com/v1_1/item?upc=\(upcCode)&appId=\(clientID)&appKey=\(clientSecret)"
    let url = NSURL(string: requestURL)
    
    let getRequest = NSMutableURLRequest(URL: NSURL(string: requestURL)!)
    
    let dataTask = self.urlSession.dataTaskWithRequest(getRequest, completionHandler: { (data, response, error) -> Void in
      
      self.nsError = error?
      
      if error == nil {
        
//         println(response)
        
        if let httpResponse = response as? NSHTTPURLResponse {
         
          var status = httpResponse.statusCode
          self.statusCode = status
          
          
          
          switch httpResponse.statusCode {
          case 200...299:
//            println("outside 200")
            if let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
             println(jsonDict)
              let newIngredient = Ingredients(jsonDictionary: jsonDict)
              //println(newIngredient)
              

              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(newIngredient,nil)
              }) //end block
              
              
              
            }//end if
          case 404:
            println("404")
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(nil, "This item is not in the database.")
            })
          
          case 401:
            println("401")
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(nil, "Api limit reached.")
            })
            
          case 300...599:
            
            println("This is bad - it's an error that may or may not be your fault")
            completionHandler(nil, "this is bad!")
            
            
            
          default:
            println("This is odd - default case fired")
          }//end Switch
        }//httpResponse
      } else {
        completionHandler(nil,"Connectivity error. Try again later.")
      }
    })//dataTask
    dataTask.resume()
  }//fetchIngredientListForUPC
}//NetworkController







//https://api.nutritionix.com/v1_1/item?upc=49000036756&appId=

//48bd25da&appKey=

//698a373a3b0e6ecda8f223451efbe070
