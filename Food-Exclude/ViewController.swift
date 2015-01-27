//
//  ViewController.swift
//  Food-Exclude
//
//  Created by Clint Akins, David Rogers on 1/26/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//

import UIKit

class ViewController: UIView {
  
  @IBOutlet weak var brandName: UILabel!
  @IBOutlet weak var foodName: UILabel!
  @IBOutlet weak var foodDescription: UILabel!
  
  @IBOutlet weak var foodIngredients: UILabel!
  
  
  var networkController = NetworkController()
  var ingredients : [Ingredients]!
  var list : Ingredients!
  var upcCode = "767707001067"

  override func awakeFromNib() {
    super.awakeFromNib()
    
    //set rootView frame with mainscreen bounds property
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    //background color
    rootView.backgroundColor = UIColor.blackColor()
    //
    rootView.setTranslatesAutoresizingMaskIntoConstraints(false)
    rootView.backgroundColor = UIColor.grayColor()
    

    
    
    self.brandName.hidden = true
    self.foodName.hidden = true
    self.foodDescription.hidden = true
    self.foodIngredients.hidden = true
    
    self.networkController.fetchIngredientListForUPC(upcCode, completionHandler: { (ingredients, errorDescription) -> () in
      
      self.list = ingredients
      self.foodIngredients.text = "Ingredients: \(self.list.ingredientsList)"
      self.brandName.hidden = false
      self.foodName.hidden = false
      self.foodDescription.hidden = false
      self.foodIngredients.hidden = false
    })

//    var foodList : String = self.list.ingredientsList.description
//    self.ingredientList!.text = "\(foodList)"
    
  
    

    
  }


}

