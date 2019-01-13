//
//  UIViewController.swift
//  tabtracker
//
//  Created by Maksim Khozyashev on 03/08/2018.
//  Copyright © 2018 ruslink. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, message: String? = nil, closeActionTitle: String? = "OK", preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction]? = nil) {
        UIAlertController.showAlert(title: title,
                                    message: message,
                                    closeActionTitle: closeActionTitle,
                                    preferredStyle: preferredStyle,
                                    actions: actions)
    }
}
