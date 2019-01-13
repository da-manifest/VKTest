//
//  MainScreenRoute.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit

protocol MainScreenRoute {
    
    func openMainScreen()
}

extension MainScreenRoute where Self: UIViewController {
    
    func openMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController")
        DispatchQueue.main.async { [weak self] in
            self?.show(vc, sender: nil)
        }
    }
}
