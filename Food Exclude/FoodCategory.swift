//
//  FoodCategory.swift
//  Food Exclude
//
//  Created by Alexandra Norcross on 1/26/15.
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

import Foundation

class FoodCategory: NSObject, NSCoding {
  var name: String
  var derivatives = [String]()
  
  //MARK: Initialize class
  
  //Initialize:
  init(name: String, derivatives: [String]) {
    self.name = name
    self.derivatives = derivatives
  } //end init
  
  //MARK: NSKeyedArchiver
  
  //Initialize: Load from archive.
  required init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObjectForKey("name") as String
    if let derivatives = aDecoder.decodeObjectForKey("derivatives") as? [String] {
      self.derivatives = derivatives
    } //end if
  } //end init

  //Function: Save to archive.
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.name, forKey: "name")
    aCoder.encodeObject(self.derivatives, forKey: "derivatives")
  } //end func
}