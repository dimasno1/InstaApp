//
//  InitialViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    var isAuthorized: Bool = false
    var state: State
    
    init(state: State = .succes) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        view.backgroundColor = .white
        view.addSubview(stateTextLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
  
    private func changeState(to: State) {
        self.state = to
    }
    
    private func setup() {
        stateTextLabel.text = state.description
        stateTextLabel.sizeToFit()
        stateTextLabel.center = view.center
    }
   
    enum State {
        case error
        case succes
        
        var description: String {
            switch self {
            case .error: return "Error authorizing"
            case .succes: return "Try to search for photos"
            }
        }
    }
    
    private let stateTextLabel = UILabel()
}
