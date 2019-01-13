//
//  VKAuthViewController.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit

final class VKAuthViewController: ViewController, MainScreenRoute, LoginScreenRoute {
    
    // MARK: - Variables
    
    // MARK: - Outlets
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: - Init
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        
        webView.loadRequest(API.authRequest)
    }
    
    // MARK: - Configure UI
    override func configureUI() {
        webView.backgroundColor = .white
    }
    
    // MARK: - Configure Events
    override func configureEvents() {
        _ = VKAPIService.didReceiveValidToken
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
            self?.openMainScreen()
        })
        
        _ = VKAPIService.didCancelAuth
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.openLoginScreen()
            })
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
}

// MARK: - UIWebViewDelegate
extension VKAuthViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        showActivityIndicator()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideActivityIndicator()
        let urlString = webView.request?.url?.absoluteString
        VKAPIService.parseURLResponce(urlString)
    }
}
