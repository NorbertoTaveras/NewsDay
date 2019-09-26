//
//  ArticleRowController.swift
//  NewsDay WatchKit Extension
//
//  Created by Norberto Taveras on 9/19/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import Foundation
import WatchKit

class ArticleRowController: NSObject {
    
    @IBOutlet weak var articleTitle: WKInterfaceLabel!
    
    var article: Article? {
        didSet {
            guard let article = article else { return }
            articleTitle.setText(article.title)
        }
    }
    
}
