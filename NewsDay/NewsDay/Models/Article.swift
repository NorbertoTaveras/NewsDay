//
//  Article.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import Foundation
import Kingfisher

class Article : NSObject, NSCoding {
    var author: String
    var title: String
    var desc: String
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
        self.desc = description
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
    
    convenience override init() {
        self.init(jsonArticle: [:])
    }
    
    // MARK: Encoding & Decoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(author, forKey: "author")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(urlImage, forKey: "urlImage")
        aCoder.encode(date, forKey: "date")
    }
    
    required init?(coder aDecoder: NSCoder) {
        author = aDecoder.decodeObject(forKey: "author") as! String
        title = aDecoder.decodeObject(forKey: "title") as! String
        desc = aDecoder.decodeObject(forKey: "desc") as! String
        content = aDecoder.decodeObject(forKey: "content") as! String
        url = aDecoder.decodeObject(forKey: "url") as? URL
        urlImage = aDecoder.decodeObject(forKey: "urlImage") as? URL
        date = aDecoder.decodeObject(forKey: "date") as? Date
    }
    
    // MARK: Archiving & Unarchiving
    public static func keyedArchivedArray(articles: [Article]) -> Data? {
        NSKeyedArchiver.setClassName("Article", for: Article.self)
        
        guard let data = try? NSKeyedArchiver.archivedData(
            withRootObject: articles,
            requiringSecureCoding: false)
            else {
                print("Unable to keyed-archive Article array")
                return nil
        }
        
        return data
    }
    
    public static func keyedUnarchiveArray(data: Data?) -> [Article]? {
        guard let archivedArticles = data else { return nil }
        
        NSKeyedUnarchiver.setClass(Article.self, forClassName: "Article")
        
        guard let articles = try?
            NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(
                archivedArticles) as? [Article]
            else {
                print("Unable to keyed-unarchive article array")
                return nil
        }
        
        return articles
    }
    
    // MARK: Misc
    func simpleHeadline(callback: @escaping ([String: Any?]) -> Void) {
        if let validUrl = urlImage {
            KingfisherManager.shared.retrieveImage(with: validUrl) { (result) in
                let image = (try? result.get())?.image
                
                let data: [String: Any?] = [
                    "title": self.title,
                    "description": self.desc,
                    "image": image
                ]
                
                callback(data)
            }
        } else {
            DispatchQueue.main.async {
                let data = [
                    "title": self.title,
                    "description": self.desc,
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
}
