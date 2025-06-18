//
//  RequestMakerOutputModelMaker.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 18.06.2025.
//

import Foundation

class RequestMakerOutputModelMaker {
    
    func makeOutputModel(model: RequestModelProtocol) -> RequestOutputModelProtocol? {
        switch model.customData.0 {
        case .Null:
            return RequestOutputModel(methodType: model.methodType, serverAdress: model.serverAdress, isConnectionSecure: model.isConnectionSecure, isSecurityValidationOn: model.isSecurityValidationOn, customHeaders: model.customHeaders, customData: nil, action: model.action)
        case .String:
            return RequestOutputModel(methodType: model.methodType, serverAdress: model.serverAdress, isConnectionSecure: model.isConnectionSecure, isSecurityValidationOn: model.isSecurityValidationOn, customHeaders: model.customHeaders, customData: model.customData.1, action: model.action)
        case .Int:
            let intCustomData = Int(model.customData.1)
            return RequestOutputModel(methodType: model.methodType, serverAdress: model.serverAdress, isConnectionSecure: model.isConnectionSecure, isSecurityValidationOn: model.isSecurityValidationOn, customHeaders: model.customHeaders, customData: intCustomData as Any, action: model.action)
        case .JSON:
            let stringData = model.customData.1
            if let data = stringData.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        return RequestOutputModel(methodType: model.methodType, serverAdress: model.serverAdress, isConnectionSecure: model.isConnectionSecure, isSecurityValidationOn: model.isSecurityValidationOn, customHeaders: model.customHeaders, customData: json, action: model.action)
                    }
                } catch {
                    return nil
                }
            }
        case .JSONArray:
            let stringData = model.customData.1
            if let data = stringData.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        return RequestOutputModel(methodType: model.methodType, serverAdress: model.serverAdress, isConnectionSecure: model.isConnectionSecure, isSecurityValidationOn: model.isSecurityValidationOn, customHeaders: model.customHeaders, customData: json, action: model.action)
                    }
                } catch {
                    return nil
                }
            }
        }
        return nil
    }
    
}
