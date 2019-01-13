//
//  AudioRecordRoute.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit

protocol AudioRecordRoute {
    
    func openAudioRecordScreen()
}

extension AudioRecordRoute where Self: UIViewController {
    
    func openAudioRecordScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AudioRecordViewController")
        DispatchQueue.main.async { [weak self] in
            self?.show(vc, sender: nil)
        }
    }
}
