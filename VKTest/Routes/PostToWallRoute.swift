//
//  PostToWallRoute.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit

protocol PostToWallRoute {
    
    func openPostToWallScreen()
}

extension PostToWallRoute where Self: UIViewController {
    
    func openPostToWallScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostToWallViewController")
        DispatchQueue.main.async { [weak self] in
            self?.show(vc, sender: nil)
        }
    }
}
