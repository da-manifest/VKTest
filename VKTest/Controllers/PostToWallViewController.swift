//
//  PostToWallViewController.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit
import RxSwift

final class PostToWallViewController: ViewController {
    
    // MARK: - Variables
    let tapGesture = UITapGestureRecognizer()
    
    // MARK: - Outlets
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Init
    
    // MARK: - Lifecycle
    
    // MARK: - Configure UI
    override func configureUI() {
        view.addGestureRecognizer(tapGesture)
        automaticallyAdjustsScrollViewInsets = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .white
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let borderColor = UIColor.init(red: 204/255,
                                       green: 204/255,
                                       blue: 204/255,
                                       alpha: 1)
        textView.layer.borderColor = borderColor.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5.0
    }
    
    // MARK: - Configure Events
    override func configureEvents() {
        _ = sendButton.rx.tap.takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.didTapSendButton()
            })
        
        _ = tapGesture.rx.event.takeUntil(rx.deallocated)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.hideKeyBoard()
            })
    }
    
    // MARK: - Actions
    private func didTapSendButton() {
        _ = VKAPIService.postToWall(text: textView.text)
            .takeUntil(rx.deallocated)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                }, onError: { [weak self] error in
                    self?.showAlert(title: APIError.description(error))
            })
    }
    
    private func hideKeyBoard() {
        textView.resignFirstResponder()
    }
    
    // MARK: - Helpers
    
}
