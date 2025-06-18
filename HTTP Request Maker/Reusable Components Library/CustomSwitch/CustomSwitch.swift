//
//  CustomSwitch.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import UIKit

class CustomSwitch: UIView {

    var titleLabel: TopAlignedLabel = TopAlignedLabel()
    var switchView: UISwitch = UISwitch()
    var delegate: CustomSwitchDelegate?
    var changedOption: CustomSwitchOption = .isConnectionSecure
    
    private let switchColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
    
    private var isOn: Bool = false
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupTitleLabel(_ title: String) {
        self.addSubview(self.titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.width.equalTo(300)
            make.leading.top.equalToSuperview()
            make.top.equalToSuperview()
        }
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.text = title
    }
    
    private func setupSwitch() {
        self.addSubview(self.switchView)
        switchView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        switchView.onTintColor = switchColor
        switchView.addTarget(self, action: #selector(onSwitchValueChanged), for: .valueChanged)
    }
    
    func configureWith(title: String,andChangedOption changedOption: CustomSwitchOption) {
        self.setupTitleLabel(title)
        self.setupSwitch()
        self.changedOption = changedOption
    }
    
    @objc private func onSwitchValueChanged(_ switchView: UISwitch) {
        delegate?.handleToggleOf(key: changedOption, value: switchView.isOn)
    }

}
