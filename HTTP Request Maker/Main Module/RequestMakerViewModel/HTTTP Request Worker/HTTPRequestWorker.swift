//
//  HTTPRequestWorker.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

class HTTPRequestWorker: NSObject, HTTPRequestWorkerProtocol {
    
    func performRequestWith(model: RequestOutputModelProtocol, completion: @escaping (Result<Data, Error>) -> Void) {
        let scheme = model.isConnectionSecure ? "https" : "http"
        guard let url = URL(string: "\(scheme)://\(model.serverAdress)") else {
            print("[HTTPRequestWorker]: Invalid server adress")
            DispatchQueue.main.async {
                completion(.failure(NSError(domain:"Invalid server adress", code: 0, userInfo:nil)))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = model.methodType.rawValue
        
        for (headerField, headerValue) in model.customHeaders {
            request.addValue(headerValue, forHTTPHeaderField: headerField)
        }
        
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
        
        let sessionConfig = URLSessionConfiguration.default
        
        let session = createURLSession(model: model, sessionConfig: sessionConfig)

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
    
    private func createURLSession(model: RequestOutputModelProtocol,sessionConfig: URLSessionConfiguration) -> URLSession {
        if !model.isSecurityValidationOn {
            return URLSession(configuration: sessionConfig,delegate: self, delegateQueue: nil)
        } else {
            return URLSession(configuration: sessionConfig)
        }
    }
    
}


extension HTTPRequestWorker: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
       completionHandler(.useCredential, urlCredential)
    }
}
