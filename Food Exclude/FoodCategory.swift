//
//  FoodCategory.swift
//  Food Exclude
//
//  Created by Alexandra Norcross on 1/26/15.
//  Copyright (c) 2015
//David Rogers,
//Vania Kurniawati,
//Clint Akin,
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

import Foundation

struct FoodCategory {
  var name: String
  var derivatives = [String]()
  var flag = false
  
  //MARK: Initialize class
  
  //Initialize:
  init(name: String, derivatives: [String]) {
    self.name = name
    self.derivatives = derivatives
    self.flag = false
  } //end init
  
  
  
  
}