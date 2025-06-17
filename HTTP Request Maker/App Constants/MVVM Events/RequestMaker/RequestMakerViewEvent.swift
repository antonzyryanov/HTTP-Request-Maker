//
//  RequestMakerViewEvent.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import Foundation

enum RequestMakerViewEvent {
    case adressChanged(String)
    case securitySettingsChanged(Bool)
    case validationSettingsChanged(Bool)
    case httpMethodChanged(HTTPMethodType)
    case executeButtonTapped
    case httpHeadersChanged([String:String])
    case httpDataChanged([String:String])
}
