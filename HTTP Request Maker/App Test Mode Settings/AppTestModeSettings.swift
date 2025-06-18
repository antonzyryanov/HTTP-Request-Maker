//
//  AppTestModeSettings.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

class AppTestModeSettings {
    var isMockNetworkLayerOn = true
    var mockServerResponseDelayTime: Double = 4.0
    var mockRequestCanFail = false
    var mockSuccessfullServerResponsesConfiguration: MockSuccessfullServerResponsesConfiguration =
        .notSuitableForTheClient
}

enum MockSuccessfullServerResponsesConfiguration {
    case suitableForTheClient
    case notSuitableForTheClient
    case bothSuitableAndNotSuitableForTheClient
}
