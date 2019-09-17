//
//  Article.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import Foundation
import Kingfisher

class Article {
    var author: String
    var title: String
    var description: String
    var content: String
    var url: URL?
    var urlImage: URL?
    var date: Date?
    
    var Date: String {
        get {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "MMM dd, yyyy"
            
            if let validDate = date {
                return formatter.string(from: validDate)
            }
            
            return ""
        }
    }
    
    init(author: String, title: String, description: String,
         content: String, url: URL?, urlImage: URL?, date: Date?) {
        self.author = author
        self.title = title
        self.description = description
        self.content = content
        self.url = url
        self.urlImage = urlImage
        self.date = date
    }
    
    convenience init (jsonArticle: [String:Any?]) {
        let url = URL.init(string: jsonArticle["url"] as? String ?? "")
        let urlImage = URL.init(string: jsonArticle["urlToImage"] as? String ?? "")
        let author = jsonArticle["author"] as? String ?? ""
        let title = jsonArticle["title"] as? String ?? ""
        let description = jsonArticle["description"] as? String ?? ""
        let content = jsonArticle["content"] as? String ?? ""
        let dateString = jsonArticle["date"] as? String
        
        let date = Article.parseDate(date: dateString)
        
        self.init(author: author,
                  title: title,
                  description: description,
                  content: content,
                  url: url,
                  urlImage: urlImage,
                  date: date)
    }
    
    convenience init() {
        self.init(jsonArticle: [:])
    }
    
    func simpleHeadline(callback: @escaping ([String: Any?]) -> Void) {
        if let validUrl = urlImage {
            KingfisherManager.shared.retrieveImage(with: validUrl) { (result) in
                let image = (try? result.get())?.image
                
                let data: [String: Any?] = [
                    "title": self.title,
                    "description": self.description,
                    "image": image
                ]
                
                callback(data)
            }
        } else {
            DispatchQueue.main.async {
                let data = [
                    "title": self.title,
                    "description": self.description,
                    "image": nil
                ]
                
                callback(data)
            }
        }
    }
    
    static func parseDate(date: String?) -> Date? {
        if let input = date {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            
            let result = dateFormatter.date(from: input)
            return result
        }
        
        return nil
    }
    
    let apiKey = "d633833ac99a41e49c3ba6f55e2b46e1"
    
    func downloadArticles() {
    }
}
