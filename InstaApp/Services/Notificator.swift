//
//  Notificator.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/20/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

class Notificator {
    
    static let shared = Notificator()
    
    private init() {
        
    }
    
    private func observe() {
        
    }
    
//    private func setup() {
//        let notification = Notification(name: .scopeBarChangedValue, object: nil, userInfo: <#T##[AnyHashable : Any]?#>)
//        notificationCenter.post(notification)
//    }
    
    let notificationCenter = NotificationCenter.default
}

extension Notification.Name {
    static let scopeBarChangedValue = Notification.Name.init("ScopeValueChanged")
}
