//
//  MockHTTPRequestNetworkWorker.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

class MockHTTPRequestNetworkWorker: NSObject, HTTPRequestWorkerProtocol {
    
    var appTestModeSettings: AppTestModeSettings?
    
    func performRequestWith(model: RequestOutputModelProtocol, completion: @escaping (Result<Data, Error>) -> Void) {
        
        var delayTime: Double = 5.0
        
        if let appTestModeSettings = appTestModeSettings {
            delayTime = appTestModeSettings.mockServerResponseDelayTime
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            self.generateRandomFakeResponse(completion: completion)
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
            
        } else {
            
        }
    }
    
}
