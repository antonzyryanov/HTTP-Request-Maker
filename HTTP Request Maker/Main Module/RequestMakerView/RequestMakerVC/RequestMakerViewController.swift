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
    private var viewModelsEventsUIHandler: RequestMakerVCViewModelEventsUIHandler?
    private var customDelegatesHandler: RequestMakerVCCustomDelegatesHandler?
    
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
        createCustomDelegatesHandler()
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
        viewModelsEventsUIHandler = RequestMakerVCViewModelEventsUIHandler(viewsContainer: self.viewsContainer)
    }
    
    private func createCustomDelegatesHandler() {
        customDelegatesHandler = RequestMakerVCCustomDelegatesHandler(viewModel: self.viewModel)
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
        viewModelsEventsUIHandler?.handleRequestSuccessEvent(serverResponse)
    }
    
    private func handleRequestFailureEvent(_ response: ServerResponsePresentationModel) {
        self.loaderPresenter?.hideLoader()
        viewModelsEventsUIHandler?.handleRequestFailureEvent(response)
    }
    
    private func handleAddressValidationFailureEvent() {
        self.loaderPresenter?.hideLoader()
        viewModelsEventsUIHandler?.handleAddressValidationFailureEvent()
    }
    
    private func handleValidationSuccess() {
        self.loaderPresenter?.hideLoader()
        viewModelsEventsUIHandler?.handleValidationSuccess()
    }
    
    private func handleDataValidationFailure(_ error: (String)) {
        viewModelsEventsUIHandler?.handleDataValidationFailure(error)
    }
    
}

extension RequestMakerViewController: CustomSwitchDelegate {
    func handleToggleOf(key: CustomSwitchOption, value: Bool) {
        customDelegatesHandler?.handleToggleOf(key: key, value: value)
    }
}

extension RequestMakerViewController: DictionaryEditorDropDownViewDelegate {
    func handeUpdateOf(dictionary: [String : String], dictType: CustomDictionaryOption) {
        customDelegatesHandler?.handeUpdateOf(dictionary: dictionary, dictType: dictType)
    }
}
