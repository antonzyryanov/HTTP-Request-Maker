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
    private weak var scrollView: UIScrollView!
    private weak var verticalStack: UIStackView!
    private weak var serverAddressTextField: UITextField!
    private weak var secureConnectionSwitch: CustomSwitch!
    private weak var secureConnectionValidationSwitch: CustomSwitch!
    private weak var httpMethodPicker: UIPickerView!
    private weak var customHTTPHeadersDropDown: DictionaryEditorDropDownView!
    private weak var customHTTPBodyDropDown: DictionaryEditorDropDownView!
    private weak var serverResponseLabel: TopAlignedLabel!
    private weak var responseStatusLabel: TopAlignedLabel!
    private weak var responseErrorLabel: TopAlignedLabel!
    private weak var responseLabel: TopAlignedLabel!
    
    init(viewController: RequestMakerViewController!, scrollView: UIScrollView!, verticalStack: UIStackView!, serverAddressTextField: UITextField!, secureConnectionSwitch: CustomSwitch!, secureConnectionValidationSwitch: CustomSwitch!, httpMethodPicker: UIPickerView!, customHTTPHeadersDropDown: DictionaryEditorDropDownView!, customHTTPBodyDropDown: DictionaryEditorDropDownView!, serverResponseLabel: TopAlignedLabel!, responseStatusLabel: TopAlignedLabel!, responseErrorLabel: TopAlignedLabel!, responseLabel: TopAlignedLabel!) {
        self.viewController = viewController
        self.scrollView = scrollView
        self.verticalStack = verticalStack
        self.serverAddressTextField = serverAddressTextField
        self.secureConnectionSwitch = secureConnectionSwitch
        self.secureConnectionValidationSwitch = secureConnectionValidationSwitch
        self.httpMethodPicker = httpMethodPicker
        self.customHTTPHeadersDropDown = customHTTPHeadersDropDown
        self.customHTTPBodyDropDown = customHTTPBodyDropDown
        self.serverResponseLabel = serverResponseLabel
        self.responseStatusLabel = responseStatusLabel
        self.responseErrorLabel = responseErrorLabel
        self.responseLabel = responseLabel
    }
    
    func build() {
        setupScrollView()
        setupVerticalStack()
        addSpacerWith(height: 164)
        setupServerAddressTextField()
        setupSecureConnectionSwitch()
        setupSecureConnectionValidationSwitch()
        setupHTTPMethodPicker()
        setupCustomHTTPHeadersDropDown()
        setupCustomHTTPBodyDropDown()
        setupDivider()
        setupServerResponseLabel()
        setupResponseStatusLabel()
        setupResponseErrorLabel()
        setupResponseLabel()
        let tap = UITapGestureRecognizer(target: viewController, action: #selector(viewController.dismissKeyboard))
        viewController.view.addGestureRecognizer(tap)
    }
    
    private func addToVStack(subview: UIView, with height: CGFloat, and width: CGFloat) {
        verticalStack.addArrangedSubview(subview)
        subview.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
    }
    
    private func setupScrollView() {
        viewController.view.addSubview(scrollView)
        scrollView.delegate = viewController
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(viewController.view)
        }
    }
    
    private func setupVerticalStack() {
        scrollView.addSubview(verticalStack)
        verticalStack.axis = .vertical
        verticalStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width-32)
        }
        verticalStack.spacing = 16
    }
    
    private func addSpacerWith(height: CGFloat) {
        let spacer = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        spacer.backgroundColor = .clear
        addToVStack(subview:spacer,with: height,and: UIScreen.main.bounds.width-64)
    }
    
    private func setupServerAddressTextField() {
        serverAddressTextField.backgroundColor = .white
        serverAddressTextField.font = .systemFont(ofSize: 24, weight: .bold)
        serverAddressTextField.placeholder = "Paste server address"
        serverAddressTextField.text = "google.com"
        addToVStack(subview:serverAddressTextField,with: 64,and: UIScreen.main.bounds.width-64)
        let divider = UIView(frame: .init(x: 0, y: 0, width: 16, height: 64))
        serverAddressTextField.leftView = divider
        serverAddressTextField.leftViewMode = .always
        serverAddressTextField.layer.cornerRadius = 16
        serverAddressTextField.clipsToBounds = true
        serverAddressTextField.autocapitalizationType = .none
        serverAddressTextField.addTarget(viewController, action: #selector(viewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupSecureConnectionSwitch() {
        secureConnectionSwitch.configureWith(title: "Secure connection", andChangedOption: .isConnectionSecure)
        secureConnectionSwitch.delegate = viewController
        addToVStack(subview:secureConnectionSwitch,with: 64,and: UIScreen.main.bounds.width-64)
    }
    
    private func setupSecureConnectionValidationSwitch() {
        secureConnectionValidationSwitch.configureWith(title: "Secure connection validation", andChangedOption: .isSecurityValidationOn)
        secureConnectionValidationSwitch.delegate = viewController
        addToVStack(subview:secureConnectionValidationSwitch,with: 64,and: UIScreen.main.bounds.width-64)
    }
    
    private func setupCustomHTTPHeadersDropDown() {
        verticalStack.addArrangedSubview(customHTTPHeadersDropDown)
        customHTTPHeadersDropDown.configureWith(model: DictionaryEditorModel(presentButtonModel: .init(presentTitle: "HTTP headers", hideTitle: "HTTP headers"),existingDictionary: ["Content-Type":"application/json"], numberOfNewElementsToAdd: 14, presentButtonHeight: 64, itemsHeight: 64, dictType: .httpHeaders))
        customHTTPHeadersDropDown.delegate = viewController
    }
    
    private func setupCustomHTTPBodyDropDown() {
        verticalStack.addArrangedSubview(customHTTPBodyDropDown)
        customHTTPBodyDropDown.configureWith(model: DictionaryEditorModel(presentButtonModel: .init(presentTitle: "HTTP body", hideTitle: "HTTP body"), existingDictionary: ["data type":"","data":""], numberOfNewElementsToAdd: 0, presentButtonHeight: 64, itemsHeight: 300, dictType: .httpData))
        customHTTPBodyDropDown.delegate = viewController
    }
    
    private func setupHTTPMethodPicker() {
        verticalStack.addArrangedSubview(httpMethodPicker)
        addToVStack(subview:httpMethodPicker,with: 64,and: UIScreen.main.bounds.width)
        httpMethodPicker.delegate = viewController
        httpMethodPicker.dataSource = viewController
    }
    
    private func setupDivider() {
        let divider = UIView()
        divider.backgroundColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
        addToVStack(subview: divider,with: 2,and: UIScreen.main.bounds.width)
    }
    
    private func setupServerResponseLabel() {
        addToVStack(subview:serverResponseLabel,with: 64,and: UIScreen.main.bounds.width)
        serverResponseLabel.font = .systemFont(ofSize: 24, weight: .bold)
        serverResponseLabel.text = "Server response:"
    }
    
    private func setupResponseStatusLabel() {
        addToVStack(subview:responseStatusLabel,with: 64,and: UIScreen.main.bounds.width)
        responseStatusLabel.font = .systemFont(ofSize: 24, weight: .bold)
        responseStatusLabel.text = "Status:"
    }
    
    private func setupResponseErrorLabel() {
        addToVStack(subview:responseErrorLabel,with: 128,and: UIScreen.main.bounds.width)
        responseErrorLabel.font = .systemFont(ofSize: 24, weight: .bold)
        responseErrorLabel.text = "Error: -"
        responseErrorLabel.numberOfLines = 4
    }
    
    private func setupResponseLabel() {
        addToVStack(subview:responseLabel,with: 280,and: UIScreen.main.bounds.width)
        responseLabel.font = .systemFont(ofSize: 24, weight: .bold)
        responseLabel.text = "Response:"
        responseLabel.numberOfLines = 6
    }
    
}
