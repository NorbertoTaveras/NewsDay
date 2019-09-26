//
//  HeadlineBaseController.swift
//  NewsDay WatchKit Extension
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class HeadlineBaseController: WKInterfaceController {
    
    let headlineIndex: Int
    var articles: [Article] = []
    
    override init() {
        headlineIndex = -1
        super.init()
    }
    
    init(headlineIndex: Int) {
        self.headlineIndex = headlineIndex
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let headlinesRequest = context as? AsyncRequest
            else { return }
        
        self.populateUI(title: "",
                        description: "",
                        urlImage: nil)
        
        headlinesRequest.withResult { (result, error) in
            guard let articles = result as? [Article]
                else { return }
            self.articles = articles
            let article = articles[self.headlineIndex]
            
            self.populateUI(title: article.title,
                            description: article.desc,
                            urlImage: article.urlImage)
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    // This must be overridden but Swift has no capability to enforce that
    // Hope for the best!
    func populateUI(title: String, description: String, urlImage: URL?) {
    }
    
    func populateControls(headlineImage: WKInterfaceImage,
                          headlineTitle: WKInterfaceLabel,
                          headlineDescription: WKInterfaceLabel,
                          title: String,
                          description: String,
                          urlImage: URL?) {
        headlineTitle.setText(title)
        headlineDescription.setText(description)
        if let urlImage = urlImage {
            headlineImage.imageFromPhone(url: urlImage)
        } else {
            headlineImage.setImage(nil)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
