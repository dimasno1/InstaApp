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
        
        view.backgroundColor = .white
        view.addSubview(stateTextLabel)
        view.addSubview(logoImageView)
        setup()
    }
    
    func changeState(to: State) {
        self.state = to
        stateTextLabel.text = state.description
    }
    
    private func setup() {
        let width = view.bounds.size.width / 3
        
        logoImageView.image = UIImage(named: "logo.png")
        logoImageView.center = view.center
        logoImageView.bounds.size = CGSize(width: width, height: width)
        
        stateTextLabel.text = state.description
        stateTextLabel.font = UIFont.billabong
        stateTextLabel.sizeToFit()
        stateTextLabel.center.x = view.center.x
        stateTextLabel.center.y = logoImageView.frame.maxY + 20
    }
    
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

extension UIFont {
    static var billabong: UIFont {
        return self.init(name: "Billabong", size: 20) ?? self.boldSystemFont(ofSize: 20)
    }
}

extension UIColor {
    static var pink: UIColor {
        return UIColor(red: 223/225, green: 51/225, blue: 145/225, alpha: 1)
    }
}
