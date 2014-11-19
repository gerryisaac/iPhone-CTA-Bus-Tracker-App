//
//  AppDelegate.swift
//  Bus Tracker
//
//  Created by Gerard Isaac on 10/21/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

import UIKit

//Create Global Variables
struct screenDimensions {
    static var screenHeight = UIScreen.mainScreen().bounds.size.height
    static var screenWidth = UIScreen.mainScreen().bounds.size.width
}

struct yourCTAkey {
    static var keyValue:NSString = "XXXXXXXXXXXXXXXXXXXXXXXX" //Enter CTA Developer Key Here
}

/*
// Set
screenDimensions.screenHeight = value
screenDimensions.screenWidth = value

// Get
let myHeight = screenDimensions.screenHeight
let myWidth = screenDimensions.screenWidth
ley myKey = yourCTAkey.keyValue
println("My Height:\(myHeight) My Width:\(myWidth) and API Key is:\(myKey)")
*/

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainNavigationController:UINavigationController?
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        // Style the Status Bar
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //Set the Default/Navigation View Controller
        mainNavigationController = UINavigationController(rootViewController: mainViewController())
        
        if let window = window {
            window.backgroundColor = UIColor.blackColor()
            window.makeKeyAndVisible()
            window.rootViewController = mainNavigationController
        }
        
        //Navigation Bar Font and Color of Navigation
        if let font = UIFont(name: "Gotham-Bold", size: 16.0) {
            mainNavigationController?.navigationBar.titleTextAttributes = [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ]
        }
        
        //Customize Appearance of Navigation Bar
        var navigationBarAppearance = UINavigationBar.appearance()
        //Navigation Bar Color
        navigationBarAppearance.barTintColor = uicolorFromHex(0x1077c6)
        
        return true
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
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

}

