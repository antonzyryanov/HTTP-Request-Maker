//
//  RequestMakerVCViewModelEventsUIHandler.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 18.06.2025.
//

import Foundation
import UIKit

class RequestMakerVCViewModelEventsUIHandler {
    
    private weak var viewsContainer: RequestMakerViewsContainer?
    
    init(viewsContainer: RequestMakerViewsContainer) {
        self.viewsContainer = viewsContainer
    }
    
    func handleValidationSuccess() {
        self.viewsContainer?.responseErrorLabel.text = "Error: -"
        self.viewsContainer?.responseErrorLabel.textColor = .black
        self.viewsContainer?.serverAddressTextField.textColor = .black
    }
    
    func handleRequestSuccessEvent(_ serverResponse: (ServerResponsePresentationModel)) {
        self.viewsContainer?.responseErrorLabel.text = "Message: \(serverResponse.message)"
        self.viewsContainer?.responseStatusLabel.text = "Status: \(serverResponse.status)"
        self.viewsContainer?.responseLabel.text = "Response:\n\(serverResponse.responseData)"
        self.viewsContainer?.serverResponseLabel.textColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
        self.viewsContainer?.responseLabel.textColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
        self.viewsContainer?.responseErrorLabel.textColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
        self.viewsContainer?.responseStatusLabel.textColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewsContainer?.serverResponseLabel.textColor = .black
            self.viewsContainer?.responseLabel.textColor = .black
            self.viewsContainer?.responseErrorLabel.textColor = .black
            self.viewsContainer?.responseStatusLabel.textColor = .black
        }
    }
    
    func handleRequestFailureEvent(_ response: ServerResponsePresentationModel) {
        self.viewsContainer?.responseErrorLabel.text = "Error: \(response.message)"
        self.viewsContainer?.responseStatusLabel.text = "Status: \(response.status)"
        self.viewsContainer?.serverResponseLabel.textColor = .red
        self.viewsContainer?.responseLabel.textColor = .red
        self.viewsContainer?.responseErrorLabel.textColor = .red
        self.viewsContainer?.responseStatusLabel.textColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewsContainer?.serverResponseLabel.textColor = .black
            self.viewsContainer?.responseLabel.textColor = .black
            self.viewsContainer?.responseErrorLabel.textColor = .black
            self.viewsContainer?.responseStatusLabel.textColor = .black
        }
    }
    
    func handleAddressValidationFailureEvent() {
        self.viewsContainer?.responseErrorLabel.text = "Error: Validation Error\nWrong server adress format"
        self.viewsContainer?.responseErrorLabel.textColor = .red
        self.viewsContainer?.serverAddressTextField.textColor = .red
    }
    
    func handleDataValidationFailure(_ error: (String)) {
        self.viewsContainer.responseErrorLabel.text = "Error: \(error)"
        self.viewsContainer.responseErrorLabel.textColor = .red
    }
    
}
