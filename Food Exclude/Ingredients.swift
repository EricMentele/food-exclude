//
//  Ingredients.swift
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
* THE SOFTWARE IS PROVIDED " AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/



import UIKit

class Ingredients {
  
  var brandName : String?
  var itemName : String?
  var brandID : String?
  var itemID : String?
  var itemDescription : String?
  var ingredientsList : String?
  var allergenMilk : String?
  var allergenEggs : String?
  var allergenFish : String?
  var allergenShellfish : String?
  var allergenTreeNuts : String?
  var allergenPeanuts : String?
  var allergenWheat : String?
  var allergenSoy : String?
  var allergenGluten : String?
  var allergenList = [String?]()
  var seperatedList = [String]()
  
  
  init(jsonDictionary : NSDictionary) {
    self.brandName = jsonDictionary["brand_name"] as? String
    self.itemName = jsonDictionary["item_name"] as? String
    self.brandID = jsonDictionary["brand_id"] as? String
    self.itemID = jsonDictionary["item_id"] as? String
    self.itemDescription = jsonDictionary["item_description"] as? String
    self.ingredientsList = jsonDictionary["nf_ingredient_statement"]  as? String
    self.allergenMilk = jsonDictionary["allergen_contains_milk"]  as? String
   
    
    if let newString = self.ingredientsList?.lowercaseString {
      var clearedString = newString.stringByReplacingOccurrencesOfString("(([\\,\\(\\)\\[\\]\\/\\\n\\@]))", withString: "", options: .RegularExpressionSearch)
      var freeString = clearedString.stringByReplacingOccurrencesOfString("(\\w+\\sfree)", withString: "", options: .RegularExpressionSearch)
      var factoryFreeString = freeString.stringByReplacingOccurrencesOfString("(allergen information:.+)", withString: "", options: .RegularExpressionSearch)
      self.seperatedList = factoryFreeString.componentsSeparatedByString(",")
      println("THIS IS THE CLEARED STRING \(factoryFreeString)")
      println(seperatedList)
    }//new string

    
    if self.allergenMilk !=  nil {
      self.allergenList.append("Milk")
    }
    self.allergenEggs = jsonDictionary["allergen_contains_eggs"]  as? String
    if self.allergenEggs !=  nil {
      self.allergenList.append("Eggs")
    }
    self.allergenFish = jsonDictionary["allergen_contains_fish"]  as? String
    if self.allergenFish !=  nil {
      self.allergenList.append("Fish")
    }
    self.allergenShellfish = jsonDictionary["allergen_contains_shellfish"]  as? String
    if self.allergenShellfish !=  nil {
      self.allergenList.append("Shellfish")
    }
    self.allergenTreeNuts = jsonDictionary["allergen_contains_tree_nuts"]  as? String
    if self.allergenTreeNuts !=  nil {
      self.allergenList.append("Tree Nuts")
    }
    self.allergenPeanuts = jsonDictionary["allergen_contains_peanuts"]  as? String
    self.allergenWheat = jsonDictionary["allergen_contains_wheat"]  as?  String
    self.allergenSoy = jsonDictionary["allergen_contains_soybeans"]  as?  String
    self.allergenGluten = jsonDictionary["allergen_contains_gluten"]  as?  String
    if self.allergenGluten !=  nil {
      self.allergenList.append("Gluten")
    }
  }
  

}





