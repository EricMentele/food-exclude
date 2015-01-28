//
//  NetworkController.swift
//  Food-Exclude
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

class NetworkController {
  
  var urlSession : NSURLSession
  let clientID = "41a64d9a"
  let clientSecret = "5a1bdae295e1685f8676b3a9745a1a86"
  
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
  
  
  func fetchIngredientListForUPC (upcCode : String, completionHandler : (Ingredients?, String?) -> ()) {
    
    //var upcCode = "767707001067"
    
    let requestURL = "https://api.nutritionix.com/v1_1/item?upc=\(upcCode)&appId=\(clientID)&appKey=\(clientSecret)"
    println(requestURL)
    let url = NSURL(string: requestURL)
    
    let getRequest = NSMutableURLRequest(URL: NSURL(string: requestURL)!)
    
    let dataTask = self.urlSession.dataTaskWithRequest(getRequest, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
        //println(response)
          switch httpResponse.statusCode {
          case 200...299:
            println("outside 200")
            if let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
              println(jsonDict)
              let newIngredient = Ingredients(jsonDictionary: jsonDict)
                
              

              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(newIngredient, nil)
                }) //end block

              
              
            }//end if
          case 404:
            println("404")
            
          
          case 300...599:
            
            println("This is bad - it's an error that may or may not be your fault")
            completionHandler(nil, "this is bad!")
          default:
            println("This is odd - default case fired")
          }//end Switch
        }
      }
    })
    dataTask.resume()
  }
      
}
    

  
  
  


//https://api.nutritionix.com/v1_1/item?upc=49000036756&appId=

//48bd25da&appKey=

//698a373a3b0e6ecda8f223451efbe070
