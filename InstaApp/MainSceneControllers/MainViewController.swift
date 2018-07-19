//
//  BaseViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

let billabongFont = UIFont(name: "Billabong", size: 20)

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authorizeController = AuthorizeViewController()
        authorizeController.delegate = self
        
        mainViewContainer.frame = view.bounds
        addChild(authorizeController, to: mainViewContainer)
      
        view.addSubview(mainViewContainer)
    }
    
    private let mainViewContainer = UIView()
}

extension MainViewController: AuthorizeViewControllerDelegate {
    func didReceive(_ authorizeViewController: AuthorizeViewController, token: Token?) {
        let navBarController = UINavigationController(rootViewController: InitialViewController(token: token))
    
        if #available(iOS 11.0, *) {
            navBarController.navigationBar.prefersLargeTitles = true
        }
        
        navBarController.navigationBar.tintColor = .pink
        
        childViewControllers.last?.deleteFromParent()
        addChild(navBarController, to: mainViewContainer)
    }
}

extension UIColor {
    static var pink: UIColor {
        return UIColor(red: 223/225, green: 51/225, blue: 145/225, alpha: 1)
    }
    
    static var transparentWhite: UIColor {
        return self.white.withAlphaComponent(0.3)
    }
}
