//
//  GeofenceViewController.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

final class GeofenceViewController: ViewController {
    
    // MARK: - Variables
    let tapGesture = UITapGestureRecognizer()
    
    // MARK: - Outlets
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var unsubscribeButton: UIButton!
    @IBOutlet weak var latitudeTextField: NumericTextField!
    @IBOutlet weak var longitudeTextField: NumericTextField!
    @IBOutlet weak var radiusTextField: NumericTextField!
    
    // MARK: - Init
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Configure UI
    
    // MARK: - Configure Events
    override func configureEvents() {
        _ = subscribeButton.rx.tap.takeUntil(rx.deallocated)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.didTapSubscribeButton()
            })
        
        _ = unsubscribeButton.rx.tap.takeUntil(rx.deallocated)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.didTapUnsubscribeButton()
            })
        
        _ = tapGesture.rx.event.takeUntil(rx.deallocated)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.hideKeyBoard()
            })
    }
    
    // MARK: - Actions
    private func didTapSubscribeButton() {
        guard
            let latitude = getLatitude(),
            let longitude = getLongitude(),
            let radius = getRadius()
        else {
            showAlert(title: "Invalid value")
            return
        }
        
        let geofence = Geofence(id: "id",
                                latitude: latitude,
                                longitude: longitude,
                                radius: radius)
        do {
            try GeofenceService().startMonitoring(geofence: geofence)
        } catch GeofenceError.deviceNotSupported {
            showAlert(title: "Geofencing is not supported on device")
        } catch GeofenceError.locationServicesDisabled {
            showAlert(title: "Location services disabled")
        } catch GeofenceError.permissionInsufficient {
            showLocationAccessAlert()
        } catch let error {
            showAlert(title: APIError.description(error))
        }
    }
    
    private func didTapUnsubscribeButton() {
        GeofenceService().stopMonitoring()
    }
    
    private func hideKeyBoard() {
        for textField in view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
    }
    
    // MARK: - Helpers
    private func showLocationAccessAlert() {
        let settingsAction = UIAlertAction(title: "Settings",
                                           style: .default) { _ in
                                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                                UIApplication.shared.openURL(url)
                                            }
        }
        showAlert(title: "Location Always Allow required",
                  closeActionTitle: "Cancel",
                  actions: [settingsAction])
    }
    
    private func getLatitude() -> Double? {
        guard let value = getValueFrom(latitudeTextField.text) else {
            return nil
        }
        if value > 90 || value < -90 {
            return nil
        }
        return value
    }
    
    private func getLongitude() -> Double? {
        guard let value = getValueFrom(longitudeTextField.text) else {
            return nil
        }
        if value > 180 || value < -180 {
            return nil
        }
        return value
    }
    
    private func getRadius() -> Double? {
        guard let value = getValueFrom(radiusTextField.text) else {
            return nil
        }
        if value < 0 {
            return nil
        }
        return value
    }
    
    private func getValueFrom(_ text: String?) -> Double? {
        guard let text = text else { return nil }
        return Double(text)
    }
}
