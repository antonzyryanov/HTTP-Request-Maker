//
//  HTTP_Request_MakerTests.swift
//  HTTP Request MakerTests
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import XCTest
@testable import HTTP_Request_Maker

final class HTTP_Request_MakerTests: XCTestCase {
    
    func test_WhenServerSendsDifferentTypes_ThenAppSuccessfullyDecodingThem() throws {
        let appTestModeSettings = AppTestModeSettings()
        appTestModeSettings.mockRequestCanFail = false
        appTestModeSettings.mockSuccessfullServerResponsesConfiguration = .suitableForTheClient
        let mockHTTPRequestWorker = MockHTTPRequestNetworkWorker()
        mockHTTPRequestWorker.appTestModeSettings = appTestModeSettings
        let mockModel = RequestOutputModel(methodType: .POST, serverAdress: "google.com", isConnectionSecure: true, isSecurityValidationOn: true, customHeaders: ["Content-Type":"application/json"], action: "Action")
        mockHTTPRequestWorker.performRequestWith(model: mockModel) { result in
            switch result {
            case .success(let data):
                do {
                    let serverResponseModel = try JSONDecoder().decode(ServerResponseModel.self, from: data)
                    XCTAssertNotNil(serverResponseModel)
                } catch {
                    XCTFail()
                }
            case .failure(_):
                XCTFail()
            }
        }
    }
    
}
