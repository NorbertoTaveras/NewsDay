//
//  ArticleViewBase.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/26/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import UIKit

class ArticleViewBase: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var articles: [Article] = []
    
    var selectedArticleIndex = -1
    
    weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func initTable(table: UITableView) {
        self.table = table
        table.delegate = self
        table.dataSource = self
    }
    
    func processArticles(resultWrapper: AsyncRequest) {
        resultWrapper.withResult { (anyArticles, error) in
            self.articles = anyArticles as! [Article]
            self.table.reloadData()
        }
    }
    
    // MARK: TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = table.dequeueReusableCell(
            withIdentifier: "article_cell") as? ArticleTableViewCell
            else { return UITableViewCell() }
        
        let target = articles[indexPath.row]
        cell.setupArticleCell(imageUrl: target.urlImage,
                              title: target.title)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticleIndex = indexPath.row
        performSegue(withIdentifier: "article_detail_view", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "article_detail_view":
            if let destination = segue.destination as? ArticleDetailViewController {

                destination.article = articles[selectedArticleIndex]
                selectedArticleIndex = -1
            }
            break
            
        default:
            break
        }
    }
}
