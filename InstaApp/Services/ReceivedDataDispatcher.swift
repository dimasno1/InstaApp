//
//  ReceivedDataDispatcher.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/27/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

final class ReceivedDataDispatcher {
    
    func add(_ command: Command, callback: @escaping ([InstaMeta]) -> Void) {
        receivedDataQueue.append(command)
        decodeNext(then: callback)
    }
    
    func decodeNext(then callback: @escaping ([InstaMeta]) -> Void) {
        guard !isBusy, let decodeCommand = receivedDataQueue.first else {
            return
        }
  
        isBusy = true
        receivedDataQueue.remove(at: 0)
        
        decodeCommand.decode { [weak self] meta in
            callback(meta)
           
            self?.isBusy = false
            self?.decodeNext(then: callback)
        }
    }
    
    private (set) var isBusy: Bool = false
    private var receivedDataQueue: [Command] = []
}
