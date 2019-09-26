//
//  ArticleViewController.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/26/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import UIKit

class ArticleViewController: ArticleViewBase {
    
    @IBOutlet weak var articleTableView: UITableView!
    var source = Source()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        initTable(table: articleTableView)
        
        let resultWrapper = AsyncRequest()
        NewsApi.downloadArticles(
            source: source,
            resultWrapper: resultWrapper)
        
        processArticles(resultWrapper: resultWrapper)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = source.name
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToArticles(segue: UIStoryboardSegue) {
        let controller = self.navigationController?.viewControllers[1] as! ArticleViewController
        navigationController?.popToViewController(controller, animated: true)
    }
}
