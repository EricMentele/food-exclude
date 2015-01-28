//
//  Allergen.swift
//  Food Exclude
//
//  Created by Alexandra Norcross on 1/27/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import Foundation

class Allergen: NSObject, NSCoding {
  var name: String
  var sensitive: Bool

  //MARK: Initialize class
  
  //Initialize:
  init(name: String, sensitive: Bool) {
    self.name = name
    self.sensitive = sensitive
  } //end init

  //MARK: NSKeyedArchiver
  
  //Initialize: Load from archive.
  required init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObjectForKey("name") as String
    self.sensitive = aDecoder.decodeBoolForKey("sensitive") as Bool
  } //end init
  
  //Function: Save to archive.
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(name, forKey: "name")
    aCoder.encodeBool(sensitive, forKey: "sensitive")
  } //end func
}