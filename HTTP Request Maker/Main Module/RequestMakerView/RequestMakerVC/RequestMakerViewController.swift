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
    private var requestMakerVCViewModelEventsUIHandler: RequestMakerVCViewModelEventsUIHandler?
    
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
        createViewModelEventsUIHandler()
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
    
    private func createViewModelEventsUIHandler() {
        requestMakerVCViewModelEventsUIHandler = RequestMakerVCViewModelEventsUIHandler(viewsContainer: self.viewsContainer)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel?.process(event: .adressChanged(textField.text ?? ""))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension RequestMakerViewController : RequestMakerViewModelToViewProtocol {
    
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
            handleDataValidationFailure(error)
        case .dataValidationSucceded:
            self.handleValidationSuccess()
        }
    }
    
    private func handleRequestSuccessEvent(_ serverResponse: (ServerResponsePresentationModel)) {
        self.loaderPresenter?.hideLoader()
        requestMakerVCViewModelEventsUIHandler?.handleRequestFailureEvent(serverResponse)
    }
    
    private func handleRequestFailureEvent(_ response: ServerResponsePresentationModel) {
        self.loaderPresenter?.hideLoader()
        requestMakerVCViewModelEventsUIHandler?.handleRequestFailureEvent(response)
    }
    
    private func handleAddressValidationFailureEvent() {
        self.loaderPresenter?.hideLoader()
        requestMakerVCViewModelEventsUIHandler?.handleAddressValidationFailureEvent()
    }
    
    private func handleValidationSuccess() {
        self.loaderPresenter?.hideLoader()
        requestMakerVCViewModelEventsUIHandler?.handleValidationSuccess()
    }
    
    private func handleDataValidationFailure(_ error: (String)) {
        requestMakerVCViewModelEventsUIHandler?.handleDataValidationFailure(error)
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
