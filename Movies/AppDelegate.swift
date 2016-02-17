//
//  AppDelegate.swift
//  Movies
//
//  Created by EastAgile16 on 10/26/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var storyboard = UIStoryboard(name: "Main", bundle: nil)
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    if configCredential() {
      configParse(launchOptions)
      configAppearance()
    } else {
      return false
    }
    
    return true
  }
  
  func configCredential() -> Bool {
    // Get credential from Config.plist file
    guard let config = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!) else {
      print("Please set up API key in Config.plist")
      return false
    }
    Credentials.sharedInstance.config = config as! [String : String]
    
    if Helper.isTestMode() {
      MovieClient.baseImageUrl = "http://image.tmdb.org/t/p/"
    } else {
      // Get base image url
      MovieClient.getBaseImageUrl { (baseUrl, error) -> () in
        if let baseUrl = baseUrl {
          MovieClient.baseImageUrl = baseUrl
        }
      }
    }
    
    return true
  }
  
  func configParse(launchOptions: [NSObject: AnyObject]?) {
    // Initialize Parse.
    Parse.setApplicationId(Credentials.sharedInstance.parseApplicationId,
      clientKey: Credentials.sharedInstance.parseClientKey)
    
    // [Optional] Track statistics around application opens.
    PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
  }
  
  func configAppearance() {
    // Set color for the navigation
    UINavigationBar.appearance().barTintColor = Color.navigationBarColor
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    
    // Set color for the status bar
    UIApplication.sharedApplication().statusBarStyle = .LightContent
    
    // Set color for the tab bar
    UITabBar.appearance().backgroundImage = UIImage()
    UITabBar.appearance().backgroundColor = Color.navigationBarColor
    UITabBar.appearance().tintColor = UIColor.whiteColor()
  }
  
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
