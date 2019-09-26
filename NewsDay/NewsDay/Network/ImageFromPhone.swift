//
//  ImageFromPhone.swift
//  NewsDay WatchKit Extension
//
//  Created by Norberto Taveras on 9/24/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import WatchKit

extension WKInterfaceImage {
    func imageFromPhone(url: URL) {
        WatchClient.getImage(from: url).withResult { (response, error) in
            let image = response as! UIImage
            self.setImage(image)
        }
    }
}
