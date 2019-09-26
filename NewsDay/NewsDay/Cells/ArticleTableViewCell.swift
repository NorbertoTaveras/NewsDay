//
//  ArticleTableViewCell.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/18/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupArticleCell(imageUrl: URL?, title: String) {
        if imageUrl != nil {
            articleImage.kf.indicatorType = .activity
            articleImage.kf.setImage(with: imageUrl)
        } else {
            let unavailableImage = UIImage(named: "news_default.png")
            articleImage.image = unavailableImage
        }
        articleTitle.text = title
    }
}
