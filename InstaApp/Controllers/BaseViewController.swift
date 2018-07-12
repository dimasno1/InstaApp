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
        addChild(view.controller(), to: mainViewContainer)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        func controller() -> UIViewController {
            switch self {
            case .map: return MapViewController()
            case .list: return ListViewController()
            case .initial: return InitialViewController()
            }
        }
    }
    
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
