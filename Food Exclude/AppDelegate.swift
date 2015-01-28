//
//  AppDelegate.swift
//  Food Exclude
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
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    //Fonts:
    UILabel.appearance().font = UIFont(name: "Avenir", size: 17.0)
    
    //Load data from archive; and direct user accordingly.
    if let userProfilesFromArchive = loadUserProfilesFromArchive() as [UserProfile]? {
      if !userProfilesFromArchive.isEmpty { //users exist: direct to scanner
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rootViewController = storyboard.instantiateViewControllerWithIdentifier("VC_USER_PROFILES") as UserProfilesViewController
        //let rootViewController = storyboard.instantiateViewControllerWithIdentifier("VC_SCANNER") as ScannerViewController
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
      } else { //no users: direct to default profile
        gotoUserProfileViewController()
      } //end if
    } else { //no users: direct to default profile
      gotoUserProfileViewController()
    } //end if
    
    return true
  } //end func
  
  //Function: Go to default user profile view controller.
  func gotoUserProfileViewController() {
    //View controller:
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let rootViewController = storyboard.instantiateViewControllerWithIdentifier("VC_USER_PROFILE") as UserProfileViewController
    rootViewController.selectedUserProfileIndex = -1
    //Navigation controller:
    let navigationController = UINavigationController(rootViewController: rootViewController)
    window?.rootViewController = navigationController
  } //end func
  
  //Function: Load user profile data from archive.
  func loadUserProfilesFromArchive() -> [UserProfile]? {
    //Documents/Archive path:
    let pathDocuments = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let pathArchive = pathDocuments + "/UserProfilesArchive"
    
    //Load data, if any, from archive.
    if let userProfiles = NSKeyedUnarchiver.unarchiveObjectWithFile(pathArchive) as? [UserProfile] {
      return userProfiles
    } else {
      return nil
    } //end if
  } //end func
  
  //Function: Save user profile data to archive.
  func saveUserProfilesToArchive(userProfiles: [UserProfile]) {
    //Documents/Archive path:
    let pathDocuments = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let pathArchive = pathDocuments + "/UserProfilesArchive"
    
    //Save data.
    NSKeyedArchiver.archiveRootObject(userProfiles, toFile: pathArchive)
  } //end func
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}