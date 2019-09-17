//
//  SourceRowController.swift
//  NewsDay WatchKit Extension
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import Foundation
import WatchKit

class SourceRowController: NSObject {
    @IBOutlet weak var sourceName: WKInterfaceLabel!
    
    var source: Source? {
        didSet {
            guard let source = source else { return }
            sourceName.setText(source.name)
        }
    }
}
