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
    
    private var networkWorker: HTTPRequestWorkerProtocol?
    private var validator = RequestMakerInputDataValidator()
    private let outputModelMaker = RequestMakerOutputModelMaker()
    private let presenter: RequestMakerResponsePresenter?
    
    init(view: RequestMakerViewModelToViewProtocol, model: RequestModelProtocol, worker: HTTPRequestWorkerProtocol?) {
        self.view = view
        self.model = model
        self.networkWorker = worker
        self.presenter = RequestMakerResponsePresenter(view: view)
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
    
    private func processChangeOf(_ address: (String)) {
        model.serverAdress = address
        if validator.urlValidated(urlString: address) {
            view.process(event: .adressValidationSucceded)
        } else {
            view.process(event: .adressValidationFailed)
        }
    }
    
    private func processHTTPDataChange(_ dict: ([String : String])) {
        let validationResult = validator.validate(dict["data"] ?? "", as: dict["data type"] ?? "")
        
        switch validationResult {
        case .success(let dataType):
            self.model.customData = (dataType,dict["data"] ?? "")
            view.process(event: .dataValidationSucceded)
        case .failure(let error):
            self.model.customData = (.Int,"Error")
            view.process(event: .dataValidationFailed(error))
        }
    }
    
    private func processExecuteButtonTapped() {
        if validator.urlValidated(urlString: model.serverAdress) {
            view.process(event: .adressValidationSucceded)
            let validationResult = validator.validate(model.customData.1, as: model.customData.0.rawValue)
            switch validationResult {
            case .success(let dataType):
                guard let outputModel = outputModelMaker.makeOutputModel(model: self.model) else {
                    self.view.process(event: .dataValidationFailed("Wrong adress or data type not specified. Possible Types: \'Int\',\'String\',\'JSON-array\',\'JSON-object\'"))
                    return
                }
                view.process(event: .makingRequest)
                networkWorker?.performRequestWith(model: outputModel, completion: { result in
                        self.presenter?.processReceivedDataAndPresentIt(result)
                })
            case .failure(let error):
                view.process(event: .dataValidationFailed(error))
            }
        } else {
            view.process(event: .adressValidationFailed)
        }
    }
    
}
