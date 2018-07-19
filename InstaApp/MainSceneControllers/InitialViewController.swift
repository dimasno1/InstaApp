//
//  InitialViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit
import SnapKit

class InitialViewController: UIViewController {
    
    init(token: Token?) {
        self.state = State(token: token)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        networkService.delegate = self
        
        view.backgroundColor = .white
        view.addSubview(stateTextLabel)
        view.addSubview(logoImageView)
        setup()
    }
    
    func changeState(to: State) {
        self.state = to
        stateTextLabel.text = state.description
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { self.stateTextLabel.frame.size.applying(CGAffineTransform(scaleX: 3, y: 3)) },
                       completion: nil)
    }
    
    private func setup() {
        logoImageView.image = UIImage(named: "logo.png")
        logoImageView.center = view.center
        logoImageView.bounds.size = CGSize(width: 300, height: 300)
        
        stateTextLabel.text = state.description
        stateTextLabel.font = billabongFont
        stateTextLabel.sizeToFit()
        stateTextLabel.center.x = view.center.x
        stateTextLabel.center.y = logoImageView.frame.maxY + 20
        
        if #available(iOS 11.0, *) {
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.tintColor = .pink
            searchController.searchBar.placeholder = "Enter number of photos to search"
            
            navigationItem.largeTitleDisplayMode = .always
            navigationItem.searchController = searchController
            navigationItem.title = "Searching"
            navigationItem.titleView = scopeBar
        }
    }
    
    private var scopeBar: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Map", "List"])
        control.tintColor = .pink
        control.layer.cornerRadius = control.frame.height / 2
        control.layer.borderColor = UIColor.pink.cgColor
        control.layer.borderWidth = 1
        control.layer.masksToBounds = true
        control.sizeToFit()
        control.selectedSegmentIndex = 1
        control.frame.size.width = UIScreen.main.bounds.width / 2
        
        return control
    }()
    
    enum State {
        case error
        case succes(token: String)
        
        var description: String {
            switch self {
            case .error: return "Sorry, you're not authorized. Try again"
            case .succes: return "Try to search for photos"
            }
        }
        
        init(token: String?) {
            self = token.flatMap { .succes(token: $0) } ?? .error
        }
    }
    
    private var authorized: Bool {
        if case .succes = state {
            return true
        }
        
        return false
    }
    
    private var state: State
    private var token: Token {
        if case let .succes(token: token) = state {
            return token
        }
        
        return ""
    }
    
    private let logoImageView = UIImageView()
    private let stateTextLabel = UILabel()
    private let networkService = NetworkService()
    private lazy var searchController = UISearchController(searchResultsController: nil)
}

extension InitialViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if authorized {
            let searchWord = searchBar.text ?? ""
            let endpointParameters = [Endpoint.Parameter.count: searchWord]
            let endpoint = Endpoint(purpose: .users, parameters: endpointParameters)
            let endpointConstructor = EndpointConstructor(endpoint: endpoint)
            
            guard let url = endpointConstructor.makeURL(with: token, searchWord: searchWord) else { return }
            print(url)
            networkService.makeRequest(for: url)
        } else {
            changeState(to: .error)
        }
        
        searchBar.resignFirstResponder()
    }
}

extension InitialViewController: NetworkServiceDelegate {
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
        
        var controllerToPush = UIViewController()
        
        DispatchQueue.main.async { [weak self] in
            switch self?.scopeBar.selectedSegmentIndex {
            case 0: controllerToPush = MapViewController(meta: collectedMeta)
            case 1: controllerToPush = ListCollectionViewController(meta: collectedMeta)
            default: break
            }
            self?.navigationController?.pushViewController(controllerToPush, animated: true)
        }
    }
}

extension UIViewController {
    
    func addChild(_ controller: UIViewController, to container: UIView) {
        self.addChildViewController(controller)
        controller.view.frame = container.bounds
        container.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    func deleteFromParent() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
        didMove(toParentViewController: nil)
    }
}
