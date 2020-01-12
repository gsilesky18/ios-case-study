//
//  AppDelegate.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let listCoordinator = ListCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: listCoordinator.viewController)
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        //Update product list when the app is reopened
        listCoordinator.updateState()
    }

}

