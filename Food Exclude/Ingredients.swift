//
//  Ingredients.swift
//  Food-Exclude
//
//  Created by David Rogers on 1/26/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//



import UIKit

class Ingredients {
  
  var brandName : String
  var itemName : String
  var brandID : String
  var itemID : String
  var itemDescription : String
  var ingredientsList : String!
  
  init(jsonDictionary : NSDictionary) {
    self.brandName = jsonDictionary["brand_name"] as String
    self.itemName = jsonDictionary["item_name"] as String
    self.brandID = jsonDictionary["brand_id"] as String
    self.itemID = jsonDictionary["item_id"] as String
    self.itemDescription = jsonDictionary["item_description"] as String
    self.ingredientsList = jsonDictionary["nf_ingredient_statement"] as String
  
  }

}
