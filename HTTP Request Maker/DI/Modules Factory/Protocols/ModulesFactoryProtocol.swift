//
//  ModulesFactoryProtocol.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import Foundation

protocol ModulesFactoryProtocol {
    func generateMainModule(mainRouter: MainRouterProtocol) -> RequestMakerViewModel?
}
