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
        
        window?.rootViewController = MainViewController(with: .authorize)
        window?.makeKeyAndVisible()
        
        let parameters: [Endpoint.Parameter: String] = [
            .max_tag_id : "123",
            .min_tag_id: "1321",
            .count: "20",
        ]
        
        let endpoint = Endpoint(purpose: .comments, parameters: parameters)
        
        let constructor = EndpointConstructor(endpoint: endpoint)
        
       let url = constructor.makeURL(with: Token("123"), searchWord: "sobaka")
        
        print(url)
        
        return true
    }
    
}

