//
//  AppDelegate.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = MainContainerViewController(with: .needsAuthorization)
        window?.makeKeyAndVisible()

        return true
    }

}
