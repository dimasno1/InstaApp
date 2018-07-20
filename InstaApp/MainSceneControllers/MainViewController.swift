//
//  BaseViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    init(purpose: Purpose, token: Token? = nil) {
        self.purpose = purpose
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if purpose == .initial {
            setupNavigationBar()
        }
        
        let controller = purpose.controller(token: token)
        
        if let controller = controller as? AuthorizeViewController {
            controller.delegate = self
        }
        
        mainViewContainer.frame = view.bounds
        addChild(controller, to: mainViewContainer)
        
        view.addSubview(mainViewContainer)
    }
    
    private func setupNavigationBar() {
        definesPresentationContext = true
        
        scopeBar = UISegmentedControl(items: ["Map", "List"])
        scopeBar?.addObserver(self, forKeyPath: "selectedSegmentIndex", options: [.new, .old, .initial], context: nil)
        
        networkService = NetworkService()
        
        guard let scopeBar = scopeBar, let networkService = networkService else {
            return
        }
        
        networkService.delegate = self
        
        scopeBar.tintColor = .pink
        scopeBar.layer.cornerRadius = scopeBar.frame.height / 2
        scopeBar.layer.borderColor = UIColor.pink.cgColor
        scopeBar.layer.borderWidth = 1
        scopeBar.layer.masksToBounds = true
        scopeBar.sizeToFit()
        scopeBar.selectedSegmentIndex = 1
        scopeBar.frame.size.width = UIScreen.main.bounds.width / 2
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .pink
        navigationItem.title = "Search"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.titleView = scopeBar
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "selectedSegmentIndex", let change = change, let old = change[.oldKey] as? Int, let newValue = change[.newKey] as? Int, old != newValue, old != -1 {
            buffer = searchController.searchBar.text ?? ""
            
            searchController.dismiss(animated: true, completion: nil)
            let searchResultsController = newValue == 0 ? MapViewController(meta: []) : ListCollectionViewController(meta: [])

            setupSearcController(with: searchResultsController)
        }
    }
    
    func setupSearcController(with resultController: UIViewController) {
        searchController = UISearchController(searchResultsController: resultController)
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .pink
        searchController.searchBar.text = buffer
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        present(searchController, animated: true, completion: nil)
    }
    
    enum Purpose {
        case authorization
        case initial
        case test
        
        func controller(token: Token?) -> UIViewController {
            switch self {
            case .authorization: return AuthorizeViewController()
            case .initial: return InitialViewController(token: token)
            case .test: return UINavigationController(rootViewController: MainViewController(purpose: .initial, token: "TEST TOKEN"))
            }
        }
    }
    
    var authorized: Bool {
        return token != nil
    }
    
    private var buffer: String = ""
    private (set) var token: Token?
    private let purpose: Purpose
    private let mainViewContainer = UIView()
    private var networkService: NetworkService?
    private var scopeBar: UISegmentedControl?
    private var searchController = UISearchController(searchResultsController: nil)
}

extension MainViewController: AuthorizeViewControllerDelegate {
    func didReceive(_ authorizeViewController: AuthorizeViewController, token: Token?) {
        let controller = UINavigationController(rootViewController: MainViewController(purpose: .initial, token: token))
        
        childViewControllers.last?.deleteFromParent()
        addChild(controller, to: mainViewContainer)
    }
}


extension MainViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if authorized {
            let searchWord = searchBar.text ?? ""
            let endpointParameters = [Endpoint.Parameter.count: searchWord]
            let endpoint = Endpoint(purpose: .users, parameters: endpointParameters)
            let endpointConstructor = EndpointConstructor(endpoint: endpoint)
            
            guard let token = token, let url = endpointConstructor.makeURL(with: token, searchWord: searchWord), let networkService = networkService else { return }
            networkService.makeRequest(for: url)
        }
        
        searchBar.resignFirstResponder()
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
        
        var collectedMeta = [InstaMeta]()
        
        instaData.forEach { meta in
            switch meta {
            case .photoMeta(let photoMeta): collectedMeta.append(photoMeta)
            case .videoMeta(let videoMeta): print(videoMeta.type)
            }
        }
        
        let geoTagMeta = collectedMeta.compactMap { $0.location == nil ? nil : $0 }
        
        var controllerToPush = UIViewController()
        
        DispatchQueue.main.async { [weak self] in
            switch self?.scopeBar?.selectedSegmentIndex {
            case 0: controllerToPush = MapViewController(meta: geoTagMeta)
            case 1: controllerToPush = ListCollectionViewController(meta: collectedMeta)
            default: break
            }
            self?.navigationController?.pushViewController(controllerToPush, animated: true)
        }
    }
}
