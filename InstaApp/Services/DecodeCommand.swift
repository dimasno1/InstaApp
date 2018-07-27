//
//  DecodeCommand.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/27/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

class DecodeCommand: Command {
    
    func decode(then callback: Command.Callback?) {
        decoder.decode(data: data, then: callback)
    }
    
    init(data: Data) {
        self.data = data
    }
    
    private var data: Data
    private var decoder = JSONDecoder()
}
