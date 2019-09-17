//
//  CategorizedSources.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import Foundation

class CategorizedSources: NSObject, NSCoding {
    var categories: [String] = []
    var details: [[Source]] = []
    
    override init() {
        super.init()
    }
    
    init(from sources: [Source]) {
        super.init()
        populate(from: sources)
    }
    
    required init?(coder aDecoder: NSCoder) {
        categories = aDecoder.decodeObject(
            forKey: "categories") as! [String]
        
        let detailCount = aDecoder.decodeInt32(
            forKey: "detailCount")
        
        details = []
        
        for index in 0 ..< detailCount {
            let entry: [Source]
            entry = aDecoder.decodeObject(
                forKey: "detail_\(index)") as! [Source]
            
            details.append(entry)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        NSKeyedArchiver.setClassName("Source", for: Source.self)
        
        aCoder.encode(categories, forKey: "categories")
        aCoder.encode(Int32(details.count), forKey: "detailCount")
        for index in 0 ..< details.count {
            aCoder.encode(details[index] as [Source], forKey: "detail_\(index)")
        }
    }
    
    public func keyedArchive() -> Data? {
        NSKeyedArchiver.setClassName("CategorizedSources", for: CategorizedSources.self)
        
        guard let data = try? NSKeyedArchiver.archivedData(
            withRootObject: self,
            requiringSecureCoding: false)
            else { return nil }
        
        return data
    }
    
    public static func keyedUnarchive(data: Data?) -> CategorizedSources? {
        guard let data = data else { return nil }
        NSKeyedUnarchiver.setClass(CategorizedSources.self,
                                   forClassName: "CategorizedSources")
        NSKeyedUnarchiver.setClass(Source.self,
                                   forClassName: "Source")
        
        let categorizedSources: CategorizedSources?
        do {
            categorizedSources = try
                NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(
                    data) as? CategorizedSources
        } catch {
            print("Error unarchiving CategorizedSources: \(error.localizedDescription)")
            return nil
        }
        
        return categorizedSources!
    }
    
    func populate(from sources: [Source]) {
        for source in sources {
            var index = categories.firstIndex(of: source.category)
            
            if index == nil {
                index = categories.count
                categories.append(source.category)
                details.append([])
            }
            
            details[index!].append(source)
        }
    }
    
    func flatten() -> [Source] {
        var flatArray: [Source] = []
        for categoryDetails in details {
            flatArray.append(contentsOf: categoryDetails)
        }
        return flatArray
    }
}
