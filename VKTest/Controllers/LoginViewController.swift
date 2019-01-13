//
//  LoginViewController.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit
import RxSwift

final class LoginViewController: ViewController, VKAuthRoute, MainScreenRoute {

    // MARK: - Variables
    
    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Init
    
    // MARK: - Lifecycle
    
    // MARK: - Configure UI
    override func configureUI() {
        loginButton.isHidden = true
        showActivityIndicator()
    }
    
    // MARK: - Configure Events
    override func configureEvents() {
        _ = VKAPIService.checkToken()
            .takeUntil(rx.deallocated)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.hideActivityIndicator()
                self?.openMainScreen()
                }, onError: { [weak self] error in
                    self?.hideActivityIndicator()
                    self?.showLoginButton()
            })

        _ = loginButton.rx.tap.takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.openVKAuthScreen()
            })
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    private func showLoginButton() {
        DispatchQueue.main.async { [weak self] in
            self?.loginButton.isHidden = false
        }
    }
}
