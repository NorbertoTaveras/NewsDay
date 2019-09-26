//
//  HeadlineTableViewCell.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/19/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import UIKit
import Kingfisher

class HeadlineTableViewCell: UITableViewCell {

    @IBOutlet weak var headlineImage: UIImageView!
    @IBOutlet weak var headlineTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupHeadline(title: String, imageUrl: URL?) {
        headlineTitle.text = title
        if imageUrl != nil {
            headlineImage.kf.indicatorType = .activity
            headlineImage.kf.setImage(with: imageUrl)
        } else {
            let unavailableImage = UIImage(named: "news_default.png")
            headlineImage.image = unavailableImage
        }
    }

}
