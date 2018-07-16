//
//  BaseViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

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
        
        networkService.delegate = self
        view.addSubview(mainViewContainer)
        view.addSubview(searchBar)
    }
    
    private func addChild(_ controller: UIViewController, to container: UIView) {
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
        
        func controller(meta: [PhotoMeta] = []) -> UIViewController {
            switch self {
            case .map: return MapViewController(meta: meta)
            case .list: return ListViewController(meta: meta)
            case .initial: return InitialViewController()
            case .authorize: return AuthorizeViewController()
            }
        }
    }
    
    private var token: Token = ""
    private var mainView: MainView
    private var searchBar = UISearchBar()
    private let mainViewContainer = UIView()
    private let networkService = NetworkService()
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if authorized {
            changeMainView(to: searchBar.selectedScopeButtonIndex == 0 ? .map : .list)
            
            let searchWord = searchBar.text ?? ""
            let endpointParameters = [
                Endpoint.Parameter.max_tag_id: "123124",
                Endpoint.Parameter.min_tag_id: "123123",
                Endpoint.Parameter.count: "20"
            ]
            
            let endpoint = Endpoint(purpose: .tags, parameters: endpointParameters)
            let endpointConstructor = EndpointConstructor(endpoint: endpoint)
            
            guard let url = endpointConstructor.makeURL(with: token, searchWord: searchWord) else { return }
            print(url)
            networkService.makeRequest(for: url)
        } else {
            guard let controller = self.childViewControllers.first as? InitialViewController else { return }
            controller.changeState(to: .error)
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        changeMainView(to: selectedScope == 0 ? .map : .list)
    }
}

extension MainViewController: AuthorizeViewControllerDelegate {
    
    func didReceive(_ authorizeViewController: AuthorizeViewController, token: Token) {
        authorized = true
        self.token = token
        changeMainView(to: .initial)
    }
}

extension MainViewController: NetworkServiceDelegate {
    
    func didReceive(_ networkService: NetworkService, data: Data?, with error: Error?) {

    }
}
