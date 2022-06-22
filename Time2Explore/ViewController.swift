//
//  ViewController.swift
//  Time2Explore
//
//  Created by Petruț Vinca on 22.06.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var homePage = "https://google.com"
    var defaultTitle = true
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Time 2 Explore"
        
        webView.load(URLRequest(url: URL(string: homePage)!))
        webView.allowsBackForwardNavigationGestures = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if defaultTitle == false {
            title = webView.title
        }
        defaultTitle = false
    }
}
