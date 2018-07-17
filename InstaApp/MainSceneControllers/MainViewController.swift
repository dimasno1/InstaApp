//
//  BaseViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private (set) var authorized: Bool
    
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
        
        let controller = mainView.controller()
        addChild(controller, to: mainViewContainer)
        
        if let controller = controller as? AuthorizeViewController {
            controller.delegate = self   
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeFrame(with:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeFrame(with:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        networkService.delegate = self
        view.addSubview(mainViewContainer)
        view.addSubview(searchBar)
    }
    
    @objc private func changeFrame(with notification: NSNotification) {
        guard let userInfo = notification.userInfo, let keyboardBounds = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
            return
        }
        let height = keyboardBounds.height

        if notification.name == .UIKeyboardWillShow {
            mainViewContainer.frame.origin.y = searchBar.frame.size.height
            mainViewContainer.frame.origin.y -= height
        } else {
            mainViewContainer.frame.origin.y += height
        }
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
        
        func controller(meta: [InstaMeta] = []) -> UIViewController {
            switch self {
            case .map: return MapViewController(meta: meta)
            case .list: return ListCollectionViewController(meta: meta)
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if authorized {
            changeMainView(to: searchBar.selectedScopeButtonIndex == 0 ? .map : .list)
            
            let searchWord = searchBar.text ?? ""
            let endpointParameters = [
                Endpoint.Parameter.count: "20"
            ]
            
            let endpoint = Endpoint(purpose: .users, parameters: endpointParameters)
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
        guard let data = data else {
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let instaResponce = try? decoder.decode(InstaResponce.self, from: data), let instaData = instaResponce.data else {
            return
        }
        
        instaData.forEach { meta in
            switch meta {
            case .photoMeta(let photoMeta): print(photoMeta.caption)
            case .videoMeta(let videoMeta): print(videoMeta.type, videoMeta.caption, videoMeta.videos)
            }
        } 
    }
}
