//
//  CustomTabBar.swift
//  Zeros Cantina
//
//  Created by Anton Zyryanov on 14.06.2025.
//

import UIKit

class CustomTabBar: UIView {
    
    private var buttonsViews: [CustomTabBarButton] = []
    
    private var navigateToScreen: ((String)->Void)? = nil
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func customizeWith(configuration: CustomTabBarConfiguration) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        setupButtons(configuration, stackView)
        setupStackView(stackView)
        stylize(stackView, configuration)
    }
    
    private func setupButtons(_ configuration: CustomTabBarConfiguration, _ stackView: UIStackView) {
        for buttonModel in configuration.buttons {
            let buttonView = CustomTabBarButton()
            buttonView.setupWith(model: buttonModel)
            buttonView.snp.makeConstraints { make in
                make.height.width.equalTo(80)
            }
            buttonView.layer.cornerRadius = configuration.buttonsCornerRadius
            buttonView.layer.masksToBounds = true
            buttonView.navigateToScreen = navigateToScreen
            buttonsViews.append(buttonView)
            buttonView.backgroundView?.backgroundColor = configuration.buttonsColor
            stackView.addArrangedSubview(buttonView)
        }
        stackView.distribution = .fillEqually
    }
    
    private func setupStackView(_ stackView: UIStackView) {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(150)
        }
    }
    
    private func stylize(_ stackView: UIStackView, _ configuration: CustomTabBarConfiguration) {
        stackView.backgroundColor = configuration.backgroundColor
        stackView.layer.cornerRadius = configuration.cornerRadius
        stackView.layer.borderWidth = configuration.borderWidth
        stackView.layer.borderColor = configuration.borderColor.cgColor
    }
    
}
