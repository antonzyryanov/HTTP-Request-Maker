//
//  RequestMakerVCTabBarPresenter.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 18.06.2025.
//

import Foundation
import UIKit

class RequestMakerVCTabBarPresenter {
    
    private weak var viewController: RequestMakerViewController?
    
    private let delayToShowButtonAnimation: Double = 0.35
    
    init(viewController: RequestMakerViewController? = nil, executeButtonTapAction: (()->Void)?) {
        self.viewController = viewController
        setupTabBar(executeButtonTapAction: executeButtonTapAction)
    }
    
    private func setupTabBar(executeButtonTapAction: (()->Void)?) {
        viewController?.tabBar.customizeWith(configuration: CustomTabBarConfiguration(backgroundColor: .white, borderColor: UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1),
                                                                      buttonsColor: .white,borderWidth: 2, cornerRadius: 16, buttonsCornerRadius: 12,
            buttons: [
            CustomTabBarButtonModel(title: "", image: UIImage(named: ""), action: {
            }),
            CustomTabBarButtonModel(title: "", image: UIImage(named: ""), action: {
            }),
            CustomTabBarButtonModel(title: "Send Request", image: UIImage(named: "send_request"), action: {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.delayToShowButtonAnimation) {
                    executeButtonTapAction?()
                }
            })
            ]
            )
        )
    }
    
}
