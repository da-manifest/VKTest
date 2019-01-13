//
//  LoginScreenRoute.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit

protocol LoginScreenRoute {
    
    func openLoginScreen()
}

extension LoginScreenRoute where Self: UIViewController {
    
    func openLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        let navigationController = self.view.window?.rootViewController as! UINavigationController
        DispatchQueue.main.async {
            navigationController.setViewControllers([vc], animated: true)
        }
    }
}
