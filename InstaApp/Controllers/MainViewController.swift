//
//  BaseViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

protocol CanBeChildViewController where Self: UIViewController {
    func deleteFromParent()
}

class MainViewController: UIViewController {
    var authorized: Bool
    
    init(with view: MainView) {
        authorized = false
        mainView = view
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        if let controller = mainView.controller() as? AuthorizeViewController {
            controller.delegate = self
            addChild(controller, to: mainViewContainer)
        }
        
        view.addSubview(mainViewContainer)
        view.addSubview(searchBar)
    }
    
    private func addChild(_ controller: CanBeChildViewController, to container: UIView) {
        guard let controller = controller as? UIViewController else { return }
        self.addChildViewController(controller)
        controller.view.frame = container.bounds
        container.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    private func changeMainView(to: MainView) {
        childViewControllers.last?.deleteFromParent()
        mainView = to
        addChild(mainView.controller(), to: mainViewContainer)
    }
    
    private func setup() {
        searchBar.showsScopeBar = true
        searchBar.showsCancelButton = true
        searchBar.scopeButtonTitles = ["Map", "List"]
        searchBar.delegate = self
        searchBar.barStyle = .default
        searchBar.sizeToFit()
        
        mainViewContainer.frame = CGRect(x: 0, y: searchBar.frame.size.height, width: searchBar.frame.size.width, height: view.frame.size.height - searchBar.frame.size.height)
    }
    
    enum MainView {
        case map
        case list
        case initial
        case authorize
        
        func controller(meta: [PhotoMeta] = []) -> CanBeChildViewController {
            switch self {
            case .map: return MapViewController(meta: meta)
            case .list: return ListViewController(meta: meta)
            case .initial: return InitialViewController()
            case .authorize: return AuthorizeViewController()
            }
        }
    }
    
    private var mainView: MainView
    private var searchBar = UISearchBar()
    private let mainViewContainer = UIView()
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        changeMainView(to: searchBar.selectedScopeButtonIndex == 0 ? .map : .list)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        changeMainView(to: selectedScope == 0 ? .map : .list)
    }
}

extension MainViewController: AuthorizeViewControllerDelegate {
    
    func didReceive(_ authorizeViewController: AuthorizeViewController, token: Token) {
        authorized = true
        changeMainView(to: .initial)
    }
}

extension UIViewController {
    
    func deleteFromParent() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
        didMove(toParentViewController: nil)
    }
}
