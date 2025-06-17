//
//  RequestMakerContract.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import Foundation

protocol RequestModelProtocol {
    var serverAdress: String { get set }
    var methodType: HTTPMethodType { get set }
    var isConnectionSecure: Bool { get set }
    var isSecurityValidationOn: Bool { get set }
    var customHeaders: [String:String] { get set }
    var customData: (PossibleDataTransferTypes,String) { get set }
    var action: String { get set }
}

protocol RequestOutputModelProtocol {
    var serverAdress: String { get set }
    var methodType: HTTPMethodType { get set }
    var isConnectionSecure: Bool { get set }
    var isSecurityValidationOn: Bool { get set }
    var customHeaders: [String:String] { get set }
    var customData: Any? { get set }
    var action: String { get set }
}

protocol RequestViewProtocol {
    func update()
}

protocol RequestMakerViewToViewModelProtocol: AnyObject {
    func process(event: RequestMakerViewEvent)
}

protocol RequestMakerViewModelToViewProtocol: AnyObject {
    func process(event: RequestMakerViewModelEvent)
}



