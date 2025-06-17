//
//  DIContainer.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import Foundation

class DIContainer: DIContainerProtocol {
    
    let mainRouter: MainRouterProtocol = MainRouter()
    private let modulesFactory: ModulesFactoryProtocol = ModulesFactoryImpl(appTestModeSettings: AppTestModeSettings())
    private var mainViewModel: RequestMakerViewModel? = nil
    
    func setupDependencies() {
        mainViewModel = modulesFactory.generateMainModule(mainRouter: mainRouter)
    }
    
}
