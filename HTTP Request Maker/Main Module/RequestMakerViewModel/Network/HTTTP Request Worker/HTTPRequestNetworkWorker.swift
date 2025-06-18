//
//  HTTPRequestNetworkWorker.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

class HTTPRequestNetworkWorker: HTTPRequestWorkerProtocol {
    
    func performRequestWith(model: RequestOutputModelProtocol, completion: @escaping (Result<Data, Error>) -> Void) {
        let scheme = model.isConnectionSecure ? "https" : "http"
        guard let url = URL(string: "\(scheme)://\(model.serverAdress)") else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain:"Invalid server adress", code: 0, userInfo:nil)))
            }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = model.methodType.rawValue
        setupHeaders(model, &request)
        setupRequestBody(model, &request, completion)
        let sessionConfig = URLSessionConfiguration.default
        let session = createURLSession(model: model, sessionConfig: sessionConfig)
        startDataTask(session, request, completion)
    }
    
    private func setupHeaders(_ model: any RequestOutputModelProtocol, _ request: inout URLRequest) {
        for (headerField, headerValue) in model.customHeaders {
            request.addValue(headerValue, forHTTPHeaderField: headerField)
        }
    }
    
    private func setupRequestBody(_ model: any RequestOutputModelProtocol, _ request: inout URLRequest, _ completion: @escaping (Result<Data, any Error>) -> Void) {
        if model.methodType != .GET {
            let data = model.customData
            let bodyDict: [String: Any?] = [
                "action": model.action,
                "data": data
            ]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyDict, options: [])
            } catch {
                print("[HTTPRequestWorker]: Error serializing JSON: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
        }
    }
    
    private func createURLSession(model: RequestOutputModelProtocol,sessionConfig: URLSessionConfiguration) -> URLSession {
        if !model.isSecurityValidationOn {
            return URLSession(configuration: sessionConfig,delegate: IgnoringCerificatesURLSessionDelegate(), delegateQueue: nil)
        } else {
            return URLSession(configuration: sessionConfig)
        }
    }
    
    private func startDataTask(_ session: URLSession, _ request: URLRequest, _ completion: @escaping (Result<Data, any Error>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } else {
                let noDataError = NSError(domain: "HTTPError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                DispatchQueue.main.async {
                    completion(.failure(noDataError))
                }
                
            }
        }
        task.resume()
    }
    
}


class IgnoringCerificatesURLSessionDelegate: NSObject, URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // обработка ошибки валидации защищенного соединения - реализовано игнорирование проверки сертификата при параметре модели запроса isSecurityValidationOn = false
        completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
