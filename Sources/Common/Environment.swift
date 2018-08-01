//
//  Environment.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/27/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

struct Environment {
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    static var isRelease: Bool {
        #if RELEASE
        return true
        #else
        return false
        #endif
    }
}
