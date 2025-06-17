//
//  CustomSwitchDelegate.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

protocol CustomSwitchDelegate {
    func handleToggleOf(key: CustomSwitchOption, value: Bool)
}
