//
//  Headline2Controller.swift
//  NewsDay WatchKit Extension
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import WatchKit

class Headline2Controller: HeadlineBaseController {
    
    @IBOutlet weak var headlineImage: WKInterfaceImage!
    @IBOutlet weak var headlineTitle: WKInterfaceLabel!
    @IBOutlet weak var headlineDescription: WKInterfaceLabel!
    
    override convenience init() {
        self.init(headlineIndex: 2)
    }
    
    override func populateUI(title: String, description: String, urlImage: URL?) {
        populateControls(headlineImage: headlineImage,
                         headlineTitle: headlineTitle,
                         headlineDescription: headlineDescription,
                         title: title,
                         description: description,
                         urlImage: urlImage)
    }
}
