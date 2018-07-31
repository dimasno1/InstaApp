//
//  SearchViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/31/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    private var scopeBar = UISegmentedControl()
    private lazy var searchController = UISearchController(searchResultsController: nil)
}
