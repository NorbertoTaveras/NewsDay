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
    
    override init() {
        headlineIndex = -1
        super.init()
    }
    
    init(headlineIndex: Int) {
        self.headlineIndex = headlineIndex
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    // This must be overridden but Swift has no capability to enforce that
    // Hope for the best!
    func populateUI(title: String, description: String, image: UIImage?) {
    }
    
    func populateControls(headlineImage: WKInterfaceImage,
                          headlineTitle: WKInterfaceLabel,
                          headlineDescription: WKInterfaceLabel,
                          title: String,
                          description: String,
                          image: UIImage?) {
        headlineTitle.setText(title)
        headlineDescription.setText(description)
        headlineImage.setImage(image)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
