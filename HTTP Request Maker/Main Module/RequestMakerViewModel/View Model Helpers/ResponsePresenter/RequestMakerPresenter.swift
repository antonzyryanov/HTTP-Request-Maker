//
//  RequestMakerResponsePresenter.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 18.06.2025.
//

import Foundation

class RequestMakerResponsePresenter {
    
    weak var view: RequestMakerViewModelToViewProtocol?
    
    init(view: RequestMakerViewModelToViewProtocol? = nil) {
        self.view = view
    }
    
    func processReceivedDataAndPresentIt(_ result: Result<Data, any Error>) {
        switch result {
        case .success(let data):
            do {
                let serverResponseModel = try JSONDecoder().decode(ServerResponseModel.self, from: data)
                if let dataValue = serverResponseModel.data {
                    switch dataValue {
                    case .null:
                        self.view?.process(event: .requestSuccessed(.init(status: String(serverResponseModel.status), message: serverResponseModel.message ?? "", responseData: "")))
                    case .string(let stringData):
                        self.view?.process(event: .requestSuccessed(.init(status: String(serverResponseModel.status), message: serverResponseModel.message ?? "", responseData: stringData)))
                    case .int(let intData):
                        self.view?.process(event: .requestSuccessed(.init(status: String(serverResponseModel.status), message: serverResponseModel.message ?? "", responseData: String(intData))))
                    case .jsonArray(let jsonArray):
                        var values: [Any] = []
                        for item in jsonArray {
                            values.append(item.value)
                        }
                        self.view?.process(event: .requestSuccessed(.init(status: String(serverResponseModel.status), message: serverResponseModel.message ?? "", responseData: "\(values)")))
                    case .jsonObject(let json):
                        var values: [String:Any] = [:]
                        for item in json {
                            values[item.key] = item.value
                        }
                        self.view?.process(event: .requestSuccessed(.init(status: String(serverResponseModel.status), message: serverResponseModel.message ?? "", responseData: "\(values)")))
                    }
                }
            } catch {
                let str = String(decoding: data, as: UTF8.self)
                self.view?.process(event: .requestSuccessed(.init(status: "", message: "The server responded but returned data in a format inappropriate for the client", responseData: "\(str)")))
            }
            
        case .failure(let error):
            for httpStatusCode in HTTPStatusCode.allCases {
                if (httpStatusCode.rawValue == error.errorCode) {
                    self.view?.process(event: .requestFailed(.init(status: "\(httpStatusCode.rawValue)", message: "Request failed", responseData: "")))
                    return
                }
            }
            self.view?.process(event: .requestFailed(.init(status: "-", message: "Request Failed", responseData: "-")))
        }
    }
    
}
