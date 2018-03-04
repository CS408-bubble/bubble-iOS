//
//  AppDelegate.swift
//  bubble
//
//  Created by Sawyer Blatz on 1/31/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FacebookCore



@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
 var window: UIWindow?
 
 
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 // Override point for customization after application launch.
 FirebaseApp.configure()
 SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
 return true
 }
 
 
 func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
 -> Bool {
 return SDKApplicationDelegate.shared.application(app, open:url, options:options)
 }

 }
