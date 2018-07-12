//
//  BaseViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

protocol BaseViewControllerChild where Self: UIViewController {
    var isChildOfBaseViewController: Bool { get }
    func deleteFromParent()
}

class BaseViewController: UIViewController {
    
    init(with view: MainView) {
        controllerCurrentlyOnScreen = view.controller()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewContainer.frame = view.bounds
        addChild(controllerCurrentlyOnScreen, to: mainViewContainer)
        
        view.addSubview(mainViewContainer)
    }
    
    private func addChild(_ controller: UIViewController, to container: UIView) {
        self.addChildViewController(controller)
        controller.view.frame = container.frame
        container.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }

    enum MainView {
        case map
        case list
        case initial
        
        func controller(meta: [PhotoMeta] = []) -> UIViewController {
            switch self {
            case .map: return MapViewController(meta: meta)
            case .list: return ListViewController(meta: meta)
            case .initial: return InitialViewController()
            }
        }
    }
    
    private var controllerCurrentlyOnScreen: UIViewController
    private var searchBar = UISearchBar()
    private let mainViewContainer = UIView()
}

extension BaseViewControllerChild {
    var isChildOfBaseViewController: Bool {
        return true
    }
    
    func deleteFromParent() {
        self.willMove(toParentViewController: nil)
        view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}
