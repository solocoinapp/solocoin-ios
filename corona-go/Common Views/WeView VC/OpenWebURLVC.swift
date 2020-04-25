//
//  OpenWebURLVC.swift
//  corona-go
//
//  Created by indie dev on 02/04/20.
//

import UIKit
import WebKit

enum URLType {
    case privacy
    case tnC
    
    var headerTitle: String {
        switch self {
        case .privacy: return "PRIVACY_POLICY".localized()
        case .tnC: return "TERMS_AND_CONDITIONS".localized()
        }
    }
    var url: String {
        switch self {
        case .privacy:
            return "https://www.solocoin.app/privacy-policy/"
        case .tnC:
            return "https://www.solocoin.app/terms-and-conditions/"
        }
    }
}


class OpenUrlWithWKWebViewVC: UIViewController {
    
    //MARK:- Constants/Variables
    private var webView: WKWebView!
    private var activityIndicator:UIActivityIndicatorView!
    private var urlString:String = ""
    private var headerTitle:String = ""
    //MARK:- init Methods
    class func createInstance(forType type: URLType) -> OpenUrlWithWKWebViewVC {
        let scOpenUrlWithWKWebViewVC = OpenUrlWithWKWebViewVC(nibName: "OpenUrlWithWKWebViewVC", bundle: nil)
        scOpenUrlWithWKWebViewVC.urlString = type.url
        scOpenUrlWithWKWebViewVC.headerTitle = type.headerTitle
        return scOpenUrlWithWKWebViewVC
    }
    
    //MARK:- View Lifecycle Methods
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }
    
    //MARK:- Setup UI and navigation bar
    private func setupUI(){
        
        URLCache.shared.removeAllCachedResponses()
        
        webView.backgroundColor = SCColorUtil.scWhite.value
        webView.scrollView.delegate = self
        webView.sizeToFit()
        
        if let url = URL(string: urlString.validateAndEncodeUrl()){
            webView.load(URLRequest(url: url))
        }
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.width - 30)/2, y: (UIScreen.main.bounds.height - 64 - 30)/2, width: 30, height: 30))
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        webView.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        guard let navController = self.navigationController else { return }
        navController.navigationBar.barTintColor = .white
        SCNavigationBarUtil.customiseUiNavigationBarTransparent(navController, color: .white)
        let textAttributes = [NSAttributedString.Key.foregroundColor:SCColorUtil.scRedDefaultTheme.value]
        navController.navigationBar.titleTextAttributes = textAttributes
        self.title = headerTitle
        self.navigationItem.hidesBackButton = false
        let backBtn = SCNavigationBarUtil.getRedBackButtonInstance()
        backBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
    }
    
    //MARK:- Helper functions
    
    @objc private func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- WKWebView delegate and UIScrollView delegate

extension OpenUrlWithWKWebViewVC:WKNavigationDelegate, UIScrollViewDelegate{
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollY = scrollView.contentOffset.y
        if scrollY < 0{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

