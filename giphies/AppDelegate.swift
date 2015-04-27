//
//  AppDelegate.swift
//  giphies
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // start network monitoring
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // pause downloader if app goes background
        GPDownloader.shared.pause()
        
        // stop network monitoring
        AFNetworkReachabilityManager.sharedManager().stopMonitoring()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // resume downloader if app get back to foreground
        GPDownloader.shared.resume()
        
        // start network monitoring
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
    }

    func applicationWillTerminate(application: UIApplication) {
        // terminate downloader if app going to be terminated
        GPDownloader.shared.invalidate()
        
        // stop network monitoring
        AFNetworkReachabilityManager.sharedManager().stopMonitoring()
    }
}

