//
//  Geofence.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 13/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import Foundation

final class Geofence {
    
    // MARK: - Variables
    let id: String
    let latitude: Double
    let longitude: Double
    let radius: Double
    
    // MARK: - Init
    init(id: String, latitude: Double, longitude: Double, radius: Double) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
    }
}
