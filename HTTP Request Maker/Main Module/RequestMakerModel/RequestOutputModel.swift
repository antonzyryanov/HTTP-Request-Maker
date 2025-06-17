//
//  RequestOutputModel.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import Foundation

struct RequestOutputModel: RequestOutputModelProtocol {
    var methodType: HTTPMethodType
    var serverAdress: String
    var isConnectionSecure: Bool
    var isSecurityValidationOn: Bool
    var customHeaders: [String:String]
    var customData: Any?
    var action: String
}
