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
    private let outputModelMaker = OutputModelMaker()
    
    init(view: RequestMakerViewModelToViewProtocol, model: RequestModelProtocol, worker: HTTPRequestWorkerProtocol?) {
        self.view = view
        self.model = model
        self.worker = worker
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
                guard let outputModel = outputModelMaker.makeOutputModel(model: self.model) else { return }
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
                                        var values: [Any] = []
                                        for item in jsonArray {
                                            values.append(item.value)
                                        }
                                        self.view.process(event: .requestSuccessed(.init(status: String(serverResponseModel.status), message: serverResponseModel.message ?? "", responseData: "\(values)")))
                                    case .jsonObject(let json):
                                        var values: [String:Any] = [:]
                                        for item in json {
                                            values[item.key] = item.value
                                        }
                                        self.view.process(event: .requestSuccessed(.init(status: String(serverResponseModel.status), message: serverResponseModel.message ?? "", responseData: "\(values)")))
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
