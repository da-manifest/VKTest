//
//  Data.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 13/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import Foundation

extension Data {
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8, allowLossyConversion: false) {
            append(data)
        }
    }
}
