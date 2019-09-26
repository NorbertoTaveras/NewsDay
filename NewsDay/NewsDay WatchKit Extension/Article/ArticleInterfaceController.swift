//
//  ArticleInterfaceController.swift
//  NewsDay WatchKit Extension
//
//  Created by Norberto Taveras on 9/26/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import WatchKit

class ArticleInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var articleTable: WKInterfaceTable!
    var source: Source?
    var articles: [Article] = []
    
    override func awake(withContext context: Any?) {
        guard let source = context as? Source else { return }
        
        self.source = source
        
        WatchClient.getArticles(source: source).withResult { (response, error) in
            guard let articles = response as? [Article] else { return }
            
            self.populateTable(with: articles)
        }
    }
    
    func populateTable(with articles: [Article]) {
        self.articles = articles
        
        articleTable.setNumberOfRows(articles.count, withRowType: "articleRow")
        for index in 0 ..< articles.count {
            guard let rowController = articleTable.rowController(at: index) as? ArticleRowController
                else { continue }
            
            rowController.article = articles[index]
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let article = articles[rowIndex]
        presentController(withName: "articleDetailView", context: article)
    }
    
}
