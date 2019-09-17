//
//  SourcesViewController.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import UIKit

class SourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var sourcesTableView: UITableView!
    
    var sources = CategorizedSources()
    var selectedSource = Source()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewsApi.getSources().withResult { (sources, error) in
            if let categorizedSources = sources {
                self.processSources(newSources: categorizedSources as! CategorizedSources)
            } else {
                
            }
        } // end of get sources
        
        sourcesTableView.delegate = self
        sourcesTableView.dataSource = self
    }
    
    // MARK: Custom Methods
    func processSources(newSources : CategorizedSources) {
        sources = newSources
        sourcesTableView.reloadData()
    }

    // MARK: Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.details.isEmpty ? 0 : sources.details[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rawCell = sourcesTableView.dequeueReusableCell(
            withIdentifier: "sourceCell",
            for: indexPath)
        
        guard let cell = rawCell as? SourceTableViewCell
            else {return rawCell}
        
        let target = sources.details[indexPath.section][indexPath.row]
        
        cell.sourceName.text = target.name
        return cell
    }
}
