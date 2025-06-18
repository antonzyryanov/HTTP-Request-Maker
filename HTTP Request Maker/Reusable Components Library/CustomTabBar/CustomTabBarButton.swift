//
//  CustomTabBarButton.swift
//  Zeros Cantina
//
//  Created by Anton Zyryanov on 14.06.2025.
//

import UIKit
import SnapKit

class CustomTabBarButton: UIView {
    
    private var titleLabel: UILabel?
    private var imageView: UIImageView?
    var backgroundView: UIView?
    private var tapAction: (()->Void)?
    var navigateToScreen: ((String)->Void)? = nil
    
    private let highlightColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupWith(model: CustomTabBarButtonModel) {
        setupBackgroundView()
        setup(image: model.image)
        setup(title: model.title)
        setupActions(model: model)
    }
    
    private func setup(title: String) {
        let titleLabel =  UILabel()
        self.titleLabel = titleLabel
        self.titleLabel?.text = title
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func setup(image: UIImage?) {
        guard let image = image else { return }
        let imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .black
        self.imageView = imageView
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(54)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(48)
        }
    }
    
    private func setupBackgroundView() {
        let backgroundView = UIView()
        self.backgroundView = backgroundView
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    private func setupActions(model:CustomTabBarButtonModel) {
        self.tapAction = model.action
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.buttonTapAction))
        self.addGestureRecognizer(tap)
    }
    
    private func playTapAnimations() {
        guard let backgroundImage = imageView else { return }
        backgroundImage.tintColor = highlightColor
        self.titleLabel?.textColor = highlightColor
        UIView.animate(withDuration: 0.2) {
            backgroundImage.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.titleLabel?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                backgroundImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.titleLabel?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            } completion: { _ in
                backgroundImage.tintColor = UIColor.black
                self.titleLabel?.textColor = UIColor.black
            }
        }
    }
    
    @objc func buttonTapAction() {
        playTapAnimations()
        tapAction?()
        navigateToScreen?(titleLabel?.text ?? "")
    }
    
}
