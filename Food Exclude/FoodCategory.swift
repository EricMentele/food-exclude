//
//  FoodCategory.swift
//  Food Exclude
//
//  Created by Alexandra Norcross on 1/26/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import Foundation

class FoodCategory: NSObject, NSCoding {
  var name: String
  var derivatives: [String]?
  
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
  
  //Function: Determine if ingredient is a derivative of the food category.
  func isDerivative(ingredient: String) -> Bool {
    let ingredientLC = ingredient.lowercaseString
    for derivative in self.derivatives {
      if derivative.lowercaseString == ingredientLC {
        return true
      } //end if
    } //end for
    return false
  } //end func
}