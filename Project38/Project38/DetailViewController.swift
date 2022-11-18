//
//  DetailViewController.swift
//  Project38
//
//  Created by MTMAC51 on 17/11/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var detailItem: Commit?
    var webView: WKWebView!

    @IBOutlet var detailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        if let detail = self.detailItem{
            detailLabel.text = detail.url
            let url = URL(string: detail.url)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }

}
