//
//  AudioRecordViewController.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit
import AVFoundation
import AudioUnit
import RxSwift
import RxCocoa

final class AudioRecordViewController: ViewController {
    
    // MARK: - Variables
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    
    // MARK: - Outlets
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - Init
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            if #available(iOS 10.0, *) {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
            } else {
                // http://www.openradar.me/42382075
                AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"),
                                                        with: AVAudioSession.Category.playAndRecord)
            }
            try recordingSession.setActive(true)
            
        } catch {
            // failed to record
        }
    }
    
    // MARK: - Configure UI
    
    // MARK: - Configure Events
    override func configureEvents() {
        _ = recordButton.rx.controlEvent(.touchDown).takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.didTouchButton()
            })
        
        _ = recordButton.rx.controlEvent(.touchUpInside).takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.didReleaseButton()
            })
    }
    
    // MARK: - Actions
    private func didTouchButton() {
        checkMicPermission()
        startRecording()
    }
    
    private func didReleaseButton() {
        finishRecording(success: true)
    }
    
    // MARK: - Helpers
    private func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            let fileURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            do {
                let data = try Data(contentsOf: fileURL)
                
            } catch let error {
                showAlert(title: APIError.description(error))
            }
        } else {
            
        }
    }
    
    private func checkMicPermission() {
        switch recordingSession.recordPermission {
        case .undetermined:
            recordingSession.requestRecordPermission() { _ in }
        case .denied:
            showMicAccessAlert()
        case .granted:
            break
        }
    }
    
    private func showMicAccessAlert() {
        let settingsAction = UIAlertAction(title: "Settings",
                                           style: .default) { _ in
                                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                                UIApplication.shared.openURL(url)
                                            }
        }
        showAlert(title: "Mic permission required",
                  closeActionTitle: "Cancel",
                  actions: [settingsAction])
    }
}

// MARK: - AVAudioRecorderDelegate
extension AudioRecordViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
