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
    var searchEngine = "https://google.com/search?q="
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPage))

        openPage(homePage)
    }
    
    @objc func searchPage() {
        let alertController = UIAlertController(title: "Enter the page :)", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Search", style: .default) {[weak self, weak alertController] action in
            guard let inputText = alertController?.textFields?[0].text else { return }
            self?.openPage(self!.searchEngine + inputText.replacingOccurrences(of: " ", with: "+"))
        })
        present(alertController, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if defaultTitle == false {
            title = webView.title
        }
        defaultTitle = false
    }
    
    func openPage(_ inputPage: String) {
        webView.load(URLRequest(url: URL(string: inputPage)!))
        webView.allowsBackForwardNavigationGestures = true
    }
}
