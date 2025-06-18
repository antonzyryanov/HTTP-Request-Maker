//
//  RequestMakerVCCustomDelegatesHandler.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 18.06.2025.
//

import Foundation
import UIKit

class RequestMakerVCCustomDelegatesHandler {
    
    private weak var viewModel: RequestMakerViewToViewModelProtocol?
    
    init(viewModel: RequestMakerViewToViewModelProtocol? = nil) {
        self.viewModel = viewModel
    }
    
    func handleToggleOf(key: CustomSwitchOption, value: Bool) {
        switch key {
        case .isConnectionSecure:
            viewModel?.process(event: .securitySettingsChanged(value))
        case .isSecurityValidationOn:
            viewModel?.process(event: .validationSettingsChanged(value))
        }
    }
        
    func handeUpdateOf(dictionary: [String : String], dictType: CustomDictionaryOption) {
        switch dictType {
        case .httpHeaders:
            viewModel?.process(event: .httpHeadersChanged(dictionary))
        case .httpData:
            viewModel?.process(event: .httpDataChanged(dictionary))
        }
    }
        
    
}
