//
//  UserProfile.swift
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

import UIKit

class UserProfile: NSObject, NSCoding {
  var name: String
  var avatar: UIImage?
  var includeProfile: Bool
  var allergens = [Allergen]()
  
  //MARK: Initialize class
  
  //Initialize:
  override init() {
    self.name = ""
    self.includeProfile = true
    
    self.allergens.append(Allergen(name: "Milk", sensitive: false))
    self.allergens.append(Allergen(name: "Eggs", sensitive: false))
    self.allergens.append(Allergen(name: "Fish", sensitive: false))
    self.allergens.append(Allergen(name: "Shellfish", sensitive: false))
    self.allergens.append(Allergen(name: "Tree Nuts", sensitive: false))
    self.allergens.append(Allergen(name: "Peanuts", sensitive: false))
    self.allergens.append(Allergen(name: "Wheat", sensitive: false))
    self.allergens.append(Allergen(name: "Soybeans", sensitive: false))
    self.allergens.append(Allergen(name: "Gluten", sensitive: false))
  } //end init
  
  //MARK: NSKeyedArchiver
  
  //Initialize: Load from archive.
  required init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObjectForKey("name") as String
    if let avatar = aDecoder.decodeObjectForKey("avatar") as? UIImage {
      self.avatar = avatar
    } //end if
    self.includeProfile = aDecoder.decodeBoolForKey("includeProfile") as Bool
    self.allergens = aDecoder.decodeObjectForKey("allergens") as [Allergen]
  } //end init
  
  //Function: Save to archive.
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.name, forKey: "name")
    aCoder.encodeObject(self.avatar, forKey: "avatar")
    aCoder.encodeBool(self.includeProfile, forKey: "includeProfile")
    aCoder.encodeObject(self.allergens, forKey: "allergens")
  } //end func
}