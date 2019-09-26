//
//  ArticleWebViewController.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/26/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import UIKit
import WebKit

class ArticleWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet var articleWebView: WKWebView!
    
    var article: Article?
    
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        
        articleWebView = WKWebView(
            frame: .zero,
            configuration: webConfig)
        
        articleWebView.uiDelegate = self
        articleWebView.navigationDelegate = self
        
        view = articleWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        if let validURL = article?.url {
            let request = URLRequest(url: validURL)
            articleWebView.load(request)
            articleWebView.allowsBackForwardNavigationGestures = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

}
