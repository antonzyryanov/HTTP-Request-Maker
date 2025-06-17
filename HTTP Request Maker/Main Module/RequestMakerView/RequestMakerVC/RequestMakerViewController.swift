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
    
    private let scrollView = UIScrollView()
    private let verticalStack = UIStackView()
    private let serverAddressTextField = UITextField()
    private let secureConnectionSwitch = CustomSwitch()
    private let secureConnectionValidationSwitch = CustomSwitch()
    private let httpMethodPicker = UIPickerView()
    private let customHTTPHeadersDropDown = DictionaryEditorDropDownView()
    private let customHTTPBodyDropDown = DictionaryEditorDropDownView()
    private let serverResponseLabel = TopAlignedLabel()
    private let responseStatusLabel = TopAlignedLabel()
    private let responseErrorLabel = TopAlignedLabel()
    private let responseLabel = TopAlignedLabel()
    private let loaderView = LoaderView()
    
    private var uiBuilder: RequestMakerVCUIBuilder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(red: 130/255, green: 188/255, blue: 244/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createBuilder()
        uiBuilder?.build()
        super.viewWillAppear(animated)
        setupTabBar()
        setupLoaderView()
    }
    
    private func createBuilder() {
        uiBuilder = RequestMakerVCUIBuilder(viewController: self, scrollView: self.scrollView, verticalStack: self.verticalStack, serverAddressTextField: self.serverAddressTextField, secureConnectionSwitch: self.secureConnectionSwitch, secureConnectionValidationSwitch: self.secureConnectionValidationSwitch, httpMethodPicker: self.httpMethodPicker, customHTTPHeadersDropDown: self.customHTTPHeadersDropDown, customHTTPBodyDropDown: self.customHTTPBodyDropDown, serverResponseLabel: self.serverResponseLabel, responseStatusLabel: self.responseStatusLabel, responseErrorLabel: self.responseErrorLabel, responseLabel: self.responseLabel)
    }
    
    private func setupTabBar() {
        tabBar.customizeWith(configuration: CustomTabBarConfiguration(backgroundColor: .white, borderColor: UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1),
                                                                      buttonsColor: .white,borderWidth: 2, cornerRadius: 16, buttonsCornerRadius: 12,
            buttons: [
            CustomTabBarButtonModel(title: "", image: UIImage(named: ""), action: {
            }),
            CustomTabBarButtonModel(title: "", image: UIImage(named: ""), action: {
            }),
            CustomTabBarButtonModel(title: "Send Request", image: UIImage(named: "send_request"), action: {
                self.viewModel?.process(event: .executeButtonTapped)
            })
            ]
            )
        )
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel?.process(event: .adressChanged(textField.text ?? ""))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupLoaderView() {
        self.view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.width.height.equalToSuperview()
        }
//        loaderView.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        loaderView.configureWith(gif: "loader")
        loaderView.backgroundColor = .white
        loaderView.configureWith(gif: "loader")
        loaderView.isHidden = true
    }
    
    private func showLoader() {
        DispatchQueue.main.async {
            self.loaderView.isHidden = false
            self.view.isUserInteractionEnabled = false
            self.view.layoutSubviews()
        }
    }
    
    private func hideLoader() {
        DispatchQueue.main.async {
            self.loaderView.isHidden = true
            self.view.isUserInteractionEnabled = true
            self.view.layoutSubviews()
        }
    }
    
}

extension RequestMakerViewController : RequestMakerViewModelToViewProtocol {
    private func validationSucceded() {
        self.responseErrorLabel.text = "Error: -"
        self.responseErrorLabel.textColor = .black
        self.serverAddressTextField.textColor = .black
    }
    
    func process(event: RequestMakerViewModelEvent) {
        switch event {
        case .makingRequest:
            self.showLoader()
        case .requestSuccessed(let serverResponse):
            self.hideLoader()
            self.responseErrorLabel.text = "Message: \(serverResponse.message)"
            self.responseStatusLabel.text = "Status: \(serverResponse.status)"
            self.responseLabel.text = serverResponse.responseData
            self.serverResponseLabel.textColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
            self.responseLabel.textColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
            self.responseErrorLabel.textColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
            self.responseStatusLabel.textColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.serverResponseLabel.textColor = .black
                self.responseLabel.textColor = .black
                self.responseErrorLabel.textColor = .black
                self.responseStatusLabel.textColor = .black
            }
        case .requestFailed(let error):
            self.hideLoader()
            self.responseErrorLabel.text = "Error: \(error)"
            self.responseStatusLabel.text = "Status: "
            self.serverResponseLabel.textColor = .red
            self.responseLabel.textColor = .red
            self.responseErrorLabel.textColor = .red
            self.responseStatusLabel.textColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.serverResponseLabel.textColor = .black
                self.responseLabel.textColor = .black
                self.responseErrorLabel.textColor = .black
                self.responseStatusLabel.textColor = .black
            }
        case .adressValidationFailed:
            self.hideLoader()
            self.responseErrorLabel.text = "Error: Validation Error\nWrong server adress format"
            self.responseErrorLabel.textColor = .red
            self.serverAddressTextField.textColor = .red
        case .adressValidationSucceded:
            self.validationSucceded()
        case .dataValidationFailed(let error):
            self.hideLoader()
            self.responseErrorLabel.text = "Error: \(error)"
            self.responseErrorLabel.textColor = .red
        case .dataValidationSucceded:
            self.validationSucceded()
        }
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
