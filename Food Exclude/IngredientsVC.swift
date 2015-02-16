//
//  IngredientsVC.swift
//  Food Exclude
//
//  Created by David Rogers on 2/15/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

var SVC = ScannerViewController?()
var list = SVC?.originIngredientsList



class IngredientsVC: UIViewController {
  
  
  @IBOutlet weak var textView: UITextView!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if list == nil {
      
      self
      self.textView.text = "Ingredients for this item are not yet available, but may become available soon. Please try another item."
      
    } else {
      
       self.textView.text = "\(list) : Powered by Nutritionix API"
      
    }
    
   
    
    
    
  }
  
  
}
