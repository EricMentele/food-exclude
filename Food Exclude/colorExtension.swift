//
//  colorExtension.swift
//  Food Exclude
//
//  Created by Vania Kurniawati on 1/29/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

extension UIColor {
  
  convenience init(red: Int, green: Int, blue: Int)
  {
    let newRed = CGFloat(red)/255
    let newGreen = CGFloat(green)/255
    let newBlue = CGFloat(blue)/255
    
    self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
  }
}