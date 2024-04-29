//
//  ReachabilityService.swift
//  VeterinaryApp
//
//  Created by Tanmay on 12/04/23.
//

import Foundation
import SystemConfiguration

struct NetworkReachabilityManagerService {
    
    private var reachabilityRef: SCNetworkReachability?
    
    init() {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com") else {
            fatalError("Unable to create SCNetworkReachability")
        }
        self.reachabilityRef = reachability
    }
    
    func isReachable() -> Bool {
        guard let reachabilityRef = reachabilityRef else { return false }
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachabilityRef, &flags)
        
        return flags.contains(.reachable)
    }
}
