//
//  SourceInterfaceController.swift
//  NewsDay WatchKit Extension
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import WatchKit

class SourceInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var sourceTable: WKInterfaceTable!
    
    var sources: [Source]?
    
    override func awake(withContext context: Any?) {
        WatchClient.getSources().withResult { (response, error) in
            guard let sources = response as? CategorizedSources else { return }
            
            self.populateTable(with: sources.flatten())
        }
    }
    
    func populateTable(with sources: [Source]) {
        sourceTable.setNumberOfRows(sources.count, withRowType: "sourceRow")
        for index in 0 ..< sources.count {
            guard let rowController = sourceTable.rowController(
                at: index) as? SourceRowController
                else { continue }
            
            rowController.source = sources[index]
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        guard let sources = sources else { return }
        let source = sources[rowIndex]
        presentController(withName: "articleListView", context: source)
    }
}
