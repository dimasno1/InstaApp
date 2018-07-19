//
//  AuthorizeViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/13/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit
import WebKit

protocol AuthorizeViewControllerDelegate: AnyObject {
    func didReceive(_ authorizeViewController: AuthorizeViewController, token: Token?)
}

typealias Token = String

class AuthorizeViewController: UIViewController {
    
    weak var delegate: AuthorizeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        view.addSubview(webView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authorize()
    }
    
    private func setup() {
        webView.frame = view.bounds
        webView.navigationDelegate = self
    }
    
    private func authorize() {
        var component = NSURLComponents(string: URLConstant.authorizeURL)!
        let urlString = String(format: "%@?%@=%@&%@=%@&%@=%@", arguments: [URLConstant.authorizeURL, URLConstant.Key.ID, URLConstant.Value.ID, URLConstant.Key.redirectURL, URLConstant.Value.redirectURL, URLConstant.Key.responceType, URLConstant.Value.recponceType])
        self.urlString = urlString
        
        guard let authURL = URL(string: urlString) else {
            return
        }
        let urlRequest = URLRequest.init(url: authURL)
        webView.load(urlRequest)
    }
    
    private var urlString: String = ""
    private let webView = WKWebView()
}

extension AuthorizeViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
        guard let stringNavigationURL = navigationAction.request.url?.absoluteString else {
            return
        }
        
        let successPhrase = "#access_token="
        if stringNavigationURL.contains(successPhrase) {
            guard let range = stringNavigationURL.range(of: successPhrase) else {
                return
            }
            
            let accessToken = String(stringNavigationURL[range.upperBound...])
            delegate?.didReceive(self, token: accessToken)
        }
    }
}
