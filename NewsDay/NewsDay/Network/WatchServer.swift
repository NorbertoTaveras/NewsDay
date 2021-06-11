//
//  WatchServer.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import Foundation

import WatchConnectivity
import Kingfisher

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
                
            case "articles":
                let sourceData = message["source"] as? Data
                let optionalSource = Source.keyedUnarchive(data: sourceData)
                
                guard let source = optionalSource else { return }
                
                NewsApi.getArticles(source: source).withResult { (result, error) in
                    guard let articles = result as? [Article] else { return }
                    
                    if let data = Article.keyedArchivedArray(articles: articles) {
                        let reply: [String: Any] = [
                            "articles": data
                        ]
                        
                        replyHandler(reply)
                    }
                }
                
            case "headlines":
                guard let country = message["country"] as? String else { return }
                guard let limit = message["limit"] as? Int else { return }
                
                NewsApi.getHeadlines(country: country, limit: limit)
                    .withResult { (result, error) in
                        guard let headlines = result as? [Article] else { return }
                        
                        if let data = Article.keyedArchivedArray(articles: headlines) {
                            let reply: [String: Any] = [
                                "articles": data
                            ]
                            
                            replyHandler(reply)
                        }
                }
                
            case "image":
                guard let urlText = message["url"] as? String else { return }
                guard let url = URL(string: urlText) else { return }
                
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    guard let image = try? result.get().image else { return }
                    
                    // Resize the image down to something reasonabe for a watch
                    // and greatly reduce bluetooth transfer size
                    guard let resizedImage = WatchServer.resizeImage(
                        image: image,
                        maxSize: CGSize(width: 448, height: 368))
                        else { return }
                    
                    let imageData = resizedImage.jpegData(compressionQuality: 0.0)
                    
                    let reply: [String: Any] = [
                        "image": imageData as Any
                    ]
                    
                    replyHandler(reply)
                }
                
            default:
                replyHandler(["error":"Unrecognized request"])
            }
        }
    }
    
    private static func resizeImage(image: UIImage, maxSize: CGSize) -> UIImage? {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        // Initially output size is the same as input size
        var outputSize = image.size
        
        // Skip unnecessary resize
        if outputSize.width <= maxSize.width &&
            outputSize.height <= maxSize.height {
            // Just return the original image
            return image
        }
        
        // Make it proportially narrower if output is too wide
        if outputSize.width > maxSize.width {
            let scale = maxSize.width / outputSize.width
            
            // Scale width and height the same amount to preserve aspect
            outputSize.width *= scale
            outputSize.height *= scale
        }
        
        // Make it proportionally shorter if output is too tall
        if outputSize.height > maxSize.height {
            let scale = maxSize.height / outputSize.height
            
            // Scale width and height same amount to preserve aspect
            outputSize.width *= scale
            outputSize.height *= scale
        }
        
        UIGraphicsBeginImageContextWithOptions(outputSize, !hasAlpha, 1.0)
        
        // Guarantee that the graphics context is ended, even on error/exception
        defer {
            UIGraphicsEndImageContext()
        }
        
        let outputRect = CGRect(origin: CGPoint.zero, size: outputSize)
        image.draw(in: outputRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
}
