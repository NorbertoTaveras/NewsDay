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
    private static let apiKey = "233a012e69b84d55aacb08dc84f38f0d"
    
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
    
    private var headlinesResult: [String: AsyncRequest] = [:]
    
    public static func getHeadlines(country: String, limit: Int?) -> AsyncRequest {
        if let articlesResult = instance.articlesResult[country] {
            return articlesResult
        }
        
        let articlesResult = AsyncRequest()
        instance.articlesResult[country] = articlesResult
        downloadHeadlines(country: country,
                          limit: limit,
                          resultWrapper: articlesResult)
        return articlesResult
    }
    
    private var articlesResult: [String: AsyncRequest] = [:]
    
    public static func getArticles(source: Source) -> AsyncRequest {
        if let articlesResult = instance.articlesResult[source.id] {
            return articlesResult
        }
        
        let articlesResult = AsyncRequest()
        instance.articlesResult[source.id] = articlesResult
        downloadArticles(source: source, resultWrapper: articlesResult)
        return articlesResult
    }
    
    private static func downloadSources(
        resultWrapper: AsyncRequest) {
        
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
    
    public static func downloadArticles(source: Source, resultWrapper: AsyncRequest) {
        
        // checks if the enconded source is empty
        // prints out a log into the console
        if source.id.isEmpty {
            print("Invalid news source name")
            return
        }
        
        // constant to hold the enconded source
        // addingPercentEncoding is used to append "%" in replace of invalid
        // characters in the sources, such as "-, " ", etc
        let encodedSource = source.id.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // constant to hold the encoded api
        // addingPercentEncoding is used to append "%" in replace of invalid
        // characters in the sources, such as "-, " ", etc
        let encodedApiKey = apiKey.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // constant to form the endpoint to retrieve articles
        // with the enconded source and api key
        let url = "https://newsapi.org/v2/everything" +
            "?sources=\(encodedSource)" +
            "&apiKey=\(encodedApiKey)" +
        "&sortBy=publishedAt"
        
        // validate the url to ensure it's not a broken source
        if let validURL = URL(string: url) {
            downloadArticle(fromUrl: validURL, resultWrapper: resultWrapper)
        }
    }
    
    public static func downloadHeadlines(country: String,
                                         limit: Int?,
                                         resultWrapper: AsyncRequest) {
        
        // constant to hold the encoded api
        // addingPercentEncoding is used to append "%" in replace of invalid
        // characters in the sources, such as "-, " ", etc
        let encodedApiKey = apiKey.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let encodedCountry = country.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // constant to form the endpoint to retrieve articles
        // with the enconded source and api key
        let url = "https://newsapi.org/v2/top-headlines" +
            "?country=\(encodedCountry)" +
            "&apiKey=\(encodedApiKey)" +
            (limit != nil ? "&pageSize=\(limit!)" : "")
        
        // https://newsapi.org/v2/top-headlines?country=us&apiKey=233a012e69b84d55aacb08dc84f38f0d
        // validate the url to ensure it's not a broken source
        if let validURL = URL(string: url) {
            downloadArticle(fromUrl: validURL, resultWrapper: resultWrapper)
        }
    }
    
    private static func downloadArticle(fromUrl validURL: URL, resultWrapper: AsyncRequest) {
        // create a default url session configuration
        let config = URLSessionConfiguration.default
        
        // create a url sessioin and passed the previously created
        // url session configuration
        let session = URLSession(configuration: config)
        
        // create a task that will download anything that is found
        // at the valid url as a data object
        let task = session.dataTask(with: validURL) { (data, response, error) in
            if let validError = error {
                print("Data task failed with: \(validError.localizedDescription)")
                resultWrapper.setResult(result: nil, error: validError)
                return
            }
            
            // check the http response returned
            guard let httpResponse = response as? HTTPURLResponse,
                let validData = data
                else {
                    print("JSON object creation failed!")
                    resultWrapper.setResult(
                        result: nil, error: NewsError.invalidJSON)
                    return
            }
            
            //  check the http response status code
            // to be within the range of >= 200 and <= 299
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299
                else {
                    print("Server returned error code \(httpResponse.statusCode)")
                    resultWrapper.setResult(
                        result: nil,
                        error: NewsError.downloadFailed)
                    return
            }
            
            do {
                // create a json object from the binary data life
                // cast it as an dictionary of strings:any
                let jsonTopLevel = try JSONSerialization.jsonObject(
                    with: validData,
                    options: .mutableContainers) as? [String: Any]
                
                // access the array of articles
                let jsonArticles = jsonTopLevel?["articles"] as? [[String:Any]] ?? []
                
                // instantiate an array of empty articles
                var articles: [Article] = []
                
                // loop through the json articles
                // to access each data within it
                for jsonArticle in jsonArticles {
                    // instantiate a new article
                    // by self init of the Article model
                    // and passing the json article
                    let newArticle = Article.init(jsonArticle: jsonArticle)
                    
                    // append the new article
                    // into the array of articles
                    articles.append(newArticle)
                }
                
                resultWrapper.setResult(result: articles as AnyObject, error: nil)
            } catch {
                print(error.localizedDescription)
                resultWrapper.setResult(result: nil, error: error)
            }
        }
        
        // begin the task
        task.resume()
    }
}
