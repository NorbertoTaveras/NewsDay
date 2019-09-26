//
//  ArticleDetailController.swift
//  NewsDay WatchKit Extension
//
//  Created by Norberto Taveras on 9/19/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import WatchKit
import Kingfisher

class ArticleDetailInterfaceController: WKInterfaceController {

    var article: Article?
    
    @IBOutlet weak var articleImage: WKInterfaceImage!
    @IBOutlet weak var articleTitle: WKInterfaceLabel!
    @IBOutlet weak var articleContent: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        article = context as? Article
        
        guard let article = article else { return }
        
        if let urlImage = article.urlImage {
            articleImage.imageFromPhone(url: urlImage)
        } else {
            let noImage = UIImage(named: "news_white_default")
            articleImage.setImage(noImage)
        }
        
        articleTitle.setText(article.title)
        articleContent.setText(article.desc)
    }
}
