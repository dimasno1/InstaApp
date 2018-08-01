//
//  InitialViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit
import SnapKit

protocol StartScreenViewControllerDelegate: AnyObject {
    func startScreenViewController(_ controller: StartScreenViewController, wantsToRepeatAuthorization: Bool)
}

class StartScreenViewController: UIViewController {

    weak var delegate: StartScreenViewControllerDelegate?

    init(state: State, delegate: StartScreenViewControllerDelegate? = nil) {
        self.state = state
        self.delegate = delegate
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
        view.addSubview(repeatButton)

        setup()
        makeConstraints()
    }

    func changeLabelText(to: String) {
        stateTextLabel.text = to
    }

    private func setup() {
        logoImageView.image = R.image.logo()

        stateTextLabel.text = state.description
        stateTextLabel.font = UIFont.billabong

        if state == .authorized {
            repeatButton.isHidden = true
        }
    }

    private func makeConstraints() {
        let width = view.bounds.size.width / 3
        let offset = 20

        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(logoImageView.snp.width)
        }

        stateTextLabel.sizeToFit()
        stateTextLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }

        repeatButton.sizeToFit()
        repeatButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-offset)
        }
    }

    @objc private func buttonTapped(_ button: UIButton) {
        delegate?.startScreenViewController(self, wantsToRepeatAuthorization: true)
    }

    enum State {
        case unauthorized
        case authorized

        var description: String {
            switch self {
            case .unauthorized: return "Sorry, you're not authorized"
            case .authorized: return "Now you're ready to search for photos"
            }
        }
    }

    private var repeatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Repeat".uppercased(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.addTarget(nil, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        return button
    }()

    private var state: State
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

    func removeFromParent() {
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
