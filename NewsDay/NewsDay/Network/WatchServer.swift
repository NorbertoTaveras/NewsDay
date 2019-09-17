//
//  WatchServer.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class WatchServer: NSObject, WCSessionDelegate {
    
    var session: WCSession?
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            session = WCSession.default
            guard let session = session else { return }
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("got session activation completion \(activationState)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("session did deactivate")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            
            let request = message["request"] as? String ?? ""
            print("got request: \(request)")
            
            switch request {
            case "sources":
                NewsApi.getSources().withResult(callback: { (result, error) in
                    guard let categorizedSources = result as? CategorizedSources else { return }
                    
                    if let data = categorizedSources.keyedArchive() {
                        let reply: [String: Any] = [
                            "sources":data
                        ]
                        replyHandler(reply)
                    }
                })
                
            default:
                replyHandler(["error":"Unrecognized request"])
            }
        }
    }
    
}
