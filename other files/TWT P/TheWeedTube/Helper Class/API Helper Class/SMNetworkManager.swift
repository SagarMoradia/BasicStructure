//
//  SMNetworkManager.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

import UIKit
import Reachability

class SMNetworkManager{

    //shared instance
    static let shared = SMNetworkManager()

    let reachability = Reachability()!

    var isReachable : Bool? = true
    
    func startNetworkReachabilityObserver() {
    
        reachability.whenReachable = { reachability in
            self.isReachable = true
        }
        reachability.whenUnreachable = { _ in
            self.isReachable = false
        }

        
        // start listening
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stopNetworkReachabilityObserver() {
        reachability.stopNotifier()

    }
}
