//
//  VKAPIService.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

final class VKAPIService {
    
    // MARK: - Variables
    static let didReceiveValidToken = PublishSubject<Void>()
    static let didCancelAuth  = PublishSubject<Void>()
    
    // MARK: - Public
    static func parseURLResponce(_ urlString: String?) {
        guard let urlString = urlString else { return }
        let fixedString = urlString.replacingOccurrences(of: "#", with: "?")
        if let urlComponents = URLComponents(string: fixedString) {
            if let token = urlComponents.queryItems?.first(where: { $0.name == "access_token" })?.value {
                KeychainService.save(token: token)
                VKAPIService.didReceiveValidToken.onNext(())
            }
            
            if urlComponents.queryItems?.first(where: { $0.name == "error" })?.value != nil {
                VKAPIService.didCancelAuth.onNext(())
            }
        }
    }
    
    static func logout() {
        KeychainService.deleteToken()
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies!
        {
            if cookie.domain.contains(".vk.com")
            {
                cookieJar.deleteCookie(cookie)
            }
        }
    }

    static func checkToken() -> Observable<Void> {
        var urlComponents = URLComponents()
        urlComponents.path = "/account.getInfo"
        return API.perform(method: urlComponents).flatMap {
            json -> Observable<Void> in
            if let error = APIError(json: json) {
                KeychainService.deleteToken()
                return Observable.error(error)
            } else {
                return Observable.just(())
            }
        }
    }
    
    static func postToWall(text: String, coordinate: CLLocationCoordinate2D? = nil, attachmentID: String? = nil) -> Observable<Void> {
        var urlComponents = URLComponents()
        urlComponents.path = "/wall.post"
        let message = URLQueryItem(name: "message", value: text)
        var queryItems = [message]
        if let coordinate = coordinate {
            let lat = URLQueryItem(name: "lat",
                                   value: "\(coordinate.latitude)")
            let long = URLQueryItem(name: "long",
                                    value: "\(coordinate.longitude)")
            queryItems.append(contentsOf: [lat, long])
        }
        if let attachmentID = attachmentID {
            let attachments = URLQueryItem(name: "attachments",
                                           value: attachmentID)
            queryItems.append(attachments)
        }
        urlComponents.queryItems = queryItems
        
        return API.perform(method: urlComponents).flatMap {
            json -> Observable<Void> in
            if let error = APIError(json: json) {
                return Observable.error(error)
            } else {
                return Observable.just(())
            }
        }
    }
    
}

// MARK: - Private
private extension VKAPIService {
    
    static func getUploadURL() -> Observable<String> {
        var urlComponents = URLComponents()
        urlComponents.path = "/docs.getUploadServer"
        return API.perform(method: urlComponents).flatMap { json -> Observable<String> in
            if let error = APIError(json: json) {
                return Observable.error(error)
            } else {
                if let url = json.dictionary?["response"]?["upload_url"].string {
                    return Observable.just(url)
                } else {
                    return Observable.error(APIError.unknown)
                }
            }
        }
    }
    
    static func upload(data: Data, name: String) -> Observable<String> {
        return VKAPIService.getUploadURL().flatMap { url -> Observable<String> in
            return API.performMultipart(url: url,
                                        data: data,
                                        mimeType: "audio/m4a",
                                        fileName: name).flatMap { json -> Observable<String> in
                                            print(json)
                                            if let error = APIError(json: json) {
                                                return Observable.error(error)
                                            } else {
                                                if let file = json.dictionary?["file"]?.string {
                                                    return Observable.just(file)
                                                } else {
                                                    return Observable.error(APIError.unknown)
                                                }
                                            }
            }
        }
    }
}
