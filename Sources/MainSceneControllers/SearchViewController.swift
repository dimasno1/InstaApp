//
//  SearchViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/31/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    init(token: Token) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(startControllerContainerView)
        addChild(startScreenViewController, to: startControllerContainerView)

        setup()
    }

    private func setup() {
        definesPresentationContext = true

        startControllerContainerView.frame = view.bounds

        scopeBar = UISegmentedControl(items: ["Map", "List"])
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

        let indexObserver = scopeBar.observe(\.selectedSegmentIndex, options: [.new, .old, .initial]) { [weak self] (_, change) in
            guard let meta = self?.metaBuffer else {
                return
            }

            self?.buffer = self?.searchController.searchBar.text ?? ""
            self?.searchController.dismiss(animated: true, completion: nil)

            let searchResultsController = change.newValue == 0 ? MapViewController(meta: meta) : ListCollectionViewController(meta: meta)

            self?.setupSearcController(with: searchResultsController)
        }

        observers = [indexObserver]
    }

    private func setupSearcController(with resultController: UIViewController) {
        searchController = UISearchController(searchResultsController: resultController)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .pink
        searchController.searchBar.text = buffer
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.searchController = searchController

        present(searchController, animated: false, completion: nil)
    }

    private var token: Token
    private var buffer: String = ""
    private var metaBuffer = [InstaMeta]()
    private var scopeBar = UISegmentedControl()
    private var observers = [NSKeyValueObservation]()
    private let startControllerContainerView = UIView()
    private let networkService = NetworkService()
    private let startScreenViewController = StartScreenViewController(state: .authorized)
    private lazy var searchController = UISearchController(searchResultsController: nil)
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text != buffer else {
            return
        }

        buffer = text
        metaBuffer.removeAll()

        networkService.makeRequest(for: text, with: token, parser: InstaDataParser()) { [weak self] (instaMeta, error) in
            guard let meta = instaMeta else {
                return
            }

            self?.metaBuffer = meta
            let updateController = self?.navigationItem.searchController?.searchResultsController as? UpdateController

            updateController?.updateResults(with: meta)
        }
    }
}
