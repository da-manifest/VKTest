//
//  UIAlertController.swift
//  tabtracker
//
//  Created by Maksim Khozyashev on 26/12/2018.
//  Copyright © 2018 ruslink. All rights reserved.
//

import UIKit

private final class ClearViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.isStatusBarHidden
    }
}

extension UIAlertController {
    
    static func showAlert(title: String?, message: String? = nil, closeActionTitle: String? = "OK", preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction]? = nil) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: preferredStyle)
        var allActions = [UIAlertAction]()
        if let closeTitle = closeActionTitle {
            allActions.append(UIAlertAction(title: closeTitle, style: .cancel))
        }
        allActions.append(contentsOf: actions ?? [])
        allActions.forEach { alertController.addAction($0) }
        
        let vc = ClearViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = vc
        window.backgroundColor = .clear
        window.windowLevel = .alert
        
        DispatchQueue.main.async {
            window.makeKeyAndVisible()
            vc.present(alertController, animated: true)
        }
    }
}
