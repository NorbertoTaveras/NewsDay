//
//  ArticleDetailViewController.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/26/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleAuthor: UILabel!
    @IBOutlet weak var articleDate: UILabel!
    @IBOutlet weak var articleDescription: UITextView!
    
    var article = Article()
    var articleUIImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        
        updateArticleDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    func updateArticleDetails() {
        articleImage.kf.indicatorType = .activity
        
        if article.urlImage != nil {
        articleImage.kf.setImage(with: article.urlImage)
        } else {
            let unavailableImage = UIImage(named: "news_default.png")
            articleImage.image = unavailableImage
        }
        
        articleTitle.text = article.title
        articleAuthor.text = article.author.trimmingCharacters(
            in: CharacterSet(charactersIn: " "))
        articleDate.text = article.Date
        articleDescription.text = article.desc
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func readMore(_ sender: UIButton) {
        performSegue(withIdentifier: "web_view", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ArticleWebViewController {
            destination.article = article
        }
    }
}
