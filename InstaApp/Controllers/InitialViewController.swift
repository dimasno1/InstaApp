//
//  InitialViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, BaseViewControllerChild {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let url = URL(string: "https://api.instagram.com/oauth/authorize/?client_id=\(Parameter.ID)&redirect_uri=\(Parameter.redirectURL)&response_type=token") else {
            return
        }
        print(url)
   
        UIApplication.shared.open(url)
    }

    enum State {
        case error
        case loading
    }
}
