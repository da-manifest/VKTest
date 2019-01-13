//
//  KeychainService.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import Foundation
import Security

private struct Constants {
    
    static let service = "testAppTokenService"
    static let account = "testAppAccount"
    
    struct KeyChain {
        
        static let kSecClassValue = NSString(format: kSecClass)
        static let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
        static let kSecValueDataValue = NSString(format: kSecValueData)
        static let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
        static let kSecAttrServiceValue = NSString(format: kSecAttrService)
        static let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
        static let kSecReturnDataValue = NSString(format: kSecReturnData)
        static let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)
    }
}

final class KeychainService {
    
    // MARK: - Public
    static func save(token: String) {
        save(service: Constants.service, data: token)
    }
    
    static func loadToken() -> String? {
        return load(service: Constants.service)
    }
    
    static func deleteToken() {
        return delete(service: Constants.service)
    }
}

// MARK: - Private
private extension KeychainService {
    
    static func save(service: String, data: String) {
        if let dataFromString = data.data(using: String.Encoding.utf8,
                                          allowLossyConversion: false) {
            let objects: [Any] = [Constants.KeyChain.kSecClassGenericPasswordValue,
                                  service,
                                  Constants.account,
                                  dataFromString]
            let keys = [Constants.KeyChain.kSecClassValue,
                        Constants.KeyChain.kSecAttrServiceValue,
                        Constants.KeyChain.kSecAttrAccountValue,
                        Constants.KeyChain.kSecValueDataValue]
            let keychainQuery = NSMutableDictionary(objects: objects,
                                                    forKeys: keys)
            SecItemDelete(keychainQuery as CFDictionary)
            SecItemAdd(keychainQuery as CFDictionary, nil)
        }
    }
    
    static func load(service: String) -> String? {
        let objects: [Any] = [Constants.KeyChain.kSecClassGenericPasswordValue,
                              service,
                              Constants.account,
                              kCFBooleanTrue,
                              Constants.KeyChain.kSecMatchLimitOneValue]
        let keys = [Constants.KeyChain.kSecClassValue,
                    Constants.KeyChain.kSecAttrServiceValue,
                    Constants.KeyChain.kSecAttrAccountValue,
                    Constants.KeyChain.kSecReturnDataValue,
                    Constants.KeyChain.kSecMatchLimitValue]
        let keychainQuery = NSMutableDictionary(objects: objects,
                                                forKeys: keys)
        var dataTypeRef :AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String?
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData,
                                            encoding: String.Encoding.utf8)
            }
        }
        return contentsOfKeychain
    }
    
    static func delete(service: String) {
        let objects: [Any] = [Constants.KeyChain.kSecClassGenericPasswordValue,
                              service,
                              Constants.account]
        let keys = [Constants.KeyChain.kSecClassValue,
                    Constants.KeyChain.kSecAttrServiceValue,
                    Constants.KeyChain.kSecAttrAccountValue]
        let keychainQuery = NSMutableDictionary(objects: objects,
                                                forKeys: keys)
        SecItemDelete(keychainQuery as CFDictionary)
    }
}
