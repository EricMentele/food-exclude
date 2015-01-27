//
//  Ingredients.swift
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

class Ingredients {
  
  var brandName : String
  var itemName : String
  var brandID : String
  var itemID : String
  var itemDescription : String
  var ingredientsList : String!
  var allergenMilk : Bool
  var allergenEggs : Bool
  var allergenFish : Bool
  var allergenShellfish : Bool
  var allergenTreeNuts : Bool
  var allergenPeanuts : Bool
  var allergenWheat : Bool
  var allergenSoy : Bool
  var allergenGluten : Bool
  
  
  init(jsonDictionary : NSDictionary) {
    self.brandName = jsonDictionary["brand_name"] as String
    self.itemName = jsonDictionary["item_name"] as String
    self.brandID = jsonDictionary["brand_id"] as String
    self.itemID = jsonDictionary["item_id"] as String
    self.itemDescription = jsonDictionary["item_description"] as String
    self.ingredientsList = jsonDictionary["nf_ingredient_statement"] as String
    self.allergenMilk = jsonDictionary["allergen_contains_milk"] as Bool
    self.allergenEggs = jsonDictionary["allergen_contains_eggs"] as Bool
    self.allergenFish = jsonDictionary["allergen_contains_fish"] as Bool
    self.allergenShellfish = jsonDictionary["allergen_contains_shellfish"] as Bool
    self.allergenTreeNuts = jsonDictionary["allergen_contains_tree_nuts"] as Bool
    self.allergenPeanuts = jsonDictionary["allergen_contains_peanuts"] as Bool
    self.allergenWheat = jsonDictionary["allergen_contains_wheat"] as Bool
    self.allergenSoy = jsonDictionary["allergen_contains_soybeans"] as Bool
    self.allergenGluten = jsonDictionary["allergen_contains_gluten"] as Bool
  }

}





