//
//  HeadlineViewController.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/26/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import UIKit

class HeadlineViewController: ArticleViewBase {

    @IBOutlet weak var headlineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTable(table: headlineTableView)
        
        let resultWrapper = AsyncRequest()
        NewsApi.downloadHeadlines(
            country: "us",
            limit: nil,
            resultWrapper: resultWrapper)
        
        processArticles(resultWrapper: resultWrapper)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Headlines"
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToArticles(segue: UIStoryboardSegue) {
        let controller = self.navigationController?.viewControllers[0] as! HeadlineViewController
        navigationController?.popToViewController(controller, animated: true)
    }
    
}
