//
//  AppDelegate.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let utilities = UtilityServices()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! RootViewController
        controller.services = AppServices()
        
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        return true
    }

}

