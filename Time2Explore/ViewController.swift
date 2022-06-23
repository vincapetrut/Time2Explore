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
    var allPages = [String]()
    var defaultTitle = true
    var progressView: UIProgressView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Time 2 Explore"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(savePage))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPage))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        toolbarItems = [
            UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack)),
            UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showPage)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: progressView),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        ]
        navigationController?.isToolbarHidden = false

        openPage(homePage)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc func savePage() {
        let alertController = UIAlertController(title: "Add page now? :)", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.textFields![0].text = webView.url?.absoluteString
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) {[weak self, weak alertController] action in
            guard let inputPage = alertController?.textFields?[0].text else { return }
            self?.allPages.append(inputPage)
        })
        present(alertController, animated: true)
    }
    
    @objc func searchPage() {
        let alertController = UIAlertController(title: "Enter page name :)", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Search", style: .default) {[weak self, weak alertController] action in
            guard let inputText = alertController?.textFields?[0].text else { return }
            self?.openPage(self!.searchEngine + inputText.replacingOccurrences(of: " ", with: "+"))
        })
        present(alertController, animated: true)
    }
    
    @objc func showPage() {
        let alertController = UIAlertController(title: allPages.isEmpty ? "No page here" : nil, message: nil, preferredStyle: .actionSheet)
        for temporaryPage in allPages {
            alertController.addAction(UIAlertAction(title: temporaryPage, style: .default){action in
                self.webView.load(URLRequest(url: URL(string: temporaryPage)!))
                self.webView.allowsBackForwardNavigationGestures = true
            })
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
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
