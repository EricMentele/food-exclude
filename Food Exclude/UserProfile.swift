//
//  UserProfile.swift
//  Food Exclude
//
//  Created by Alexandra Norcross on 1/26/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class UserProfile: NSObject, NSCoding {
  var name: String
  var avatar: UIImage?
  var includeProfile: Bool
  //var allergens = [FoodCategory]()
  
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
//    if let allergens = aDecoder.decodeObjectForKey("allergens") as? [FoodCategory] {
//      self.allergens = allergens
//    } //end if
  } //end init
  
  //Function: Save to archive.
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.name, forKey: "name")
    aCoder.encodeObject(self.avatar, forKey: "avatar")
    aCoder.encodeBool(self.includeProfile, forKey: "includeProfile")
//    aCoder.encodeObject(self.allergens, forKey: "allergens")
  } //end func
}