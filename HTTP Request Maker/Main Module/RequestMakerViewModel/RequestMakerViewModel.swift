//
//  MainViewModel.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import Foundation
import UIKit

class RequestMakerViewModel {
    
    private var view: RequestMakerViewModelToViewProtocol
    private var model: RequestModelProtocol
    private var worker: HTTPRequestWorkerProtocol?
    
    private var validator = RequestMakerValidator()
    
    init(view: RequestMakerViewModelToViewProtocol, model: RequestModelProtocol, worker: HTTPRequestWorkerProtocol?) {
        self.view = view
        self.model = model
        self.worker = worker
    }
    
    private func makeOutputModel() -> RequestOutputModelProtocol? {
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

extension RequestMakerViewModel: RequestMakerViewToViewModelProtocol {
    
    func process(event: RequestMakerViewEvent) {
        switch event {
        case .adressChanged(let adress):
            processChangeOf(adress)
        case .securitySettingsChanged(let isConnectionSecure):
            model.isConnectionSecure = isConnectionSecure
        case .validationSettingsChanged(let isSecurityValidationOn):
            model.isSecurityValidationOn = isSecurityValidationOn
        case .httpMethodChanged(let hTTPMethodType):
            model.methodType = hTTPMethodType
        case .executeButtonTapped:
            processExecuteButtonTapped()
        case .httpHeadersChanged(let headers):
            self.model.customHeaders = headers
        case .httpDataChanged(let dict):
            guard dict.count > 1
            else { return }
            processHTTPDataChange(dict)

            
        }
    }
    
    private func processChangeOf(_ adress: (String)) {
        if validator.urlValidated(urlString: adress) {
            model.serverAdress = adress
            view.process(event: .adressValidationSucceded)
        } else {
            view.process(event: .adressValidationFailed)
        }
    }
    
    private func processHTTPDataChange(_ dict: ([String : String])) {
        let dataContainer = dict["data"]
        let dataTypeContainer = dict["data type"]
        let validationResult = validator.validate(dict["data"] ?? "", as: dict["data type"] ?? "")
        switch validationResult {
        case .success(let dataType):
            self.model.customData = (dataType,dict["data"] ?? "")
            view.process(event: .dataValidationSucceded)
        case .failure(let error):
            view.process(event: .dataValidationFailed(error))
        }
    }
    
    private func processExecuteButtonTapped() {
        view.process(event: .makingRequest)
        if validator.urlValidated(urlString: model.serverAdress) {
            view.process(event: .adressValidationSucceded)
            let validationResult = validator.validate(model.customData.1, as: model.customData.0.rawValue)
            switch validationResult {
            case .success(let dataType):
                guard let outputModel = makeOutputModel() else { return }
                    worker?.performRequestWith(model: outputModel, completion: { result in
                        switch result {
                        case .success(let data):
                            do {
                                let serverResponseModel = try JSONDecoder().decode(ServerResponseModel.self, from: data)
                                if let dataValue = serverResponseModel.data {
                                    switch dataValue {
                                    case .null:
                                        self.view.process(event: .requestSuccessed(.init(status: String(serverResponseModel.status), message: serverResponseModel.message ?? "", responseData: "")))
                                    case .string(let stringData):
                                        self.view.process(event: .requestSuccessed(.init(status: String(serverResponseModel.status), message: serverResponseModel.message ?? "", responseData: stringData)))
                                    case .int(let intData):
                                        self.view.process(event: .requestSuccessed(.init(status: String(serverResponseModel.status), message: serverResponseModel.message ?? "", responseData: String(intData))))
                                    case .jsonArray(let jsonArray):
                                        self.view.process(event: .requestSuccessed(.init(status: String(serverResponseModel.status), message: serverResponseModel.message ?? "", responseData: "\(jsonArray)")))
                                    case .jsonObject(let json):
                                        self.view.process(event: .requestSuccessed(.init(status: String(serverResponseModel.status), message: serverResponseModel.message ?? "", responseData: "\(json)")))
                                    }
                                }
                            } catch {
                                self.view.process(event: .requestFailed("Request failed"))
                            }
                            
                        case .failure(let error):
                            self.view.process(event: .requestFailed(error.localizedDescription))
                        }
                    })
               
                
            case .failure(let error):
                view.process(event: .dataValidationFailed(error))
            }
        } else {
            view.process(event: .adressValidationFailed)
        }
    }
    
    
}
