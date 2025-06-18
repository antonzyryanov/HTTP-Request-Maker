//
//  MainViewController.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import UIKit
import SnapKit

class RequestMakerViewController: VCWithCustomTabBar {
    
    var viewModel: RequestMakerViewToViewModelProtocol?
    
    private let viewsContainer = RequestMakerViewsContainer()
    private var uiBuilder: RequestMakerVCUIBuilder?
    private var loaderPresenter: LoaderPresenter?
    private var tabBarPresenter: RequestMakerVCTabBarPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(red: 130/255, green: 188/255, blue: 244/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createBuilder()
        uiBuilder?.build()
        super.viewWillAppear(animated)
        createTabBarPresenter()
        createLoaderPresenter()
    }
    
    private func createBuilder() {
        uiBuilder = RequestMakerVCUIBuilder(viewController: self, viewsContainer: viewsContainer)
    }
    
    private func createTabBarPresenter() {
        self.tabBarPresenter = RequestMakerVCTabBarPresenter(viewController: self, executeButtonTapAction: {
            self.viewModel?.process(event: .executeButtonTapped)
        })
    }
    
    private func createLoaderPresenter() {
        loaderPresenter = LoaderPresenter(viewController: self)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel?.process(event: .adressChanged(textField.text ?? ""))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension RequestMakerViewController : RequestMakerViewModelToViewProtocol {
    private func handleValidationSuccess() {
        self.loaderPresenter?.hideLoader()
        self.viewsContainer.responseErrorLabel.text = "Error: -"
        self.viewsContainer.responseErrorLabel.textColor = .black
        self.viewsContainer.serverAddressTextField.textColor = .black
    }
    
    func process(event: RequestMakerViewModelEvent) {
        switch event {
        case .makingRequest:
            self.loaderPresenter?.showLoader()
        case .requestSuccessed(let serverResponse):
            handleRequestSuccessEvent(serverResponse)
        case .requestFailed(let response):
            handleRequestFailureEvent(response)
        case .adressValidationFailed:
            handleAddressValidationFailureEvent()
        case .adressValidationSucceded:
            self.handleValidationSuccess()
        case .dataValidationFailed(let error):
            self.loaderPresenter?.hideLoader()
            self.viewsContainer.responseErrorLabel.text = "Error: \(error)"
            self.viewsContainer.responseErrorLabel.textColor = .red
        case .dataValidationSucceded:
            self.handleValidationSuccess()
        }
    }
    
    private func handleRequestSuccessEvent(_ serverResponse: (ServerResponsePresentationModel)) {
        self.loaderPresenter?.hideLoader()
        self.viewsContainer.responseErrorLabel.text = "Message: \(serverResponse.message)"
        self.viewsContainer.responseStatusLabel.text = "Status: \(serverResponse.status)"
        self.viewsContainer.responseLabel.text = "Response:\n\(serverResponse.responseData)"
        self.viewsContainer.serverResponseLabel.textColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
        self.viewsContainer.responseLabel.textColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
        self.viewsContainer.responseErrorLabel.textColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
        self.viewsContainer.responseStatusLabel.textColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewsContainer.serverResponseLabel.textColor = .black
            self.viewsContainer.responseLabel.textColor = .black
            self.viewsContainer.responseErrorLabel.textColor = .black
            self.viewsContainer.responseStatusLabel.textColor = .black
        }
    }
    
    private func handleRequestFailureEvent(_ response: ServerResponsePresentationModel) {
        self.loaderPresenter?.hideLoader()
        self.viewsContainer.responseErrorLabel.text = "Error: \(response.message)"
        self.viewsContainer.responseStatusLabel.text = "Status: \(response.status)"
        self.viewsContainer.serverResponseLabel.textColor = .red
        self.viewsContainer.responseLabel.textColor = .red
        self.viewsContainer.responseErrorLabel.textColor = .red
        self.viewsContainer.responseStatusLabel.textColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewsContainer.serverResponseLabel.textColor = .black
            self.viewsContainer.responseLabel.textColor = .black
            self.viewsContainer.responseErrorLabel.textColor = .black
            self.viewsContainer.responseStatusLabel.textColor = .black
        }
    }
    
    private func handleAddressValidationFailureEvent() {
        self.loaderPresenter?.hideLoader()
        self.viewsContainer.responseErrorLabel.text = "Error: Validation Error\nWrong server adress format"
        self.viewsContainer.responseErrorLabel.textColor = .red
        self.viewsContainer.serverAddressTextField.textColor = .red
    }
    
}

extension RequestMakerViewController: CustomSwitchDelegate {
    func handleToggleOf(key: CustomSwitchOption, value: Bool) {
        switch key {
        case .isConnectionSecure:
            viewModel?.process(event: .securitySettingsChanged(value))
        case .isSecurityValidationOn:
            viewModel?.process(event: .validationSettingsChanged(value))
        }
    }
}

extension RequestMakerViewController: DictionaryEditorDropDownViewDelegate {
    
    func handeUpdateOf(dictionary: [String : String], dictType: CustomDictionaryOption) {
        switch dictType {
        case .httpHeaders:
            viewModel?.process(event: .httpHeadersChanged(dictionary))
        case .httpData:
            viewModel?.process(event: .httpDataChanged(dictionary))
        }
    }
    
}
