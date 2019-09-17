//
//  NewsApi.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import Foundation

class NewsApi {
    private static let instance = NewsApi()
    
    enum NewsError: Error {
        case invalidJSON
        case downloadFailed
    }
    
    private init() {
        print("NewsApi created")
    }
    
    // Only get the sources once
    private var sourcesResult: AsyncRequest?
    
    public static func getSources() -> AsyncRequest {
        if let sourcesResult = instance.sourcesResult {
            return sourcesResult
        }
        
        let sourcesResult = AsyncRequest()
        instance.sourcesResult = sourcesResult
        downloadSources(resultWrapper: sourcesResult)
        
        return sourcesResult
    }
    
    // TODO: getHealines() & getArticle()
    /*    public static func getHeadlines() -> AsyncRequest<AnyObject> {
     } */
    
    /*    public static func getArticle() -> AsyncRequest<AnyObject> {
     }*/
    
    private static func downloadSources(
        resultWrapper: AsyncRequest) {
        
        let apiKey = "d633833ac99a41e49c3ba6f55e2b46e1"
        
        let url: String = "https://newsapi.org/v2/sources?language=en&apiKey=\(apiKey)"
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        if let validURL = URL(string: url) {
            
            let task = session.dataTask(with: validURL) { (data, response, error) in
                if let error = error {
                    print("Data task failed with: \(error.localizedDescription)")
                    resultWrapper.setResult(result: nil, error: error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let validData = data
                    else {
                        print("JSON object creation failed");
                        resultWrapper.setResult(
                            result: nil,
                            error: NewsError.downloadFailed)
                        return
                }
                
                do {
                    guard let jsonTopLevel = try JSONSerialization.jsonObject(
                        with: validData,
                        options: .mutableContainers) as? [String: Any]
                        else { throw NewsError.invalidJSON }
                    
                    let jsonSourceArray = jsonTopLevel["sources"] as? [[String: Any]] ?? []
                    
                    var sources: [Source] = []
                    
                    for jsonSource in jsonSourceArray {
                        let newSource = Source.init(jsonSource: jsonSource)
                        sources.append(newSource)
                    }
                    
                    let categorizedSources = Source.categorize(sources: sources)
                    
                    resultWrapper.setResult(result: categorizedSources, error: nil)
                } catch NewsError.invalidJSON {
                    print("Invalid JSON at \(validURL.description)")
                    resultWrapper.setResult(result: nil, error: error)
                } catch {
                    print("Unable to process data from \(validURL.description)")
                    resultWrapper.setResult(result: nil, error: error)
                }
            }
            task.resume()
        }
    } // end of downloadSources()
    
}
