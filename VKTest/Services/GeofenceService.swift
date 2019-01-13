//
//  GeofenceService.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 13/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

enum GeofenceError: Error {
    
    case deviceNotSupported
    case locationServicesDisabled
    case permissionInsufficient
}

final class GeofenceService {
    
    // MARK: - Variables
    private let locationManager = CLLocationManager()
    
    // MARK: - Public
    func startMonitoring(geofence: Geofence) throws {
        try checkLocationPermission()
        startMonitoring(region: makeRegionWith(geofence: geofence))
    }
    
    func stopMonitoring() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
}

// MARK: - Private
private extension GeofenceService {
    
    private func makeRegionWith(geofence: Geofence) -> CLCircularRegion {
        let center = CLLocationCoordinate2D(latitude: geofence.latitude,
                                            longitude: geofence.longitude)
        let region = CLCircularRegion(center: center,
                                      radius: geofence.radius,
                                      identifier: geofence.id)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    private func startMonitoring(region: CLCircularRegion) {
        locationManager.startMonitoring(for: region)
    }
    
    private func checkLocationPermission() throws {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            throw GeofenceError.deviceNotSupported
        }
        
        if !CLLocationManager.locationServicesEnabled() {
            throw GeofenceError.locationServicesDisabled
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied, .authorizedWhenInUse:
            throw GeofenceError.permissionInsufficient
        case .authorizedAlways:
            break
        }
    }
}
