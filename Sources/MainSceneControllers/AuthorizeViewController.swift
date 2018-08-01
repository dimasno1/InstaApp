//
//  AuthorizeViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/13/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

protocol AuthorizeViewControllerDelegate: AnyObject {
    func authorizeViewController(_ controller: AuthorizeViewController, didReceive result: AuthorizeViewController.AuthorizationResult)
}

typealias Token = String

class AuthorizeViewController: UIViewController {
    
    weak var delegate: AuthorizeViewControllerDelegate?
    
    init(delegate: AuthorizeViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.navigationDelegate = self
        makeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authorize()
    }
    
    private func makeConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func authorize() {
        let authorizeParameters = [
            Endpoint.Parameter.client_id: AuthorizeConstant.ID,
            Endpoint.Parameter.redirect_uri: AuthorizeConstant.redirectURL,
            Endpoint.Parameter.response_type: AuthorizeConstant.responceType,
            Endpoint.Parameter.scope: AuthorizeConstant.fullScope
        ]
        
        let authorizeEndpoint = Endpoint(purpose: .authorize, parameters: authorizeParameters)
        let constructor = EndpointConstructor(endpoint: authorizeEndpoint)
        guard let authURL = constructor.makeURL() else {
            return
        }
        
        let urlRequest = URLRequest.init(url: authURL)
        webView.load(urlRequest)
    }
    
    enum AuthorizationResult {
        case failed
        case success(Token)
    }
    
    private var urlString: String = ""
    private let webView = WKWebView()
}

extension AuthorizeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
        guard let stringNavigationURL = navigationAction.request.url?.absoluteString else {
            delegate?.authorizeViewController(self, didReceive: .failed)
            return
        }
        
        if Environment.isDebug {
            print(stringNavigationURL)
        }
        
        let successPhrase = "#access_token="
        guard let range = stringNavigationURL.range(of: successPhrase) else {
            return
        }
        
        let accessToken = String(stringNavigationURL[range.upperBound...])
        delegate?.authorizeViewController(self, didReceive: .success(accessToken))
    }
}
// law of demetra
