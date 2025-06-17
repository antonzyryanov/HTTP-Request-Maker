//
//  RequestMakerViewModelEvent.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import Foundation

enum RequestMakerViewModelEvent{
    case makingRequest
    case requestSuccessed(ServerResponsePresentationModel)
    case requestFailed(String)
    case adressValidationSucceded
    case adressValidationFailed
    case dataValidationFailed(String)
    case dataValidationSucceded
}
