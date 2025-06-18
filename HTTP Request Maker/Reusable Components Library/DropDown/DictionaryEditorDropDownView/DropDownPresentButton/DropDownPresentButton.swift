//
//  DropDownPresentButton.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import UIKit

class DropDownPresentButton: UIView, DropDownPresentButtonProtocol {
    
    var isPresented: Bool = false {
        didSet {
            if isPresented {
                label.text = model.hideTitle
                arrowImageView.image = UIImage(named: "arrow_up")
            } else {
                label.text = model.presentTitle
                arrowImageView.image = UIImage(named: "arrow_down")
            }
        }
    }

    var label = UILabel()
    
    var arrowImageView = UIImageView()
    
    var model: DropDownPresentButtonModel = DropDownPresentButtonModel(presentTitle: "Show", hideTitle: "Hide")
    
    func configureWith(model: DropDownPresentButtonModel) {
        self.model = model
        setupLabel(model: model)
        setupImage()
    }
    
    private func setupLabel(model: DropDownPresentButtonModel) {
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        label.text = model.presentTitle
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    private func setupImage() {
        self.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(18)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        arrowImageView.image = UIImage(named: "arrow_down")
    }

}
