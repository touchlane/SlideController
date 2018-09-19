//
//  AppDelegate.swift
//  ScrollController
//
//  Created by pknd on 08/16/2017.
//  Copyright (c) 2017 Touchlane LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let rootVC = RootUINavigationController()
    var router: RootRouter?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        router = RootRouter(presenter: rootVC)
        window?.rootViewController = rootVC
        router?.openMainScreen(animated: true)
        window?.makeKeyAndVisible()
        return true
    }

}
