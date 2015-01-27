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
  
  var allergicToMilk: Bool = false
  var allergicToEggs: Bool = false
  var allergicToFish: Bool = false
  var allergicToShellfish: Bool = false
  var allergicToTreeNuts: Bool = false
  var allergicToPeanuts: Bool = false
  var allergicToWheat: Bool = false
  var allergicToSoybeans: Bool = false
  var allergicToGluten: Bool = false
  
  //MARK: Initialize class
  
  //Initialize:
  init(name: String, includeProfile: Bool) {
    self.name = name
    self.includeProfile = includeProfile
  } //end init
  
  //MARK: NSKeyedArchiver
  
  //Initialize: Load from archive.
  required init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObjectForKey("name") as String
    if let avatar = aDecoder.decodeObjectForKey("avatar") as? UIImage {
      self.avatar = avatar
    } //end if
    self.includeProfile = aDecoder.decodeBoolForKey("includeProfile") as Bool
    
    self.allergicToMilk = aDecoder.decodeBoolForKey("allergicToMilk") as Bool
    self.allergicToEggs = aDecoder.decodeBoolForKey("allergicToEggs") as Bool
    self.allergicToFish = aDecoder.decodeBoolForKey("allergicToFish") as Bool
    self.allergicToShellfish = aDecoder.decodeBoolForKey("allergicToShellfish") as Bool
    self.allergicToTreeNuts = aDecoder.decodeBoolForKey("allergicToTreeNuts") as Bool
    self.allergicToPeanuts = aDecoder.decodeBoolForKey("allergicToPeanuts") as Bool
    self.allergicToWheat = aDecoder.decodeBoolForKey("allergicToWheat") as Bool
    self.allergicToSoybeans = aDecoder.decodeBoolForKey("allergicToSoybeans") as Bool
    self.allergicToGluten = aDecoder.decodeBoolForKey("allergicToGluten") as Bool
  } //end init
  
  //Function: Save to archive.
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.name, forKey: "name")
    aCoder.encodeObject(self.avatar, forKey: "avatar")
    aCoder.encodeBool(self.includeProfile, forKey: "includeProfile")

    aCoder.encodeBool(self.allergicToMilk, forKey: "allergicToMilk")
    aCoder.encodeBool(self.allergicToEggs, forKey: "allergicToEggs")
    aCoder.encodeBool(self.allergicToFish, forKey: "allergicToFish")
    aCoder.encodeBool(self.allergicToShellfish, forKey: "allergicToShellfish")
    aCoder.encodeBool(self.allergicToTreeNuts, forKey: "allergicToTreeNuts")
    aCoder.encodeBool(self.allergicToPeanuts, forKey: "allergicToPeanuts")
    aCoder.encodeBool(self.allergicToWheat, forKey: "allergicToWheat")
    aCoder.encodeBool(self.allergicToSoybeans, forKey: "allergicToSoybeans")
    aCoder.encodeBool(self.allergicToGluten, forKey: "allergicToGluten")
  } //end func
}