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
            asyncRequest.setResult(result: nil, error: error)
        })
    }
    
    public static func getArticles(source: Source) -> AsyncRequest {
        let articlesRequest = AsyncRequest()
        
        instance.asyncSession.withResult { (anySession, error) in
            getArticles(session: anySession as? WCSession,
                        source: source,
                        asyncRequest: articlesRequest)
        }
        
        return articlesRequest
    }
    
    private static func getArticles(session: WCSession?,
                                    source: Source,
                                    asyncRequest: AsyncRequest) {
        
        guard let session = session else {
            asyncRequest.setResult(result: nil, error: nil)
            return
        }
        
        let request: [String: Any] = [
            "request": "articles",
            "source": source.keyedArchive() as Any
        ]
        
        session.sendMessage(request, replyHandler: { (reply) in
            guard let replyData = reply["articles"] as? Data else { return }
            let articles = Article.keyedUnarchiveArray(data: replyData)
            asyncRequest.setResult(
                result: articles as AnyObject?,
                error: nil)
        }, errorHandler: { (error) in
            print("Error in articles request: \(error.localizedDescription)")
            asyncRequest.setResult(result: nil, error: error)
        })
        
    }
    
    public static func getImage(from url: URL) -> AsyncRequest {
        let imageRequest = AsyncRequest()
        
        instance.asyncSession.withResult { (anySession, error) in
            getImage(session: anySession as? WCSession,
                     url: url,
                     asyncRequest: imageRequest)
        }
        
        return imageRequest
    }
    
    private static func getImage(session: WCSession?,
                                 url: URL,
                                 asyncRequest: AsyncRequest) {
        guard let session = session else {
            asyncRequest.setResult(result: nil, error: nil)
            return
        }
        
        let request: [String: Any] = [
            "request": "image",
            "url": url.absoluteString
        ]
        
        session.sendMessage(request, replyHandler: { (reply) in
            guard let imageData = reply["image"] as? Data else { return }
            let image = UIImage(data: imageData)
            asyncRequest.setResult(
                result: image as AnyObject?,
                error: nil)
        }, errorHandler: { (error) in
            print("Error in image request: \(error.localizedDescription)")
            asyncRequest.setResult(result: nil, error: error)
        })
    }
    
    public static func getHeadlines(country: String, limit: Int?) -> AsyncRequest {
        let headlineRequest = AsyncRequest()
        
        instance.asyncSession.withResult { (anySession, error) in
            getHeadlines(session: anySession as? WCSession,
                         country: country,
                         limit: limit,
                         asyncRequest: headlineRequest)
        }
        
        return headlineRequest
    }
    
    private static func getHeadlines(session: WCSession?,
                                     country: String,
                                     limit: Int?,
                                     asyncRequest: AsyncRequest) {
        guard let session = session else {
            asyncRequest.setResult(result: nil, error: nil)
            return
        }
        
        let request: [String: Any] = [
            "request": "headlines",
            "country": country,
            "limit": limit as Any
        ]
        
        session.sendMessage(request, replyHandler: { (reply) in
            guard let headlineData = reply["articles"] as? Data
                else { return }
            
            guard let headlines = Article.keyedUnarchiveArray(
                data: headlineData)
                else { return }
            
            asyncRequest.setResult(
                result: headlines as AnyObject?,
                error: nil)
        }, errorHandler: { (error) in
            print("Error in headlines request: \(error.localizedDescription)")
            asyncRequest.setResult(result: nil, error: error)
        })
    }
    
}
