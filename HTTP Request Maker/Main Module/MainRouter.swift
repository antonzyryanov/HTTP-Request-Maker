//
//  MainRouter.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import Foundation
import UIKit

class MainRouter: MainRouterProtocol {
    
    var viewModel: RequestMakerViewModel?
    weak var mainView: RequestMakerViewController?
    
    func startApp() {
        guard let currentWindow = UIApplication.shared.currentWindow,
        let vc = mainView else { return }
        currentWindow.rootViewController = vc
    }
    
}
