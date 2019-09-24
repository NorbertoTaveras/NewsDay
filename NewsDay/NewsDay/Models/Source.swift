//
//  Source.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import Foundation

class Source: NSObject, NSCoding {
    var id: String
    var name: String
    var desc: String
    var category: String
    var language: String
    var country: String
    
    init(id: String, name: String, description: String,
         category: String, language: String, country: String) {
        self.id = id
        self.name = name
        self.desc = description
        self.category = category
        self.language = language
        self.country = country
    }
    
    // MARK: Encoding & Decoding
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String
        desc = aDecoder.decodeObject(forKey: "description") as! String
        category = aDecoder.decodeObject(forKey: "category") as! String
        language = aDecoder.decodeObject(forKey: "language") as! String
        country = aDecoder.decodeObject(forKey: "country") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(desc, forKey: "description")
        aCoder.encode(category, forKey: "category")
        aCoder.encode(language, forKey: "language")
        aCoder.encode(country, forKey: "country")
    }
    
    // MARK: JSON Inits
    convenience init(jsonSource: [String: Any]) {
        self.init(
            id: jsonSource["id"] as? String ?? "",
            name: jsonSource["name"] as? String ?? "",
            description: jsonSource["description"] as? String ?? "",
            category: jsonSource["category"] as? String ?? "",
            language: jsonSource["language"] as? String ?? "",
            country: jsonSource["country"] as? String ?? "")
    }
    
    override convenience init() {
        self.init(jsonSource: [:])
    }
    
    // MARK: Archiving & Unarchiving Object
    public func keyedArchive() -> Data? {
        NSKeyedArchiver.setClassName("Source", for: Source.self)
        
        guard let data = try? NSKeyedArchiver.archivedData(
            withRootObject: self,
            requiringSecureCoding: false)
            else {
                print("Unable to keyed-archive Source array")
                return nil
        }
        
        return data
    }
    
    public static func keyedUnarchive(data: Data?) -> Source? {
        guard let archivedSource = data else { return nil }
        
        NSKeyedUnarchiver.setClass(Source.self, forClassName: "Source")
        
        guard let sources = try?
            NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(
                archivedSource) as? Source
            else {
                print("Unable to keyed-unarchive source array")
                return nil
        }
        
        return sources
    }
    
    // MARK: Archiving & Unarchiving Array
    public static func keyedArchiveArray(sources: [Source]) -> Data? {
        NSKeyedArchiver.setClassName("Source", for: Source.self)
        
        guard let data = try? NSKeyedArchiver.archivedData(
            withRootObject: sources,
            requiringSecureCoding: false)
            else {
                print("Unable to keyed-archive Source array")
                return nil
        }
        
        return data
    }
    
    public static func keyedUnarchiveArray(data: Data?) -> [Source]? {
        guard let archivedSources = data else { return nil }
        
        NSKeyedUnarchiver.setClass(Source.self, forClassName: "Source")
        
        guard let sources = try?
            NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(
                archivedSources) as? [Source]
            else {
                print("Unable to keyed-unarchive source array")
                return nil
        }
        
        return sources
    }
    
    public static func categorize(sources: [Source]) -> CategorizedSources {
        return CategorizedSources(from: sources)
    }
}
