//
//  UserProfilesHeader.swift
//  Food Exclude
//
//  Created by Alexandra Norcross on 1/29/15.
//  Copyright (c) 2015
//David Rogers,
//Vania Kurniawati,
//Clint Akin,
//Alexandra Norcross,
//Eric Mentele. All rights reserved.

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

class UserProfilesHeader: UIView {
  //Outlets:
  @IBOutlet weak var labelIncludeProfile: UILabel!
  
  //Function: Set up.
  override func awakeFromNib() {
    labelIncludeProfile.font = UIFont(name: "Avenir-Black", size: 20.0)
  } //end func
}
