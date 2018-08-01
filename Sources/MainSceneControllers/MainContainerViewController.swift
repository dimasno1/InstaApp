//
//  MainContainerViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/31/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    init(with state: State) {
        self.state = state

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.state = .unauthorized
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(containerView)
        containerView.frame = view.bounds

        changeState(to: state)
    }

    private func changeState(to: State) {
        state = to
    }

    enum State {
        case authorized(Token)
        case unauthorized
        case needsAuthorization
    }

    private var state: State {
        didSet {
            visibleViewController.removeFromParent()

            switch state {
            case let .authorized(token): visibleViewController = UINavigationController(rootViewController: SearchViewController(token: token))
            case .needsAuthorization: visibleViewController = AuthorizeViewController(delegate: self)
            case .unauthorized: visibleViewController = StartScreenViewController(state: .unauthorized, delegate: self)
            }

            addChild(visibleViewController, to: containerView)
        }
    }

    private var containerView = UIView()
    private lazy var visibleViewController = UIViewController()
}

extension MainContainerViewController: AuthorizeViewControllerDelegate {
    func didReceive(_ authorizeViewController: AuthorizeViewController, result: AuthorizeViewController.AuthorizationResult) {
        switch result {
        case let .success(token): changeState(to: .authorized(token))
        case .failed: changeState(to: .unauthorized)
        }
    }
}

extension MainContainerViewController: StartScreenViewControllerDelegate {
    func startScreenViewController(_ controller: StartScreenViewController, wantsToRepeatAuthorization: Bool) {
        changeState(to: .needsAuthorization)
    }
}
