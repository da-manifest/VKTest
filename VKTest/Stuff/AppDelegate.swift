//
//  AppDelegate.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager.delegate = self
        return true
    }
}

// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            var text = "Вход в "
            text += "\(region.center.latitude), "
            text += "\(region.center.longitude), "
            text += "\(region.radius)"
            _ = VKAPIService.postToWall(text: text).take(1).subscribe()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            var text = "Выход из "
            text += "\(region.center.latitude), "
            text += "\(region.center.longitude), "
            text += "\(region.radius)"
            _ = VKAPIService.postToWall(text: text).take(1).subscribe()
        }
    }
}
