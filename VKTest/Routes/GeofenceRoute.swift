//
//  GeofenceRoute.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit

protocol GeofenceRoute {
    
    func openGeofenceScreen()
}

extension GeofenceRoute where Self: UIViewController {
    
    func openGeofenceScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GeofenceViewController")
        DispatchQueue.main.async { [weak self] in
            self?.show(vc, sender: nil)
        }
    }
}
