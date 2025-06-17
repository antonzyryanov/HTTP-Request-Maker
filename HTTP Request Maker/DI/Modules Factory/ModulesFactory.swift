//
//  ModulesFactory.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import Foundation

class ModulesFactoryImpl: ModulesFactoryProtocol {
    
    var appTestModeSettings: AppTestModeSettings?
    
    init(appTestModeSettings: AppTestModeSettings? = nil) {
        self.appTestModeSettings = appTestModeSettings
    }
    
    func generateMainModule(mainRouter: any MainRouterProtocol) -> RequestMakerViewModel? {
        guard let router = mainRouter as? MainRouter else { return nil }
        let view = RequestMakerViewController()
        let model = RequestModel(methodType: .GET,serverAdress: "google.com", isConnectionSecure: false, isSecurityValidationOn: false, customHeaders: [:], customData: (.String,""), action: "Action")
        var httpRequestWorker: HTTPRequestWorkerProtocol?
        if appTestModeSettings?.isMockNetworkLayerOn ?? false {
            let mockHTTPRequestWorker = MockHTTPRequestWorker()
            mockHTTPRequestWorker.appTestModeSettings = appTestModeSettings
            httpRequestWorker = mockHTTPRequestWorker
        } else {
            httpRequestWorker = HTTPRequestWorker()
        }
        let viewModel = RequestMakerViewModel(view: view, model: model, worker: httpRequestWorker)
        view.viewModel = viewModel
        router.mainView = view
        return viewModel
    }
    
}
