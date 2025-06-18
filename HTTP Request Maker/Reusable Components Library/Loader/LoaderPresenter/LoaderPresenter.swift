//
//  LoaderPresenter.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 18.06.2025.
//

import Foundation
import UIKit

class LoaderPresenter {
    
    private weak var viewController: UIViewController?
    
    private let loaderView = LoaderView()
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
        self.setupLoaderView()
    }
    
    private func setupLoaderView() {
        viewController?.view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        loaderView.backgroundColor = .white
        loaderView.configureWith(gif: "loader")
        loaderView.isHidden = true
    }
    
    func showLoader() {
        DispatchQueue.main.async {
            self.viewController?.view.isUserInteractionEnabled = false
        }
        DispatchQueue.main.async {
            self.loaderView.isHidden = false
            self.viewController?.view.layoutSubviews()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.loaderView.isHidden = true
            self.viewController?.view.isUserInteractionEnabled = true
            self.viewController?.view.layoutSubviews()
        }
    }
    
}
