//
//  RequestMakerVCUIBuilder.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation
import UIKit

class RequestMakerVCUIBuilder {

    private weak var viewController: RequestMakerViewController!
    private weak var viewsContainer: RequestMakerViewsContainer!
    
    private let commonElementsHeight: CGFloat = 64
    private let commonElementsHorizontalInsets: CGFloat = 32
    
    init(viewController: RequestMakerViewController!, viewsContainer: RequestMakerViewsContainer!) {
        self.viewController = viewController
        self.viewsContainer = viewsContainer
    }
    
    func build() {
        setupScrollView()
        setupVerticalStack()
        addSpacerWith(height: 164)
        setupServerAddressTextField()
        setupCustomSwitches()
        setupHTTPMethodPicker()
        setupDropDowns()
        setupDivider()
        setupLabels()
        setupKeyboardGesture()
    }
    
    private func setupScrollView() {
        viewController.view.addSubview(viewsContainer.scrollView)
        viewsContainer.scrollView.delegate = viewController
        viewsContainer.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(viewController.view)
        }
    }
    
    private func setupVerticalStack() {
        viewsContainer.scrollView.addSubview(viewsContainer.verticalStack)
        viewsContainer.verticalStack.axis = .vertical
        viewsContainer.verticalStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width-32)
        }
        viewsContainer.verticalStack.spacing = 16
    }
    
    private func addSpacerWith(height: CGFloat) {
        let spacer = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        spacer.backgroundColor = .clear
        addToVStack(subview:spacer,with: height,and: UIScreen.main.bounds.width-commonElementsHorizontalInsets*2)
    }
    
    private func setupServerAddressTextField() {
        viewsContainer.serverAddressTextField.backgroundColor = .white
        viewsContainer.serverAddressTextField.font = .systemFont(ofSize: 24, weight: .bold)
        viewsContainer.serverAddressTextField.placeholder = "Paste server address"
        viewsContainer.serverAddressTextField.text = "google.com"
        addToVStack(subview:viewsContainer.serverAddressTextField,with: commonElementsHeight,and: UIScreen.main.bounds.width-commonElementsHorizontalInsets*2)
        let divider = UIView(frame: .init(x: 0, y: 0, width: 16, height: commonElementsHeight))
        viewsContainer.serverAddressTextField.leftView = divider
        viewsContainer.serverAddressTextField.leftViewMode = .always
        viewsContainer.serverAddressTextField.layer.cornerRadius = 16
        viewsContainer.serverAddressTextField.clipsToBounds = true
        viewsContainer.serverAddressTextField.autocapitalizationType = .none
        viewsContainer.serverAddressTextField.addTarget(viewController, action: #selector(viewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupCustomSwitches() {
        setupSecureConnectionSwitch()
        setupSecureConnectionValidationSwitch()
    }
    
    private func setupSecureConnectionSwitch() {
        viewsContainer.secureConnectionSwitch.configureWith(title: "Secure connection", andChangedOption: .isConnectionSecure)
        viewsContainer.secureConnectionSwitch.delegate = viewController
        addToVStack(subview:viewsContainer.secureConnectionSwitch,with: commonElementsHeight,and: UIScreen.main.bounds.width-commonElementsHorizontalInsets*2)
    }
    
    private func setupSecureConnectionValidationSwitch() {
        viewsContainer.secureConnectionValidationSwitch.configureWith(title: "Secure connection validation", andChangedOption: .isSecurityValidationOn)
        viewsContainer.secureConnectionValidationSwitch.delegate = viewController
        addToVStack(subview:viewsContainer.secureConnectionValidationSwitch,with: commonElementsHeight,and: UIScreen.main.bounds.width-commonElementsHorizontalInsets*2)
    }
    
    private func setupHTTPMethodPicker() {
        viewsContainer.verticalStack.addArrangedSubview(viewsContainer.httpMethodPicker)
        addToVStack(subview:viewsContainer.httpMethodPicker,with: commonElementsHeight,and: UIScreen.main.bounds.width)
        viewsContainer.httpMethodPicker.delegate = viewController
        viewsContainer.httpMethodPicker.dataSource = viewController
    }
    
    private func setupDropDowns() {
        setupCustomHTTPHeadersDropDown()
        setupCustomHTTPBodyDropDown()
    }
    
    private func setupDivider() {
        let divider = UIView()
        divider.backgroundColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
        addToVStack(subview: divider,with: 2,and: UIScreen.main.bounds.width)
    }
    
    private func setupCustomHTTPHeadersDropDown() {
        viewsContainer.verticalStack.addArrangedSubview(viewsContainer.customHTTPHeadersDropDown)
        viewsContainer.customHTTPHeadersDropDown.configureWith(model: DictionaryEditorModel(presentButtonModel: .init(presentTitle: "HTTP headers", hideTitle: "HTTP headers"),existingDictionary: ["Content-Type":"application/json"], numberOfNewElementsToAdd: 14, presentButtonHeight: commonElementsHeight, itemsHeight: commonElementsHeight, dictType: .httpHeaders))
        viewsContainer.customHTTPHeadersDropDown.delegate = viewController
    }
    
    private func setupCustomHTTPBodyDropDown() {
        viewsContainer.verticalStack.addArrangedSubview(viewsContainer.customHTTPBodyDropDown)
        viewsContainer.customHTTPBodyDropDown.configureWith(model: DictionaryEditorModel(presentButtonModel: .init(presentTitle: "HTTP body", hideTitle: "HTTP body"), existingDictionary: ["data type":"","data":""], numberOfNewElementsToAdd: 0, presentButtonHeight: commonElementsHeight, itemsHeight: 300, dictType: .httpData))
        viewsContainer.customHTTPBodyDropDown.delegate = viewController
    }
    
    private func setupLabels() {
        setupServerResponseLabel()
        setupResponseStatusLabel()
        setupResponseErrorLabel()
        setupResponseLabel()
    }
    
    private func setupServerResponseLabel() {
        addToVStack(subview:viewsContainer.serverResponseLabel,with: commonElementsHeight,and: UIScreen.main.bounds.width)
        viewsContainer.serverResponseLabel.font = .systemFont(ofSize: 24, weight: .bold)
        viewsContainer.serverResponseLabel.text = "Server response:"
    }
    
    private func setupResponseStatusLabel() {
        addToVStack(subview:viewsContainer.responseStatusLabel,with: commonElementsHeight,and: UIScreen.main.bounds.width)
        viewsContainer.responseStatusLabel.font = .systemFont(ofSize: 24, weight: .bold)
        viewsContainer.responseStatusLabel.text = "Status:"
    }
    
    private func setupResponseErrorLabel() {
        addToVStack(subview:viewsContainer.responseErrorLabel,with: 128,and: UIScreen.main.bounds.width)
        viewsContainer.responseErrorLabel.font = .systemFont(ofSize: 24, weight: .bold)
        viewsContainer.responseErrorLabel.text = "Error: -"
        viewsContainer.responseErrorLabel.numberOfLines = 4
    }
    
    private func setupResponseLabel() {
        addToVStack(subview:viewsContainer.responseLabel,with: 280,and: UIScreen.main.bounds.width)
        viewsContainer.responseLabel.font = .systemFont(ofSize: 24, weight: .bold)
        viewsContainer.responseLabel.text = "Response:"
        viewsContainer.responseLabel.numberOfLines = 6
    }
    
    private func setupKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: viewController, action: #selector(viewController.dismissKeyboard))
        viewController.view.addGestureRecognizer(tap)
    }
    
    private func addToVStack(subview: UIView, with height: CGFloat, and width: CGFloat) {
        viewsContainer.verticalStack.addArrangedSubview(subview)
        subview.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
    }
    
}
