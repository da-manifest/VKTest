//
//  ViewController.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    // MARK: - Variables
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Outlets
    
    // MARK: - Init
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureActivityIndicator()
        configureUI()
        configureEvents()
    }
    
    // MARK: - Configure UI
    func configureUI() {}
    
    private func configureActivityIndicator() {
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        activityIndicator.center = CGPoint(x: view.frame.size.width / 2,
                                           y: view.frame.size.height / 2)
        view.addSubview(activityIndicator)
    }
    
    // MARK: - Configure Events
    func configureEvents() {}
    
    // MARK: - Actions
    func showActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Helpers    
    deinit {
        print("deinit")
    }
}
