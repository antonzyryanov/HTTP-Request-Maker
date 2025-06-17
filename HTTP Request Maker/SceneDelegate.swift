//
//  SceneDelegate.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var diContainer: DIContainer?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }


    func sceneDidBecomeActive(_ scene: UIScene) {
        if diContainer == nil {
            diContainer = DIContainer()
            diContainer?.setupDependencies()
            showUIToUserAfterDIFinished()
        }
    }
    
    private func showUIToUserAfterDIFinished() {
        guard let mainRouter = diContainer?.mainRouter else { return }
        mainRouter.startApp()
    }

}

