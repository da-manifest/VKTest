//
//  VKAuthRoute.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit

protocol VKAuthRoute {
    
    func openVKAuthScreen()
}

extension VKAuthRoute where Self: UIViewController {
    
    func openVKAuthScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VKAuthViewController")
        DispatchQueue.main.async { [weak self] in
            self?.show(vc, sender: nil)
        }
    }
}
