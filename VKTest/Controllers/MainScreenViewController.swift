//
//  MainScreenViewController.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MainScreenViewController: ViewController, MainScreenViewController.Routes {
    
    typealias Routes = PostToWallRoute
        & AudioRecordRoute
        & GeofenceRoute
        & LoginScreenRoute
    
    // MARK: - Variables
    private let logoutButton = UIBarButtonItem()
    
    // MARK: - Outlets
    @IBOutlet weak var postToWallButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var geofenceButton: UIButton!
    
    // MARK: - Init
    
    // MARK: - Lifecycle
    
    // MARK: - Configure UI
    override func configureUI() {
        logoutButton.title = "Logout"
        self.navigationItem.setRightBarButton(logoutButton, animated: true)
    }
    
    // MARK: - Configure Events
    override func configureEvents() {
        _ = postToWallButton.rx.tap.takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.openPostToWallScreen()
            })
        
        _ = recordAudioButton.rx.tap.takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.openAudioRecordScreen()
            })
        
        _ = geofenceButton.rx.tap.takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.openGeofenceScreen()
            })
        
        _ = logoutButton.rx.tap.takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                VKAPIService.logout()
                self?.openLoginScreen()
            })
    }
    // MARK: - Actions
    
    // MARK: - Helpers
    
}
