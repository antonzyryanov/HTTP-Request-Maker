//
//  MockHTTPRequestWorker.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

class MockHTTPRequestWorker: NSObject, HTTPRequestWorkerProtocol {
    
    var appTestModeSettings: AppTestModeSettings?
    
    func performRequestWith(model: RequestOutputModelProtocol, completion: @escaping (Result<Data, Error>) -> Void) {
        
        var delayTime: Double = 5.0
        
        if let appTestModeSettings = appTestModeSettings {
            delayTime = appTestModeSettings.mockServerResponseDelayTime
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            self.generateRandomFakeResponse(completion: completion)
        }
        return
        
        let scheme = model.isConnectionSecure ? "https" : "http"
        guard let url = URL(string: "\(scheme)://\(model.serverAdress)") else {
            print("[HTTPRequestWorker]: Invalid server adress")
            completion(.failure(NSError(domain:"Invalid server adress", code: 0, userInfo:nil)))
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
                completion(.failure(error))
                return
            }
        }
        
        let sessionConfig = URLSessionConfiguration.default
        
        let session = createURLSession(model: model, sessionConfig: sessionConfig)

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                completion(.success(data))
            } else {
                let noDataError = NSError(domain: "HTTPError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
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
    
    private func generateRandomFakeResponse(completion: @escaping (Result<Data, Error>) -> Void) {
        
        if appTestModeSettings?.mockRequestCanFail ?? false {
            let isRequestFailed = Bool.random()
            if isRequestFailed {
                let badResponsesStatusCodes = HTTPStatusCode.allCases.filter { statusCode in
                    (399<statusCode.rawValue) && (600>statusCode.rawValue)
                }
                guard let randomResponseStatusCode = badResponsesStatusCodes.randomElement() else { return }
                guard let randomHTTPStatusCode = HTTPStatusCode.allCases.randomElement() else { return }
                completion(.failure(NSError(domain: "Response error", code: randomResponseStatusCode.rawValue)))
                return
            }
        }
        
        var usedMockServerResponsesJSONSIndexesRange: Range<Int> = 1..<11
        
        switch appTestModeSettings?.mockSuccessfullServerResponsesConfiguration {
        case .suitableForTheClient:
            usedMockServerResponsesJSONSIndexesRange = 1..<11
        case .notSuitableForTheClient:
            usedMockServerResponsesJSONSIndexesRange = 11..<16
        case .bothSuitableAndNotSuitableForTheClient:
            usedMockServerResponsesJSONSIndexesRange = 1..<16
        case nil:
            usedMockServerResponsesJSONSIndexesRange = 1..<11
        }
        
        let randomMockIndex = Int.random(in: usedMockServerResponsesJSONSIndexesRange)
        if let path = Bundle.main.path(forResource: "ResponseMock\(randomMockIndex)", ofType: "json")
        {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
                completion(.success(jsonData as Data))
            } catch let error {
                completion(.failure(NSError(domain: "Server did not respond", code: -1)))
                print(error.localizedDescription)
            }
            
        }
    }
    
}


extension MockHTTPRequestWorker: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
       completionHandler(.useCredential, urlCredential)
    }
}
