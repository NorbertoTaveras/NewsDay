//
//  WatchClient.swift
//  NewsDay WatchKit Extension
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class WatchClient: NSObject, WCSessionDelegate {
    
    private static let instance = WatchClient()
    let asyncSession: AsyncRequest
    
    private override init() {
        asyncSession = AsyncRequest()
        super.init()
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            guard session.isReachable else { return }
            self.asyncSession.setResult(result: session, error: nil)
        }
    }
    
    public static func getSources() -> AsyncRequest {
        let sourceRequest = AsyncRequest()
        
        instance.asyncSession.withResult { (anySession, error) in
            getSources(session: anySession as? WCSession,
                       asyncRequest: sourceRequest)
        }
        return sourceRequest
    }
    
    private static func getSources(session: WCSession?, asyncRequest: AsyncRequest) {
        guard let session = session else {
            asyncRequest.setResult(result: nil, error: nil)
            return
        }
        
        let request: [String: Any] = [
            "request": "sources"
        ]
        
        session.sendMessage(request, replyHandler: { (reply) in
            guard let replyData = reply["sources"] as? Data else { return }
            let sources = CategorizedSources.keyedUnarchive(data: replyData)
            asyncRequest.setResult(
                result: sources as AnyObject?,
                error: nil)
        }, errorHandler: { (error) in
            print("Error in sources request: \(error.localizedDescription)")
        })
    }
    
}
