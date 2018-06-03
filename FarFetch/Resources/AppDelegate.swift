//
//  AppDelegate.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setRealmDBConfig()
        startRealmDBInstance()
        
        return true
    }
    
    // MARK: - Help
    func setRealmDBConfig() {
        DbHelper.shared.setRealmConfig()
    }
    
    func startRealmDBInstance() {
        DbHelper.shared.startRealmDBInstance()
    }


}

