//
//  API.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 12/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

private struct Constants {
    
    static let timeout: Double = 30
    
    static let apiVersion = "5.92"
    
    struct AuthURL {
        static let host = "oauth.vk.com"
        static let path = "/authorize"
    }
    static let clientID = "6816316"
    static let redirectURL = "https://oauth.vk.com/blank.html"
    static let scope = "wall, docs"
    
    struct MainURL {
        static let host = "api.vk.com"
        static let path = "/method"
    }
}

final class API {
    
    typealias Response = Observable<JSON>
    
    static func perform(method: URLComponents) -> Response {
        let request = createRequest(method, timeoutInterval: Constants.timeout)
        return performRequest(request).map { $0 }
    }
    
    static func performMultipart(url: String,
                                 data: Data,
                                 mimeType: String,
                                 fileName: String) -> Response {
        var headers = [String: String]()
        let boundary = "Boundary-\(NSUUID().uuidString)"
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        
        let body = createBodyForUpload(data: data,
                                       ofType: mimeType,
                                       fileName: fileName,
                                       boundary: boundary)
        
        var request: URLRequest = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = Constants.timeout
        request.httpMethod = "POST"
        request.httpBody = body
        return performRequest(request).map { $0 }
    }
}

// MARK: - Auth Request
extension API {
    
    static var authRequest: URLRequest {
        return URLRequest(url: authURLComponents.url!,
                          cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                          timeoutInterval: Constants.timeout)
        
    }
    
    private static var authURLComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constants.AuthURL.host
        urlComponents.path = Constants.AuthURL.path
        let clientID = URLQueryItem(name: "client_id", value: Constants.clientID)
        let display = URLQueryItem(name: "display", value: "mobile")
        let redirectURI = URLQueryItem(name: "redirect_uri", value: Constants.redirectURL)
        let scope = URLQueryItem(name: "scope", value: Constants.scope)
        let responceType = URLQueryItem(name: "response_type", value: "token")
        let apiVersion = URLQueryItem(name: "v", value: Constants.apiVersion)
        urlComponents.queryItems = [clientID,
                                    display,
                                    redirectURI,
                                    scope,
                                    responceType,
                                    apiVersion]
        return urlComponents
    }
}

// MARK: - Private
private final class APIURLSession: URLSession, URLSessionDelegate {
    static let apiShared = APIURLSession()
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration,
                                 delegate: self,
                                 delegateQueue: nil)
        
        return session.dataTask(with: request,
                                completionHandler: completionHandler)
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential,
                          URLCredential(trust: challenge.protectionSpace.serverTrust!)
        )
    }
}

private extension API {
    
    static var apiMainURLComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constants.MainURL.host
        urlComponents.path = Constants.MainURL.path
        let apiVersion = URLQueryItem(name: "v", value: Constants.apiVersion)
        let token = URLQueryItem(name: "access_token",
                                 value: KeychainService.loadToken() ?? "")
        urlComponents.queryItems = [apiVersion, token]
        return urlComponents
    }
    
    static func performRequest(_ request: URLRequest) -> Response {
        let observable = APIURLSession.apiShared.rx.response(request: request)
            .flatMapLatest { (response, data) -> Response in
                let parsed = parse(data: data, response: response)
                return parsed
            }.catchError { error in
                let apiError = APIError.get(byError: error)
                return Observable.error(apiError)
        }
        
        return observable
    }
    
    static func createRequest(_ method: URLComponents, timeoutInterval: TimeInterval) -> URLRequest {
        var urlComponents = apiMainURLComponents
        urlComponents.path = apiMainURLComponents.path + method.path
        if let queryItems = method.queryItems {
            urlComponents.queryItems?.append(contentsOf: queryItems)
        }
        var request: URLRequest = URLRequest(url: urlComponents.url!)
        request.timeoutInterval = timeoutInterval
        request.httpMethod = "GET"
        return request
    }
    
    static func parse(data: Data, response: HTTPURLResponse) -> Response {
        do {
            let json = try JSON(data: data)
            if let error = APIError(json: json) {
                return Observable.error(error)
            }
            return Observable.just(json)
        } catch let error {
            return Observable.error(error)
        }
    }
    
    static func createBodyForUpload(data: Data,
                                    ofType mimeType: String,
                                    fileName: String,
                                    boundary: String) -> Data? {
        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")

        return body
    }
}
